/* eslint-disable import/prefer-default-export */

import actions from "./actions";
import { EXPORT_URL } from "./constants";

export const fetchExports = params => {
  const { data } = params || {};

  return {
    type: actions.FETCH_EXPORTS,
    api: {
      path: EXPORT_URL,
      params: data
    }
  };
};
