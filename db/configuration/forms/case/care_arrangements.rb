care_arrangements_fields_subform = [
  Field.new('name' => 'child_caregiver_status',
            'type' => 'radio_button',
            'display_name_en' => 'Is this a same caregiver as was previously entered for the child?',
            'option_strings_source' => 'lookup lookup-yes-no',
            'visible' => false),
  Field.new('name' => 'child_caregiver_reason_change',
            'type' => 'select_box',
            'display_name_en' => 'If this is a new caregiver, give the reason for the change',
            'option_strings_source' => 'lookup lookup-caregiver-change-reason'),
  Field.new('name' => 'care_arrangements_include_referral_form',
            'type' => 'tick_box',
            'tick_box_label_en' => 'Yes',
            'display_name_en' => 'If this is the current caregiver, include in the Referral Details form?',
            'help_text_en' => 'Only include if the person being referred is a child'),
  Field.new('name' => 'care_arrangements_type',
            'type' => 'select_box',
            'display_name_en' => "What are the child's current care arrangements?",
            'option_strings_source' => 'lookup lookup-care-arrangements-type'),
  Field.new('name' => 'care_arrangements_type_other',
            'type' => 'text_field',
            'display_name_en' => 'If Other, please specify'),
  Field.new('name' => 'care_arrangements_type_notes',
            'type' => 'textarea',
            'display_name_en' => 'Care Arrangement Notes',
            'visible' => false),
  Field.new('name' => 'care_agency_name',
            'type' => 'text_field',
            'display_name_en' => 'Name of Agency Providing Care Arrangements',
            'visible' => false),
  Field.new('name' => 'name_caregiver_separator',
            'type' => 'separator',
            'display_name_en' => 'If not with parents, main person caring for the child.'),
  Field.new('name' => 'name_caregiver',
            'type' => 'text_field',
            'display_name_en' => 'Name of Current Caregiver',
            'help_text_en' => 'If the child is with the parents, proceed to Care Arrangements.'),
  Field.new('name' => 'nickname_caregiver',
            'type' => 'text_field',
            'display_name_en' => 'Other names or spellings caregiver is known by',
            'help_text_en' => 'e.g., nickname, second family name'),
  Field.new('name' => 'caregiver_age',
            'type' => 'numeric_field',
            'display_name_en' => "Caregiver's Age"),
  Field.new('name' => 'caregiver_dob',
            'type' => 'date_field',
            'display_name_en' => "Caregiver's Date of Birth (DOB)"),
  Field.new('name' => 'age_estimated_caragiver',
            'type' => 'tick_box',
            'tick_box_label_en' => 'Yes',
            'display_name_en' => 'Is the Age estimated?'),
  Field.new('name' => 'caregiver_sex',
            'type' => 'select_box',
            'display_name_en' => 'Sex',
            'option_strings_source' => 'lookup lookup-gender'),
  Field.new('name' => 'caregiver_national_id',
            'type' => 'text_field',
            'display_name_en' => 'National ID'),
  Field.new('name' => 'caregiver_unhcr_individual_id',
            'type' => 'text_field',
            'display_name_en' => 'UNHCR Individual ID'),
  Field.new('name' => 'caregiver_other_id',
            'type' => 'text_field',
            'display_name_en' => 'Other ID'),
  Field.new('name' => 'caregiver_id_type_and_no',
            'type' => 'text_field',
            'display_name_en' => "Caregiver's Identification - Type and Number",
            'visible' => false),
  Field.new('name' => 'caregiver_related_child',
            'type' => 'radio_button',
            'display_name_en' => 'Is caregiver related to the child?',
            'option_strings_source' => 'lookup lookup-yes-no'),
  Field.new('name' => 'relationship_caregiver',
            'type' => 'select_box',
            'display_name_en' => 'Relationship to child',
            'option_strings_source' => 'lookup lookup-family-relationship'),
  Field.new('name' => 'caregiver_know_family',
            'type' => 'radio_button',
            'display_name_en' => 'If not related, does the caregiver know the family of the child?',
            'option_strings_source' => 'lookup lookup-yes-no'),
  Field.new('name' => 'family_size_under_18',
            'type' => 'numeric_field',
            'display_name_en' => 'Family Size: Under 18'),
  Field.new('name' => 'family_size_over_18',
            'type' => 'numeric_field',
            'display_name_en' => 'Family Size: Over 18'),
  Field.new('name' => 'address_caregiver',
            'type' => 'textarea',
            'display_name_en' => "Caregiver's Address",
            'guiding_questions_en' => "Enter the Caregiver's address and location here even if the same as the Child's current address for traceability if the child moves or the caregiver changes."),
  Field.new('name' => 'location_caregiver',
            'type' => 'select_box',
            'display_name_en' => "Caregiver's Location",
            'option_strings_source' => 'Location'),
  Field.new('name' => 'care_arrangement_started_date',
            'type' => 'date_field',
            'display_name_en' => 'When did this care arrangement start?'),
  Field.new('name' => 'caregiver_willing_to_continue',
            'type' => 'radio_button',
            'display_name_en' => 'Is caregiver willing to continue taking care of the child?',
            'option_strings_source' => 'lookup lookup-yes-no-duration'),
  Field.new('name' => 'caregiver_willing_to_continue_for_how_long',
            'type' => 'text_field',
            'display_name_en' => 'If yes, for how long?'),
  Field.new('name' => 'caregiver_willing_to_continue_not_reason',
            'type' => 'textarea',
            'display_name_en' => 'If not willing to continue care for the child, provide details'),
  Field.new('name' => 'caregiver_location_status',
            'type' => 'radio_button',
            'display_name_en' => "Is the caregiver's current location temporary",
            'option_strings_source' => 'lookup lookup-yes-no'),
  Field.new('name' => 'address_caregiver_future',
            'type' => 'textarea',
            'display_name_en' => 'If yes, what is the future address?'),
  Field.new('name' => 'location_caregiver_future',
            'type' => 'select_box',
            'display_name_en' => 'What is the future location?',
            'option_strings_source' => 'Location'),
  Field.new('name' => 'telephone_caregiver_future',
            'type' => 'text_field',
            'display_name_en' => 'What is the future telephone?'),
  Field.new('name' => 'telephone_caregiver',
            'type' => 'text_field',
            'display_name_en' => "Caregiver's Telephone",
            'help_text_en' => "Enter the caregiver's current telephone / other contact details"),
  Field.new('name' => 'child_consent_caregiver_contacted',
            'type' => 'radio_button',
            'display_name_en' => 'Does the child consent for the caregiver to be contacted?',
            'option_strings_source' => 'lookup lookup-yes-no'),
  Field.new('name' => 'child_consent_caregiver_contacted_no_details',
            'type' => 'textarea',
            'display_name_en' => 'If no, provide details'),
  Field.new('name' => 'other_persons_living_in_household',
            'type' => 'textarea',
            'display_name_en' => 'Other persons living in the household'),
  Field.new('name' => 'other_information_from_caregiver',
            'type' => 'textarea',
            'display_name_en' => 'Other information from the caregiver about the child and his/her family',
            'visible' => false)
]

care_arrangements_section = FormSection.create_or_update!(
  'visible' => false,
  'is_nested' => true,
  :mobile_form => true,
  :order_form_group => 50,
  :order => 10,
  :order_subform => 1,
  :unique_id => 'care_arrangements_section',
  :parent_form => 'case',
  'editable' => true,
  :fields => care_arrangements_fields_subform,
  :initial_subforms => 1,
  'name_en' => 'Nested Care Arrangements',
  'description_en' => 'Care Arrangements Subform',
  'collapsed_field_names' => %w[care_arrangements_type name_caregiver care_arrangement_started_date]
)

care_arrangements_fields = [
  Field.new({"name" => "child_caregiver_status",
             "type" => "radio_button",
             "display_name_en" => "Is this a same caregiver as was previously entered for the child?",
             "option_strings_source" => "lookup lookup-yes-no",
             'visible' => false
           }),
  Field.new({"name" => "child_caregiver_reason_change",
             "type" => "select_box",
             "display_name_en" => "If this is a new caregiver, give the reason for the change",
             "option_strings_text_en" => [
               { id: 'abuse_exploitation', display_text: "Abuse & Exploitation" },
               { id: 'death_of_caregiver', display_text: "Death of Caregiver" },
               { id: 'Education', display_text: "Education" },
               { id: 'ill_health_of_caregiver', display_text: "Ill health of caregiver" },
               { id: 'other', display_text: "Other" },
               { id: 'poverty', display_text: "Poverty" },
               { id: 'relationship_breakdown', display_text: "Relationship Breakdown" }
             ].map(&:with_indifferent_access),
             'visible' => false
            }),
  Field.new({"name" => "care_arrangements_type",
             "type" => "select_box",
             "display_name_en" => "What are the child's current care arrangements?",
             "option_strings_text_en" => [
               { id: 'stays_with_related_caregiver', display_text: "Stays with related caregiver" },
               { id: 'stays_with_unrelated_caregiver', display_text: "Stays with unrelated caregiver" },
               { id: 'residential_care_center', display_text: "Residential Care Center" },
               { id: 'child_headed_household', display_text: "Child Headed Household" },
               { id: 'lives_with_peers_other_children', display_text: "Lives with peers/other children" },
               { id: 'independent_living', display_text: "Independent Living" },
               { id: 'other', display_text: "Other (Please specify)" }
             ].map(&:with_indifferent_access),
             'visible' => false
            }),
  Field.new({"name" => "care_arrangements_type_notes",
             "type" => "textarea",
             "display_name_en" => "Care Arrangement Notes",
             'visible' => false
            }),
  Field.new({"name" => "care_agency_name",
             "type" => "text_field",
             "display_name_en" => "Name of Agency Providing Care Arrangements",
             'visible' => false
            }),
  Field.new({"name" => "name_caregiver",
             "type" => "text_field",
             "display_name_en" => "Name of Current Caregiver",
             'visible' => false
            }),
  Field.new({"name" => "relationship_caregiver",
             "type" => "select_box",
             "display_name_en" => "Relationship of the Caregiver to the Child",
             "option_strings_source" => "lookup lookup-family-relationship",
             'visible' => false
            }),
  Field.new({"name" => "caregiver_id_type_and_no",
             "type" => "text_field",
             "display_name_en" => "Caregiver's Identification - Type and Number",
             'visible' => false
            }),
  Field.new({"name" => "caregiver_age",
             "type" => "numeric_field",
             "display_name_en" => "Caregiver's Age",
             'visible' => false
            }),
  Field.new({"name" => "address_caregiver",
             "type" => "textarea",
             "display_name_en" => "Address where the child is currently living?",
             'visible' => false
            }),
  Field.new({"name" => "location_caregiver",
             "type" => "select_box",
             "display_name_en" => "Caregiver's Location",
             "option_strings_source" => "Location",
             'visible' => false
            }),
  Field.new({"name" => "telephone_caregiver",
             "type" => "text_field",
             "display_name_en" => "Caregiver's Telephone",
             'visible' => false
            }),
  Field.new({"name" => "care_arrangement_started_date",
             "type" => "date_field",
             "display_name_en" => "When did this care arrangement start?",
             'visible' => false
            }),
  Field.new({"name" => "caregiver_location_status",
             "type" => "radio_button",
             "display_name_en" => "Is the caregiver's current location temporary",
             "option_strings_source" => "lookup lookup-yes-no",
             'visible' => false
           }),
  Field.new({"name" => "address_caregiver_future",
             "type" => "textarea",
             "display_name_en" => "If yes, what is the future address?",
             'visible' => false
            }),
  Field.new({"name" => "location_caregiver_future",
             "type" => "select_box",
             "display_name_en" => "What is the future location?",
             "option_strings_source" => "Location",
             'visible' => false
            }),
  Field.new({"name" => "telephone_caregiver_future",
             "type" => "text_field",
             "display_name_en" => "What is the future telephone?",
             'visible' => false
            }),
  Field.new({"name" => "caregiver_willing_to_continue",
             "type" => "radio_button",
             "display_name_en" => "Is caregiver willing to continue taking care of the child?",
             "option_strings_source" => "lookup lookup-yes-no",
             'visible' => false
           }),
  Field.new({"name" => "caregiver_willing_to_continue_for_how_long",
             "type" => "text_field",
             "display_name_en" => "If yes, for how long?",
             'visible' => false
            }),
  Field.new({"name" => "caregiver_know_family",
             "type" => "radio_button",
             "display_name_en" => "Does the caregiver know the family of the child?",
             "option_strings_source" => "lookup lookup-yes-no",
             'visible' => false
           }),
  Field.new({"name" => "other_information_from_caregiver",
             "type" => "textarea",
             "display_name_en" => "Other information from the caregiver about the child and his/her family",
             'visible' => false
            }),
  Field.new('name' => 'current_care_arrangement_header',
            'type' => 'separator',
            'display_name_en' => "Current Care Arrangement",
            'guiding_questions_en' => "Primero automatically fills in the below fields with information from the most recent Care Arrangements subform entry"),
  Field.new('name' => 'current_name_caregiver',
            'type' => 'text_field',
            'display_name_en' => 'Name of Current Caregiver',
            'disabled' => true),
  Field.new('name' => 'current_care_arrangements_type',
            'type' => 'select_box',
            'display_name_en' => "What are the child's current care arrangements?",
            'option_strings_source' => 'lookup lookup-care-arrangements-type',
            'disabled' => true),
  Field.new('name' => 'current_care_arrangement_started_date',
            'type' => 'date_field',
            'display_name_en' => 'When did this care arrangement start?',
            'disabled' => true),
  Field.new('name' => 'care_arrangements_section',
            'type' => 'subform',
            'editable' => true,
            'subform_section' => care_arrangements_section,
            'display_name_en' => 'Care Arrangements')
]

FormSection.create_or_update!({
  unique_id: "care_arrangements",
  parent_form: "case",
  visible: true,
  order_form_group: 110,
  order: 10,
  order_subform: 0,
  form_group_id: "services_follow_up",
  editable: true,
  fields: care_arrangements_fields,
  name_en: "Care Arrangements",
  description_en: "Care Arrangements"
})
