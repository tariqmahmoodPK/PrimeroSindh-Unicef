json.data do
  json.array! @districts do |district|
    json.partial! 'api/v2/locations/districts', location: district
  end
end
