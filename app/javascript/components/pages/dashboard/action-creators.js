import { RECORD_PATH } from "../../../config";
import { DB_COLLECTIONS_NAMES } from "../../../db";

import actions from "./actions";

export const fetchFlags = (recordType, activeOnly = false) => {
  const commonPath = `record_type=${recordType}`;
  const path = activeOnly
    ? `${RECORD_PATH.flags}?active_only=true&${commonPath}`
    : `${RECORD_PATH.flags}?${commonPath}`;

  return {
    type: actions.DASHBOARD_FLAGS,
    api: {
      path
    }
  };
};

export const fetchCasesByStatus = () => {
  return {
    type: actions.CASES_BY_STATUS,
    payload: {
      casesByStatus: {
        open: "100",
        closed: "100"
      }
    }
  };
};

export const fetchCasesByCaseWorker = () => {
  return {
    type: actions.CASES_BY_CASE_WORKER,
    payload: {
      casesByCaseWorker: [
        {
          case_worker: "Case Worker 1",
          assessment: "2",
          case_plan: "1",
          follow_up: "0",
          services: "1"
        },
        {
          case_worker: "Case Worker 2",
          assessment: "2",
          case_plan: "1",
          follow_up: "0",
          services: "1"
        }
      ]
    }
  };
};

export const fetchCasesRegistration = () => {
  return {
    type: actions.CASES_REGISTRATION,
    payload: {
      casesRegistration: {
        jan: 150,
        feb: 100,
        mar: 50,
        apr: 120,
        may: 200,
        jun: 100,
        jul: 80,
        aug: 50,
        sep: 120
      }
    }
  };
};

export const fetchCasesOverview = () => {
  return {
    type: actions.CASES_OVERVIEW,
    payload: {
      casesOverview: {
        transfers: 4,
        waiting: 1,
        pending: 1,
        rejected: 1
      }
    }
  };
};

export const fetchServicesStatus = () => {
  return {
    type: actions.SERVICES_STATUS,
    payload: {
      services: {
        caseManagement: [
          { status: "in_progress", high: 4, medium: 0, low: 1 },
          { status: "near_deadline", high: 1, medium: 0, low: 0 },
          { status: "overdue", high: 1, medium: 0, low: 1 }
        ],
        screening: [
          { status: "in_progress", high: 4, medium: 0, low: 1 },
          { status: "near_deadline", high: 1, medium: 0, low: 0 },
          { status: "overdue", high: 1, medium: 0, low: 1 }
        ]
      }
    }
  };
};

export const openPageActions = payload => {
  return {
    type: actions.OPEN_PAGE_ACTIONS,
    payload
  };
};

export const fetchDashboards = () => ({
  type: actions.DASHBOARDS,
  api: {
    path: RECORD_PATH.dashboards,
    db: {
      collection: DB_COLLECTIONS_NAMES.DASHBOARDS
    }
  }
});

export const fetchRegisteredCasesByProtectionConcern = () => ({
  type: actions.REGISTERED_CASES_BY_PROTECTION_CONCERN,
  api: {
    path: "dashboards/protection_concerns_services_stats"
  }
});

export const fetchRegisteredAndResolvedCasesByDistricts = () => ({
  type: actions.REGISTERED_AND_RESOLVED_CASES_BY_DISTRICTS,
  api: {
    path: "dashboards/registered_resolved_cases_stats"
  }
});

export const fetchMonthlyRegisteredAndResolvedCases = () => ({
  type: actions.MONTHLY_REGISTERED_AND_RESOLVED_CASES,
  api: {
    path: "dashboards/month_wise_registered_and_resolved_cases_stats"
  }
});

export const fetchRegisteredAndResolvedCasesDept = () => ({
  type: actions.REGISTERED_AND_RESOLVED_CASES_BY_DEPT,
  api: {
    path: "dashboards/get_resolved_cases_by_department"
  }
});

export const fetchHarmCases = () => ({
  type: actions.HARM_CASES,
  api: {
    path: "dashboards/significant_harm_cases_registered_by_age_and_gender_stats"
  }
});

export const fetchResCasesByAge = () => ({
  type: actions.RES_CASES_BY_AGE,
  api: {
    path: "dashboards/resolved_cases_by_age_and_violence"
  }
});

export const fetchResCasesByGender = () => ({
  type: actions.RES_CASES_BY_GENDER,
  api: {
    path: "dashboards/resolved_cases_by_gender_and_types_of_violence_stats"
  }
});

export const fetchStaffByGender = () => ({
  type: actions.STAFF_BY_GENDER,
  api: {
    path: "dashboards/staff_by_gender"
  }
});

export const fetchSocialServiceWorkforce = () => ({
  type: actions.SOCIAL_SERVICE_WORKFORCE,
  api: {
    path: "dashboards/social_service_workforce_by_district"
  }
});

export const fetchCaseStatuses = () => ({
  type: actions.CASE_STATUSES,
  api: {
    path: "dashboards/get_child_statuses"
  }
});

export const fetchDemographicsAnalysis = () => ({
  type: actions.DEMOGRAPHICS_ANALYSIS,
  api: {
    path: "dashboards/demographic_analysis_stats"
  }
});

// Bulk Graphs

export const fetchGraphOne = () => ({
  type: actions.GRAPH_ONE,
  api: {
    path: "dashboards/cases_referred_to_departments"
  }
});

export const fetchGraphTwo = () => ({
  type: actions.GRAPH_TWO,
  api: {
    path: "dashboards/get_cases_with_supervision_order"
  }
});

export const fetchGraphThree = () => ({
  type: actions.GRAPH_THREE,
  api: {
    path: "dashboards/get_cases_with_custody_order"
  }
});

export const fetchGraphFour = () => ({
  type: actions.GRAPH_FOUR,
  api: {
    path: "dashboards/alternative_care_placement_by_gender"
  }
});

export const fetchGraphFive = () => ({
  type: actions.GRAPH_FIVE,
  api: {
    path: "dashboards/demographic_analysis_stats"
  }
});

export const fetchGraphSix = () => ({
  type: actions.GRAPH_SIX,
  api: {
    path: "dashboards/services_provided_by_age_and_violence"
  }
});

export const fetchGraphSeven = () => ({
  type: actions.GRAPH_SEVEN,
  api: {
    path: "dashboards/demographic_analysis_stats"
  }
});

export const fetchGraphEight = () => ({
  type: actions.GRAPH_EIGHT,
  api: {
    path: "dashboards/demographic_analysis_stats"
  }
});

export const fetchGraphNine = () => ({
  type: actions.GRAPH_NINE,
  api: {
    path: "dashboards/referred_resolved_cases_by_department"
  }
});

export const fetchGraphTen = () => ({
  type: actions.GRAPH_TEN,
  api: {
    path: "dashboards/cases_receiving_services_by_gender"
  }
});

export const fetchGraphEleven = () => ({
  type: actions.GRAPH_ELEVEN,
  api: {
    path: "dashboards/services_provided_by_gender_and_violence"
  }
});

export const fetchGraphTwelve = () => ({
  type: actions.GRAPH_TWELVE,
  api: {
    path: "dashboards/demographic_analysis_stats"
  }
});

export const fetchGraphThirteen = () => ({
  type: actions.GRAPH_THIRTEEN,
  api: {
    path: "dashboards/transffered_cases_by_district"
  }
});

export const fetchGraphFourteen = () => ({
  type: actions.GRAPH_FOURTEEN,
  api: {
    path: "dashboards/transfer_rejected_cases_with_district"
  }
});

export const fetchGraphFifteen = () => ({
  type: actions.GRAPH_FIFTEEN,
  api: {
    path: "dashboards/services_recieved_by_type_of_physical_violence"
  }
});

export const fetchGraphSixteen = () => ({
  type: actions.GRAPH_SIXTEEN,
  api: {
    path: "dashboards/registered_resolved_by_gender_and_age"
  }
});

export const fetchGraphSeventeen = () => ({
  type: actions.GRAPH_SEVENTEEN,
  api: {
    path: "dashboards/demographic_analysis_stats"
  }
});

export const fetchGraphEigtheen = () => ({
  type: actions.GRAPH_EIGHTEEN,
  api: {
    path: "dashboards/demographic_analysis_stats"
  }
});

export const fetchGraphNineteen = () => ({
  type: actions.GRAPH_NINETEEN,
  api: {
    path: "dashboards/demographic_analysis_stats"
  }
});

export const fetchGraphTwenty = () => ({
  type: actions.GRAPH_TWENTY,
  api: {
    path: "dashboards/demographic_analysis_stats"
  }
});

export const fetchGraphTwentyOne = () => ({
  type: actions.GRAPH_TWENTY_ONE,
  api: {
    path: "dashboards/map_of_registered_cases_district_wise"
  }
});

export const fetchGraphTwentyFour = () => ({
  type: actions.GRAPH_TWENTY_FOUR,
  api: {
    path: "dashboards/cases_with_court_orders"
  }
});
