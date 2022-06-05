import { fromJS } from "immutable";

import { listEntriesToRecord } from "../../libs";

import NAMESPACE from "./namespace";
import { FETCH_SAVED_SEARCHES_SUCCESS, REMOVE_SAVED_SEARCH_SUCCESS, SAVE_SEARCH_SUCCESS } from "./actions";
import { SavedSearchesRecord } from "./records";

const DEFAULT_STATE = fromJS({ data: [] });

const reducer = (state = DEFAULT_STATE, { type, payload }) => {
  switch (type) {
    case FETCH_SAVED_SEARCHES_SUCCESS:
      return state.set("data", listEntriesToRecord(payload.data, SavedSearchesRecord));
    case REMOVE_SAVED_SEARCH_SUCCESS:
      return state.set(
        "data",
        state.get("data").filter(d => d.id !== payload.data.id)
      );
    case SAVE_SEARCH_SUCCESS:
      return state.update("data", data => {
        return data.push(SavedSearchesRecord(payload.data));
      });
    default:
      return state;
  }
};

export default { [NAMESPACE]: reducer };
