
class NotifyDcpuAdministratorMailer < ActionMailer::Base
  def notify_about_pending_approvals(user, child)
    @child = child
    @user = user
    @url = root_url

    if @user.present?
      mail(to: @user.email,
           subject: "Reminder: Notify CPI In-charge on pending closure approval requests")
    else
      Rails.logger.error "Mail not sent - Case [#{@child.name}] not found"
    end
  end
end
