# frozen_string_literal: true

module Indicators
  class QueriedIndicator < AbstractIndicator
    attr_accessor :queries

    def self.type
      'queried_indicator'
    end

    def facet_name
      name
    end

    def query(sunspot, user)
      this = self
      sunspot.instance_eval do
        with(:owned_by, user.user_name) if this.scope_to_owner
        with(:referred_users, user.user_name) if this.scope_to_referred
        with(:transferred_to_users, user.user_name) if this.scope_to_transferred
        # TODO: Add agency user scope
        with(:owned_by_groups, user.user_group_unique_ids) if this.scope_to_owned_by_groups
        without(:last_updated_by, user.user_name) if this.scope_to_not_last_update
        this.scope&.each { |f| f.query_scope(self) }
        facet(this.facet_name, zeros: true) do
          row(this.name) do
            this.queries.each { |f| f.query_scope(self) }
          end
        end
      end
    end

    def stat_query_strings(_, owner, user)
      scope_query_strings +
        owner_query_string(owner) +
        referred_query_string(user) +
        transferred_query_string(user) +
        owned_by_groups_query_string(user) +
        not_last_updated_query_string(user) +
        (queries&.map(&:to_s) || [])
    end
  end
end
