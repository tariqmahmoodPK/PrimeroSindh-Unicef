import * as index from "./index";

describe("pages/admin - index", () => {
  const indexValues = { ...index };

  it("should have known properties", () => {
    [
      "default",
      "AgenciesForm",
      "AgenciesList",
      "AuditLogs",
      "CodeOfConduct",
      "ConfigurationsList",
      "ConfigurationsForm",
      "ContactInformation",
      "FormBuilder",
      "FormsList",
      "LocationsList",
      "LookupsForm",
      "LookupsList",
      "RolesForm",
      "RolesList",
      "UserGroupsForm",
      "UserGroupsList",
      "UsersForm",
      "UsersList"
    ].forEach(property => {
      expect(indexValues).to.have.property(property);
      delete indexValues[property];
    });
    expect(indexValues).to.be.empty;
  });
});
