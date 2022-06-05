/* eslint-disable import/prefer-default-export */

import { POTENTIAL_MATCHES } from "./actions";

export const fetchPotentialMatches = () => {
  return {
    type: POTENTIAL_MATCHES,
    payload: {
      data: {
        tracingRequestId: "123",
        relationName: "CP Admin",
        inquiryDate: "2018-01-06",
        tracingRequest: "",
        matches: [
          {
            caseId: "#1234",
            age: "11",
            sex: "male",
            user: "primero_admin_cp",
            agency: "agency-unicef",
            score: "Possible"
          }
        ]
      }
    }
  };
};
