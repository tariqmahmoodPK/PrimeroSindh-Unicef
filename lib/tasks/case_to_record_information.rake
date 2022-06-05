namespace :case_to_record_information do
  desc 'Case Information to Record Information'
  task record_information: :environment do
    lookup_for_case_info = Lookup.where("name_i18n @> ?", {en: "Form Groups - CP Case"}.to_json).last

    unless lookup_for_case_info.lookup_values_i18n[0]["display_text"]["en"].eql?("Record Information")
      lookup_for_case_info.lookup_values_i18n[0]["display_text"]["en"]="Record Information"
      lookup_for_case_info.save
    end
  end
end