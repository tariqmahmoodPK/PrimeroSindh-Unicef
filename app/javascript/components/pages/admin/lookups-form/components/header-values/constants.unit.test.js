import * as constants from "./constants";

describe("<HeadersValues /> - components/header-values/constants", () => {
  it("should have known properties", () => {
    const clone = { ...constants };

    ["NAME"].forEach(property => {
      expect(clone).to.have.property(property);
      delete clone[property];
    });

    expect(clone).to.be.empty;
  });
});
