# frozen_string_literal: true

module Tasks
  # Class for Assessment Task
  class RegistrationTask < Task
    def self.from_case(record)
      task?(record) ? [RegistrationTask.new(record)] : []
    end

    def self.task?(record)
      record.data["registration_due_date_c67c49c"].present? && record.data["date_and_time_registration_was_completed_529de5d"].blank? && record.data["due_date_for_initial_assessment_0e82430"].blank?
    end

    def self.field_name
      'registration_due_date_c67c49c'
    end

    def due_date
     parent_case.data["registration_due_date_c67c49c"]
    end

    def completion_field
      'date_and_time_registration_was_completed_529de5d'
    end
  end
end
