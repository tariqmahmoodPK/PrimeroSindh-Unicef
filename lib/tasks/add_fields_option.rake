namespace :add_fields_option do
  desc 'Adding other option to the Types of abuse field'
  task add_other_option: :environment do
    lookup_for_types_of_abuse = Lookup.find_by_unique_id ("lookup-type-of-abuse-29c82ae")
    other_option = {"id"=>"other", "disabled"=>false, "display_text"=>{"ar"=>"", "en"=>"Other", "fr"=>""}}

    next if lookup_for_types_of_abuse.lookup_values_i18n.include?(other_option)

    lookup_for_types_of_abuse.lookup_values_i18n.append(other_option)
    lookup_for_types_of_abuse.save
  end
end