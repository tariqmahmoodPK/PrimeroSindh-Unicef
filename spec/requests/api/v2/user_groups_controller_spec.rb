# frozen_string_literal: true

require 'rails_helper'

describe Api::V2::UserGroupsController, type: :request do
  before :each do
    clean_data(UserGroup, Role)
    @role = Role.create!(
      name: 'Test Role 1',
      unique_id: 'test-role-1',
      group_permission: 'group',
      permissions: [
        Permission.new(resource: Permission::USER_GROUP, actions: [Permission::READ])
      ]
    )
    @user_group_a = UserGroup.create!(unique_id: 'user-group-1', name: 'user group 1')
    @user_group_b = UserGroup.create!(unique_id: 'user-group-2', name: 'user group 2')
  end

  let(:json) { JSON.parse(response.body) }

  describe 'GET /api/v2/user_groups' do
    it 'list the user_groups' do
      login_for_test(
        permissions: [
          Permission.new(resource: Permission::USER_GROUP, actions: [Permission::READ])
        ]
      )

      get '/api/v2/user_groups'
      expect(response).to have_http_status(200)
      expect(json['data'].size).to eq(2)
      expect(json['data'].map { |group| group['name'] }).to eq(['user group 1', 'user group 2'])
    end

    it 'list the user_groups with page and per' do
      login_for_test(
        permissions: [
          Permission.new(resource: Permission::USER_GROUP, actions: [Permission::READ])
        ]
      )

      get '/api/v2/user_groups?per=1&page=2'
      expect(response).to have_http_status(200)
      expect(json['data'].size).to eq(1)
      expect(json['data'].first['unique_id']).to eq(@user_group_b.unique_id)
    end

    it 'returns 403 if user is not authorized to access' do
      login_for_test(
        permissions: [
          Permission.new(resource: Permission::USER_GROUP, actions: [Permission::WRITE])
        ]
      )

      get '/api/v2/user_groups'
      expect(response).to have_http_status(403)
      expect(json['errors'][0]['resource']).to eq('/api/v2/user_groups')
      expect(json['errors'][0]['message']).to eq('Forbidden')
    end

    it 'should return the user_groups assigned to the current_user when group_permission is "group"' do
      login_for_test(
        permissions: [
          Permission.new(resource: Permission::USER_GROUP, actions: [Permission::READ])
        ],
        role: @role,
        user_group_ids: [@user_group_a.id]
      )

      get '/api/v2/user_groups', params: { managed: true }
      expect(response).to have_http_status(200)
      expect(json['data'].size).to eq(1)
      expect(json['data'].first['unique_id']).to eq(@user_group_a.unique_id)
    end
  end

  describe 'GET /api/v2/user_groups/:id' do
    it 'fetches the correct user_group with code 200' do
      login_for_test(
        permissions: [
          Permission.new(resource: Permission::USER_GROUP, actions: [Permission::READ])
        ]
      )

      get "/api/v2/user_groups/#{@user_group_b.id}"
      expect(response).to have_http_status(200)
      expect(json['data']['unique_id']).to eq('user-group-2')
    end

    it 'returns 403 if user is not authorized to access' do
      login_for_test(
        permissions: [
          Permission.new(resource: Permission::USER, actions: [Permission::MANAGE])
        ]
      )

      get "/api/v2/user_groups/#{@user_group_b.id}"
      expect(response).to have_http_status(403)
      expect(json['errors'][0]['resource']).to eq("/api/v2/user_groups/#{@user_group_b.id}")
      expect(json['errors'][0]['message']).to eq('Forbidden')
    end

    it 'returns a 404 when trying to fetch a user_group with a non-existant id' do
      login_for_test(
        permissions: [
          Permission.new(resource: Permission::USER_GROUP, actions: [Permission::READ])
        ]
      )

      get '/api/v2/user_groups/thisdoesntexist'
      expect(response).to have_http_status(404)
      expect(json['errors'].size).to eq(1)
      expect(json['errors'][0]['resource']).to eq('/api/v2/user_groups/thisdoesntexist')
    end
  end

  describe 'POST /api/v2/user_groups' do
    it 'creates a new user_group and returns 200 and json' do
      login_for_test(
        permissions: [
          Permission.new(resource: Permission::USER_GROUP, actions: [Permission::MANAGE])
        ]
      )
      params = {
        data: {
          unique_id: 'test_unique_id21',
          name: 'test_nam12',
          disabled: false,
          description: 'test_description12'
        }
      }

      post '/api/v2/user_groups', params: params, as: :json
      expect(response).to have_http_status(200)
      expect(json['data']['name']).to eq(params[:data][:name])
      expect(UserGroup.first.users.count).to eq(0)
    end

    describe 'POST user_group as a admin' do
      before :each do
        clean_data(UserGroup, Agency, PrimeroModule, Role, User, FormSection, PrimeroProgram)
        agency = Agency.create!(name: 'Agency 1', agency_code: 'agency1')
        program = PrimeroProgram.create!(
          unique_id: 'primeroprogram-primero',
          name: 'Primero',
          description: 'Default Primero Program'
        )
        cp = PrimeroModule.create!(
          unique_id: 'primeromodule-cp',
          name: 'CP',
          description: 'Child Protection',
          associated_record_types: %w[case tracing_request incident],
          primero_program: program,
          form_sections: [FormSection.create!(name: 'form_1')]
        )
        role = Role.create!(
          name: 'Test Role 1',
          unique_id: 'test-role-1',
          permissions: [
            Permission.new(resource: Permission::USER_GROUP, actions: [Permission::MANAGE])
          ],
          group_permission: Permission::SELF,
          modules: [cp]
        )
        @user = User.create!(
          full_name: 'Test User 1',
          user_name: 'test_user_1',
          password: 'a12345678',
          password_confirmation: 'a12345678',
          email: 'test_user_1@localhost.com',
          agency_id: agency.id,
          role: role
        )
      end

      it 'creates a new user_group as a admin' do
        sign_in(@user)
        params = {
          data: {
            unique_id: 'test_unique_id21',
            name: 'test_nam12',
            disabled: false,
            description: 'test_description12'
          }
        }

        post '/api/v2/user_groups', params: params, as: :json
        expect(response).to have_http_status(200)
        expect(json['data']['name']).to eq(params[:data][:name])
        expect(UserGroup.first.users.count).to eq(1)
        expect(UserGroup.first.users.first).to eq(@user)
      end

      after :each do
        clean_data(UserGroup, Agency, PrimeroModule, Role, User, FormSection, PrimeroProgram)
      end
    end

    it 'Error 409 same uniq_id' do
      login_for_test(
        permissions: [
          Permission.new(resource: Permission::USER_GROUP, actions: [Permission::MANAGE])
        ]
      )
      params = {
        data: {
          unique_id: 'user-group-1',
          name: 'test_nam12',
          disabled: false,
          description: 'test_descriptio1n2'
        }
      }

      post '/api/v2/user_groups', params: params, as: :json
      expect(response).to have_http_status(409)
      expect(json['errors'].size).to eq(1)
      expect(json['errors'].first['message']).to eq('Conflict: A record with this id already exists')
      expect(json['errors'][0]['resource']).to eq('/api/v2/user_groups')
    end

    it 'returns 403 if user is not authorized to access' do
      login_for_test(
        permissions: [
          Permission.new(resource: Permission::USER, actions: [Permission::MANAGE])
        ]
      )
      params = {}

      post '/api/v2/user_groups', params: params, as: :json
      expect(response).to have_http_status(403)
      expect(json['errors'][0]['resource']).to eq('/api/v2/user_groups')
      expect(json['errors'][0]['message']).to eq('Forbidden')
    end
  end

  describe 'PATCH /api/v2/user_groups/:id' do
    it 'updates an existing user_group with 200' do
      login_for_test(
        permissions: [
          Permission.new(resource: Permission::USER_GROUP, actions: [Permission::MANAGE])
        ]
      )
      params = {
        data: {
          id: @user_group_b.id,
          unique_id: @user_group_b.unique_id,
          name: 'test_nam12',
          disabled: false,
          description: 'test_descriptio1n2'
        }
      }

      patch "/api/v2/user_groups/#{@user_group_b.id}", params: params, as: :json
      expect(response).to have_http_status(200)
      expect(json['data'].except('core_resource')).to eq(params[:data].deep_stringify_keys)
      expect(json['data']['core_resource']).to eq(false)
    end

    it 'updates an non-existing user_group' do
      login_for_test(
        permissions: [
          Permission.new(resource: Permission::USER_GROUP, actions: [Permission::MANAGE])
        ]
      )
      params = {}

      patch '/api/v2/user_groups/thisdoesntexist', params: params
      expect(response).to have_http_status(404)
      expect(json['errors'].size).to eq(1)
      expect(json['errors'][0]['resource']).to eq('/api/v2/user_groups/thisdoesntexist')
    end

    it 'returns 403 if user is not authorized to access' do
      login_for_test(
        permissions: [
          Permission.new(resource: Permission::USER, actions: [Permission::MANAGE])
        ]
      )
      params = {}

      patch "/api/v2/user_groups/#{@user_group_b.id}", params: params
      expect(response).to have_http_status(403)
      expect(json['errors'][0]['resource']).to eq("/api/v2/user_groups/#{@user_group_b.id}")
      expect(json['errors'][0]['message']).to eq('Forbidden')
    end
  end

  describe 'DELETE /api/v2/user_groups/:id' do
    it 'successfully deletes a user_group with a code of 200' do
      login_for_test(
        permissions: [
          Permission.new(resource: Permission::USER_GROUP, actions: [Permission::MANAGE])
        ]
      )

      delete "/api/v2/user_groups/#{@user_group_a.id}"
      expect(response).to have_http_status(200)
      expect(json['data']['id']).to eq(@user_group_a.id)
      expect(UserGroup.find_by(id: @user_group_a.id)).to be nil
    end

    it 'returns 403 if user is not authorized to access' do
      login_for_test(
        permissions: [
          Permission.new(resource: Permission::USER, actions: [Permission::MANAGE])
        ]
      )

      delete "/api/v2/user_groups/#{@user_group_a.id}"
      expect(response).to have_http_status(403)
      expect(json['errors'][0]['resource']).to eq("/api/v2/user_groups/#{@user_group_a.id}")
      expect(json['errors'][0]['message']).to eq('Forbidden')
    end

    it 'returns a 404 when trying to delete a user_group with a non-existant id' do
      login_for_test(
        permissions: [
          Permission.new(resource: Permission::USER_GROUP, actions: [Permission::MANAGE])
        ]
      )

      delete '/api/v2/user_groups/thisdoesntexist'
      expect(response).to have_http_status(404)
      expect(json['errors'].size).to eq(1)
      expect(json['errors'][0]['resource']).to eq('/api/v2/user_groups/thisdoesntexist')
    end
  end

  after :each do
    clean_data(UserGroup)
  end
end
