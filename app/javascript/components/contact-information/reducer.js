import { fromJS } from "immutable";

import { FETCH_DATA_SUCCESS, FETCH_DATA_STARTED, FETCH_DATA_FINISHED, FETCH_DATA_FAILURE } from "./actions";
import { ContactInformationRecord } from "./records";

const DEFAULT_STATE = fromJS({});

export default (state = DEFAULT_STATE, { type, payload }) => {
  switch (type) {
    case FETCH_DATA_SUCCESS:
      return state.set("data", ContactInformationRecord(payload.data));
    case FETCH_DATA_STARTED:
      return state.set("loading", fromJS(payload)).set("errors", false);
    case FETCH_DATA_FINISHED:
      return state.set("loading", fromJS(payload));
    case FETCH_DATA_FAILURE:
      return state.set("errors", true);
    default:
      return state;
  }
};
