import { expect } from "chai";
import { fromJS } from "immutable";

import ActionDialog from "../../../../action-dialog";
import { setupMountedComponent } from "../../../../../test";
import { ACTIONS } from "../../../../../libs/permissions";

import UserConfirmation from "./component";

describe("<UserConfirmation /> - Component", () => {
  let component;
  const props = {
    close: () => {},
    dialogName: "dialog",
    id: "20",
    pending: false,
    saveMethod: "new",
    setPending: () => {},
    userConfirmationOpen: false,
    userData: {}
  };
  const initialState = fromJS({
    records: {
      users: {
        data: [
          {
            id: "1",
            user_name: "Jose"
          },
          {
            id: "2",
            user_name: "Carlos"
          }
        ],
        metadata: { total: 2, per: 20, page: 1 }
      }
    },
    user: {
      permissions: {
        users: [ACTIONS.MANAGE]
      }
    }
  });

  beforeEach(() => {
    ({ component } = setupMountedComponent(UserConfirmation, props, initialState));
  });

  it("renders UserConfirmation component", () => {
    expect(component.find(UserConfirmation)).to.have.length(1);
  });

  describe("when open ActionDialog", () => {
    let testComponent;

    before(() => {
      ({ component: testComponent } = setupMountedComponent(UserConfirmation, { ...props, open: true }, initialState));
    });

    it("render dialogContent <p>", () => {
      expect(testComponent.find(ActionDialog).find("p")).to.have.lengthOf(1);
    });
  });
});
