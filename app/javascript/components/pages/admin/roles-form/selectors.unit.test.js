import { fromJS } from "immutable";

import NAMESPACE from "./namespace";
import * as selectors from "./selectors";

const stateWithHeaders = fromJS({
  records: {
    admin: {
      roles: {
        selectedRole: { id: 1 },
        errors: true,
        loading: false,
        serverErrors: [{ message: "error-1" }],
        saving: false,
        copiedRole: {
          name: "Copy of Test Role"
        }
      }
    }
  }
});

const stateWithoutHeaders = fromJS({});

describe("<RolesForm /> - Selectors", () => {
  it("should have known the selectors", () => {
    const creators = { ...selectors };

    ["getLoading", "getRole", "getServerErrors", "getSavingRecord", "getCopiedRole"].forEach(property => {
      expect(creators).to.have.property(property);
      delete creators[property];
    });

    expect(creators).to.be.empty;
  });

  describe("getRole", () => {
    it("should return selected role", () => {
      const expected = stateWithHeaders.getIn(["records", "admin", NAMESPACE, "selectedRole"]);

      const role = selectors.getRole(stateWithHeaders);

      expect(role).to.deep.equal(expected);
    });

    it("should return empty object when selected role empty", () => {
      const role = selectors.getRole(stateWithoutHeaders);

      expect(role).to.be.empty;
    });
  });

  describe("getServerErrors", () => {
    it("should return server errors", () => {
      const expected = stateWithHeaders.getIn(["records", "admin", NAMESPACE, "serverErrors"]);

      const serverErrors = selectors.getServerErrors(stateWithHeaders);

      expect(serverErrors).to.deep.equal(expected);
    });

    it("should return empty object when no server errors", () => {
      const user = selectors.getServerErrors(stateWithoutHeaders);

      expect(user).to.be.empty;
    });
  });

  describe("getSavingRecord", () => {
    it("should return saving", () => {
      const expected = stateWithHeaders.getIn(["records", "admin", NAMESPACE, "saving"]);

      const saving = selectors.getSavingRecord(stateWithHeaders);

      expect(saving).to.deep.equal(expected);
    });
  });

  describe("getLoading", () => {
    it("should return loading", () => {
      const expected = stateWithHeaders.getIn(["records", "admin", NAMESPACE, "loading"]);

      const loading = selectors.getLoading(stateWithHeaders);

      expect(loading).to.deep.equal(expected);
    });
  });

  describe("getCopiedRole", () => {
    it("should return valid object", () => {
      const expected = stateWithHeaders.getIn(["records", "admin", NAMESPACE, "copiedRole"]);

      const copiedRole = selectors.getCopiedRole(stateWithHeaders);

      expect(copiedRole).to.deep.equal(expected);
    });

    it("should return empty object when no server errors", () => {
      const copiedRole = selectors.getCopiedRole(stateWithoutHeaders);

      expect(copiedRole).to.be.empty;
    });
  });
});
