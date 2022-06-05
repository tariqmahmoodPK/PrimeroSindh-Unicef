# frozen_string_literal: true

module Tasks
  # Class for Assessment Task
  class AssessmentTask < Task
    def self.from_case(record)
      task?(record) ? [AssessmentTask.new(record)] : []
    end

    def self.task?(record)
      record.data["due_date_for_initial_assessment_0e82430"].present? && record.data["date_and_time_initial_assessment_started_a6e573c"].blank?
    end

    def self.field_name
      'due_date_for_initial_assessment_0e82430'
    end

    def due_date
      parent_case.data["due_date_for_initial_assessment_0e82430"]
    end

    def completion_field
      'date_and_time_initial_assessment_started_a6e573c'
    end
  end
end
