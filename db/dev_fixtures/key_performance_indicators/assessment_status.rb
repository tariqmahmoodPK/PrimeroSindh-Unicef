require_relative 'setup.rb'

# Create test case
Child.new_with_user(TEST_USER, {
    "age"=>100,
    "sex"=>"male",
    "name"=>"Pizza Hut",
    "status"=>"open",
    "occupation"=>"Pizza Person",
    "hidden_name"=>true,
    "gbv_religion"=>"religion3",
    "date_of_birth"=>Date.parse("1958/06/15"),
    "dependents_no"=>1,
    "gbv_ethnicity"=>"ethnicity2",
    "notes_section"=>[],
    "gbv_nationality"=>"nationality4",
    "maritial_status"=>"divorced_separated",
    "survivor_code_no"=>1,
    "country_of_origin"=>"algeria",
    "survivor_caretaker"=>"other",
    "gbv_disability_type"=>"physical_disability",
    "caretaker_occupation"=>"Unknown",
    "survivor_lives_alone"=>false,
    "gbv_displacement_status"=>"idp",
    "caretaker_marital_status"=>"unknown_not_applicable",
    "survivor_caretaker_other"=>"None else",
    "unaccompanied_separated_status"=>"no",
    "survivor_assessment_form" => [{
      'assessment_emotional_state_start' => 'Overwhelmed',
      'assessment_emotional_state_end' => 'Resilient',
      'assessment_presenting_problem' => 'Anxiety',
      'assessment_main_concerns' => 'Poor sales',
      'assessment_current_situation' => 'Poor'
    }]
}).save!

puts 'Created test case with completed survivor assessment form'
