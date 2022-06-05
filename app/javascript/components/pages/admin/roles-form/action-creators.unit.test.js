import { stub } from "../../../../test";
import { RECORD_PATH } from "../../../../config";
import { ENQUEUE_SNACKBAR, generate } from "../../../notifier";

import * as actionsCreators from "./action-creators";
import actions from "./actions";

describe("<RolesForm /> - Action Creators", () => {
  it("should have known action creators", () => {
    const creators = { ...actionsCreators };

    ["clearSelectedRole", "deleteRole", "fetchRole", "saveRole", "setCopyRole", "clearCopyRole"].forEach(property => {
      expect(creators).to.have.property(property);
      delete creators[property];
    });

    expect(creators).to.be.empty;
  });

  it("should check that 'fetchRole' action creator returns the correct object", () => {
    const expectedAction = {
      type: actions.FETCH_ROLE,
      api: {
        path: `${RECORD_PATH.roles}/10`
      }
    };

    expect(actionsCreators.fetchRole(10)).to.deep.equal(expectedAction);
  });

  it("should check that 'saveRole' action creator returns the correct object", () => {
    stub(generate, "messageKey").returns(4);

    const args = {
      id: null,
      body: {
        prop1: "prop-1"
      },
      message: "Saved successfully"
    };

    const expectedAction = {
      type: actions.SAVE_ROLE,
      api: {
        path: RECORD_PATH.roles,
        method: "POST",
        body: args.body,
        successCallback: {
          action: ENQUEUE_SNACKBAR,
          payload: {
            message: "Saved successfully",
            options: {
              key: 4,
              variant: "success"
            }
          },
          redirectWithIdFromResponse: true,
          redirect: `/admin/${RECORD_PATH.roles}`
        }
      }
    };

    expect(actionsCreators.saveRole(args)).to.deep.equal(expectedAction);
  });

  it("should check that 'deleteRole' action creator returns the correct object", () => {
    stub(generate, "messageKey").returns(4);

    const args = {
      id: 10,
      message: "Deleted successfully"
    };

    const expectedAction = {
      type: actions.DELETE_ROLE,
      api: {
        path: `${RECORD_PATH.roles}/10`,
        method: "DELETE",
        successCallback: {
          action: ENQUEUE_SNACKBAR,
          payload: {
            message: "Deleted successfully",
            options: {
              key: 4,
              variant: "success"
            }
          },
          redirectWithIdFromResponse: false,
          redirect: `/admin/${RECORD_PATH.roles}`
        }
      }
    };

    expect(actionsCreators.deleteRole(args)).to.deep.equal(expectedAction);
  });

  it("should check that 'setCopyRole' action creator returns the correct object", () => {
    const payload = { name: "Copy of Test" };
    const expectedAction = {
      type: actions.SET_COPY_ROLE,
      payload
    };

    expect(actionsCreators.setCopyRole(payload)).to.deep.equal(expectedAction);
  });

  it("should check that 'clearCopyRole' action creator returns the correct object", () => {
    const expectedAction = {
      type: actions.CLEAR_COPY_ROLE
    };

    expect(actionsCreators.clearCopyRole()).to.deep.equal(expectedAction);
  });

  afterEach(() => {
    if (generate.messageKey.restore) {
      generate.messageKey.restore();
    }
  });
});
