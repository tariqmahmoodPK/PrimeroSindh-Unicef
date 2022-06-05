import { DB_STORES } from "../../db/constants";

import generateRecordProperties from "./generate-record-properties";

export default (action, store) => {
  const { api } = action;
  const { collection } = api?.db || {};
  const { data, ...rest } = api?.body || {};
  const isRecord = collection === DB_STORES.RECORDS;

  const generatedProperties = generateRecordProperties(store, api, isRecord);

  return {
    ...action,
    api: {
      ...api,
      body: { data: { ...data, ...generatedProperties }, ...rest }
    }
  };
};
