# frozen_string_literal: true

json.data do
  json.partial! 'api/v2/locations/location', location: @location, with_hierarchy: true
end
