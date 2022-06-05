/* eslint-disable import/prefer-default-export */

import { Record } from "immutable";

export const TransitionRecord = Record({
  id: null,
  record_id: null,
  record_type: null,
  created_at: null,
  responded_at: null,
  notes: "",
  rejected_reason: "",
  status: null,
  type: null,
  consent_overridden: null,
  consent_individual_transfer: null,
  transitioned_by: null,
  transitioned_to_remote: null,
  transitioned_to: null,
  service: null,
  remote: true,
  transitioned_to_agency: null,
  rejection_note: null
});
