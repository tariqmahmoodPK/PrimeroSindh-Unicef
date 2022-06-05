import { fromJS } from "immutable";

import { DASHBOARD_NAMES } from "./constants";
import NAMESPACE from "./namespace";

export const selectFlags = state => {
  return state.getIn(["records", NAMESPACE, "flags"], fromJS({}));
};

export const selectCasesByStatus = state => {
  return state.getIn(["records", NAMESPACE, "casesByStatus"], fromJS({}));
};

export const selectCasesByCaseWorker = state => {
  return state.getIn(["records", NAMESPACE, "casesByCaseWorker"], fromJS([]));
};

export const selectCasesRegistration = state => {
  return state.getIn(["records", NAMESPACE, "casesRegistration"], fromJS({}));
};

export const selectCasesOverview = state => {
  return state.getIn(["records", NAMESPACE, "casesOverview"], fromJS({}));
};

export const selectServicesStatus = state => {
  return state.getIn(["records", NAMESPACE, "servicesStatus"], fromJS({}));
};

export const selectIsOpenPageActions = state => {
  return state.getIn(["records", NAMESPACE, "isOpenPageActions"], false);
};

export const getDashboards = state => {
  return state.getIn(["records", NAMESPACE, "data"], false);
};

export const getDashboardByName = (state, name) => {
  const currentState = getDashboards(state);
  const noDashboard = fromJS({});

  if (!currentState) {
    return noDashboard;
  }
  const dashboardData = currentState.filter(f => f.get("name") === name).first();

  return dashboardData?.size ? dashboardData : noDashboard;
};

export const getCasesByAssessmentLevel = state => {
  const currentState = getDashboards(state);

  if (!currentState) {
    return fromJS({});
  }
  const dashboardData = currentState.filter(f => f.get("name") === DASHBOARD_NAMES.CASE_RISK).first();

  return dashboardData?.size ? dashboardData : fromJS({});
};

export const getWorkflowIndividualCases = state => {
  return getDashboardByName(state, DASHBOARD_NAMES.WORKFLOW).deleteIn(["stats", "closed"]);
};

export const getApprovalsAssessment = state => getDashboardByName(state, DASHBOARD_NAMES.APPROVALS_ASSESSMENT);

export const getApprovalsCasePlan = state => getDashboardByName(state, DASHBOARD_NAMES.APPROVALS_CASE_PLAN);

export const getApprovalsClosure = state => getDashboardByName(state, DASHBOARD_NAMES.APPROVALS_CLOSURE);

export const getApprovalsActionPlan = state => getDashboardByName(state, DASHBOARD_NAMES.APPROVALS_ACTION_PLAN);

export const getApprovalsGbvClosure = state => getDashboardByName(state, DASHBOARD_NAMES.APPROVALS_GBV_CLOSURE);

export const getWorkflowTeamCases = state => getDashboardByName(state, DASHBOARD_NAMES.WORKFLOW_TEAM);

export const getReportingLocation = state => getDashboardByName(state, DASHBOARD_NAMES.REPORTING_LOCATION);

export const getApprovalsAssessmentPending = state =>
  getDashboardByName(state, DASHBOARD_NAMES.APPROVALS_ASSESSMENT_PENDING);

export const getApprovalsClosurePending = state => getDashboardByName(state, DASHBOARD_NAMES.APPROVALS_CLOSURE_PENDING);

export const getApprovalsCasePlanPending = state =>
  getDashboardByName(state, DASHBOARD_NAMES.APPROVALS_CASE_PLAN_PENDING);

export const getApprovalsActionPlanPending = state =>
  getDashboardByName(state, DASHBOARD_NAMES.APPROVALS_ACTION_PLAN_PENDING);

export const getApprovalsGbvClosurePending = state =>
  getDashboardByName(state, DASHBOARD_NAMES.APPROVALS_GBV_CLOSURE_PENDING);

export const getProtectionConcerns = state => getDashboardByName(state, DASHBOARD_NAMES.PROTECTION_CONCERNS);

export const getCasesByTaskOverdueAssessment = state =>
  getDashboardByName(state, DASHBOARD_NAMES.CASES_BY_TASK_OVERDUE_ASSESSMENT);

export const getCasesByTaskOverdueCasePlan = state =>
  getDashboardByName(state, DASHBOARD_NAMES.CASES_BY_TASK_OVERDUE_CASE_PLAN);

export const getCasesByTaskOverdueServices = state =>
  getDashboardByName(state, DASHBOARD_NAMES.CASES_BY_TASK_OVERDUE_SERVICES);

export const getCasesByTaskOverdueFollowups = state =>
  getDashboardByName(state, DASHBOARD_NAMES.CASES_BY_TASK_OVERDUE_FOLLOWUPS);

export const getSharedWithMe = state => getDashboardByName(state, DASHBOARD_NAMES.SHARED_WITH_ME);

export const getSharedWithOthers = state => getDashboardByName(state, DASHBOARD_NAMES.SHARED_WITH_OTHERS);

export const getGroupOverview = state => getDashboardByName(state, DASHBOARD_NAMES.GROUP_OVERVIEW);

export const getCaseOverview = state => getDashboardByName(state, DASHBOARD_NAMES.CASE_OVERVIEW);

export const getNationalAdminSummary = state => getDashboardByName(state, DASHBOARD_NAMES.NATIONAL_ADMIN_SUMMARY);

export const getSharedFromMyTeam = state => getDashboardByName(state, DASHBOARD_NAMES.SHARED_FROM_MY_TEAM);

export const getSharedWithMyTeam = state => getDashboardByName(state, DASHBOARD_NAMES.SHARED_WITH_MY_TEAM);

export const getCaseIncidentOverview = state => getDashboardByName(state, DASHBOARD_NAMES.CASE_INCIDENT_OVERVIEW);

export const getCasesBySocialWorker = state => getDashboardByName(state, DASHBOARD_NAMES.CASES_BY_SOCIAL_WORKER);

export const getDashboardFlags = (state, excludeResolved = false) => {
  const flags = state.getIn(["records", NAMESPACE, "flags", "data"], fromJS([]));

  if (excludeResolved) {
    return flags.filter(flag => !flag.get("removed"));
  }

  return flags;
};

export const getCasesToAssign = state => getDashboardByName(state, DASHBOARD_NAMES.CASES_TO_ASSIGN);

export const getRegisteredCasesByProtectionConcern = state => {
  return state.getIn(["records", NAMESPACE, "registeredCasesByProtectionConcern"], fromJS({}));
};

export const getRegisteredAndResolvedCasesByDistricts = state => {
  return state.getIn(["records", NAMESPACE, "registeredAndResolvedCasesByDistricts"], fromJS({}));
};

export const getMonthlyRegisteredAndResolvedCases = state => {
  return state.getIn(["records", NAMESPACE, "monthlyRegisteredAndResolvedCases"], fromJS({}));
};

export const getRegisteredAndResolvedCasesDept = state => {
  return state.getIn(["records", NAMESPACE, "registeredAndResolvedCasesDept"], fromJS({}));
};

export const getHarmCases = state => {
  return state.getIn(["records", NAMESPACE, "harmCases"], fromJS({}));
};

export const getResCasesByAge = state => {
  return state.getIn(["records", NAMESPACE, "resCasesByAge"], fromJS({}));
};

export const getResCasesByGender = state => {
  return state.getIn(["records", NAMESPACE, "resCasesByGender"], fromJS({}));
};

export const getStaffByGender = state => {
  return state.getIn(["records", NAMESPACE, "staffByGender"], fromJS({}));
};

export const getSocialServiceWorkforce = state => {
  return state.getIn(["records", NAMESPACE, "socialServiceWorkforce"], fromJS({}));
};

export const getCaseStatuses = state => {
  return state.getIn(["records", NAMESPACE, "caseStatuses"], fromJS({}));
};

export const getDemographicsAnalysis = state => {
  return state.getIn(["records", NAMESPACE, "demographicsAnalysis"], fromJS({}));
};

// Bulk

export const getGraphOne = state => {
  return state.getIn(["records", NAMESPACE, "graphOne"], fromJS({}));
};

export const getGraphTwo = state => {
  return state.getIn(["records", NAMESPACE, "graphTwo"], fromJS({}));
};

export const getGraphThree = state => {
  return state.getIn(["records", NAMESPACE, "graphThree"], fromJS({}));
};

export const getGraphFour = state => {
  return state.getIn(["records", NAMESPACE, "graphFour"], fromJS({}));
};

export const getGraphFive = state => {
  return state.getIn(["records", NAMESPACE, "graphFive"], fromJS({}));
};

export const getGraphSix = state => {
  return state.getIn(["records", NAMESPACE, "graphSix"], fromJS({}));
};

export const getGraphSeven = state => {
  return state.getIn(["records", NAMESPACE, "graphSeven"], fromJS({}));
};

export const getGraphEight = state => {
  return state.getIn(["records", NAMESPACE, "graphEight"], fromJS({}));
};

export const getGraphNine = state => {
  return state.getIn(["records", NAMESPACE, "graphNine"], fromJS({}));
};

export const getGraphTen = state => {
  return state.getIn(["records", NAMESPACE, "graphTen"], fromJS({}));
};

export const getGraphEleven = state => {
  return state.getIn(["records", NAMESPACE, "graphEleven"], fromJS({}));
};

export const getGraphTwelve = state => {
  return state.getIn(["records", NAMESPACE, "graphTwelve"], fromJS({}));
};

export const getGraphThirteen = state => {
  return state.getIn(["records", NAMESPACE, "graphThirteen"], fromJS({}));
};

export const getGraphFourteen = state => {
  return state.getIn(["records", NAMESPACE, "graphFourteen"], fromJS({}));
};

export const getGraphFifteen = state => {
  return state.getIn(["records", NAMESPACE, "graphFifteen"], fromJS({}));
};

export const getGraphSixteen = state => {
  return state.getIn(["records", NAMESPACE, "graphSixteen"], fromJS({}));
};

export const getGraphSeventeen = state => {
  return state.getIn(["records", NAMESPACE, "graphSeventeen"], fromJS({}));
};

export const getGraphEighteen = state => {
  return state.getIn(["records", NAMESPACE, "graphEighteen"], fromJS({}));
};

export const getGraphNineteen = state => {
  return state.getIn(["records", NAMESPACE, "graphNineteen"], fromJS({}));
};

export const getGraphTwenty = state => {
  return state.getIn(["records", NAMESPACE, "graphTwenty"], fromJS({}));
};

export const getGraphTwentyOne = state => {
  return state.getIn(["records", NAMESPACE, "graphTwentyOne"], fromJS({}));
};

export const getGraphTwentyFour = state => {
  return state.getIn(["records", NAMESPACE, "graphTwentyFour"], fromJS({}));
};
