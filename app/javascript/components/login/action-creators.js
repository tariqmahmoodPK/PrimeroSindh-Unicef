/* eslint-disable import/prefer-default-export */

import { DB_COLLECTIONS_NAMES } from "../../db";

import actions from "./actions";

export const loginSystemSettings = () => async dispatch => {
  return dispatch({
    type: actions.LOGIN,
    api: {
      path: "identity_providers",
      method: "GET",
      db: {
        collection: DB_COLLECTIONS_NAMES.IDP
      }
    }
  });
};
