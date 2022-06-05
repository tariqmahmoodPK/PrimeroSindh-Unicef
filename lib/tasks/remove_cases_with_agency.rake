namespace :remove_cases_with_agency do
  desc 'remove_cases that belongs to UNICEF and test agency'
  task remove_cases_with_agency_rake: :environment do
    agency = Agency.find_by(unique_id: "UNICEF")
    Child.where("data @> ?", { owned_by_agency_id: agency.unique_id }.to_json).destroy_all if agency.present?
    
    test_agency = Agency.find_by(unique_id: "A1")
    Child.where("data @> ?", { owned_by_agency_id: test_agency.unique_id }.to_json).destroy_all if test_agency.present?
    
    agency.destroy if agency.present?
    test_agency.destroy if test_agency.present?
  end
end
