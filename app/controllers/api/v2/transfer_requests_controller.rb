# frozen_string_literal: true

# API for creating transfer requests
class Api::V2::TransferRequestsController < Api::V2::RecordResourceController
  def index
    authorize! :read, @record
    @transitions = @record.transfer_requests
    render 'api/v2/transitions/index'
  end

  def create
    authorize! :request_transfer, @record.class
    @transition = transfer_request(@record)
    updates_for_record(@record)
    render 'api/v2/transitions/create'
  end

  def update
    authorize! :read, @record
    @transition = TransferRequest.find(params[:id])
    @transition.respond!(params[:data])
    updates_for_record(@transition.record)
    render 'api/v2/transitions/update'
  end

  def index_action_message
    'list_transfer_requests'
  end

  def create_action_message
    'transfer_request'
  end

  def update_action_message
    "transfer_#{params[:data][:status]}"
  end

  private

  def transfer_request(record)
    notes = params[:data][:notes]
    consent_individual_transfer = params[:data][:consent_individual_transfer] || false
    TransferRequest.create!(
      transitioned_by: current_user.user_name,
      consent_individual_transfer: consent_individual_transfer,
      transitioned_to: record.owned_by,
      notes: notes, record: record
    )
  end
end
