# frozen_string_literal: true

json.data do
  json.partial! 'api/v2/primero_configurations/configuration', configuration: @configuration
end
