# frozen_string_literal: true

json.data do
  json.partial! 'api/v2/saved_searches/saved_search', saved_search: @saved_search
end
