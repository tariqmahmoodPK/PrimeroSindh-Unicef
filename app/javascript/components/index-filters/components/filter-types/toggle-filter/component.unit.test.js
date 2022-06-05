import { setupMockFormComponent, spy } from "../../../../../test";

import ToggleFilter from "./component";

describe("<ToggleFilter>", () => {
  const filter = {
    field_name: "filter",
    name: "Filter 1",
    options: {
      en: [
        { id: "option-1", display_text: "Option 1" },
        { id: "option-2", display_text: "Option 2" }
      ]
    }
  };

  const props = {
    filter
  };

  it("renders panel", () => {
    const { component } = setupMockFormComponent(ToggleFilter, { props, includeFormProvider: true });

    expect(component.exists("Panel")).to.be.true;
  });

  it("renders toggle buttons", () => {
    const { component } = setupMockFormComponent(ToggleFilter, { props, includeFormProvider: true });

    ["option-1", "option-2"].forEach(option => expect(component.exists(`button[value='${option}']`)).to.be.true);
  });

  it("renders select as secondary filter, with valid pros in the more section", () => {
    const newProps = {
      addFilterToList: () => {},
      filter,
      mode: {
        secondary: true
      },
      moreSectionFilters: {},
      reset: false,
      setMoreSectionFilters: () => {},
      setReset: () => {}
    };
    const { component } = setupMockFormComponent(ToggleFilter, { props: newProps, includeFormProvider: true });
    const clone = { ...component.find(ToggleFilter).props() };

    ["option-1", "option-2"].forEach(option => expect(component.exists(`button[value='${option}']`)).to.be.true);

    [
      "addFilterToList",
      "commonInputProps",
      "filter",
      "mode",
      "moreSectionFilters",
      "reset",
      "setMoreSectionFilters",
      "setReset"
    ].forEach(property => {
      expect(clone).to.have.property(property);
      delete clone[property];
    });

    expect(clone).to.be.empty;
  });

  it("should have not call setMoreSectionFilters if mode.secondary is false when changing value", () => {
    const newProps = {
      addFilterToList: () => {},
      filter,
      mode: {
        secondary: true
      },
      moreSectionFilters: {},
      reset: false,
      setMoreSectionFilters: spy(),
      setReset: () => {}
    };

    const { component } = setupMockFormComponent(ToggleFilter, { props: newProps, includeFormProvider: true });
    const toggleFilter = component.find("button").at(1);

    expect(toggleFilter).to.have.lengthOf(1);
    toggleFilter.simulate("click");

    expect(newProps.setMoreSectionFilters).to.have.been.called;
  });
});
