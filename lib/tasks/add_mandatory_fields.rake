namespace :add_mandatory_fields do
  desc 'Adding mandatory form fields'
  task add_mandatory_form_fields: :environment do
    referral_form = FormSection.find_by(unique_id: 'referral')
    referral_form.fields.create!(
      name: "name_of_user",
      type: "text_field",
      display_name_en: "Name Of User",
      required: true,
      editable: false,
      disabled: true
    ) if referral_form.fields.find_by(name: 'name_of_user').nil?

    basic_information_form = FormSection.find_by(unique_id: 'formsection-basic-information-df4d92e')
    basic_information_form.fields.create!(
      name: "child_s_name",
      type: "text_field",
      display_name_en: "Child's Name",
      required: true,
      editable: false,
      disabled: true
    ) if basic_information_form.fields.find_by(name: 'child_s_name').nil?

    response_form = FormSection.find_by(unique_id: 'formsection-response-form-c74a56b')
    response_form.fields.create!(
      name: "case_goal",
      type: "text_field",
      display_name_en: "Case Goal",
      required: true,
      editable: false,
      disabled: true
    ) if response_form.fields.find_by(name: 'case_goal').nil?

    basic_identity_form = FormSection.find_by(unique_id: 'basic_identity')
    basic_identity_form.fields.find_by(name: 'case_id_display').destroy
    basic_identity_form.fields.find_by(name: 'case_status_reopened').destroy
    basic_identity_form.fields.find_by(name: 'assessment_due_date').destroy

    date_confidentiality_form = FormSection.find_by(unique_id: 'consent')
    date_confidentiality_form.fields.find_by(name: 'unhcr_export_opt_in').destroy
  end
end
