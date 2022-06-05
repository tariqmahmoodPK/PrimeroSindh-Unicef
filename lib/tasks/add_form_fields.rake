namespace :add_form_fields do
  desc 'Adding consent_form field to consent_form for file_upload'
  task add_document_fields: :environment do
    consent_form = FormSection.find_by(unique_id: 'consent')
    consent_form.fields.create!(
      name: "consent_form",
      type: "document_upload_box",
      editable: false,
      display_name_en: "Consent Form",
      help_text_en: "Only PDF, TXT, DOC, DOCX, XLS, XLSX, CSV, JPG, JPEG, PNG files permitted"
    ) if consent_form.fields.find_by(name: 'consent_form').nil?

    care_placement_form = FormSection.find_by(unique_id: 'formsection-alternative-care-placement-form-21c8dec')

    FormSection.create_or_update!(
      unique_id: "formsection-court-orders-919f5a6",
      parent_form: "case",
      visible: true,
      order_form_group: 0,
      order: 0,
      order_subform: 0,
      initial_subforms: 0,
      form_group_id: "case_plan",
      editable: true,
      name_en: "Court Orders",
      description_en: "Court Orders"
    )

    court_order_form = FormSection.find_by(unique_id: "formsection-court-orders-919f5a6")

    if court_order_form.present?
      FormPermission.find_or_create_by!(
        role_id: User.first.role.id,
        form_section_id: court_order_form.id,
        permission: "rw"
      )
      court_order_form.update(primero_module_ids: [PrimeroModule.first.id])
    end

    court_order_form.fields.create!(
      name: 'court_order_0253ae2',
      type: 'document_upload_box',
      editable: false,
      order: 1,
      visible: true,
      display_name_en: "Court Orders",
      help_text_en: "Only PDF, TXT, DOC, DOCX, XLS, XLSX, CSV, JPG, JPEG, PNG files permitted"
     ) if court_order_form.fields.find_by(name: "court_order_0253ae2").nil?

    initial_assessment_form = FormSection.find_by(unique_id: 'formsection-initial-assessment-14e3c9a')

    initial_assessment_form.fields.create!(
      name: "signed_or_scanned_letter_sent_to_the_parent_or_guardian",
      type: "document_upload_box",
      editable: false,
      display_name_en: "signed/scanned letter sent to the parent/guardian(regarding findings of initial assessment)",
      help_text_en: "Only PDF, TXT, DOC, DOCX, XLS, XLSX, CSV, JPG, JPEG, PNG files permitted",
      order: 16
    ) if initial_assessment_form.fields.find_by(name: 'signed_or_scanned_letter_sent_to_the_parent_or_guardian').nil?

    initial_assessment_form.fields.create!(
      name: "signed_or_scanned_letter_sent_to_person_reporting_child_abuse",
      type: "document_upload_box",
      editable: false,
      display_name_en: "signed/scanned letter sent to person reporting child abuse",
      help_text_en: "Only PDF, TXT, DOC, DOCX, XLS, XLSX, CSV, JPG, JPEG, PNG files permitted",
      order: 21
    ) if initial_assessment_form.fields.find_by(name: 'signed_or_scanned_letter_sent_to_person_reporting_child_abuse').nil?

    initial_assessment_form.fields.create!(
      name: 'upload_letter_for_parent_guardian_d306d09',
      type: 'seperator',
      display_name_en: 'Upload letter for Parent/Guardian',
      help_text_en: 'Files should be no larger than 2 MB (executable (.exe) files cannot be uploaded).',
      guiding_questions_en: 'Files should be no larger than 2 MB (executable (.exe) files cannot be uploaded).',
      order: 15
    ) if initial_assessment_form.fields.find_by(name: 'upload_letter_for_parent_guardian_d306d09').nil?

    Field.where(name: [
      'is_this_the_current_document__56eb13e',
      'is_this_the_current_document__7cf9bb6',
      'add_document_407ff83',
      'document_name_55c12b9',
      'comments_130a999',
      'add_document_b795dc8',
      'document_name_94afbdd',
      'comments_0e04e1b',
      'add_document_c1e049d',
      'is_this_the_current_document__e42314c',
      'document_name_ee94440',
      'comments_b15c8b2',
      'upload_court_order_0253ae2'
    ]).destroy_all

    initial_assessment_form.fields.create!(
      name: "auto_schedule_comprehensive_assessment",
      type: "tick_box",
      order: 21,
      "display_name_en" => "Do you want to enable auto scheduling?"
    ) if initial_assessment_form.fields.find_by(name: 'auto_schedule_comprehensive_assessment').nil?
  end
end
