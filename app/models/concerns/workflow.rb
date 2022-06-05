# frozen_string_literal: true

# Note: Currently this concern contains logic / fields specific to Child/Case.
# Note: This is dependent on the Serviceable concern.  Serviceable must be included before Workflow
module Workflow
  extend ActiveSupport::Concern

  WORKFLOW_NEW = 'new'
  WORKFLOW_CLOSED = 'closed'
  WORKFLOW_REOPENED = 'reopened'
  WORKFLOW_SERVICE_PROVISION = 'service_provision' # Note, this status is deprecated
  WORKFLOW_SERVICE_IMPLEMENTED = 'services_implemented'
  WORKFLOW_REGISTRATION = "registration"
  WORKFLOW_ASSESSMENT = 'assessment'
  WORKFLOW_CASE_PLAN = 'case_plan'
  WORKFLOW_REFERRALS = 'referrals'
  WORKFLOW_FINAL_CASE_REVIEW = 'final_case_review'
  WORKFLOW_CASE_CLOSURE = 'case_closure'
  WORKFLOW_CASE_CLOSED = 'case_closed'

  LOOKUP_RESPONSE_TYPES = 'lookup-service-response-type'

  included do
    store_accessor :data, :workflow
    alias_method :workflow_status, :workflow

    searchable do
      string :workflow_status, as: 'workflow_status_sci'
      string :workflow, as: 'workflow_sci'
    end

    before_create :set_workflow_registration
    before_save :calculate_workflow
  end

  def set_workflow_registration
    self.workflow ||= WORKFLOW_REGISTRATION
  end

  def calculate_workflow
    if workflow_assessment?
      self.workflow = WORKFLOW_ASSESSMENT
    elsif workflow_case_plan?
      self.workflow = WORKFLOW_CASE_PLAN
    elsif workflow_final_case_review?
      self.workflow = WORKFLOW_FINAL_CASE_REVIEW
    elsif workflow_case_closure?
      self.workflow = WORKFLOW_CASE_CLOSURE
    elsif workflow_case_closed?
      self.workflow = WORKFLOW_CASE_CLOSED
    end
  end

  def workflow_assessment?
    changes_to_save_for_record.key?(self.match_key_from_pattern("date_and_time_registration_was_completed"))
  end

  def workflow_case_plan?
    return changes_to_save_for_record.key?(self.match_key_from_pattern("date_and_time_initial_assessment_was_completed")) unless self.get_hash_keys_values("is_the_case_competent_for_a_comprehensive_assessment")
    changes_to_save_for_record.key?(self.match_key_from_pattern("date_comprehensive_assessment_completed"))
  end

  def workflow_final_case_review?
    changes_to_save_for_record.key?(self.match_key_from_pattern("case_decision"))
  end

  def workflow_case_closure?
    return unless self.get_hash_keys_values("closure_approved_date")
    status != Record::STATUS_OPEN
  end

  def workflow_case_closed?
    status != Record::STATUS_OPEN
  end

  # Class methods
  module ClassMethods
    def workflow_statuses(modules = [], lookups = nil)
      I18n.available_locales.map do |locale|
        status_list = []
        status_list << workflow_key_value(WORKFLOW_REGISTRATION, locale)
        status_list << workflow_key_value(WORKFLOW_ASSESSMENT, locale)
        status_list << workflow_key_value(WORKFLOW_CASE_PLAN, locale)
        status_list << workflow_key_value(WORKFLOW_REFERRALS, locale)
        status_list << workflow_key_value(WORKFLOW_FINAL_CASE_REVIEW, locale)
        status_list << workflow_key_value(WORKFLOW_CASE_CLOSURE, locale)
        { locale => status_list }
      end.inject(&:merge)
    end

    def lookup_response_types(lookups = nil)
      lookup = lookups&.find { |lkp| lkp.unique_id == LOOKUP_RESPONSE_TYPES }
      lookup || Lookup.find_by(unique_id: LOOKUP_RESPONSE_TYPES)
    end

    private

    def workflow_key_value(status, locale = I18n.locale)
      {
        'id' => status,
        'display_text' => I18n.t("case.workflow.#{status}", locale: locale)
      }
    end
  end
end
