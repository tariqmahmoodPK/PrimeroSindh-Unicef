# frozen_string_literal: true

PrimeroModule.create_or_update!(
  unique_id: 'primeromodule-cp',
  name: "CP",
  description: "Child Protection",
  associated_record_types: ["case", "tracing_request", "incident"],
  form_sections: FormSection.where(unique_id: [
    "activities", "assessment", "basic_identity", "best_interest",
    "care_arrangements", "care_assessment", "child_under_5", "bia_documents",
    "child_wishes", "closure_form", "consent", "family_details", "followup",
    "interview_details", "other_documents", "other_identity_details", "partner_details",
    "photos_and_audio", "protection_concern_details", "protection_concern",
    "record_owner", "services", "tracing", "verification", "bid_documents",
    "tracing_request_inquirer", "tracing_request_record_owner", "tracing_request_tracing_request",
    "tracing_request_photos_and_audio", "followup", "reunification_details", "other_reportable_fields_case",
    "other_reportable_fields_tracing_request", "referral_transfer", "notes", "cp_case_plan", "cp_bia_form",
    "cp_incident_form", "cp_individual_details", "cp_offender_details", "cp_other_reportable_fields", "cp_incident_record_owner",
    "incident_details_container", "approvals", "conference_details_container",
    "summary", "referral", "incident_from_case", "transfer_assignments", "change_logs"
  ]),
  field_map: {
    map_to: "primeromodule-cp",
    fields: [
      {
        source: [
          "incident_details",
          "cp_incident_identification_violence"
        ],
        target: "cp_incident_identification_violence"
      },
      {
        source: [
          "incident_details",
          "incident_date"
        ],
        target: "incident_date"
      },
      {
        source: [
          "incident_details",
          "cp_incident_location_type"
        ],
        target: "cp_incident_location_type"
      },
      {
        source: [
          "incident_details",
          "cp_incident_location_type_other"
        ],
        target: "cp_incident_location_type_other"
      },
      {
        source: [
          "incident_details",
          "incident_location"
        ],
        target: "incident_location"
      },
      {
        source: [
          "incident_details",
          "cp_incident_timeofday"
        ],
        target: "cp_incident_timeofday"
      },
      {
        source: [
          "incident_details",
          "cp_incident_timeofday_actual"
        ],
        target: "cp_incident_timeofday_actual"
      },
      {
        source: [
          "incident_details",
          "cp_incident_violence_type"
        ],
        target: "cp_incident_violence_type"
      },
      {
        source: [
          "incident_details",
          "cp_incident_previous_incidents"
        ],
        target: "cp_incident_previous_incidents"
      },
      {
        source: [
          "incident_details",
          "cp_incident_previous_incidents_description"
        ],
        target: "cp_incident_previous_incidents_description"
      },
      {
        source: [
          "incident_details",
          "cp_incident_abuser_name"
        ],
        target: "cp_incident_abuser_name"
      },
      {
        source: [
          "incident_details",
          "cp_incident_perpetrator_nationality"
        ],
        target: "cp_incident_perpetrator_nationality"
      },
      {
        source: [
          "incident_details",
          "perpetrator_sex"
        ],
        target: "perpetrator_sex"
      },
      {
        source: [
          "incident_details",
          "cp_incident_perpetrator_age"
        ],
        target: "cp_incident_perpetrator_age"
      },
      {
        source: [
          "incident_details",
          "cp_incident_perpetrator_national_id_no"
        ],
        target: "cp_incident_perpetrator_national_id_no"
      },
      {
        source: [
          "incident_details",
          "cp_incident_perpetrator_other_id_type"
        ],
        target: "cp_incident_perpetrator_other_id_type"
      },
      {
        source: [
          "incident_details",
          "cp_incident_perpetrator_other_id_no"
        ],
        target: "cp_incident_perpetrator_other_id_no"
      },
      {
        source: [
          "incident_details",
          "cp_incident_perpetrator_marital_status"
        ],
        target: "cp_incident_perpetrator_marital_status"
      },
      {
        source: [
          "incident_details",
          "cp_incident_perpetrator_occupation"
        ],
        target: "cp_incident_perpetrator_occupation"
      },
      {
        source: [
          "incident_details",
          "cp_incident_perpetrator_relationship"
        ],
        target: "cp_incident_perpetrator_relationship"
      },
      {
        source: ["age"],
        target: "age"
      },
      {
        source: ["sex"],
        target: "cp_sex"
      },
      {
        source: ["nationality"],
        target: "cp_nationality"
      },
      {
        source: ["national_id_no"],
        target: "national_id_no"
      },
      {
        source: ["other_id_type"],
        target: "other_id_type"
      },
      {
        source: ["other_id_no"],
        target: "other_id_no"
      },
      {
        source: ["maritial_status"],
        target: "maritial_status"
      },
      {
        source: ["educational_status"],
        target: "educational_status"
      },
      {
        source: ["occupation"],
        target: "occupation"
      },
      {
        source: ["disability_type"],
        target: "cp_disability_type"
      },
      {
        source: ["owned_by"],
        target: "owned_by"
      }
    ]
  },
  module_options: {
    workflow_status_indicator: true,
    allow_searchable_ids: true,
    use_workflow_service_implemented: true,
    use_workflow_case_plan: true,
    use_workflow_assessment: false,
    reporting_location_filter: true
  },
  primero_program: PrimeroProgram.find_by(unique_id: "primeroprogram-primero"),
)
