import * as constants from "./constants";

describe("<FormBuilder />/components/<SubformFieldList /> - Constants", () => {
  it("should have known properties", () => {
    const clonedActions = { ...constants };

    ["NAME"].forEach(property => {
      expect(clonedActions).to.have.property(property);
      delete clonedActions[property];
    });

    expect(clonedActions).to.be.empty;
  });
});
