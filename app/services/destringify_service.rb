# frozen_string_literal: true

# A service to convert the boolean, date, integer, and time string values
# of object with a ruby Hash interface (such as the Rails params) to
# Date, Time, Integer, and Boolean ruby objects.
# Comma delineated strings are converted to Arrays, Hashes with integer keys
# are converted to Arrays, and values separated by .. are converted to ranges.
class DestringifyService
  def self.destringify(value, lists_and_ranges = false)
    new.destringify(value, lists_and_ranges)
  end

  # Disabling Rubocop because this really is a complex thing
  # rubocop:disable Metrics/AbcSize
  # rubocop:disable Metrics/CyclomaticComplexity
  # rubocop:disable Metrics/MethodLength
  # rubocop:disable Metrics/PerceivedComplexity
  def destringify(value, lists_and_ranges)
    # Recursively parse and cast a hash of string values to Dates, DateTimes, Integers, Booleans.
    # If all keys in a hash are numeric, convert it to an array.
    case value
    when nil, ''
      nil
    when ::ActiveSupport::JSON::DATE_REGEX
      begin
        Date.parse(value)
      rescue ArgumentError
        value
      end
    when ::ActiveSupport::JSON::DATETIME_REGEX
      begin
        Time.zone.parse(value)
      rescue ArgumentError
        value
      end
    when /^(true|false)$/
      ::ActiveRecord::Type::Boolean.new.cast(value)
    when /^\d+$/
      value.to_i
    when Array
      value.map { |v| destringify(v, lists_and_ranges) }
    when Hash
      # If value.keys is empty the expression returns true. For that reason we need the check for present?
      has_numeric_keys = value.keys.present? && value.keys.all? { |k| k.match?(/^\d+$/) }
      if has_numeric_keys
        value.sort_by { |k, _| k.to_i }.map { |_, v| destringify(v, lists_and_ranges) }
      else
        value.map { |k, v| [k, destringify(v, lists_and_ranges)] }.to_h
      end
    else
      if lists_and_ranges && value.is_a?(String)
        if value.match?(/,/)
          value.split(',').map { |v| destringify(v, lists_and_ranges) }
        elsif value.match?(/\.\./)
          range = value.split('..')
          {
            'from' => destringify(range[0], lists_and_ranges),
            'to' => destringify(range[1], lists_and_ranges)
          }
        else
          value
        end
      else
        value
      end
    end
  end
  # rubocop:enable Metrics/AbcSize
  # rubocop:enable Metrics/CyclomaticComplexity
  # rubocop:enable Metrics/MethodLength
  # rubocop:enable Metrics/PerceivedComplexity
end
