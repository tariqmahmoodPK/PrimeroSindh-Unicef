# frozen_string_literal: true

# API for fetching the aggregate statistics backing the dashboards
class Api::V2::DashboardsController < ApplicationApiController
  def index
    @dashboards = current_user.role.dashboards
    indicators = @dashboards.map(&:indicators).flatten
    @indicator_stats = IndicatorQueryService.query(indicators, current_user)
    @indicator_stats["indicators"] = Child.get_role_wise_workflow(current_user)
  end

  def resolved_cases_by_gender_and_types_of_violence_stats
    @stats = Child.resolved_cases_by_gender_and_types_of_violence(current_user)
  end

  def protection_concerns_services_stats
    @stats = Child.protection_concern_stats(current_user)
  end

  def registered_resolved_cases_stats
    @stats = Child.registered_resolved_cases_by_district(current_user)
  end

  def month_wise_registered_and_resolved_cases_stats
    @stats = Child.month_wise_registered_and_resolved_cases(current_user)
  end

  def get_resolved_cases_by_department
    @cases = Child.resolved_cases_department_wise(current_user)
  end

  def significant_harm_cases_registered_by_age_and_gender_stats
    @stats = Child.significant_harm_cases_registered_by_age_and_gender(current_user)
  end

  def resolved_cases_by_age_and_violence
    @cases = Child.resolved_cases_by_age_and_violence(current_user)
  end

  def social_service_workforce_by_district
    @users = User.social_service_workforce_by_district(current_user)
  end

  def get_child_statuses
    @statuses = Child.get_child_statuses(current_user)
  end

  def demographic_analysis_stats
    @stats = Child.demographic_analysis(current_user)
  end

  def staff_by_gender
    @stats = User.staff_by_gender_stats(current_user)
  end

  def referred_resolved_cases_by_department
    @stats = Child.referred_resolved_cases_by_department(current_user)
  end

  def services_provided_by_age_and_violence
    @stats = Child.services_provided_by_age_and_violence(current_user)
  end

  def alternative_care_placement_by_gender
    @stats = Child.alternative_care_placement_by_gender(current_user)
  end
  
  def get_cases_with_supervision_order
    @cases = Child.get_cases_with_supervision_order(current_user)
  end

  def get_cases_with_custody_order
    @cases = Child.get_cases_with_custody_order(current_user)
  end

  def cases_referred_to_departments
    @stats = Child.cases_referred_to_departments(current_user)
  end
  
  def cases_receiving_services_by_gender
    @stats = Child.cases_receiving_services_by_gender(current_user)
  end

  def services_provided_by_gender_and_violence
    @stats = Child.services_provided_by_gender_and_violence(current_user)
  end

  def registered_resolved_by_gender_and_age
    @cases = Child.registered_resolved_by_gender_and_age(current_user)
  end

  def services_recieved_by_type_of_physical_violence
    @cases = Child.services_recieved_by_type_of_physical_violence(current_user)
  end

  def transfer_rejected_cases_with_district
    @cases = Child.transfer_rejected_cases_with_district(current_user)
  end

  def services_provided_by_police
    @cases = Child.services_provided_by_police(current_user)
  end

  def transffered_cases_by_district
    @stats = Child.transffered_cases_by_district(current_user)
  end

  def map_of_registered_cases_district_wise
    @stats = Child.map_of_registered_cases_district_wise(current_user)
  end

  def cases_with_court_orders
    @cases = Child.get_cases_with_court_orders(current_user)
  end
  
  def role_wise_workflow
    @cases = Child.get_role_wise_workflow(current_user)
  end
end
