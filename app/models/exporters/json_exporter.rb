# frozen_string_literal: true

# Exports records to JSON formatted text
class Exporters::JsonExporter < Exporters::BaseExporter
  class << self
    def id
      'json'
    end

    def excluded_properties
      %w[encrypted_password reset_password_token reset_password_sent_at]
    end

    def supported_models
      [Child, Incident, TracingRequest]
    end
  end

  def export(records, user, options = {})
    establish_export_constraints(records, user, options)
    hashes = records.map { |m| convert_model_to_hash(m) }
    buffer.write(JSON.pretty_generate(hashes))
  end

  def convert_model_to_hash(record)
    field_names = fields.map(&:name)
    json_parse = JSON.parse(record.to_json)
    data_fields = json_parse['data'].select { |k, _| field_names.include?(k) }
    json_parse['data'] = data_fields
    json_parse
  end
end
