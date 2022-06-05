# frozen_string_literal: true

# This is the connector for the private MS-developed micro service:
# Primero User Management API for Azure Active Directory.
# It only makes sense to use within the context of the UNICEF-hosted Primero SaaS.
class ApiConnector::AzureActiveDirectoryConnector < ApiConnector::AbstractConnector
  IDENTIFIER = 'aad'

  def self.id
    IDENTIFIER
  end

  def fetch(user)
    response = connection.get("/users/#{user.user_name}")
    response[1]
  end

  def create(user)
    status, response = connection.post('/users', post_params(user))
    log_response(user, status, response)
    response_attributes(response, user)
  end

  def update(user)
    status, response = connection.patch("/users/#{user.user_name}", patch_params(user))
    log_response(user, status, response)
    response_attributes(response, user)
  end

  def syncable?(user)
    # Only if the user's IDP is configured to sync with this connector
    identity_sync_connector = user&.identity_provider&.configuration&.dig('identity_sync_connector')
    identity_sync_connector == self.class.name.demodulize
  end

  def new?(user)
    sync_metadata = user&.identity_provider_sync&.dig(id)
    !sync_metadata&.dig('synced_on')
  end

  def relevant_updates?(user)
    user.full_name != user['identity_provider_sync']['aad']['full_name'] ||
      !user.disabled != user['identity_provider_sync']['aad']['enabled']
  end

  def post_params(user)
    {
      user_name: user.user_name,
      full_name: user.full_name
    }
  end

  def patch_params(user)
    {
      user_name: user.user_name,
      full_name: user.full_name,
      enabled: !user.disabled
    }
  end

  def response_attributes(response, user)
    {
      one_time_password: response['one_time_password'],
      identity_provider_sync: {
        aad: {
          message: "(#{response['correlation_id']}) #{response['error_msg']}"
        }.merge(response['error_msg'].blank? ? synced_attributes(user) : {})
      }
    }.compact
  end

  def synced_attributes(user)
    {
      synced_on: DateTime.now,
      synced_values: {
        full_name: user.full_name,
        enabled: !user.disabled
      }
    }
  end

  def log_response(user, status, response)
    message_suffix = "with IDP #{user&.identity_provider&.name} (#{user&.identity_provider&.unique_id}): "\
                     "(#{response['correlation_id']}) #{response['error_msg']}"
    case status
    when 200, 201
      Rails.logger.info("Connector #{id}: Successfully synced User #{user.user_name} #{message_suffix}")
    else
      Rails.logger.error("Error syncing User #{user.user_name} #{message_suffix}")
    end
  end
end
