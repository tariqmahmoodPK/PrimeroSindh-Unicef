# frozen_string_literal: true

json.data do
  json.management Permission.management
  json.resource_actions Permission::RESOURCE_ACTIONS
end
