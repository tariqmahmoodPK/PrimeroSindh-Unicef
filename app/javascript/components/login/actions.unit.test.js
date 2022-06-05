import actions from "./actions";

describe("<Login /> - Actions", () => {
  it("should have known actions", () => {
    const cloneActions = { ...actions };

    ["LOGIN", "LOGIN_SUCCESS", "LOGIN_STARTED", "LOGIN_FAILURE", "LOGIN_FINISHED"].forEach(property => {
      expect(cloneActions).to.have.property(property);
      expect(cloneActions[property]).to.be.a("string");
      delete cloneActions[property];
    });

    expect(cloneActions).to.be.empty;
  });
});
