# frozen_string_literal: true

# PeriodicJob job to clean up exports older than 30 days
class NotifyDcpuAdministrator < PeriodicJob
  def perform_rescheduled
    self.notify
  rescue StandardError => e
    Rails.logger.error("Error in the notifying to the CPI In-charge\n#{e.backtrace}")
  end

  def self.reschedule_after
    1.day
  end

  def notify
    Child.with_approvals_subforms.each do |child|
      child.approval_subforms.each do |approval|
        next unless approval['approval_requested_for'] && approval['approval_status'] == "requested"

        admins = User.dcpu_admin_with_mail_enabled
        next Rails.logger.info "Closure Approval Request Mail not sent. No CPI In-charge present with send_mail enabled. Case [#{child.id}]" if admins.blank?

        admins.each { |admin| NotifyDcpuAdministratorMailer.notify_about_pending_approvals(admin, child).deliver_later }
      end
    end
  end

  def self.perform_job?
    # Loading service configurations
    # activestorage/lib/active_storage/engine.rb
    # initializer "active_storage.services"
    ActiveStorage::Blob.service
    current_service = Rails.application.config.active_storage.service.to_s
    Rails.configuration.active_storage.service_configurations.dig(current_service, 'service') == 'Disk'
  end
end
