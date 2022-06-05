import * as constants from "./constants";

describe("<WorkflowIndividualCases> - pages/dashboard/components/workflow-individual-cases/constants", () => {
  const clone = { ...constants };

  it("should have known properties", () => {
    expect(clone).to.be.an("object");
    ["CLOSED", "NAME"].forEach(property => {
      expect(clone).to.have.property(property);
      delete clone[property];
    });

    expect(clone).to.be.empty;
  });
});
