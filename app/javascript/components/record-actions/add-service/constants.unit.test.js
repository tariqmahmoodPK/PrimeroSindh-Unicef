import * as constants from "./constants";

describe("<AddService /> - constants", () => {
  it("should have known constant", () => {
    const clone = { ...constants };

    ["NAME", "SERVICES_SUBFORM", "SERVICES_SUBFORM_NAME"].forEach(property => {
      expect(clone).to.have.property(property);
      delete clone[property];
    });

    expect(clone).to.be.empty;
  });
});
