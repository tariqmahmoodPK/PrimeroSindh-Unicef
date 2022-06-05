import * as constants from "./constants";

describe("<ContactInformation /> - Constants", () => {
  it("should have known constant", () => {
    const clonedConstants = { ...constants };

    expect(clonedConstants).to.be.an("object");

    ["NAME", "FORM_ID"].forEach(property => {
      expect(clonedConstants).to.have.property(property);
      delete clonedConstants[property];
    });

    expect(clonedConstants).to.be.empty;
  });
});
