import * as index from "./index";

describe("Approvals - index", () => {
  const indexValues = { ...index };

  it("should have known exported properties", () => {
    ["default"].forEach(property => {
      expect(indexValues).to.have.property(property);
      delete indexValues[property];
    });

    expect(indexValues).to.be.empty;
  });
});
