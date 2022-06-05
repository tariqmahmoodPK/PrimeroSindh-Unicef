# frozen_string_literal: true

module Indicators
  class AbstractIndicator < ValueObject
    attr_accessor :name, :record_model, :scope, :scope_to_owner, :scope_to_referred,
                  :scope_to_transferred, :scope_to_not_last_update, :scope_to_owned_by_groups

    class << self
      def dawn_of_time
        Time.zone.at(0)
      end

      def recent_past
        Time.zone.now - 10.days
      end

      def last_week
        {
          from: 1.week.ago.beginning_of_week,
          to: 1.week.ago.end_of_week
        }
      end

      def this_week
        {
          from: present.beginning_of_week,
          to: present.end_of_week
        }
      end

      def present
        Time.zone.now
      end

      def type
        'indicator'
      end
    end

    def query(_, _)
      raise NotImplementedError
    end

    def facet_name
      name
    end

    def stats_from_search(sunspot_search, user)
      owner = owner_from_search(sunspot_search)
      sunspot_search.facet(facet_name).rows.map do |row|
        stat = {
          'count' => row.count,
          'query' => stat_query_strings(row, owner, user)
        }
        [row.value, stat]
      end.to_h
    end

    def stat_query_strings(_, _, _)
      raise NotImplementedError
    end

    protected

    def owner_from_search(sunspot_search)
      return unless scope_to_owner

      owner_query = sunspot_search&.query&.scope&.to_params
                      &.dig(:fq)&.find { |p| p.match(/owned_by/) }
      owner_query && owner_query.split(':')[1]
    end

    def scope_query_strings
      scope&.map(&:to_s) || []
    end

    def owner_query_string(owner)
      if owner.present?
        ["owned_by=#{owner}"]
      else
        []
      end
    end

    def referred_query_string(user)
      if user.present? && scope_to_referred
        ["referred_users=#{user.user_name}"]
      else
        []
      end
    end

    def transferred_query_string(user)
      if user.present? && scope_to_transferred
        ["transferred_to_users=#{user.user_name}"]
      else
        []
      end
    end

    def owned_by_groups_query_string(user)
      if user.present? && scope_to_owned_by_groups
        ["owned_by_groups=#{user.user_group_unique_ids.join(',')}"]
      else
        []
      end
    end

    def not_last_updated_query_string(user)
      if user.present? && scope_to_not_last_update
        ["not[last_updated_by]=#{user.user_name}"]
      else
        []
      end
    end
  end
end
