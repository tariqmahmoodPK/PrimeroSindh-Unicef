import * as constants from "./constants";

describe("<AuditLogs /> pages/admin/audit-logs/constants", () => {
  it("should have known properties", () => {
    const clone = { ...constants };

    expect(clone).to.be.an("object");
    ["AUDIT_LOG", "DATA", "DEFAULT_FILTERS", "ERRORS", "LOADING", "METADATA", "NAME", "TIMESTAMP", "USER_NAME"].forEach(
      property => {
        expect(clone).to.have.property(property);
        delete clone[property];
      }
    );

    expect(clone).to.be.empty;
  });
});
