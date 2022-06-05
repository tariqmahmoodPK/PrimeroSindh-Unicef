# frozen_string_literal: true

json.merge! flag.attributes
json.record_type Record.map_name(flag.record_type).pluralize

record_access_denied = !current_user.can?(:read, flag.record)
json.record_access_denied record_access_denied

if local_assigns.has_key? :updates_for_record
  unless record_access_denied
    json.record do
      json.partial! 'api/v2/records/record',
                    record: flag.record,
                    selected_field_names: updates_for_record
    end
  end
end
