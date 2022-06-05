/* eslint-disable import/prefer-default-export */

import { fromJS, Record } from "immutable";

export const PrimeroModuleRecord = Record({
  unique_id: "",
  name: "",
  associated_record_types: [],
  options: {},
  workflows: {},
  field_map: fromJS([])
});
