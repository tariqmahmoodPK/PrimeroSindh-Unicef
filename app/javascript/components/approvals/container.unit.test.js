import { fromJS } from "immutable";
import { AccordionDetails, AccordionSummary } from "@material-ui/core";

import RecordFormTitle from "../record-form/form/record-form-title";
import { setupMountedComponent } from "../../test";

import Approvals from "./container";
import ApprovalPanel from "./components/panel";

describe("<Approvals /> - Component", () => {
  let component;

  const props = {
    approvals: fromJS([
      {
        unique_id: "6e96ab79-d786-4117-a48c-c99194741beb",
        approved_by: "primero",
        approval_date: "2020-01-01",
        approval_status: "rejected",
        approval_for_type: "Action Plan",
        approval_response_for: "assessment",
        approval_requested_for: null,
        approval_manager_comments: "First comment"
      },
      {
        unique_id: "670332c6-1f1d-415d-9df5-1d94039ce79a",
        approved_by: "primero1",
        approval_date: "2020-01-02",
        approval_status: "approved",
        approval_for_type: "Service Provision",
        approval_response_for: "bia",
        approval_requested_for: null,
        approval_manager_comments: "This is the second comment"
      },
      {
        unique_id: "dab91917-3fbd-4cde-bf42-b09df19dbf08",
        approved_by: "primero2",
        approval_date: "2020-01-03",
        approval_status: "requested",
        approval_for_type: null,
        approval_response_for: null,
        approval_requested_for: "closure",
        approval_manager_comments: "This is third comment"
      },
      {
        unique_id: "e6952ae6-3515-4000-a6c2-b8dcd93cb28a",
        approved_by: "primero3",
        approval_date: "2020-01-04",
        approval_status: "requested",
        approval_for_type: "Case Plan",
        approval_response_for: null,
        approval_requested_for: "case_plan",
        approval_manager_comments: "This is the last comment"
      }
    ]),
    handleToggleNav: () => {},
    mobileDisplay: false
  };

  beforeEach(() => {
    ({ component } = setupMountedComponent(Approvals, props, {}));
  });

  it("renders Approvals component", () => {
    expect(component.find(Approvals)).to.have.length(1);
  });

  it("renders 4 ApprovalsPanel", () => {
    expect(component.find(ApprovalPanel)).to.have.lengthOf(4);
    expect(component.find(AccordionDetails)).to.have.lengthOf(4);
    expect(component.find(AccordionSummary)).to.have.lengthOf(4);
  });

  it("renders component with valid props", () => {
    const approvalsProps = { ...component.find(Approvals).props() };

    ["approvals", "handleToggleNav", "mobileDisplay"].forEach(property => {
      expect(approvalsProps).to.have.property(property);
      delete approvalsProps[property];
    });
    expect(approvalsProps).to.be.empty;
  });

  describe("When we don't have data", () => {
    let noDataComponent;

    const emptyProps = {
      mobileDisplay: true,
      handleToggleNav: () => {}
    };

    beforeEach(() => {
      ({ component: noDataComponent } = setupMountedComponent(Approvals, emptyProps, {}));
    });

    it("renders Approvals component", () => {
      expect(noDataComponent.find(Approvals)).to.have.length(1);
    });
    it("not renders ApprovalPanel only the title", () => {
      expect(noDataComponent.find(ApprovalPanel)).to.have.lengthOf(0);
      expect(noDataComponent.find(RecordFormTitle)).to.have.lengthOf(1);
      expect(noDataComponent.find(RecordFormTitle).text()).to.equal("forms.record_types.approvals");
    });
  });
});
