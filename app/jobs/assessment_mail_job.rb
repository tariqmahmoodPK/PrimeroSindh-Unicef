class AssessmentMailJob < ApplicationJob
  queue_as :mailer

  def perform(user_id, case_id, due_date)
    @child = Child.find_by(id: case_id)
    return if @child.data["date_and_time_initial_assessment_was_completed_5c8fae2"].present?
    AssessmentMailer.regular_reminder_complete_initial_assessment(case_id, user_id, due_date).deliver_later
  end
end
