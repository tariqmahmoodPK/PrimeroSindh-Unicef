import { fromJS } from "immutable";

import AssociatedRolesForm from "./associated-roles";

describe("pages/admin/<RolesForm>/forms - AssociatedRolesForm", () => {
  const i18n = { t: () => "" };

  it("returns the AssociatedRolesForm with fields", () => {
    const roleForms = AssociatedRolesForm(fromJS([]), i18n);

    expect(roleForms).to.exist;
    expect(roleForms.fields).to.have.lengthOf(2);
  });
});
