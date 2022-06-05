def create_or_update_system_setting(setting_hash)
  #There should only be 1 row in system settings

  system_setting = SystemSettings.first

  if system_setting.nil?
    puts "Creating System Settings "
    SystemSettings.create! setting_hash
  else
    puts "Updating System Settings"
    system_setting.update setting_hash
  end
end

create_or_update_system_setting(
  auto_populate_list: [
    {
      field_key: "name",
      format: [
        "name_first",
        "name_middle",
        "name_last"
      ],
      separator: " ",
      auto_populated: true
    }
  ],
  reporting_location_config: {
    field_key: "owned_by_location",
    admin_level: 2,
    admin_level_map: { '1' => ['province'], '2' => ['district'] }
  },
  primary_age_range: "primero",
  age_ranges: {
    "primero" => [0..5, 6..11, 12..17, 18..AgeRange::MAX],
    "unhcr" => [0..4, 5..11, 12..17, 18..59, 60..AgeRange::MAX]
  },
  show_alerts: true,
  approval_forms_to_alert: {
    assessment: 'assessment',
    cp_case_plan: 'case_plan',
    closure_form: 'closure',
    action_plan_form: 'action_plan',
    gbv_case_closure_form: 'gbv_closure'
  },
  changes_field_to_form: {
    notes_section: 'notes',
    incident_details: 'incident_details_container',
    services_section: 'services'
  },
  due_date_from_appointment_date: false,
  notification_email_enabled: true,
  welcome_email_enabled: false,
  welcome_email_text: "Click link below to log into Primero.  Please see your system administrator if you have any issues.",
  export_config_id: {
    "unhcr" => "export-unhcr-csv",
    "duplicate_id" => "export-duplicate-id-csv"
  },
  duplicate_export_field: "national_id_no",
  approvals_labels_en: {
    assessment: 'Assessment',
    case_plan: 'Child Care Plan',
    closure: 'Closure',
    action_plan: 'Action Plan',
    gbv_closure: 'GBV Closure'
  },
  approvals_labels_ar: {
    assessment: 'Assessment',
    case_plan: 'Child Care Plan',
    closure: 'Closure',
    action_plan: 'Action Plan',
    gbv_closure: 'GBV Closure'
  }
)
