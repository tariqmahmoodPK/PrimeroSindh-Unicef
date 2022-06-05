import Autocomplete from "@material-ui/lab/Autocomplete";

import { setupMockFormComponent, spy } from "../../../../../test";

import SelectFilter from "./component";

describe("<SelectFilter>", () => {
  const filter = {
    field_name: "filter",
    name: "Filter 1",
    options: [
      { id: "option-1", display_text: "Option 1" },
      { id: "option-2", display_text: "Option 2" }
    ]
  };

  const props = {
    addFilterToList: () => {},
    filter
  };

  it("renders panel", () => {
    const { component } = setupMockFormComponent(SelectFilter, { props, includeFormProvider: true });

    expect(component.exists("Panel")).to.be.true;
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
    const { component } = setupMockFormComponent(SelectFilter, { props: newProps, includeFormProvider: true });
    const clone = { ...component.find(SelectFilter).props() };

    expect(component.exists("Panel")).to.be.true;

    [
      "addFilterToList",
      "commonInputProps",
      "filter",
      "mode",
      "moreSectionFilters",
      "multiple",
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
        secondary: false
      },
      isDateFieldSelectable: true,
      moreSectionFilters: {},
      reset: false,
      setMoreSectionFilters: spy(),
      setReset: () => {}
    };

    const { component } = setupMockFormComponent(SelectFilter, { props: newProps, includeFormProvider: true });

    const select = component.find(Autocomplete);

    expect(select).to.have.lengthOf(1);
    select.props().onChange({}, [{ id: "option-2", display_text: "Option 2" }]);

    expect(newProps.setMoreSectionFilters).to.have.not.been.called;
  });
});
