# frozen_string_literal: true

require 'rails_helper'

describe Api::V2::TracingRequestsController, type: :request do
  before :each do
    @tracing_request1 = TracingRequest.create!(data: { inquiry_date: Date.new(2019, 3, 1), relation_name: 'Test 1' })
    @tracing_request2 = TracingRequest.create!(data: { inquiry_date: Date.new(2018, 3, 1), relation_name: 'Test 2' })
    @trace = Trace.create!(tracing_request: @tracing_request1, name: 'Test Trace')
    @trace1 = Trace.create!(
      data: { name: 'Trace Test 1' },
      tracing_request: @tracing_request2
    )
    @trace2 = Trace.create!(
      data: { name: 'Trace Test 2' },
      tracing_request: @tracing_request2
    )
    Sunspot.commit
  end

  let(:json) { JSON.parse(response.body) }

  describe 'GET /api/v2/tracing_requests', search: true do
    it 'lists tracing_requests and accompanying metadata' do
      login_for_test
      get '/api/v2/tracing_requests'

      expect(response).to have_http_status(200)
      expect(json['data'].size).to eq(2)
      expect(json['data'].map { |c| c['relation_name'] }).to include(
        @tracing_request1.relation_name,
        @tracing_request2.relation_name
      )
      expect(json['metadata']['total']).to eq(2)
      expect(json['metadata']['per']).to eq(20)
      expect(json['metadata']['page']).to eq(1)
    end

    it 'returns flag_count for the short form ' do
      @tracing_request1.add_flag('This is a flag IN', Date.today, 'faketest')

      login_for_test(permissions: permission_flag_record)
      get '/api/v2/tracing_requests?fields=short'

      expect(response).to have_http_status(200)
      expect(
        json['data'].map { |record| record['flag_count'] if record['id'] == @tracing_request1.id }.compact
      ).to eq([1])
    end
  end

  describe 'GET /api/v2/tracing_requests/:id' do
    it 'fetches the correct record with code 200' do
      login_for_test
      get "/api/v2/tracing_requests/#{@tracing_request1.id}"

      expect(response).to have_http_status(200)
      expect(json['data']['id']).to eq(@tracing_request1.id)
    end

    it 'contains traces embedded in the data hash' do
      login_for_test
      get "/api/v2/tracing_requests/#{@tracing_request1.id}"

      expect(json['data']['tracing_request_subform_section'].size).to eq(1)
      expect(json['data']['tracing_request_subform_section'][0]['unique_id']).to eq(@trace.id)
    end
  end

  describe 'POST /api/v2/tracing_requests' do
    it 'creates a new record with 200 and returns it as JSON' do
      login_for_test
      params = { data: { inquiry_date: '2019-04-01', relation_name: 'Test' } }
      post '/api/v2/tracing_requests', params: params, as: :json

      expect(response).to have_http_status(200)
      expect(json['data']['id']).not_to be_empty
      expect(json['data']['inquiry_date']).to eq(params[:data][:inquiry_date])
      expect(json['data']['relation_name']).to eq(params[:data][:relation_name])
      expect(TracingRequest.find_by(id: json['data']['id'])).not_to be_nil
    end

    it 'filters sensitive information from logs' do
      allow(Rails.logger).to receive(:debug).and_return(nil)
      login_for_test
      params = { data: { inquiry_date: '2019-04-01', relation_name: 'Test' } }
      post '/api/v2/tracing_requests', params: params, as: :json

      %w[data].each do |fp|
        expect(Rails.logger).to have_received(:debug).with(/\["#{fp}", "\[FILTERED\]"\]/)
      end
    end
  end

  describe 'PATCH /api/v2/tracing_requests/:id' do
    it 'updates an existing record with 200' do
      login_for_test
      params = { data: { inquiry_date: '2019-04-01', relation_name: 'Tester' } }
      patch "/api/v2/tracing_requests/#{@tracing_request1.id}", params: params, as: :json

      expect(response).to have_http_status(200)
      expect(json['data']['id']).to eq(@tracing_request1.id)

      tracing_request1 = TracingRequest.find_by(id: @tracing_request1.id)
      expect(tracing_request1.data['inquiry_date'].iso8601).to eq(params[:data][:inquiry_date])
      expect(tracing_request1.data['relation_name']).to eq(params[:data][:relation_name])
    end

    it 'filters sensitive information from logs' do
      allow(Rails.logger).to receive(:debug).and_return(nil)
      login_for_test
      params = { data: { inquiry_date: '2019-04-01', relation_name: 'Tester' } }
      patch "/api/v2/tracing_requests/#{@tracing_request1.id}", params: params, as: :json

      %w[data].each do |fp|
        expect(Rails.logger).to have_received(:debug).with(/\["#{fp}", "\[FILTERED\]"\]/)
      end
    end
  end

  describe 'DELETE /api/v2/tracing_requests/:id' do
    it 'successfully deletes a record with a code of 200' do
      login_for_test(
        permissions: [
          Permission.new(resource: Permission::TRACING_REQUEST, actions: [Permission::ENABLE_DISABLE_RECORD])
        ]
      )
      delete "/api/v2/tracing_requests/#{@tracing_request1.id}"

      expect(response).to have_http_status(200)
      expect(json['data']['id']).to eq(@tracing_request1.id)

      tracing_request1 = TracingRequest.find_by(id: @tracing_request1.id)
      expect(tracing_request1.record_state).to be false
    end
  end

  describe 'GET /api/v2/tracing_requests/:id/traces' do
    it 'successfully returns the traces with a code of 200' do
      login_for_test(permissions: [Permission.new(resource: Permission::TRACING_REQUEST, actions: [Permission::READ])])

      get "/api/v2/tracing_requests/#{@tracing_request2.id}/traces"

      expect(response).to have_http_status(200)
      expect(json['data'].size).to eq(2)
      expect(json['data'].map { |c| c['id'] }).to include(@trace1.id, @trace2.id)
    end

    it 'returns 403 if the user is not authorized' do
      login_for_test(permissions: [])

      get "/api/v2/tracing_requests/#{@tracing_request2.id}/traces"

      expect(response).to have_http_status(403)
      expect(json['errors'].size).to eq(1)
      expect(json['errors'][0]['resource']).to eq("/api/v2/tracing_requests/#{@tracing_request2.id}/traces")
    end

    it 'returns 404 if the case does not exist' do
      login_for_test(permissions: [Permission.new(resource: Permission::TRACING_REQUEST, actions: [Permission::READ])])

      get '/api/v2/tracing_requests/thisdoesntexist/traces'

      expect(response).to have_http_status(404)
      expect(json['errors'].size).to eq(1)
      expect(json['errors'][0]['resource']).to eq('/api/v2/tracing_requests/thisdoesntexist/traces')
    end
  end

  after :each do
    clean_data(Trace, TracingRequest)
  end
end
