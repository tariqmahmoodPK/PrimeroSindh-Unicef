import { Select } from "@material-ui/core";
import { DatePicker, DateTimePicker } from "@material-ui/pickers";

import { setupMockFormComponent, spy } from "../../../../../test";

import DateFilter from "./component";

describe("<DateFilter>", () => {
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
    addFilterToList: () => {},
    filter,
    filterToList: {}
  };

  it("renders panel", () => {
    const { component } = setupMockFormComponent(DateFilter, { props, includeFormProvider: true });

    expect(component.exists("Panel")).to.be.true;
  });

  it("renders 2 DatePicker component", () => {
    const { component } = setupMockFormComponent(DateFilter, { props, includeFormProvider: true });

    expect(component.find(DateTimePicker)).to.have.lengthOf(0);
    expect(component.find(DatePicker)).to.have.lengthOf(2);
  });

  it("renders 2 DateTimePicker component if we pass the prop dateIncludeTime = true", () => {
    const newProps = {
      addFilterToList: () => {},
      filter: { ...filter, dateIncludeTime: true },
      filterToList: {}
    };
    const { component } = setupMockFormComponent(DateFilter, { props: newProps, includeFormProvider: true });

    expect(component.find(DatePicker)).to.have.lengthOf(0);
    expect(component.find(DateTimePicker)).to.have.lengthOf(2);
  });

  it("renders date-filter as secondary filter, with valid pros in the more section", () => {
    const newProps = {
      addFilterToList: () => {},
      filter,
      filterToList: {},
      mode: {
        secondary: true
      },
      moreSectionFilters: {},
      reset: false,
      setMoreSectionFilters: () => {},
      setReset: () => {}
    };
    const { component } = setupMockFormComponent(DateFilter, { props: newProps, includeFormProvider: true });
    const clone = { ...component.find(DateFilter).props() };

    expect(component.exists("Panel")).to.be.true;

    [
      "addFilterToList",
      "commonInputProps",
      "filter",
      "filterToList",
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
      filterToList: {},
      isDateFieldSelectable: true,
      mode: {
        secondary: false
      },
      moreSectionFilters: {},
      reset: false,
      setMoreSectionFilters: spy(),
      setReset: () => {}
    };

    const { component } = setupMockFormComponent(DateFilter, { props: newProps, includeFormProvider: true });

    const select = component.find(Select);

    expect(select).to.have.lengthOf(1);

    select.props().onChange({ target: { value: "option-2" } });

    expect(newProps.setMoreSectionFilters).to.have.not.been.called;
  });
});
