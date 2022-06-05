# frozen_string_literal: true

require 'rails_helper'

describe Api::V2::IdentityProvidersController, type: :request do
  before :each do
    Rails.application.configure do
      config.x.idp.use_identity_provider = true
    end

    clean_data(IdentityProvider)
    @identity_providers_primero = IdentityProvider.create!(
      id: 1,
      name: 'primero',
      unique_id: 'primeroims',
      provider_type: 'b2c',
      configuration: {
        client_id: '123',
        authorization_url: 'url',
        identity_scope: ['123'],
        verification_url: 'verifyurl',
        domain_hint: 'primeroims'
      }
    )

    @identity_providers_unicef = IdentityProvider.create!(
      id: 2,
      name: 'unicef',
      unique_id: 'unicef',
      provider_type: 'b2c',
      configuration: {
        client_id: '123',
        authorization_url: 'url',
        identity_scope: ['123'],
        verification_url: 'verifyurl',
        domain_hint: 'unicef'
      }
    )
  end

  let(:json) { JSON.parse(response.body) }

  describe 'GET /api/v2/identity_providers' do
    it 'lists identity providers' do
      get '/api/v2/identity_providers'

      expect(response).to have_http_status(200)
      expect(json['data'].size).to eq(2)
      expect(json['data'].map { |c| c['authorization_url'] }).to include(
        @identity_providers_primero.authorization_url, @identity_providers_unicef.authorization_url
      )
      expect(json['data'].map { |c| c['client_id'] }).to include(
        @identity_providers_primero.client_id, @identity_providers_unicef.client_id
      )
      expect(json['data'].map { |c| c['identity_scope'] }).to include(
        @identity_providers_primero.identity_scope, @identity_providers_unicef.identity_scope
      )
      expect(json['data'].map { |c| c['provider_type'] }).to include(
        @identity_providers_primero.provider_type, @identity_providers_unicef.provider_type
      )
      expect(json['data'].map { |c| c['unique_id'] }).to include(
        @identity_providers_primero.unique_id, @identity_providers_unicef.unique_id
      )
      expect(json['data'].map { |c| c['verification_url'] }).to include(
        @identity_providers_primero.verification_url, @identity_providers_unicef.verification_url
      )
      expect(json['data'].map { |c| c['domain_hint'] }).to include('unicef', 'primeroims')

      expect(json['data'].map { |c| c['name'] }[0]).to include(@identity_providers_primero['name'])
      expect(json['data'].map { |c| c['name'] }[1]).to include(@identity_providers_unicef['name'])
    end

    it 'identity providers with zero record' do
      IdentityProvider.destroy_all
      get '/api/v2/identity_providers'

      expect(response).to have_http_status(200)
      expect(json['data']).to eq([])
      expect(json['metadata']['use_identity_provider']).to be true
    end
  end

  after :each do
    clean_data(IdentityProvider)
    Rails.application.configure do
      config.x.idp.use_identity_provider = false
    end
  end
end
