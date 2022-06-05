import { fromJS } from "immutable";
import { Grid } from "@material-ui/core";
import Chip from "@material-ui/core/Chip";

import { setupMountedComponent } from "../../../../test";

import ApprovalSummary from "./component";

describe("<ApprovalSummary /> - Component", () => {
  let component;
  const props = {
    approvalSubform: fromJS({
      approval_date: "2020-01-01",
      approval_response_for: "assessment"
    }),
    css: {
      approvalsValueSummary: "approvalsValueSummary"
    },
    isRequest: false,
    isResponse: true
  };

  const initialState = fromJS({
    application: {
      approvalsLabels: {
        assessment: {
          en: "Assessment"
        }
      }
    }
  });

  beforeEach(() => {
    ({ component } = setupMountedComponent(ApprovalSummary, props, initialState));
  });

  it("render ApprovalSummary component", () => {
    expect(component.find(ApprovalSummary)).to.have.length(1);
  });

  it("render a Grid", () => {
    expect(component.find(Grid)).to.have.lengthOf(3);
  });

  it("render a Chip", () => {
    expect(component.find(Chip)).to.have.lengthOf(1);
  });

  it("render the correct approvals label value", () => {
    expect(component.find("div.approvalsValueSummary").first().text()).to.be.equal(
      "Assessment - approvals.response_for_title"
    );
  });

  it("renders component with valid props", () => {
    const approvalsProps = { ...component.find(ApprovalSummary).props() };

    ["approvalSubform", "css", "isRequest", "isResponse"].forEach(property => {
      expect(approvalsProps).to.have.property(property);
      delete approvalsProps[property];
    });
    expect(approvalsProps).to.be.empty;
  });
});
