# frozen_string_literal: true

json.data do
  json.partial! 'api/v2/lookups/lookup', lookup: @lookup
end
