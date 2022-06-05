# frozen_string_literal: true

# Represents actions to request approval for a record and to approve those requests
class Approval < ValueObject
  attr_accessor :record, :fields, :user_name, :approval_type, :approval_id, :comments

  ASSESSMENT = 'assessment'
  CASE_PLAN = 'case_plan'
  CLOSURE = 'closure'
  ACTION_PLAN = 'action_plan'
  GBV_CLOSURE = 'gbv_closure'

  APPROVAL_STATUS_PENDING = 'pending'
  APPROVAL_STATUS_REQUESTED = 'requested'
  APPROVAL_STATUS_APPROVED = 'approved'
  APPROVAL_STATUS_REJECTED = 'rejected'

  ASSESSMENT_FIELDS = {
    approved: 'assessment_approved',
    approval_status: 'approval_status_assessment',
    approved_date: 'assessment_approved_date',
    approved_comments: 'assessment_approved_comments'
  }.freeze

  CASE_PLAN_FIELDS = {
    approved: 'case_plan_approved',
    approval_status: 'approval_status_case_plan',
    approved_date: 'case_plan_approved_date',
    approved_comments: 'case_plan_approved_comments',
    approval_type: 'case_plan_approval_type'
  }.freeze

  CLOSURE_FIELDS = {
    approved: 'closure_approved',
    approval_status: 'approval_status_closure',
    approved_date: 'closure_approved_date',
    approved_comments: 'closure_approved_comments'
  }.freeze

  ACTION_PLAN_FIELDS = {
    approved: 'action_plan_approved',
    approval_status: 'approval_status_action_plan',
    approved_date: 'action_plan_approved_date',
    approved_comments: 'action_plan_approved_comments',
    approval_type: 'action_plan_approval_type'
  }.freeze

  GBV_CLOSURE_FIELDS = {
    approved: 'gbv_closure_approved',
    approval_status: 'approval_status_gbv_closure',
    approved_date: 'gbv_closure_approved_date',
    approved_comments: 'gbv_closure_approved_comments'
  }.freeze

  class << self
    def get!(approval_id, record, user_name, params = {})
      raise Errors::UnknownPrimeroEntityType, 'approvals.error_invalid_approval' if types.exclude?(approval_id)

      Approval.new(approval_id: approval_id, record: record, user_name: user_name,
                   fields: "Approval::#{approval_id.upcase}_FIELDS".constantize, approval_type: params[:approval_type],
                   comments: params[:notes])
    end

    def types
      [Approval::ASSESSMENT, Approval::CASE_PLAN, Approval::CLOSURE, Approval::ACTION_PLAN, Approval::GBV_CLOSURE]
    end
  end

  def perform!(status)
    case status
    when Approval::APPROVAL_STATUS_REQUESTED then request!
    when Approval::APPROVAL_STATUS_APPROVED then approve!
    when Approval::APPROVAL_STATUS_REJECTED then reject!
    else raise Errors::InvalidPrimeroEntityType, 'approvals.error_invalid_status'
    end
    record.save!
  end

  def request!
    record.add_approval_alert(approval_id, SystemSettings.current)
    record.send("#{fields[:approval_status]}=", Approval::APPROVAL_STATUS_PENDING)

    if record.module.selectable_approval_types.present? && approval_id == Approval::CASE_PLAN
      record.send("#{fields[:approval_type]}=", approval_type)
    end

    record.approval_subforms ||= []
    record.approval_subforms << approval_request_action(Approval::APPROVAL_STATUS_PENDING, approval_id, user_name)
  end

  def approve!
    record.send("#{fields[:approved]}=", true)
    record.send("#{fields[:approval_status]}=", Approval::APPROVAL_STATUS_APPROVED)
    record.send("#{fields[:approved_date]}=", Date.today)
    record.send("#{fields[:approved_comments]}=", comments) if comments.present?
    record.approval_subforms ||= []
    record.approval_subforms << approval_response_action(Approval::APPROVAL_STATUS_APPROVED, approval_id, user_name,
                                                         comments)
    delete_approval_alerts
  end

  def reject!
    record.send("#{fields[:approved]}=", false)
    record.send("#{fields[:approval_status]}=", Approval::APPROVAL_STATUS_REJECTED)
    record.send("#{fields[:approved_date]}=", Date.today)
    record.send("#{fields[:approved_comments]}=", comments) if comments.present?
    record.approval_subforms ||= []
    record.approval_subforms << approval_response_action(Approval::APPROVAL_STATUS_REJECTED, approval_id, user_name,
                                                         comments)
    delete_approval_alerts
  end

  protected

  def approval_request_action(status, approval_id, requested_by)
    approval_action(status, approval_requested_for: approval_id, requested_by: requested_by)
  end

  def approval_response_action(status, approval_id, approved_by, comments = nil)
    approval_action(status, approval_response_for: approval_id, approval_status: status, approved_by: approved_by,
                            approval_manager_comments: comments)
  end

  def approval_action(status, properties)
    status = Approval::APPROVAL_STATUS_REQUESTED if status == Approval::APPROVAL_STATUS_PENDING
    action = { approval_requested_for: nil, approval_response_for: nil, approval_for_type: nil,
               approval_date: Date.today, approval_status: status, approved_by: nil, requested_by: nil,
               approval_manager_comments: nil }.merge(properties)

    if [action[:approval_requested_for], action[:approval_response_for]].include?(Approval::CASE_PLAN)
      action = action.merge(approval_for_type: record.case_plan_approval_type)
    end

    action.compact
  end

  def delete_approval_alerts
    return if record.alerts.blank?

    record.alerts.where(type: approval_id, alert_for: Alertable::APPROVAL).destroy_all
  end
end
