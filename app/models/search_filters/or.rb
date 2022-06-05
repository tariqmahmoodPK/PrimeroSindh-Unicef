# frozen_string_literal: true

# Transform API query parameter or[field_name1]=value1&or[field_name2]=value2 into a Sunspot query
class SearchFilters::Or < SearchFilters::SearchFilter
  attr_accessor :filters

  def query_scope(sunspot)
    this = self
    sunspot.instance_eval do
      any_of do
        this.filters.each do |filter|
          # TODO: For now assume that nested filters are only Value,
          # but there is a better, functional way to solve that... later
          with(filter.field_name, filter.value)
        end
      end
    end
  end

  def as_location_filter(record_class)
    return self unless location_field_filter?(record_class)

    SearchFilters::Or.new(filters: filters.map { |f| f.as_location_filter(record_class) })
  end

  def location_field_filter?(record_class)
    filters.any? { |f| f.location_field_filter?(record_class) }
  end

  def to_h
    filters_hash = filters&.map(&:to_h) || []
    {
      type: 'or',
      filters: filters_hash
    }
  end

  def to_s
    filters.map do |filter|
      key, value = filter.to_s.split('=')
      "or[#{key}]=#{value}"
    end
  end
end
