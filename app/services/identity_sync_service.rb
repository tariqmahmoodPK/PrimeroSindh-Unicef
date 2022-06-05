# frozen_string_literal: true

# Publish creation or changes to Primero users to external systems.
# This is used by the UNICEF SaaS Azure Active Directory, but can be used for MDM,
# or other case management system integrations.
# The underlying connectors are configured via consistently named environment variables.
# The pattern is PRIMERO_IDENTITY_SYNC_AAD_<PROPERTY>.
# Common properties are: HOST, PORT, TLS (client|truthy|falsey), TLS_CLIENT_KEY, TLS_CLIENT_CERT
class IdentitySyncService
  ENV_PREFIX = 'PRIMERO_IDENTITY_SYNC_AAD_'

  attr_accessor :connectors

  class << self
    def instance
      @instance ||= build.freeze
    end

    def build
      instance = new
      instance.connectors = []
      IdentityProvider.all.each do |provider|
        connector_class = provider.identity_sync_connector
        next unless connector_class

        instance.connectors << connector_class.build_from_env(prefix: ENV_PREFIX)
      end
      instance
    end

    def sync!(user, connector_id = nil)
      instance.sync!(user, connector_id)
    end
  end

  def sync!(user, connector_id = nil)
    connectors = if connector_id
                   self.connectors.select { |c| c.id == connector_id }
                 else
                   self.connectors
                 end
    updates = connectors.reduce({}) do |aggregate, connector|
      update = connector.sync(user)
      aggregate.deep_merge(update)
    end
    user.update!(sanitize(updates)) && updates
  end

  def sanitize(updates)
    return {} unless updates.is_a?(Hash)

    attributes = User.attribute_names.reject { |a| a.include?('password') }
    updates.with_indifferent_access.slice(*attributes)
  end
end
