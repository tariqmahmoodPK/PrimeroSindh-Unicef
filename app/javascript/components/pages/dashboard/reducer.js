import { fromJS, Map } from "immutable";
import orderBy from "lodash/orderBy";

import actions from "./actions";
import NAMESPACE from "./namespace";
import { DASHBOARD_FLAGS_SORT_ORDER, DASHBOARD_FLAGS_SORT_FIELD } from "./constants";

const DEFAULT_STATE = Map({});

const reducer = (state = DEFAULT_STATE, { type, payload }) => {
  if (type == actions.GRAPH_TWENTY_FOUR_SUCCESS) {
    console.log("type ", type, payload);
  }

  switch (type) {
    case actions.REGISTERED_CASES_BY_PROTECTION_CONCERN_SUCCESS:
      return state.set("registeredCasesByProtectionConcern", fromJS(payload));
    case actions.REGISTERED_AND_RESOLVED_CASES_BY_DISTRICTS_SUCCESS:
      return state.set("registeredAndResolvedCasesByDistricts", fromJS(payload));
    case actions.MONTHLY_REGISTERED_AND_RESOLVED_CASES_SUCCESS:
      return state.set("monthlyRegisteredAndResolvedCases", fromJS(payload));
    case actions.REGISTERED_AND_RESOLVED_CASES_BY_DEPT_SUCCESS:
      return state.set("registeredAndResolvedCasesDept", fromJS(payload));
    case actions.HARM_CASES_SUCCESS:
      return state.set("harmCases", fromJS(payload));
    case actions.RES_CASES_BY_AGE_SUCCESS:
      return state.set("resCasesByAge", fromJS(payload));
    case actions.RES_CASES_BY_GENDER_SUCCESS:
      return state.set("resCasesByGender", fromJS(payload));
    case actions.STAFF_BY_GENDER_SUCCESS:
      return state.set("staffByGender", fromJS(payload));
    case actions.SOCIAL_SERVICE_WORKFORCE_SUCCESS:
      return state.set("socialServiceWorkforce", fromJS(payload));
    case actions.CASE_STATUSES_SUCCESS:
      return state.set("caseStatuses", fromJS(payload));
    case actions.DEMOGRAPHICS_ANALYSIS_SUCCESS:
      return state.set("demographicsAnalysis", fromJS(payload));
    case actions.GRAPH_ONE_SUCCESS:
      return state.set("graphOne", fromJS(payload));
    case actions.GRAPH_TWO_SUCCESS:
      return state.set("graphTwo", fromJS(payload));
    case actions.GRAPH_THREE_SUCCESS:
      return state.set("graphThree", fromJS(payload));
    case actions.GRAPH_FOUR_SUCCESS:
      return state.set("graphFour", fromJS(payload));
    case actions.GRAPH_FIVE_SUCCESS:
      return state.set("graphFive", fromJS(payload));
    case actions.GRAPH_SIX_SUCCESS:
      return state.set("graphSix", fromJS(payload));
    case actions.GRAPH_SEVEN_SUCCESS:
      return state.set("graphSeven", fromJS(payload));
    case actions.GRAPH_EIGHT_SUCCESS:
      return state.set("graphEight", fromJS(payload));
    case actions.GRAPH_NINE_SUCCESS:
      return state.set("graphNine", fromJS(payload));
    case actions.GRAPH_TEN_SUCCESS:
      return state.set("graphTen", fromJS(payload));
    case actions.GRAPH_ELEVEN_SUCCESS:
      return state.set("graphEleven", fromJS(payload));
    case actions.GRAPH_TWELVE_SUCCESS:
      return state.set("graphTwelve", fromJS(payload));
    case actions.GRAPH_THIRTEEN_SUCCESS:
      return state.set("graphThirteen", fromJS(payload));
    case actions.GRAPH_FOURTEEN_SUCCESS:
      return state.set("graphFourteen", fromJS(payload));
    case actions.GRAPH_FIFTEEN_SUCCESS:
      return state.set("graphFifteen", fromJS(payload));
    case actions.GRAPH_SIXTEEN_SUCCESS:
      return state.set("graphSixteen", fromJS(payload));
    case actions.GRAPH_SEVENTEEN_SUCCESS:
      return state.set("graphSeventeen", fromJS(payload));
    case actions.GRAPH_EIGHTEEN_SUCCESS:
      return state.set("graphEighteen", fromJS(payload));
    case actions.GRAPH_NINETEEN_SUCCESS:
      return state.set("graphNineteen", fromJS(payload));
    case actions.GRAPH_TWENTY:
      return state.set("graphTwenty", fromJS(payload));
    case actions.GRAPH_TWENTY_ONE_SUCCESS:
      return state.set("graphTwentyOne", fromJS(payload));
    case actions.GRAPH_TWENTY_FOUR_SUCCESS:
      return state.set("graphTwentyFour", fromJS(payload));
    case actions.DASHBOARD_FLAGS:
      return state.set("flags", fromJS(payload));
    case actions.CASES_BY_STATUS:
      return state.set("casesByStatus", fromJS(payload.casesByStatus));
    case actions.CASES_BY_CASE_WORKER:
      return state.set("casesByCaseWorker", fromJS(payload.casesByCaseWorker));
    case actions.CASES_REGISTRATION:
      return state.set("casesRegistration", fromJS(payload.casesRegistration));
    case actions.CASES_OVERVIEW:
      return state.set("casesOverview", fromJS(payload.casesOverview));
    case actions.DASHBOARDS_STARTED:
      return state.set("loading", fromJS(payload)).set("errors", false);
    case actions.DASHBOARDS_SUCCESS:
      return state.set("data", fromJS(payload.data));
    case actions.DASHBOARDS_FINISHED:
      return state.set("loading", fromJS(payload));
    case actions.DASHBOARDS_FAILURE:
      return state.set("errors", true);
    case actions.DASHBOARD_FLAGS_STARTED:
      return state.setIn(["flags", "loading"], fromJS(payload)).setIn(["flags", "errors"], false);
    case actions.DASHBOARD_FLAGS_SUCCESS: {
      const orderedArray = orderBy(payload.data, dateObj => new Date(dateObj[DASHBOARD_FLAGS_SORT_FIELD]), [
        DASHBOARD_FLAGS_SORT_ORDER
      ]);

      return state.setIn(["flags", "data"], fromJS(orderedArray));
    }
    case actions.DASHBOARD_FLAGS_FINISHED:
      return state.setIn(["flags", "loading"], fromJS(payload));
    case actions.DASHBOARD_FLAGS_FAILURE:
      return state.setIn(["flags", "errors"], true);
    case actions.SERVICES_STATUS:
      return state.set("servicesStatus", fromJS(payload.services));
    case actions.OPEN_PAGE_ACTIONS:
      return state.set("isOpenPageActions", fromJS(payload));
    case "user/LOGOUT_SUCCESS":
      return DEFAULT_STATE;
    default:
      return state;
  }
};

export default { [NAMESPACE]: reducer };
