namespace :remove_duplicate_lookup_option do
  desc 'Removing duplicate lookup option from forms of violence'
  task remove_duplicate_lookup_option_rake: :environment do
    look = Lookup.where("name_i18n @> ?", {en: "Forms of Violence"}.to_json).last
    duplicate = look.lookup_values_i18n[24]
    look.lookup_values_i18n.delete_at(24) if duplicate.has_key? "id" and duplicate.has_value? "physical_torture_from_adults_or_other_children_e3e3729"
  end
end
