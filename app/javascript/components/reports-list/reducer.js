import { fromJS } from "immutable";

import { DEFAULT_METADATA } from "../../config";

import {
  CLEAR_METADATA,
  FETCH_REPORTS_SUCCESS,
  FETCH_REPORTS_STARTED,
  FETCH_REPORTS_FINISHED,
  FETCH_REPORTS_FAILURE
} from "./actions";

const DEFAULT_STATE = fromJS({});

export default (state = DEFAULT_STATE, { type, payload }) => {
  switch (type) {
    case FETCH_REPORTS_STARTED:
      return state.set("loading", true).set("errors", false);
    case FETCH_REPORTS_SUCCESS:
      return state.set("data", fromJS(payload.data)).set("metadata", fromJS(payload.metadata)).set("errors", false);
    case FETCH_REPORTS_FINISHED:
      return state.set("loading", false);
    case FETCH_REPORTS_FAILURE:
      return state.set("errors", true);
    case CLEAR_METADATA:
      return state.set("metadata", fromJS(DEFAULT_METADATA));
    default:
      return state;
  }
};
