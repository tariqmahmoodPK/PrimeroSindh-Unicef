# frozen_string_literal: true

# rubocop:disable Metrics/ClassLength
# The truth of it is, this is a long class.
# Just the same, it shouldn't exceed 300 lines (250 lines of active code).

# The central Primero model object that represents an individual's case.
# In spite of the name, this will represent adult cases as well.
class Child < ApplicationRecord
  RISK_LEVEL_HIGH = 'high'
  RISK_LEVEL_NONE = 'none'
  RISK_LEVEL_EXTREME = 'extreme__test__672d4c2'
  NAME_FIELDS = %w[name name_nickname name_other].freeze

  self.table_name = 'cases'

  def self.parent_form
    'case'
  end

  # This module updates photo_keys with the before_save callback and needs to
  # run before the before_save callback in Historical to make the history
  include Record
  include Searchable
  include Historical
  include BIADerivedFields
  include CareArrangements
  include UNHCRMapping
  include Ownable
  include AutoPopulatable
  include Serviceable
  include Workflow
  include Flaggable
  include Transitionable
  include Reopenable
  include Approvable
  include Alertable
  include Attachable
  include Noteable
  include EagerLoadable
  include Webhookable
  include Kpi::GBVChild

  store_accessor(
    :data,
    :case_id, :case_id_code, :case_id_display,
    :nickname, :name, :protection_concerns, :consent_for_tracing, :hidden_name,
    :name_first, :name_middle, :name_last, :name_nickname, :name_other,
    :registration_date, :age, :estimated, :date_of_birth, :sex, :address_last,
    :risk_level, :date_case_plan, :case_plan_due_date, :date_case_plan_initiated,
    :date_closure, :assessment_due_date, :assessment_requested_on,
    :followup_subform_section, :protection_concern_detail_subform_section,
    :disclosure_other_orgs,
    :ration_card_no, :icrc_ref_no, :unhcr_id_no, :unhcr_individual_no, :un_no, :other_agency_id,
    :survivor_code_no, :national_id_no, :other_id_no, :biometrics_id, :family_count_no, :dss_id, :camp_id, :cpims_id,
    :tent_number, :nfi_distribution_id,
    :nationality, :ethnicity, :religion, :language, :sub_ethnicity_1, :sub_ethnicity_2, :country_of_origin,
    :displacement_status, :marital_status, :disability_type, :incident_details,
    :location_current, :tracing_status, :name_caregiver,
    :urgent_protection_concern, :child_preferences_section, :family_details_section, :care_arrangements_section,
    :duplicate
  )

  before_save :update_basic_info, :auto_fill_comprehensive_assessment_date, :auto_fill_initial_assessment_due_date, :auto_fill_survivor_under_18_check_box, :auto_fill_necessity_principle_to_seprate_child_from_harm_prepetrating_individual

  has_many :incidents, foreign_key: :incident_case_id
  has_many :matched_traces, class_name: 'Trace', foreign_key: 'matched_case_id'
  has_many :duplicates, class_name: 'Child', foreign_key: 'duplicate_case_id'
  belongs_to :duplicate_of, class_name: 'Child', foreign_key: 'duplicate_case_id', optional: true

  scope :by_date_of_birth, -> { where.not('data @> ?', { date_of_birth: nil }.to_json) }
  scope :check_registration_and_assessment_date, -> { where("data->'registration_date' ?| array[:options]", options: (Date.today - 2.days..Date.today - 1.days).map(&:to_s))
                                                      .where('data @> ?', { date_and_time_initial_assessment_was_completed_5c8fae2: nil }.to_json)
                                                      .where('data @> ?', { is_this_a__significant_harm__case__03fe116: true }.to_json)
                                                    }
  scope :pending_cases_to_assigned, -> (user_names) { where("data ->> 'owned_by' = data ->> 'created_by' ").where("data->'owned_by' ?| array[:options]", options: user_names) }
  scope :with_province, ->(user) { where("data ->> :key LIKE :value", :key => "owned_by_location", :value => "#{user.location.first(3)}%" ).where('data @> ?', { is_this_a__significant_harm__case_or_a_regular_case__d49a084: true }.to_json) }
  scope :with_district, ->(user) { where("data @> ?", { owned_by_location: user.location }.to_json) }
  scope :with_department, ->(agency) { where("data @> ?", { owned_by_agency_id: agency }.to_json) }
  scope :with_approvals_subforms, -> { where("data @> ?", { approval_subforms: [] }.to_json) }
  scope :attachment_with_specific_type, -> (user_names, document_type) { includes(:attachments).where("data->'owned_by' ?| array[:options]", options: user_names)
                                                                   .where(attachments: { type_of_document: document_type }) }
  scope :attachment_with_specific_type_and_user, -> (username, document_type) { includes(:attachments).where("data @> ?", { owned_by: username }.to_json).where(attachments: { type_of_document: document_type }) }
  scope :attachment_with_specific_type_and_province, -> (user, document_type) { includes(:attachments).where("data ->> :key LIKE :value", :key => "owned_by_location", :value => "#{user.location.first(3)}%").where(attachments: { type_of_document: document_type }) }
  scope :check_for_alternate_care_placement_with_user, -> (username) { find_by_sql("SELECT * FROM cases 
                                                              WHERE data->>'make__if_other__please_specify__appear_dynamically_83aa4ee' IS NOT NULL AND
                                                              (data->>'owned_by' = '#{username}')::boolean is true") }
  scope :check_for_alternate_care_placement, -> { find_by_sql("SELECT * FROM cases WHERE data->>'make__if_other__please_specify__appear_dynamically_83aa4ee' IS NOT NULL") }

  def auto_fill_comprehensive_assessment_date
    initial_assesment_completed = self.data['date_and_time_initial_assessment_was_completed_5c8fae2']

    return unless initial_assesment_completed.present?

    data['if_the_child_is_in_need_of_such_services__the_comprehensive_assessment_shall_commence_immediately_and_be_completed_within_15_days_of_this_report__that_is__by_8832cc6'] = initial_assesment_completed.to_date + 30.days if self.data["is_the_case_competent_for_a_comprehensive_assessment__72cf293"].present?
  end

  def auto_fill_initial_assessment_due_date
    return unless self.data['do_you_want_to_enable_auto_scheduling__9f716bf'].present?

    is_this_significant_harm_case = self.data["is_this_a__significant_harm__case_or_a_regular_case__d49a084"]
    registration_date = self.data["date_and_time_registration_was_completed_529de5d"]

    return if registration_date.blank?

    if is_this_significant_harm_case.present?
      data["due_date_for_initial_assessment_0e82430"] = registration_date.to_date + 3.days
    else
      data["due_date_for_initial_assessment_0e82430"] = registration_date.to_date + 7.days
    end
  end


  def auto_fill_survivor_under_18_check_box
    age = data["child_s_age_f2599ad"]
    data["is_the_survivor_under_18_years_of_age__561695b"] = age.present? && age.in?(0..17) ? true : false
  end
  
  def auto_fill_necessity_principle_to_seprate_child_from_harm_prepetrating_individual
    data["this_is_a_significant_harm_case__and_it_is_necessary_to_separate_the_child_from_the_perpetrating_parent_guardian_carer_as_an_emergency_safety_measure__if_in_the_child_s_best_interest__the_perpetrating_parent_guardian_will_receive_services_for_reunification__if_the_non_perpetrating_parent_guardian_is_able_to_protect_the_child__that_relationship_will_be_supported___go_on_to_suitability_principle__and_create_a_child_protection_plan_for_child__be88bc7"] = (self.data["is_this_a__significant_harm__case_or_a_regular_case__d49a084"].present?) ? true : false
  end

  def self.sortable_text_fields
    %w[name case_id_display national_id_no]
  end

  def self.quicksearch_fields
    # The fields family_count_no and dss_id are hacked in only because of Bangladesh
    # The fields camp_id, tent_number and nfi_distribution_id are hacked in only because of Iraq
    %w[ unique_identifier short_id case_id_display
        ration_card_no icrc_ref_no rc_id_no unhcr_id_no unhcr_individual_no un_no
        other_agency_id survivor_code_no national_id_no other_id_no biometrics_id
        family_count_no dss_id camp_id tent_number nfi_distribution_id ] + NAME_FIELDS
  end

  def update_basic_info
    self.data['sex'] = self.data['child_s_sex_2fe5059']
    self.data['age'] = self.data['child_s_age_f2599ad']
    self.data['name'] = self.data['child_s_name_8d017d7']
  end

  def self.summary_field_names
    common_summary_fields + %w[
      case_id_display name survivor_code_no age sex registration_date
      hidden_name workflow case_status_reopened module_id
    ]
  end

  def self.alert_count_self(current_user)
    records_owned_by = open_enabled_records.owned_by(current_user.user_name)
    records_referred_users =
      open_enabled_records.select { |record| record.referred_users.include?(current_user.user_name) }
    (records_referred_users + records_owned_by).uniq.count
  end

  def self.child_matching_field_names
    MatchingConfiguration.matchable_fields('case', false).pluck(:name) | MatchingConfiguration::DEFAULT_CHILD_FIELDS
  end

  def self.family_matching_field_names
    MatchingConfiguration.matchable_fields('case', true).pluck(:name) | MatchingConfiguration::DEFAULT_INQUIRER_FIELDS
  end

  def self.api_path
    '/api/v2/cases'
  end

  searchable do
    sortable_text_fields.each { |f| string("#{f}_sortable", as: "#{f}_sortable_sci") { data[f] }}
    Child.child_matching_field_names.each { |f| text_index(f, suffix: 'matchable') }
    Child.family_matching_field_names.each { |f| text_index(f, suffix: 'matchable', subform_field_name: 'family_details_section') }
    quicksearch_fields.each { |f| text_index(f) }
    %w[registration_date date_case_plan_initiated assessment_requested_on date_closure].each { |f| date(f) }
    %w[estimated urgent_protection_concern consent_for_tracing has_case_plan].each { |f| boolean(f) }
    %w[day_of_birth age].each { |f| integer(f) }
    %w[status sex current_care_arrangements_type].each { |f| string(f, as: "#{f}_sci") }
    string :risk_level, as: 'risk_level_sci' do
      risk_level.present? ? risk_level : RISK_LEVEL_NONE
    end
    string :protection_concerns, multiple: true

    date :assessment_due_dates, multiple: true do
      Tasks::AssessmentTask.from_case(self).map(&:due_date)
    end
    date :case_plan_due_dates, multiple: true do
      Tasks::CasePlanTask.from_case(self).map(&:due_date)
    end
    date :followup_due_dates, multiple: true do
      Tasks::FollowUpTask.from_case(self).map(&:due_date)
    end
    boolean(:has_incidents) { incidents.size.positive? }
  end

  validate  :validate_initial_assessment_starting_date,:validate_initial_assessment_ending_date,
            :validate_interviews_date, :validate_comprehensive_assessment_completed_date,
            :validate_comprehensive_assessment_started_date, :validate_case_plan_due_date, :validate_closure_date,
            :validate_protection_concerns_reported_date, if: -> { registration_date.present? }
  validate  :validate_date_of_birth, :validate_age, :validate_callers_age, :validate_callers_phone_no,
            :validate_mothers_age, :validate_fathers_age, :validate_guardians_age, :validate_mothers_phone_no, :validate_fathers_phone_no, :validate_guardians_phone_no,
            :validate_principals_phone_no, :validate_landline_no, :validate_alleged_perpetrator_phone_no, :validate_follow_up_phone_no, :validate_date_report_was_received,
            :validate_registration_completion_date, :validate_initial_assesment_start_date, :validate_interview_date_with_initial_assessment_completion_date, :validate_interview_date_with_initial_assessment_start_date

  before_validation :auto_fill_registration_date
  before_save :sync_protection_concerns, :check_for_sending_comprehensive_assessment
  before_save :auto_populate_name, :update_with_default_value_if_nil, :add_age_from_DOB, :send_notification_for_case_response, :auto_fill_significant_harm_cases, :autofill_risk_level_filter
  before_create :hide_name, :check_for_starting_initial_assessment_on_create
  after_save :save_incidents, :check_registration_completion_date, :check_date_and_time_initial_assessment_completed, :auto_fill_reported_by, :auto_fill_alternate_care_replacement_form
  after_create :assign_child_to_dcpu
  before_update :check_for_starting_initial_assessment

  alias super_defaults defaults
  def defaults
    super_defaults
    self.notes_section ||= []
  end

  def self.report_filters
    [
      { 'attribute' => 'status', 'value' => [STATUS_OPEN] },
      { 'attribute' => 'record_state', 'value' => ['true'] }
    ]
  end

  # TODO: does this need reporting location???
  # TODO: does this need the reporting_location_config field key
  # TODO: refactor with nested
  def self.minimum_reportable_fields
    {
      'boolean' => ['record_state'],
      'string' => %w[
        status sex risk_level owned_by_agency_id owned_by workflow workflow_status risk_level consent_reporting
      ],
      'multistring' => %w[associated_user_names owned_by_groups],
      'date' => ['registration_date'],
      'integer' => ['age'],
      'location' => %w[owned_by_location location_current]
    }
  end

  def autofill_risk_level_filter
    significant_harm = self.data['is_this_a__significant_harm__case_or_a_regular_case__d49a084']
    if significant_harm.present?
      self.data['risk_level'] = RISK_LEVEL_EXTREME
    else
      self.data['risk_level'] = RISK_LEVEL_HIGH
    end
  end

  def auto_fill_significant_harm_cases
    shc_flag1 = self.data['is_the_alleged_perpetrator_a_parent__guardian__or_care_giver_of_the_child__5000fdd']
    shc_flag2 = self.data['do_the_alleged_perpetrator_and_victim_live_in_the_same_household_or_facility__or_will_the_alleged_perpetrator_have_continuing_access_to_the_victim_without_intervention_by_the_court__f6b2249']
    shc_flag3 = self.data['has_the_victim_experienced__significant_harm__or_is_he_or_she_at_risk_of_more__significant_harm___without_intervention__fe0f2bc']
    shc_flag4 = self.data['does_the_child_need_to_be_rescued_from_his_her_environment__29bdbf9']

    if shc_flag1.present? || shc_flag2.present? || shc_flag3.present? || shc_flag4.present?
      self.data['is_this_a__significant_harm__case_or_a_regular_case__d49a084'] = true
    else
      self.data['is_this_a__significant_harm__case_or_a_regular_case__d49a084'] = false
    end
  end

  def self.nested_reportable_types
    [ReportableProtectionConcern, ReportableService, ReportableFollowUp]
  end

  def validate_date_of_birth
    return unless date_of_birth.present? && (!((Date.today - date_of_birth) / 365).floor.in? (0..17))

    errors.add(:date_of_birth, I18n.t('errors.models.child.date_of_birth'))
  end

  def validate_interview_date_with_initial_assessment_completion_date
    initial_assessment_completed = self.data['date_and_time_initial_assessment_was_completed_5c8fae2']
    interview_date = self.data['date_of_the_interview_13c582b']
    return if initial_assessment_completed.blank? || interview_date.blank?

    return if interview_date.to_date < initial_assessment_completed.to_date
    errors.add :base, :invalid, message: "Interview date should be before initial assessment completion date."
  end

  def validate_interview_date_with_initial_assessment_start_date
    initial_assessment_started = self.data['date_and_time_initial_assessment_started_a6e573c']
    interview_date = self.data['date_of_the_interview_13c582b']
    return if initial_assessment_started.blank? || interview_date.blank?

    return if interview_date.to_date > initial_assessment_started.to_date
    errors.add :base, :invalid, message: "Interview date should be after initial assessment start date."
  end

  def validate_date_report_was_received
    rep_date = data["date_report_was_received_900acf0"]
    reg_date = data["date_and_time_02a4a28"]
    return unless rep_date.present? && reg_date.present? && rep_date < reg_date.to_date

    errors.add :base, :invalid, message: "Date report was received date should come after the Date & time of call received to helpline."
  end

  def validate_registration_completion_date
    rep_date = data["date_report_was_received_900acf0"]
    reg_date = data["date_and_time_02a4a28"]
    reg_comp_date = data["date_and_time_registration_was_completed_42a39b3"]
    return unless rep_date.present? && reg_comp_date.present? && reg_comp_date.to_date < rep_date || reg_date.present? && reg_comp_date.present? && reg_comp_date.to_time < reg_date.to_time

    errors.add :base, :invalid, message: "Date and Time Registration was completed should come after the Date & time of call received to helpline and Date report received."
  end

  def validate_initial_assesment_start_date
    initial_assesment_started = self.data['date_and_time_initial_assessment_started_a6e573c']
    initial_assesment_completed = self.data['date_and_time_initial_assessment_was_completed_5c8fae2']
    return if initial_assesment_completed.blank?
    return if initial_assesment_started.present? && initial_assesment_completed.present? && (initial_assesment_started.to_date < initial_assesment_completed.to_date)

    errors.add :base, :invalid, message: "Initial asessment completion date should come after initial asessment start date"
  end

  def validate_age
    age = get_hash_keys_values("child_s_age")
    return unless age.present? && (age > 17)

    errors.add :age, :invalid, message:  "Please enter age between the range 0-17."
  end

  def validate_callers_age
    age = get_hash_keys_values("caller_s_age")
    return unless age.present? && (age < 5 || (age > 100))

    errors.add :base, :invalid, message: "Please enter caller's age between the range 5-100."
  end

  def validate_mothers_age
    age = get_hash_keys_values("mother_s_age")
    return unless age.present? && (age < 5 || age > 100)

    errors.add :base, :invalid, message: "Please enter mothers's age between the range 5-100."
  end

  def validate_fathers_age
    age = get_hash_keys_values("father_s_age")
    return unless age.present? && (age < 5 || age > 100)

    errors.add :base, :invalid, message: "Please enter father's age between the range 5-100."
  end

  def validate_guardians_age
    age = get_hash_keys_values("guardian_s_age")
    return unless age.present? && (age < 5 || age > 100)

    errors.add :base, :invalid, message: "Please enter guardian's age between the range 5-100."
  end

  def validate_callers_phone_no
    mobile = get_hash_keys_values("mobile")
    return if mobile.nil? || (mobile.present? && mobile.number? && mobile.size.in?(7..11))

    errors.add :base, :invalid, message: "Mobile number should be numeric and 7-11 digits long."
  end

  def validate_mothers_phone_no
    mobile = get_hash_keys_values("mother_s_phone_number")
    return if mobile.nil? || (mobile.present? && mobile.number? && mobile.size.in?(7..11))

    errors.add :base, :invalid, message: "Mothers phone number should be numeric and 7-11 digits long."
  end

  def validate_fathers_phone_no
    mobile = get_hash_keys_values("father_s_phone_number")
    return if mobile.nil? || (mobile.present? && mobile.number? && mobile.size.in?(7..11))

    errors.add :base, :invalid, message: "Fathers phone number should be numeric and 7-11 digits long."
  end

  def validate_guardians_phone_no
    mobile = get_hash_keys_values("guardian_s_contact_number")
    return if mobile.nil? || (mobile.present? && mobile.number? && mobile.size.in?(7..11))

    errors.add :base, :invalid, message: "Guardians contact number should be numeric and 7-11 digits long."
  end

  def validate_principals_phone_no
    mobile = get_hash_keys_values("contact_number_for_principal")
    return if mobile.nil? || (mobile.present? && mobile.number? && mobile.size.in?(7..11))

    errors.add :base, :invalid, message: "Principals contact number should be numeric and 7-11 digits long."
  end

  def validate_landline_no
    mobile = get_hash_keys_values("landline")
    return if mobile.nil? || (mobile.present? && mobile.number? && mobile.size.in?(7..11))

    errors.add :base, :invalid, message: "Landline number should be numeric and 7-11 digits long."
  end

  def validate_alleged_perpetrator_phone_no
    mobile = get_hash_keys_values("alleged_perpetrator_s_phone_number")
    return if mobile.nil? || mobile.blank? || (mobile.present? && mobile.number? && mobile.size.in?(7..11))

    errors.add :base, :invalid, message: "Alleged Perpetrator phone number should be numeric and 7-11 digits long."
  end

  def validate_follow_up_phone_no
    mobile = get_hash_keys_values("phone_number_for_follow_up")
    return if mobile.nil? || mobile.blank? || (mobile.present? && mobile.number? && mobile.size.in?(7..11))

    errors.add :base, :invalid, message: "Follow up phone number should be numeric and 7-11 digits long."
  end

  def validate_initial_assessment_starting_date
    date = get_hash_keys_values("date_and_time_initial_assessment_started")
    return unless date.present? && (date.to_date <= registration_date)

    errors.add :base, :invalid, message: "Assessment's starting date should come after the registration date."
  end

  def validate_initial_assessment_ending_date
    date = get_hash_keys_values("date_and_time_initial_assessment_was_completed")
    return unless date.present? && (date.to_date <= registration_date)

    errors.add :base, :invalid, message: "Assessment's completing date should come after the registration date."
  end
  
  def validate_interviews_date
    date = get_hash_keys_values("date_of_the_interview")
    return unless date.present? && (date.to_date <= registration_date)

    errors.add :base, :invalid, message: "Interview's date should come after the registration date."
  end
  
  def validate_protection_concerns_reported_date
    date = get_hash_keys_values("date_child_protection_concern_was_reported")
    return unless date.present? && (date.to_date <= registration_date)

    errors.add :base, :invalid, message: "Protection concerns reporting's date should come after the registration date."
  end
  
  def validate_comprehensive_assessment_completed_date
    date = get_hash_keys_values("date_comprehensive_assessment_completed")
    return unless date.present? && (date <= registration_date)

    errors.add :base, :invalid, message: "Comprehensive assessment's completing date should come after the registration date."
  end
  
  def validate_comprehensive_assessment_started_date
    date = get_hash_keys_values("date_comprehensive_assessment_started_c5394db")
    return unless date.present? && (date <= registration_date)

    errors.add :base, :invalid, message: "Comprehensive assessment's starting date should come after the registration date."
  end
  
  def validate_case_plan_due_date
    date = get_hash_keys_values("case_plan_due_date")
    return unless date.present? && (date <= registration_date)

    errors.add :base, :invalid, message: "Child Care plan due date should come after the registration date."
  end

  def validate_closure_date
  date = get_hash_keys_values("date_closure")
  return unless date.present? && (date <= registration_date)

  errors.add :base, :invalid, message: "Case closing due date should come after the registration date."
end

  alias super_update_properties update_properties
  def update_properties(user, data)
    build_or_update_incidents(user, (data.delete('incident_details') || []))
    self.mark_for_reopen = @incidents_to_save.present?
    super_update_properties(user, data)
  end

  def build_or_update_incidents(user, incidents_data)
    return unless incidents_data

    @incidents_to_save = incidents_data.map do |incident_data|
      incident = Incident.find_by(id: incident_data['unique_id'])
      incident ||= IncidentCreationService.incident_from_case(self, incident_data, module_id, user)
      unless incident.new_record?
        incident_data.delete('unique_id')
        incident.data = RecordMergeDataHashService.merge_data(incident.data, incident_data) unless incident.new_record?
      end
      incident.has_changes_to_save? ? incident : nil
    end.compact
  end

  def save_incidents
    return unless @incidents_to_save

    Incident.transaction do
      @incidents_to_save.each(&:save!)
    end
  end

  def to_s
    name.present? ? "#{name} (#{unique_identifier})" : unique_identifier
  end

  def auto_populate_name
    # This 2 step process is necessary because you don't want to overwrite self.name if auto_populate is off
    a_name = auto_populate('name')
    self.name = a_name if a_name.present?
  end

  def hide_name
    self.hidden_name = true if module_id == PrimeroModule::GBV
  end

  def set_instance_id
    system_settings = SystemSettings.current
    self.case_id ||= unique_identifier
    self.case_id_code ||= auto_populate('case_id_code', system_settings)
    self.case_id_display ||= create_case_id_display(system_settings)
  end

  def create_case_id_code(system_settings)
    separator = system_settings&.case_code_separator.present? ? system_settings.case_code_separator : ''
    id_code_parts = []
    if system_settings.present? && system_settings.case_code_format.present?
      system_settings.case_code_format.each { |cf| id_code_parts << PropertyEvaluator.evaluate(self, cf) }
    end
    id_code_parts.reject(&:blank?).join(separator)
  end

  def create_case_id_display(system_settings)
    [case_id_code, short_id].compact.join(auto_populate_separator('case_id_code', system_settings))
  end

  def display_id
    case_id_display
  end

  def day_of_birth
    return nil unless date_of_birth.is_a? Date

    AgeService.day_of_year(date_of_birth)
  end

  def case_plan?
    interventions = data['cp_case_plan_subform_case_plan_interventions']
    return false if interventions.blank?

    plan = interventions.find_index do |i|
      i['intervention_service_to_be_provided'].present? ||
        i['intervention_service_goal'].present?
    end
    plan.present?
  end
  alias has_case_plan case_plan?

  def sync_protection_concerns
    protection_concerns = self.data["types_of_abuse_fc733c0"] || []
    from_subforms = protection_concern_detail_subform_section&.map { |pc| pc['protection_concern_type'] }&.compact || []
    self.protection_concerns = (protection_concerns + from_subforms).uniq
  end

  def self.protection_concern_stats(user)
    name = user.role.name
    return { permission: false } unless name.in? ['CPO', 'Referral', 'CPI In-charge', 'CP Manager']

    stats = {
      gbv_survivor: { cases: 0, percentage: 0 },
      statelessness: { cases: 0, percentage: 0 },
      trafficked_smuggled: { cases: 0, percentage: 0 },
      arrested_detained: { cases: 0, percentage: 0 },
      sexually_exploited: { cases: 0, percentage: 0 },
    }

    total_case_count = Child.get_childs(user, "significant", "registered").count
    Child.get_childs(user, "significant").each do |child|
      stats.each do |key, value|
        next unless key.to_s.in? child.protection_concerns

        stats[key][:cases] += 1
      end
    end.count

    stats.each do |key, value|
      value[:percentage] = get_percentage(value[:cases], total_case_count) unless total_case_count.eql?(0)
    end
    total_cases =  {
      physically_or_mentally_abused: { cases: stats[:arrested_detained][:cases], percentage: stats[:arrested_detained][:percentage]},
      street_child: { cases: stats[:statelessness][:cases], percentage: stats[:statelessness][:percentage]},
      neglect_or_negligent_treatment: { cases: stats[:trafficked_smuggled][:cases], percentage: stats[:trafficked_smuggled][:percentage]},
      exploitation: { cases: stats[:gbv_survivor][:cases], percentage: stats[:gbv_survivor][:percentage]},
      sexual_abuse_or_exploitation: { cases: stats[:sexually_exploited][:cases], percentage: stats[:sexually_exploited][:percentage]},
    }

    total_cases
  end

  def self.get_childs(user, significant_harm = nil, registered = nil)
    case user.role.name
    when "CP Manager"
      with_province(user)
    when "CPI In-charge"
      get_cases_for_particular_user_group(user.user_groups, significant_harm)
    when "CPO"
      get_cases_assigned_to_specific_user(user, significant_harm, registered).results
    else
      get_cases_with_district_and_agency(user, significant_harm)
    end
  end
  
  def self.get_resolved_cases_for_role(user, significant_harm = nil)
    case user.role.name
    when "CP Manager"
      get_resolved_cases_by_province_and_agency(user, significant_harm)
    when "CPI In-charge"
      get_resolved_cases_for_particular_user_group(user.user_groups, significant_harm).results
    when "CPO"
      get_resolved_cases_with_user(user.user_name, significant_harm).results
    else
      get_resolved_cases_with_district_and_agency(user, significant_harm)
    end
  end

  def self.get_closed_cases_for_role(user, significant_harm = nil)
    case user.role.name
    when "CP Manager"
      get_closed_cases_by_province_and_agency(user, significant_harm)
    when "CPI In-charge"
      get_closed_cases_for_particular_user_group(user.user_groups, significant_harm).results
    when "CPO"
      get_closed_cases_by_user(user.user_name, significant_harm).results
    else
      get_closed_cases_with_district_and_agency(user, significant_harm)
    end
  end

  def self.get_cases_with_district_and_agency(user, significant_harm = nil)
    usernames = user.agency.users.pluck(:user_name)
    cases = Child.search do
      with(:is_this_a__significant_harm__case_or_a_regular_case__d49a084, true) if significant_harm.present?
      any_of do
        with(:owned_by, usernames)
        with(:owned_by_location, user.location)
      end
    end

    search = Child.search do
       with(:is_this_a__significant_harm__case_or_a_regular_case__d49a084, true) if significant_harm.present?
      any_of do
        with(:owned_by, usernames)
        with(:owned_by_location, user.location)
      end
      paginate :page => 1, :per_page => cases.total
    end

    search.results
  end

  def self.get_resolved_cases_with_district_and_agency(user, significant_harm = nil)
    usernames = user.agency.users.pluck(:user_name)
    cases = Child.search do
      with(:status, "closed")
       with(:is_this_a__significant_harm__case_or_a_regular_case__d49a084, true) if significant_harm.present?
      any_of do
        with(:owned_by, usernames)
        with(:owned_by_location, user.location)
      end
      any_of do
        with(:case_goals_all_met_601e9c9, true)
        with(:case_goals_substantially_met_and_there_is_no_child_protection_concern_b0f5a44, true)
      end
    end

    search = Child.search do
      with(:status, "closed")
       with(:is_this_a__significant_harm__case_or_a_regular_case__d49a084, true) if significant_harm.present?
      any_of do
        with(:owned_by, usernames)
        with(:owned_by_location, user.location)
      end
      any_of do
        with(:case_goals_all_met_601e9c9, true)
        with(:case_goals_substantially_met_and_there_is_no_child_protection_concern_b0f5a44, true)
      end
      paginate :page => 1, :per_page => cases.total
    end

    search.results
  end

  def self.get_closed_cases_with_district_and_agency(user, significant_harm = nil)
    usernames = user.agency.users.pluck(:user_name)
    cases = Child.search do
      with(:status, "closed")
      with(:is_this_a__significant_harm__case_or_a_regular_case__d49a084, true) if significant_harm.present?
      any_of do
        with(:owned_by, usernames)
        with(:owned_by_location, user.location)
      end
    end

    search = Child.search do
      with(:status, "closed")
      with(:is_this_a__significant_harm__case_or_a_regular_case__d49a084, true) if significant_harm.present?
      any_of do
        with(:owned_by, usernames)
        with(:owned_by_location, user.location)
      end
      paginate :page => 1, :per_page => cases.total
    end

    search.results
  end
  
  def self.get_resolved_cases_by_province_and_agency(user, significant_harm = nil)
    usernames = user.agency.users.pluck(:user_name)
    province = with_province(user)
    search = Child.search do
      with(:status, "closed")
      with(:is_this_a__significant_harm__case_or_a_regular_case__d49a084, true) if significant_harm.present?
      any_of do
        with(:owned_by, usernames)
        with(:owned_by_location, province)
      end
      any_of do
        with(:case_goals_all_met_601e9c9, true)
        with(:case_goals_substantially_met_and_there_is_no_child_protection_concern_b0f5a44, true)
      end
    end

    search.results
  end

  def self.get_closed_cases_by_province_and_agency(user, significant_harm = nil)
    usernames = user.agency.users.pluck(:user_name)
    province = with_province(user)
    cases = Child.search do
      with(:status, "closed")
      with(:is_this_a__significant_harm__case_or_a_regular_case__d49a084, true) if significant_harm.present?
      any_of do
        with(:owned_by, usernames)
        with(:owned_by_location, province)
      end
    end

    search = Child.search do
      with(:status, "closed")
      with(:is_this_a__significant_harm__case_or_a_regular_case__d49a084, true) if significant_harm.present?
      any_of do
        with(:owned_by, usernames)
        with(:owned_by_location, province)
      end
      paginate :page => 1, :per_page => cases.total
    end

    search.results
  end

  def self.get_cases_with_agency(agency_id)
    search = Child.search do
      with(:owned_by_agency_id, agency_id)
    end

    search
  end

  def match_criteria
    match_criteria = data.slice(*Child.child_matching_field_names).compact
    match_criteria = match_criteria.merge(
      Child.family_matching_field_names.map do |field_name|
        [field_name, values_from_subform('family_details_section', field_name)]
      end.to_h
    )
    match_criteria = match_criteria.transform_values { |v| v.is_a?(Array) ? v.join(' ') : v }
    match_criteria.select { |_, v| v.present? }
  end

  def matches_to
    Trace
  end

  def associations_as_data(current_user = nil)
    return @associations_as_data if @associations_as_data

    incident_details = RecordScopeService.scope_with_user(incidents, current_user).map do |incident|
      incident.data&.reject { |_, v| RecordMergeDataHashService.array_of_hashes?(v) }
    end.compact || []
    @associations_as_data = { 'incident_details' => incident_details }
  end

  def associations_as_data_keys
    %w[incident_details]
  end

  def self.resolved_cases_by_gender_and_types_of_violence(user)
    return { permission: false } unless user.role.name.in? ['CPI In-charge', 'CPO', 'CP Manager']

    result = {}
    result["stats"] =  {
      arrested_detained: { male: 0, female: 0, transgender: 0 },
      statelessness: { male: 0, female: 0, transgender: 0 },
      trafficked_smuggled: { male: 0, female: 0, transgender: 0 },
      gbv_survivor: { male: 0, female: 0, transgender: 0 },
      sexually_exploited: { male: 0, female: 0, transgender: 0 },
    }

    get_resolved_cases_for_role(user).each do |child|
      result["stats"].each do |key, value|
        next unless key.to_s.in? child.protection_concerns

        gender = child.data["child_s_sex_2fe5059"]
        next unless gender

        case gender
        when "male"
          result["stats"][key][:male] += 1
        when "female"
          result["stats"][key][:female] += 1
        else
          result["stats"][key][:transgender] += 1
        end
      end
    end

    result
  end

  def self.registered_resolved_cases_by_district(user)
    return { permission: false } unless user.role.name.eql?('CP Manager')

    stats = {}
    districts = Location.with_type_district

    Child.get_registered_and_resolved_cases.results.each do |child|
      next unless child.data["location_current"].in? districts

      location = Location.find_by_location_code(child.location_current)&.placename_en
      stats[location] = {registered_cases: 0, resolved_cases: 0} unless stats[location]
      stats[location][:registered_cases] += 1 if child.data["child_s_age_f2599ad"].present? && child.data["status"].eql?("open")
      stats[location][:resolved_cases] += 1 if (child.data["case_goals_all_met_601e9c9"] || child.data["case_goals_substantially_met_and_there_is_no_child_protection_concern_b0f5a44"]) && child.data["status"].eql?("closed")
    end

    stats
  end

  def self.get_gender_hash
    gender_list = {
      "male" => 0,
      "female" => 0,
      "transgender" => 0,
      "total" => 0
    }

    gender_list
  end

  def self.hash_return_for_month_wise_api
    month_list = {
      "Jan" => get_gender_hash,
      "Feb" => get_gender_hash,
      "Mar" => get_gender_hash,
      "Apr" => get_gender_hash,
      "May" => get_gender_hash,
      "Jun" => get_gender_hash,
      "Jul" => get_gender_hash,
      "Aug" => get_gender_hash,
      "Sep" => get_gender_hash,
      "Oct" => get_gender_hash,
      "Nov" => get_gender_hash,
      "Dec" => get_gender_hash,
    }

    month_list
  end

  def self.month_wise_registered_and_resolved_cases(user)
    name = user.role.name
    return { permission: false } unless name.in? ['CPO', 'Referral', 'CPI In-charge', 'CP Manager']

    stats = {
      "Resolved" => hash_return_for_month_wise_api,
      "Registered" => hash_return_for_month_wise_api
    }
    Child.get_childs(user).each do |child|
      day = child.created_at
      next unless day.to_date.in? (Date.today.prev_year..Date.today)

      key = day.strftime("%B")[0,3]
      gender = (child.data["child_s_sex_2fe5059"].in? ["male", "female"]) ? child.data["child_s_sex_2fe5059"] : "transgender"

      if child.age.present? && child.data["status"].eql?("open")
        stats["Registered"][key][gender] += 1
        stats["Registered"][key]["total"] += 1
      elsif child.data["status"].eql?("closed")
        stats["Resolved"][key][gender] += 1
        stats["Resolved"][key]["total"] += 1
      end
    end

    stats
  end

  def self.resolved_cases_department_wise(user)
    return { permission: false } unless user.role.unique_id == "role-cp-manager"
    cases = { }

    Child.get_resolved_cases.results.each do |child|
      cases["#{child.data["owned_by_agency_id"]}"] = 0 unless cases["#{child.data["owned_by_agency_id"]}"].present?
      cases["#{child.data["owned_by_agency_id"]}"] += 1
    end

    cases
  end

  def self.get_demographic_child_cases_for_user_group(usernames)
    search = Child.search do
      with(:owned_by, usernames)
      any_of do
        with(:is_child_an_ethnic_minority__5d99703, true)
        with(:is_child_a_religious_minority__48d6e93, true)
        with(:are_parents_guardians_bisp_beneficiary__ac4c758, true)
        without(:type_of_disability_b97c7ca, nil)
      end
    end

    search
  end

  def self.demographic_analysis(user)
    return { permission: false } unless user.role.name.in? ['CPO', 'Referral', 'CPI In-charge', 'CP Manager']

    total_cases = Child.count
    stats = {
      "No. of Minority Cases" => 0,
      "No. of Children with Disabilities (CWB)" => 0,
      "No. of BISP Beneficiaries" => 0
    }
    demographic_cases = user.role.name == "CPI In-charge" ? get_demographic_child_cases_for_user_group(user.user_groups.first.users.pluck(:user_name)) : demographic_childs

    demographic_cases.results.each do |child|
      stats["No. of Minority Cases"] += 1 if child.data["is_child_an_ethnic_minority__5d99703"] || child.data["is_child_a_religious_minority__48d6e93"]
      stats["No. of Children with Disabilities (CWB)"] += 1 if child.data["type_of_disability_b97c7ca"].present?
      stats["No. of BISP Beneficiaries"] += 1 if child.data["are_parents_guardians_bisp_beneficiary__ac4c758"]
    end

    stats_final = [stats["No. of Minority Cases"], stats["No. of Children with Disabilities (CWB)"], stats["No. of BISP Beneficiaries"]]
    stats_final
  end

  def self.resolved_cases_by_age_and_violence(user)
    return { permission: false } unless ['CP Manager', 'CPI In-charge', 'CPO', 'Referral'].include?(user.role.name)
    cases = {}

    get_closed_cases_for_role(user).each do |child|
      unless cases["#{child.data["child_s_age_f2599ad"]}"]
        cases["#{child.data["child_s_age_f2599ad"]}"] = {
          "gbv_survivor": 0,
          "statelessness": 0,
          "trafficked_smuggled": 0,
          "arrested_detained": 0,
          "sexually_exploited": 0
        }
      end

      cases["#{child.data["child_s_age_f2599ad"]}"].each do |key, value|
        next unless key.to_s.in? child.protection_concerns
        cases["#{child.data["child_s_age_f2599ad"]}"][key] += 1
      end
    end

    cases
  end

  def auto_fill_registration_date
    return unless changes_to_save_for_record.key?(self.match_key_from_pattern("date_and_time_registration_was_completed"))
    data["registration_date"] = self.get_hash_keys_values("date_and_time_registration_was_completed")
  end

  def check_registration_completion_date
    is_this_significant_harm_case = self.get_hash_keys_values("is_this_a__significant_harm__case_or_a_regular_case")
    return unless data['start_initial_assessment']

    case_type = is_this_significant_harm_case ? 'Significant Harm' : 'Regular'
    username = self.data["last_updated_by"].present? ? self.data["last_updated_by"] : self.data["owned_by"]
    user_id = User.find_by_user_name(username).id
    due_date = self.data["due_date_for_initial_assessment_0e82430"].to_s
    AssessmentMailer.start_initial_assessment(self.id, case_type, user_id, due_date).deliver_later
    AssessmentMailJob.set(wait_until: Time.now + 5.days).perform_later(user_id, self.id, due_date.to_s) unless self.get_hash_keys_values("date_and_time_initial_assessment_was_completed")
  end

  def check_for_starting_initial_assessment
    return data['start_initial_assessment'] = false unless changes_to_save_for_record.key?(self.match_key_from_pattern("date_and_time_registration_was_completed"))

    data['start_initial_assessment'] = true
  end

  def check_for_starting_initial_assessment_on_create
    return data['start_initial_assessment'] = false unless data[self.match_key_from_pattern("date_and_time_registration_was_completed")].present?

    data['start_initial_assessment'] = true
  end

  def check_for_sending_comprehensive_assessment
    return data['start_comprehensive_assessment'] = false unless changes_to_save_for_record.key?(self.match_key_from_pattern("date_and_time_initial_assessment_was_completed"))

    data['start_comprehensive_assessment'] = true
  end

  def check_date_and_time_initial_assessment_completed
    return unless data['start_comprehensive_assessment'] && self.data["auto_schedule_comprehensive_assessment"]

    case_type = self.get_hash_keys_values("is_this_a__significant_harm__case_or_a_regular_case") ? 'Significant Harm' : 'Regular'
    username = self.data["last_updated_by"].present? ? self.data["last_updated_by"] : self.data["owned_by"]
    user_id = User.find_by_user_name(username).id
    due_date = self.data['if_the_child_is_in_need_of_such_services__the_comprehensive_assessment_shall_commence_immediately_and_be_completed_within_15_days_of_this_report__that_is__by_8832cc6']
    AssessmentMailer.start_comprehensive_assessment(self.id, user_id, case_type, due_date).deliver_later
  end

  def match_key_from_pattern(key_name)
    self.data.select{ |key,value| key[key_name] }.keys.last
  end

  def get_days_for_scheduling
    self.get_hash_keys_values("is_this_a_significant_harm_case_or_a_regular_case") == RISK_LEVEL_HIGH ? 15 : 4
  end

  def get_hash_keys_values(field_name)
    data.select { |key, value| key.to_s.match(/#{field_name}/) }.values.last
  end

  def update_with_default_value_if_nil
    self.data["auto_schedule_comprehensive_assessment"] = false unless self.data["auto_schedule_initial_assessment"].blank?
  end

  def self.demographic_childs
    search = Child.search do
      any_of do
        with(:is_child_an_ethnic_minority__5d99703, true)
        with(:is_child_a_religious_minority__48d6e93, true)
        with(:are_parents_guardians_bisp_beneficiary__ac4c758, true)
        without(:type_of_disability_b97c7ca, nil)
      end
    end

    search
  end

  def self.rejected_transfer_case
    search = Child.search do
      with(:transfer_status, "rejected")
    end

    search
  end

  def self.rejected_transfer_case_with_user(username)
    search = Child.search do
      with(:transfer_status, "rejected")
      with(:owned_by, username)
    end
    
    search
  end

  def self.rejected_transfer_case_with_user_group(user_groups)
    search = Child.search do
      with(:transfer_status, "rejected")
      with(:owned_by_groups, user_groups)
    end
    
    search
  end

  def self.significant_harm_cases_registered_by_age_and_gender(user)
    name = user.role.name
    return { permission: false } unless name.in? ['CPO', 'CPI In-charge']

    stats = {
      gbv_survivor: { cases: 0},
      statelessness: { cases: 0},
      trafficked_smuggled: { cases: 0},
      arrested_detained: { cases: 0},
      sexually_exploited: { cases: 0}
    }

    Child.get_childs(user, "significant").each do |child|
      stats.each do |key, value|
        next unless key.to_s.in? child.protection_concerns

        stats[key][:cases] += 1
      end
    end

    total_cases = [stats[:arrested_detained][:cases], stats[:statelessness][:cases], stats[:trafficked_smuggled][:cases], stats[:gbv_survivor][:cases], stats[:sexually_exploited][:cases]]
    total_cases
  end

  def assign_child_to_dcpu
    created_by = User.find_by(user_name: self.data["created_by"])
    return if created_by.role.name != "CPHO"

    case_location = self.data["district_2647797"]
    return if case_location.blank?
    location_code = Location.find_by("cast(hierarchy_path as text) LIKE ? AND type = 'district'", "%#{Location.find_by(location_code: case_location).hierarchy_path.split('.').second}%").location_code
    dcpu_admin = User.includes(:role).find_by(agency_id: created_by.agency_id, location: location_code, roles: {name: 'CPI In-charge'})
    return if dcpu_admin.blank?

    Assign.create!(
      record: self, transitioned_to: dcpu_admin.user_name,
      transitioned_by: created_by.user_name
    )
  end

  def add_date_of_birth
    age = get_hash_keys_values("child_s_age")
    return if age.blank? || date_of_birth.present?

    data['date_of_birth'] = Date.today.beginning_of_year - age.years
  end
  
  def add_age_from_DOB
    birth_date = get_hash_keys_values("date_of_birth")
    return if birth_date.blank? || data['child_s_age_f2599ad'].present?

    calculated_age = ((Time.zone.now - birth_date.to_time) / 1.year.seconds).floor
    data['child_s_age_f2599ad'] = calculated_age
    data["is_the_survivor_under_18_years_of_age__561695b"] = calculated_age.in?(0..17) ? true : false
  end

  def self.get_closed_cases
    search = Child.search do
      any_of do
        with(:child_s_age_f2599ad, nil)
        with(:status, "closed")
        all_of do
          with(:i_certify_that_the_above_reported_facts_and_findings_are_true_to_the_best_of_my_knowledge__based_on_the_above_findings__i_conclude_that_the_above_named_child_is_in_need_of_child_protection_services__40be6e0, false)
          without(:date_and_time_initial_assessment_was_completed_5c8fae2, nil)
        end
      end
    end

    search
  end

  def self.get_closed_cases_with_user(username)
    search = Child.search do
      with(:owned_by, username)
      any_of do
        with(:child_s_age_f2599ad, nil)
        with(:status, "closed")
        all_of do
          with(:i_certify_that_the_above_reported_facts_and_findings_are_true_to_the_best_of_my_knowledge__based_on_the_above_findings__i_conclude_that_the_above_named_child_is_in_need_of_child_protection_services__40be6e0, false)
          without(:date_and_time_initial_assessment_was_completed_5c8fae2, nil)
        end
      end
    end

    search
  end

  def self.get_registered_cases
    search = Child.search do
      without(:child_s_age_f2599ad, nil)
      without(:status, "closed")
    end

    search
  end

  def self.get_registered_cases_with_user(username)
    search = Child.search do
      with(:owned_by, username)
      without(:child_s_age_f2599ad, nil)
      without(:status, "closed")
    end

    search
  end

  def self.get_registered_cases_with_user_group(user_groups)
    search = Child.search do
      with(:owned_by_groups, user_groups)
      without(:child_s_age_f2599ad, nil)
      without(:status, "closed")
    end

    search
  end

  def self.get_resolved_cases
    search = Child.search do
      with(:status, "closed")
      any_of do
        with(:case_goals_all_met_601e9c9, true)
        with(:case_goals_substantially_met_and_there_is_no_child_protection_concern_b0f5a44, true)
      end
    end

    search
  end


  def self.get_registered_and_resolved_cases
    search = Child.search do
      any_of do
       without(:child_s_age_f2599ad, nil)
        any_of do
          with(:case_goals_all_met_601e9c9, true)
          with(:case_goals_substantially_met_and_there_is_no_child_protection_concern_b0f5a44, true)
        end
      end
    end

    search
  end

  def self.get_percentage(value, count)
    ((value / count.to_f) * 100).round
  end

  def update_case_worflow_to_referrals
    new_data = data
    data['workflow'] = Workflow::WORKFLOW_REFERRALS

    update_column(:data, new_data)
  end

  def self.get_cases_assigned_to_specific_user(user, significant_harm = nil, registered = nil)
    cases = Child.search do
      with(:owned_by, user.user_name)
      with(:is_this_a__significant_harm__case_or_a_regular_case__d49a084, true) if significant_harm.present?
      without(:date_and_time_registration_was_completed_529de5d, nil) if registered.present?
    end

    search = Child.search do
      with(:owned_by, user.user_name)
      with(:is_this_a__significant_harm__case_or_a_regular_case__d49a084, true) if significant_harm.present?
      without(:date_and_time_registration_was_completed_529de5d, nil) if registered.present?
      paginate :page => 1, :per_page => cases.total
    end

    search
  end

  def self.get_significant_harm_cases
    search = Child.search do
      with(:is_this_a__significant_harm__case_or_a_regular_case__d49a084, true)
    end

    search
  end

  def self.get_significant_harm_cases_with_user(username)
    search = Child.search do
      with(:owned_by, username)
      with(:is_this_a__significant_harm__case_or_a_regular_case__d49a084, true)
    end

    search
  end

  def self.get_significant_harm_cases_with_user_group(user_groups)
    search = Child.search do
      with(:owned_by_groups, user_groups)
      with(:is_this_a__significant_harm__case_or_a_regular_case__d49a084, true)
    end

    search
  end

  def self.get_child_statuses(user)
    role_name = user.role.name
    return { permission: false } unless ['CPI In-charge', 'CPO', 'CP Manager', 'Referral'].include?(role_name)

    case role_name
    when "CPO"
      registered_cases = Child.get_registered_cases_with_user(user.user_name).total
      harm_cases = Child.get_significant_harm_cases_with_user(user.user_name).total
    when "CPI In-charge"
      registered_cases = get_registered_cases_with_user_group(user.user_groups.pluck(:unique_id)).total
      harm_cases = Child.get_significant_harm_cases_with_user_group(user.user_groups.pluck(:unique_id)).total
    else
      registered_cases = Child.get_registered_cases.total
      harm_cases = Child.get_significant_harm_cases.total
    end

    if role_name.in? ["CPI In-charge", "CPO"]
      resolved_cases = role_name.eql?("CPO") ? Child.get_resolved_cases_with_user(user.user_name).total : Child.get_resolved_cases_with_user(user.user_groups.first.users.pluck(:user_name)).total
      closed_cases = role_name.eql?("CPO") ? Child.get_closed_cases_with_user(user.user_name).total : Child.get_closed_cases_with_user(user.user_groups.first.users.pluck(:user_name)).total
    end
    statuses = { "stats" => {} }

    statuses["stats"]["Role"] = role_name
    statuses["stats"]["Number of Cases"] = Child.count
    statuses["stats"]["data"] = { "Registered (Open)": registered_cases, "Emergency Cases": harm_cases }
    statuses["stats"]["data"].merge!("Pending Approval for Closure": Child.pending_cases_to_assigned(user.user_groups.first.users.pluck(:user_name)).size) if role_name.eql?("CPI In-charge")
    statuses["stats"]["data"].merge!("Closed": closed_cases) if role_name.in? ["CPI In-charge", "CPO"]
    statuses["stats"]["data"].merge!("Assigned to Me": Child.get_cases_assigned_to_specific_user(user).total) if role_name.eql?("CPO")

    statuses
  end

  def send_notification_for_case_response
    date_of_case_referred = self.match_key_from_pattern("date_of_case_referred")
    return unless changes_to_save_for_record.key?(date_of_case_referred)

    users = []
    focal_person = User.find_by_user_name(self.data['last_updated_by'])
    users << [focal_person.email, "focal_person"]
    cpo = Agency.get_cpo(self.data["owned_by_agency_id"])
    users << [cpo.email, "cpo"]

    return if users.empty?

    users.each do |user|
      NotificationMailer.send_response_notification(self.short_id, user.first, user.last).deliver_later
    end
  end

  def self.get_cases_with_supervision_order(user)
    role = user.role.name
    return { permission: false } unless ['CPI In-charge', 'CPO'].include?(role)

    return cases = { "cases_with_supervision_order" => Child.attachment_with_specific_type(user.user_groups.first.users.pluck(:user_name), "supervision_order").size } if role.eql?("CPI In-charge")

    cases = { "cases_with_supervision_order" => Child.attachment_with_specific_type_and_user(user.user_name, "supervision_order").size }
  end

  def self.get_cases_with_custody_order(user)
    role = user.role.name
    return { permission: false } unless ['CPI In-charge', 'CPO'].include?(role)

    return cases = { "cases_with_custody_order" => Child.attachment_with_specific_type(user.user_groups.first.users.pluck(:user_name), "custody_and_placement_order").size } if role.eql?("CPI In-charge")

    cases = { "cases_with_custody_order" => Child.attachment_with_specific_type_and_user(user.user_name, "custody_and_placement_order").size }
  end

  def self.get_cases_with_court_orders(user)
    role = user.role.name
    return { permission: false } unless ['CPI In-charge', 'CPO', 'CP Manager'].include?(role)

    cases = {
      "supervision_order" => 0, "permanent_custody_placement_order" => 0, "interim_custody_placement_order" => 0, "seek_and_find_order" => 0
    }

    cases["supervision_order"] = Child.attachment_with_specific_type(user.user_groups.first.users.pluck(:user_name), "supervision_order").size if role.eql?("CPI In-charge")
    cases["permanent_custody_placement_order"] = Child.attachment_with_specific_type(user.user_groups.first.users.pluck(:user_name), "permanent_custody_placement_order").size if role.eql?("CPI In-charge")
    cases["interim_custody_placement_order"] = Child.attachment_with_specific_type(user.user_groups.first.users.pluck(:user_name), "interim_custody_placement_order").size if role.eql?("CPI In-charge")
    cases["seek_and_find_order"] = Child.attachment_with_specific_type(user.user_groups.first.users.pluck(:user_name), "seek_and_find_order").size if role.eql?("CPI In-charge")

    cases["supervision_order"] = Child.attachment_with_specific_type_and_user(user.user_name, "supervision_order").size if role.eql?("CPO")
    cases["permanent_custody_placement_order"] = Child.attachment_with_specific_type_and_user(user.user_name, "permanent_custody_placement_order").size if role.eql?("CPO")
    cases["interim_custody_placement_order"] = Child.attachment_with_specific_type_and_user(user.user_name, "interim_custody_placement_order").size if role.eql?("CPO")
    cases["seek_and_find_order"] = Child.attachment_with_specific_type_and_user(user.user_name, "seek_and_find_order").size if role.eql?("CPO")

    cases["supervision_order"] = Child.attachment_with_specific_type_and_province(user, "supervision_order").size
    cases["permanent_custody_placement_order"] = Child.attachment_with_specific_type_and_province(user, "permanent_custody_placement_order").size
    cases["interim_custody_placement_order"] = Child.attachment_with_specific_type_and_province(user, "interim_custody_placement_order").size
    cases["seek_and_find_order"] = Child.attachment_with_specific_type_and_province(user, "seek_and_find_order").size

    cases_array = [cases["supervision_order"], cases["permanent_custody_placement_order"], cases["interim_custody_placement_order"], cases["seek_and_find_order"]]
    cases_array
  end

  def auto_fill_reported_by
    role = User.find_by_user_name(self.data["created_by"]).role.name
    return unless role.eql?("CPO")

    new_data = self.data.merge(reported_by_4646c1e: self.data["created_by"])
    self.update_column(:data, new_data)
  end

  def auto_fill_alternate_care_replacement_form
    return if self.data["owned_by_agency_id"].blank?

    cpo = Agency.find_by_unique_id(self.data["owned_by_agency_id"]).users.includes(:role).find_by(role: { name:"CPO" })
    dcpu = Agency.find_by_unique_id(self.data["owned_by_agency_id"]).users.includes(:role).find_by(role: { name:"CPI In-charge" })
    return if cpo.blank? && dcpu.blank?
    
    new_data = self.data.merge(name_of_cpo_fc3e1d1: cpo.user_name) if cpo.present?
    self.update_column(:data, new_data) if new_data.present?

    new_data = self.data.merge(name_of_supervisor_0a7ec8b: dcpu.user_name) if dcpu.present?
    self.update_column(:data, new_data) if new_data.present?
  end

  def self.get_reffered_and_resolved_cases
    search = Child.search do
      any_of do 
        without(:assigned_user_names, nil)
        with(:status, "closed")
        any_of do
          with(:case_goals_all_met_601e9c9, true)
          with(:case_goals_substantially_met_and_there_is_no_child_protection_concern_b0f5a44, true)
        end
      end
    end

    search
  end

  def self.get_resolved_cases_with_user(username , significant_harm = nil)
    cases = Child.search do
      with(:owned_by, username)
      with(:status, "closed")
      with(:is_this_a__significant_harm__case_or_a_regular_case__d49a084, true) if significant_harm.present?
      any_of do
        with(:case_goals_all_met_601e9c9, true)
        with(:case_goals_substantially_met_and_there_is_no_child_protection_concern_b0f5a44, true)
      end
    end

    search = Child.search do
      with(:owned_by, username)
      with(:status, "closed")
      with(:is_this_a__significant_harm__case_or_a_regular_case__d49a084, true) if significant_harm.present?
      any_of do
        with(:case_goals_all_met_601e9c9, true)
        with(:case_goals_substantially_met_and_there_is_no_child_protection_concern_b0f5a44, true)
      end
      paginate :page => 1, :per_page => cases.total
    end

    search
  end

  def self.get_closed_cases_by_user(username, significant_harm = nil)
    cases = Child.search do
      with(:owned_by, username)
      with(:status, "closed")
      with(:is_this_a__significant_harm__case_or_a_regular_case__d49a084, true) if significant_harm.present?
    end

    search = Child.search do
      with(:owned_by, username)
      with(:status, "closed")
      with(:is_this_a__significant_harm__case_or_a_regular_case__d49a084, true) if significant_harm.present?
      paginate :page => 1, :per_page => cases.total
    end

    search
  end

  def self.get_service_provided_childs_with_age_type_of_violence
    cases = Child.search do
      without(:make__if_other__please_specify__appear_dynamically_83aa4ee, nil)
      without(:child_s_age_f2599ad, nil)
      without(:types_of_abuse_fc733c0, nil)
    end

    search = Child.search do
      without(:make__if_other__please_specify__appear_dynamically_83aa4ee, nil)
      without(:child_s_age_f2599ad, nil)
      without(:types_of_abuse_fc733c0, nil)
      paginate :page => 1, :per_page => cases.total
    end

    search
  end

  def self.referred_resolved_cases_by_department(user)
    return { permission: false } unless user.role.name.eql?('CP Manager')

    stats = {}
    Agency.all.each do |agency|
      stats.merge!({ agency.name => { "Reffered Cases" => 0, "Resolved Cases" => 0 } })
    end

    Child.get_reffered_and_resolved_cases.results.each do |child|
      next unless child.data["assigned_user_names"].present?

      child.data["assigned_user_names"].each do |reffer|
        dept = Agency.find(User.find_by(user_name: reffer).agency_id).name
        if (child.data["case_goals_all_met_601e9c9"] || child.data["case_goals_substantially_met_and_there_is_no_child_protection_concern_b0f5a44"]) && child.data["status"].eql?("closed")
          stats[dept]["Resolved Cases"] += 1
        else
          stats[dept]["Reffered Cases"] += 1
        end
      end
    end

    stats
  end

  def self.get_alternate_care_replacement_cases
    search = Child.search do
      with(:the_child_family_has_received_the_services_to_prevent_separation__but_it_was_not_been_successful__to_serve_the_child_s_best_interest__it_is_now_necessary_to_make_an_alternative_care_placement___move_on_to_the_suitability_principle__8bb4ea1, true)
      without(:child_s_sex_2fe5059, nil)
    end
    
    search
  end

  def self.get_reffered_cases
    search = Child.search do
      without(:assigned_user_names, nil)
    end

    search.results
  end

  def self.services_provided_by_age_and_violence(user)
    return { permission: false } unless user.role.name.in? ['Focal Person', 'Referral']

    stats = { "labels" => [
      "Physical Violence or Injury",
      "Mental Violence",
      "Neglect and Negligent Treatment",
      "Exploitation",
      "Sexual Abuse and Sexual Exploitation"
      ], "data" => [
        {
          "name" => "0..9",
          "dataset" => [0, 0, 0, 0, 0]
        },
        {
          "name" => "10..17",
          "dataset" => [0, 0, 0, 0, 0]
        }
      ]
    }
      
    Child.get_service_provided_childs_with_age_type_of_violence.results.each do |child|
      age = child.data["child_s_age_f2599ad"]
      child.data["types_of_abuse_fc733c0"].each do |concern|
        case concern
        when "arrested_detained"
          stats["data"][0]["dataset"][0] += 1 if age.in?(0..9)
          stats["data"][1]["dataset"][0] += 1 if age.in?(10..17)
        when "statelessness"
          stats["data"][0]["dataset"][1] += 1 if age.in?(0..9)
          stats["data"][1]["dataset"][1] += 1 if age.in?(10..17)
        when "trafficked_smuggled"
          stats["data"][0]["dataset"][2] += 1 if age.in?(0..9)
          stats["data"][1]["dataset"][2] += 1 if age.in?(10..17)
        when "gbv_survivor"
          stats["data"][0]["dataset"][3] += 1 if age.in?(0..9)
          stats["data"][1]["dataset"][3] += 1 if age.in?(10..17)
        when "sexually_exploited"
          stats["data"][0]["dataset"][4] += 1 if age.in?(0..9)
          stats["data"][1]["dataset"][4] += 1 if age.in?(10..17)
        end
      end
    end

    stats
  end

  def self.alternative_care_placement_by_gender(user)
    role_name = user.role.name
    return { permission: false } unless role_name.in? ['CPO', 'CPI In-charge']

    stats = {
      male: 0,
      female: 0,
      transgender: 0
    }

    alternate_cases = role_name.eql?("CPO") ? check_for_alternate_care_placement_with_user(user.user_name) : with_department(user.agency.unique_id).check_for_alternate_care_placement
    alternate_cases.each do |child|
      gender = child.data["child_s_sex_2fe5059"]

      case gender
      when "male"
        stats[:male] += 1
      when "female"
        stats[:female] += 1
      else
        stats[:transgender] += 1
      end
    end

    stats_final = [stats[:male], stats[:female], stats[:transgender]]
    stats_final
  end

  def self.cases_referred_to_departments(user)
    return { permission: false } unless user.role.name.in? ['CPO', 'CPI In-charge']

    stats = {}
    Agency.all.each do |agency|
      stats.merge!({ agency.name => 0 })
    end

    Child.get_reffered_cases.each do |child|
      child.data["assigned_user_names"].each do |reffer|
        dept = Agency.find(User.find_by(user_name: reffer).agency_id).name
        stats[dept] += 1
      end
    end

    stats
  end

  def self.get_service_provided_cases_by_gender
    search = Child.search do
      without(:make__if_other__please_specify__appear_dynamically_83aa4ee, nil)
      without(:child_s_sex_2fe5059, nil)
    end

    search.results
  end

  def self.cases_receiving_services_by_gender(user)
    return { permission: false } unless user.role.name.eql?('Referral')

    stats = {
      "Boys" => 0,
      "Girls" => 0,
      "Transgender" => 0
    }

    Child.get_service_provided_cases_by_gender.each do |child|
      gender = child.data["child_s_sex_2fe5059"]

      case gender
      when "male"
        stats["Boys"] += 1
      when "female"
        stats["Girls"] += 1
      else
        stats["Transgender"] += 1
      end
    end
    stats_array = [stats["Boys"], stats["Girls"], stats["Transgender"]]
    stats_array
  end

  def self.get_service_provided_childs_with_gender_type_of_violence
    cases = Child.search do
      without(:make__if_other__please_specify__appear_dynamically_83aa4ee, nil)
      without(:child_s_sex_2fe5059, nil)
      without(:types_of_abuse_fc733c0, nil)
    end

    search = Child.search do
      without(:make__if_other__please_specify__appear_dynamically_83aa4ee, nil)
      without(:child_s_sex_2fe5059, nil)
      without(:types_of_abuse_fc733c0, nil)
      paginate :page => 1, :per_page => cases.total
    end

    search.results
  end

  def self.get_object_against_sex(sex)
    if sex.eql?("male")
      index = 0
    elsif sex.eql?("female")
      index = 1
    else
      index = 2
    end
    index 
  end

  def self.services_provided_by_gender_and_violence(user)
    return { permission: false } unless user.role.name.in? ['Focal Person', 'Referral']

    stats = { "labels" => [
      "Physical Violence or Injury",
      "Mental Violence",
      "Neglect and Negligent Treatment",
      "Exploitation",
      "Sexual Abuse and Sexual Exploitation"
      ], "data" => [
        {
          "name" => "Male",
          "dataset" => [0, 0, 0, 0, 0]
        },
        {
          "name" => "Female",
          "dataset" => [0, 0, 0, 0, 0]
        },
        {
          "name" => "Transgender",
          "dataset" => [0, 0, 0, 0, 0]
        }
      ]
    }
      
    Child.get_service_provided_childs_with_gender_type_of_violence.each do |child|
      sex = child.data["child_s_sex_2fe5059"]
      obj = get_object_against_sex(sex)
      child.data["types_of_abuse_fc733c0"].each do |concern|
        case concern
        when "arrested_detained"
          stats["data"][obj]["dataset"][0] += 1
        when "statelessness"
          stats["data"][obj]["dataset"][1] += 1
        when "trafficked_smuggled"
          stats["data"][obj]["dataset"][2] += 1
        when "gbv_survivor"
          stats["data"][obj]["dataset"][3] += 1
        when "sexually_exploited"
          stats["data"][obj]["dataset"][4] += 1
        end
      end
    end

    stats
  end

  def self.increment_cases_with_range(type, age, obj, cases)
    case age
    when 0..9
      cases["data"][obj]["data"][type.eql?("resolve_case") ? 1 : 0] += 1
    when 10..17
      cases["data"][obj]["data"][type.eql?("register_case") ? 2 : 3] += 1
    end
    cases
  end

  def self.registered_resolved_by_gender_and_age(user)
    role = user.role.name
    return { permission: false }

    cases = { "labels" => [
      "Registered (0-9)",
      "Resolved (0-9)",
      "Registered (10-17)",
      "Resolved (10-17)"
      ], "data" => [
        {
          "name" => "Male",
          "data" => [0, 0, 0, 0]
        },
        {
          "name" => "Female",
          "data" => [0, 0, 0, 0]
        },
        {
          "name" => "Transgender",
          "data" => [0, 0, 0, 0]
        }
      ]
    }

    if role == "CPO"
      Child.get_resolved_cases_with_user(user.user_name).results.each do |child|
        obj = get_object_against_sex(child.data["child_s_sex_2fe5059"])
        age = child.data['age']

        increment_cases_with_range("resolve_case", age, obj, cases)
      end
      Child.get_registered_cases_with_user(user.user_name).results.each do |child|
        obj = get_object_against_sex(child.data["child_s_sex_2fe5059"])
        age = child.data['age']

        increment_cases_with_range("register_case", age, obj, cases)
      end
      return cases
    end

    Child.get_resolved_cases.results.each do |child|
      obj = get_object_against_sex(child.data["child_s_sex_2fe5059"])
      age = child.data['age']

      increment_cases_with_range("resolve_case", age, obj, cases)
    end

    Child.get_registered_cases.results.each do |child|
      obj = get_object_against_sex(child.data["child_s_sex_2fe5059"])
      age = child.data['age']

      increment_cases_with_range("register_case", age, obj, cases)
    end

    cases
  end

  def self.services_recieved_by_type_of_physical_violence(user)
    role_name = user.role.name
    return { permission: false } unless role_name.in? ['CPO', 'CPI In-charge']

    cases = {
      "dataset" => [
        { "count" => 0, "percentage" => 0 },
        { "count" => 0, "percentage" => 0 },
        { "count" => 0, "percentage" => 0 }
      ],
      "labels" => [
        "Hitting, Kicking, Shaking, Beating, Bites, Burns, Strangulation, Poisoning and Suffocation",
        "Physical torture by adults and other children.",
        "All other forms of torture, cruel, Inhumane or degrading treatment or punishment"
      ]
    }

    resolved_cases = role_name == "CPO" ? Child.get_resolved_cases_with_user(user.user_name) : Child.get_resolved_cases_for_particular_user_group(user.user_groups)
    cases_count = resolved_cases.total unless resolved_cases.blank?

    resolved_cases.results.each do |child|
      type_of_violence = child.data["forms_of_violence_82ef103"].last unless child.data["forms_of_violence_82ef103"].blank?
      if type_of_violence.in? ["hitting__kicking__shaking__beating__bites__burns__strangulation__poisoning_and_suffocation_5fdc878"]
        cases["dataset"][0]["count"] += 1
      elsif type_of_violence.in? ["physical_torture_by_adults_and_other_children_8f74475", "physical_torture_from_adults_or_other_children_23d7d6c"]
        cases["dataset"][1]["count"] += 1
      else
        cases["dataset"][2]["count"] += 1
      end
    end

    cases["dataset"].each do |data|
      break if cases_count.nil?
      data[:percentage] = get_percentage(data["count"], cases_count)
    end

    cases
  end

  def self.transfer_rejected_cases_with_district(user)
    role_name = user.role.name
    return { permission: false } unless role_name.in? ['CPO', 'CPI In-charge']

    rejected_transfer_cases = role_name == "CPO" ? rejected_transfer_case_with_user(user.user_name) : rejected_transfer_case_with_user_group(user.user_groups.pluck(:unique_id))
    location_hash = Location.pluck_location_placename
    location_label = Location.with_type_district
    label_count = location_label.size
    cases = { "labels" => location_label, "dataset" => Array.new(label_count, 0) }

    rejected_transfer_cases.results.each do |child|
      location = child.data['owned_by_location']

      label_index = cases['labels'].find_index(location)
      next if label_index.nil?
      cases["dataset"][label_index] = 0 if cases["dataset"][label_index].nil?
      cases["dataset"][label_index] += 1
    end

    cases["labels"].each_with_index do |label, index|
      cases["labels"][index] = location_hash.detect { |code| code[label.to_sym] }.values.last
    end

    cases
  end

  def self.get_cases_for_particular_user_group(user_groups, significant_harm = nil)
    usernames = user_groups.first.users.pluck(:user_name)
    cases = Child.search do
      with(:owned_by, usernames)
      with(:is_this_a__significant_harm__case_or_a_regular_case__d49a084, true) if significant_harm.present?
    end

    search = Child.search do
      with(:owned_by, usernames)
      with(:is_this_a__significant_harm__case_or_a_regular_case__d49a084, true) if significant_harm.present?
      paginate :page => 1, :per_page => cases.total
    end

    search.results
  end

  def self.get_resolved_cases_for_particular_user_group(user_groups, significant_harm = nil)
    usernames = user_groups.first.users.pluck(:user_name)
    search = Child.search do
      with(:owned_by, usernames)
      with(:status, "closed")
      with(:is_this_a__significant_harm__case_or_a_regular_case__d49a084, true) if significant_harm.present?
      any_of do
        with(:case_goals_all_met_601e9c9, true)
        with(:case_goals_substantially_met_and_there_is_no_child_protection_concern_b0f5a44, true)
      end
    end

    search
  end

  def self.get_closed_cases_for_particular_user_group(user_groups, significant_harm =nil)
    usernames = user_groups.first.users.pluck(:user_name)
    cases = Child.search do
      with(:owned_by, usernames)
      with(:status, "closed")
       with(:is_this_a__significant_harm__case_or_a_regular_case__d49a084, true) if significant_harm.present?
    end

    search = Child.search do
      with(:owned_by, usernames)
      with(:status, "closed")
       with(:is_this_a__significant_harm__case_or_a_regular_case__d49a084, true) if significant_harm.present?
      paginate :page => 1, :per_page => cases.total
    end

    search
  end

  def self.services_provided_by_police(user)
    role_name = user.role.name
    return { "permission" => false } unless role_name.in? ['CPO', 'CPI In-charge']

    cases = {
      "lodging_an_fir_c09aa09" => 0,
      "arrest_and_remove_dangerous_abuse_perpetrators_from_children_upon_court_order_61333d2" => 0,
      "investigate_criminal_child_abuse_allegations_1fc162e" => 0,
      "collect_and_present_evidence_in_criminal_child_abuse_cases__in_collaboration_with_swd_and_prosecution__20ee937" => 0,
      "accompany_cpos_when_requested_during_the_course_of_case_management_9fbfe61" => 0,
      "provide_security_to_children_and_their_families_during_court_proceedings_f99b6e5" => 0,
      "arrest_alleged_accused_as_per_pakistan_penal_laws_5901f52" => 0
    }

    cases_ids = role_name == "CPO" ? get_resolved_cases_with_user(user.user_name).results.pluck(:id) : get_resolved_cases_for_particular_user_group(user.user_groups).results.pluck(:id)

    Transition.where(type: "Referral", status: "accepted", transitioned_to_agency: "A2", record_id: cases_ids).each do |transition|
      cases[transition.service] += 1
    end

    cases
  end

  def self.get_transfer_case
    search = Child.search do
      with(:transfer_status, "accepted")
      without(:location_current, nil)
      without(:associated_user_names, nil)
    end
    
    search.results
  end

  def self.get_transfer_case_with_user_group(user_groups)
    search = Child.search do
      with(:transfer_status, "accepted")
      with(:owned_by_groups, user_groups)
      without(:location_current, nil)
      without(:associated_user_names, nil)
    end
    
    search.results
  end

  def self.is_coming(user, assigned_user)
    Transition.where(type:"Transfer", status:"accepted", transitioned_to: user.user_name).present?
  end

  def self.is_outgoing(user, assigned_user)
    Transition.where(type:"Transfer", status:"accepted", transitioned_by: user.user_name).present?
  end

  def self.transffered_cases_by_district(user)
    role_name = user.role.name
    return { "permission" => false }

    transffered_cases = role_name == "Superuser" ? get_transfer_case : get_transfer_case_with_user_group(user.user_groups.pluck(:unique_id))
    location_hash = Location.pluck_location_placename
    location_label = Location.with_type_district
    label_count = location_label.size
    cases = { "labels" => location_label, "dataset" => [
        {
          "name" => " Incoming",
          "data" => Array.new(label_count, 0)
        },
        {
          "name" => " Outgoing",
          "data" => Array.new(label_count, 0)
        }
      ]
    }

    transffered_cases.each do |child|
      location = child.data["location_current"]
      label_index = cases["labels"].find_index(location)

      if ((label_index.present?) && (child.data["associated_user_names"].present?))
        child.data["associated_user_names"].each do |assigned_user|
          cases["dataset"][0]["data"][label_index] += 1 if Child.is_coming(user, assigned_user)
          cases["dataset"][1]["data"][label_index] += 1 if Child.is_outgoing(user, assigned_user)
        end
      end
    end

    cases["labels"].each_with_index do |label, index|
      cases["labels"][index] = location_hash.detect { |code| code[label.to_sym] }.values.last
    end

    cases
  end

  def self.get_registered_cases_with_district
    districts = Location.with_type_district
    search = Child.search do
      without(:child_s_age_f2599ad, nil)
      without(:status, "closed")
      with(:location_current, districts)
    end

    search.results
  end

  def self.map_of_registered_cases_district_wise(user)
    return { permission: false } unless user.role.name.eql?('CP Manager')

    stats = {}

    total_cases = Child.get_registered_cases_with_district.each do |child|
      location = Location.find_by_location_code(child.location_current)&.placename_en
      stats[location] = {count: 0, percentage: 0} unless stats[location]
      stats[location][:count] += 1
    end.count

    stats.each do |key, value|
      value[:percentage] = get_percentage(value[:count], total_cases) unless total_cases.eql?(0)
    end

    stats_final = []
    stats.each do |key, value|
      stats_final << [key, value[:count], value[:percentage]]
    end

    stats_final
  end
  
  def self.get_role_wise_workflow(user)
    role_name = user.role.name
    return { "permission" => false } unless role_name.eql?('CPI In-charge')

    location_codes = Location.where("cast(hierarchy_path as text) LIKE ?", "%#{Location.find_by(location_code: user.location).hierarchy_path.split('.').second}%").pluck(:location_code)

    usernames = [user.user_name]
    usernames << User.includes(:role).where(location: location_codes, roles: {name: "CPO"}).pluck(:user_name)
    cases = {
      "registration" => 0,
      "assessment" => 0,
      "case_plan" => 0,
      "referrals" => 0,
      "final_case_review" => 0,
      "case_closure" => 0
    }

    get_cases_by_given_usernames(usernames.flatten).each do |child|
      next unless cases[child.workflow].present?
      cases[child.workflow] += 1
    end

    cases.transform_keys! &:titleize
  end

  def self.get_cases_by_given_usernames(usernames)
    cases = Child.search do
      with(:owned_by, usernames)
    end

    search = Child.search do
      with(:owned_by, usernames)
      without(:workflow, nil)
      paginate :page => 1, :per_page => cases.total
    end

    search.results
  end
end
