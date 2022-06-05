namespace :edit_fields_text do
  desc 'Editing text of form fields'
  task edit_fields_text_rake: :environment do
    field = Field.where("display_name_i18n @> ?", {en: "Types of Abuse found in Initial Assessment"}.to_json).last
    abuse_form = Field.where("display_name_i18n @> ?", {en: "The following forms of abuse, neglect, exploitation, or violence against a child"}.to_json).last

    unless field.display_name_i18n["en"].eql?("Protection Concern found in Initial Assessment")
      field.display_name_i18n["en"] = "Protection Concern found in Initial Assessment"
      field.save
    end

    unless field.display_name_i18n["en"].eql?("The following categories of abuse, neglect, exploitation, or violence against a child")
      abuse_form.display_name_i18n["en"] = "The following categories of abuse, neglect, exploitation, or violence against a child"
      abuse_form.save
    end
  end
end
