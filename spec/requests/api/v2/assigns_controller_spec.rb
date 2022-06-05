# frozen_string_literal: true

require 'rails_helper'

describe Api::V2::AssignsController, type: :request do
  include ActiveJob::TestHelper
  before :each do
    PrimeroModule.destroy_all
    @primero_module = PrimeroModule.new(name: 'CP')
    @primero_module.save(validate: false)
    @permission_assign_case = Permission.new(
      resource: Permission::CASE,
      actions: [Permission::READ, Permission::WRITE, Permission::CREATE, Permission::ASSIGN]
    )
    @role = Role.new(permissions: [@permission_assign_case], modules: [@primero_module])
    @role.save(validate: false)
    @group1 = UserGroup.create!(name: 'Group1')
    @user1 = User.new(user_name: 'user1', role: @role, user_groups: [@group1])
    @user1.save(validate: false)
    @group2 = UserGroup.create!(name: 'Group2')
    @user2 = User.new(user_name: 'user2', role: @role, user_groups: [@group2])
    @user2.save(validate: false)
    @case = Child.create(
      data: {
        name: 'Test', owned_by: 'user1',
        module_id: @primero_module.unique_id
      }
    )
  end

  let(:json) { JSON.parse(response.body) }
  let(:audit_params) { enqueued_jobs.find { |job| job[:job] == AuditLogJob }[:args].first }

  describe 'GET /api/v2/case/:id/assigns' do
    before :each do
      @assign1 = Assign.create!(transitioned_by: 'user1', transitioned_to: 'user2', record: @case)
    end

    it 'lists the assigns for a case' do
      sign_in(@user2)
      get "/api/v2/cases/#{@case.id}/assigns"

      expect(response).to have_http_status(200)
      expect(json['data'].size).to eq(1)
      expect(json['data'][0]['record_id']).to eq(@case.id.to_s)
      expect(json['data'][0]['transitioned_to']).to eq('user2')
      expect(json['data'][0]['transitioned_by']).to eq('user1')
    end

    it "get a forbidden message if the user doesn't have view permission" do
      login_for_test(permissions: [])
      get "/api/v2/cases/#{@case.id}/assigns"

      expect(response).to have_http_status(403)
      expect(json['errors'][0]['status']).to eq(403)
      expect(json['errors'][0]['resource']).to eq("/api/v2/cases/#{@case.id}/assigns")
      expect(json['errors'][0]['message']).to eq('Forbidden')
    end
  end

  describe 'POST /api/v2/case/:id/assigns' do
    it 'assigns a the record to the target user' do
      sign_in(@user1)
      params = { data: { transitioned_to: 'user2', notes: 'Test Notes' } }
      post "/api/v2/cases/#{@case.id}/assigns", params: params

      expect(response).to have_http_status(200)
      expect(json['data']['record_id']).to eq(@case.id.to_s)
      expect(json['data']['transitioned_to']).to eq('user2')
      expect(json['data']['transitioned_by']).to eq('user1')
      expect(json['data']['notes']).to eq('Test Notes')

      expect(audit_params['action']).to eq('assign')
    end

    it "get a forbidden message if the user doesn't have assign permission" do
      login_for_test
      params = { data: { transitioned_to: 'user2', notes: 'Test Notes' } }
      post "/api/v2/cases/#{@case.id}/assigns", params: params

      expect(response).to have_http_status(403)
      expect(json['errors'][0]['status']).to eq(403)
      expect(json['errors'][0]['resource']).to eq("/api/v2/cases/#{@case.id}/assigns")
      expect(json['errors'][0]['message']).to eq('Forbidden')
    end
  end

  describe 'POST /api/v2/case/assigns' do
    before :each do
      @case2 = Child.create(
        data: {
          name: 'Test2', owned_by: 'user1',
          module_id: @primero_module.unique_id
        }
      )
    end

    context 'bulk assign with valid permissions' do
      it 'assigns multiple records to the target user' do
        sign_in(@user1)
        params = { data: { ids: [@case.id, @case2.id], transitioned_to: 'user2', notes: 'Test Notes' } }
        post '/api/v2/cases/assigns', params: params

        expect(response).to have_http_status(200)
        expect(json['data'].size).to eq(2)
        expect(json['data'][0]['record_id']).to eq(@case.id.to_s)
        expect(json['data'][0]['transitioned_to']).to eq('user2')
        expect(json['data'][0]['transitioned_by']).to eq('user1')
        expect(json['data'][1]['record_id']).to eq(@case2.id.to_s)
        expect(json['data'][1]['transitioned_to']).to eq('user2')
        expect(json['data'][1]['transitioned_by']).to eq('user1')

        expect(audit_params['action']).to eq('bulk_assign')
      end
    end

    context 'bulk assigns with mismatched permissions' do
      before :each do
        permission = Permission.new(
          resource: Permission::CASE,
          actions: [Permission::READ, Permission::WRITE, Permission::CREATE, Permission::ASSIGN_WITHIN_USER_GROUP]
        )
        role = Role.new(permissions: [permission], modules: [@primero_module])
        role.save(validate: false)
        @user1.role = role
        @user1.save(validate: false)
      end

      it 'reports errors if there was a problem assigning at least one of the record' do
        sign_in(@user1)
        params = { data: { ids: [@case.id, @case2.id], transitioned_to: 'user2', notes: 'Test Notes' } }
        post '/api/v2/cases/assigns', params: params

        expect(response).to have_http_status(200)
        expect(json['data'].size).to eq(0)
        expect(json['errors'].size).to eq(2)
        expect(json['errors'][0]['detail']).to eq('transitioned_to')
      end
    end
  end

  after :each do
    clear_enqueued_jobs
    clean_data(PrimeroModule, UserGroup, Role, User, Child, Transition)
  end
end
