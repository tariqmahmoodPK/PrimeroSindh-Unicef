import { fromJS } from "immutable";

import { ContactInformationRecord } from "../../../contact-information/records";

import actions from "./actions";

const DEFAULT_STATE = fromJS({});

export default (state = DEFAULT_STATE, { type, payload }) => {
  switch (type) {
    case actions.SAVE_CONTACT_INFORMATION_STARTED:
      return state.set("loading", true);
    case actions.SAVE_CONTACT_INFORMATION_SUCCESS:
      return state.set("data", ContactInformationRecord(payload.data));
    case actions.SAVE_CONTACT_INFORMATION_FINISHED:
      return state.set("loading", false);
    default:
      return state;
  }
};
