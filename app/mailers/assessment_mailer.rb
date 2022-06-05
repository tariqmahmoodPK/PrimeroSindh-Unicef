class AssessmentMailer < ActionMailer::Base
  def start_initial_assessment(case_id, case_type, user_id, due_date)
    @user = User.find_by(id: user_id)
    @child = Child.find_by(id: case_id)
    @case_type = case_type
    @due_date = due_date
    @url = root_url

    if @child.present?
      mail(to: @user.email,
           subject: "Start initial assessment on #{@child.short_id}")
    else
      Rails.logger.error "Mail not sent - Case [#{case_id}] not found"
    end
  end

  def complete_initial_assessment(case_id, user_id, case_type, due_date)
    @user = User.find_by(id: user_id)
    @child = Child.find_by(id: case_id)
    @case_type = case_type
    @due_date = due_date
    @url = root_url

    if @child.present?
      mail(to: @user.email,
           subject: "Complete initial assessment")
    else
      Rails.logger.error "Mail not sent - Case [#{case_id}] not found"
    end
  end

  def regular_reminder_complete_initial_assessment(case_id, user_id, due_date)
    @user = User.find_by(id: user_id)
    @child = Child.find_by(id: case_id)
    @due_date = due_date
    @url = root_url

    if @child.present?
      mail(to: @user.email,
           subject: "Reminder: Complete initial assessment on #{@child.short_id}")
    else
      Rails.logger.error "Mail not sent - Case [#{case_id}] not found"
    end
  end

  def shc_reminder_complete_initial_assessment(case_id, user_id, due_date)
    @user = User.find_by(id: user_id)
    @child = Child.find_by(id: case_id)
    @due_date = due_date
    @url = root_url

    if @child.present?
      mail(to: @user.email,
           subject: "Reminder: Complete initial assessment on #{@child.short_id}")
    else
      Rails.logger.error "Mail not sent - Case [#{case_id}] not found"
    end
  end

  def start_comprehensive_assessment(case_id, user_id, case_type, due_date)
    @user = User.find_by(id: user_id)
    @child = Child.find_by(id: case_id)
    @case_type = case_type
    @due_date = due_date
    @url = root_url

    if @child.present?
      mail(to: @user.email,
           subject: "Complete comprehensive assessment on #{@child.short_id}")
    else
      Rails.logger.error "Mail not sent - Case [#{case_id}] not found"
    end
  end
end
