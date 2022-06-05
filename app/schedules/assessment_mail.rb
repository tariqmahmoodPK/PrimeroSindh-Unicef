class AssessmentMail < PeriodicJob
  def perform_rescheduled
    self.send_notification
  rescue StandardError => e
    Rails.logger.error("Error in the notifying to the managers\n#{e.backtrace}")
  end

  def self.reschedule_after
    1.days
  end

  def send_notification
    @childs = Child.check_registration_and_assessment_date
    return if @childs.nil?

    @childs.each do |child|
      registration_date = child.data["registration_date"]

      username = child.data["last_updated_by"].present? ? child.data["last_updated_by"] : child.data["owned_by"]
      user_id = User.find_by_user_name(username).id
      case_type = child.get_hash_keys_values("is_this_a_significant_harm_case_or_a_regular_case") == Child::RISK_LEVEL_HIGH ? 'Regular' : 'Significant Harm'
      due_date = child.data['assessment_due_date']
      if registration_date == Date.today - 1
        AssessmentMailer.complete_initial_assessment(child.id, user_id, case_type, due_date).deliver_later
      else
        AssessmentMailer.shc_reminder_complete_initial_assessment(child.id, user_id, due_date).deliver_later
      end
    end
  end
end
