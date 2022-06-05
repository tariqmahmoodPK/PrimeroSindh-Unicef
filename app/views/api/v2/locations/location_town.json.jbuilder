json.data do
  json.array! @towns do |town|
    json.partial! 'api/v2/locations/districts', location: town
  end
end
