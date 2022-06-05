import { setupMockFormComponent, spy } from "../../../../../test";

import CheckboxFilter from "./component";

describe("<CheckboxFilter>", () => {
  const filter = {
    field_name: "filter",
    name: "Filter 1",
    options: [
      { id: "option-1", display_text: "Option 1" },
      { id: "option-2", display_text: "Option 2" }
    ]
  };

  const props = { addFilterToList: () => {}, filter };

  it("renders panel", () => {
    const { component } = setupMockFormComponent(CheckboxFilter, { props, includeFormProvider: true });

    expect(component.exists("Panel")).to.be.true;
  });

  it("renders checkbox inputs", () => {
    const { component } = setupMockFormComponent(CheckboxFilter, { props, includeFormProvider: true });

    ["option-1", "option-2"].forEach(option => expect(component.exists(`input[value='${option}']`)).to.be.true);
  });

  it("renders checkbox with valid pros in the more section", () => {
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
    const { component } = setupMockFormComponent(CheckboxFilter, { props: newProps, includeFormProvider: true });

    ["option-1", "option-2"].forEach(option => expect(component.exists(`input[value='${option}']`)).to.be.true);

    const clone = { ...component.find(CheckboxFilter).props() };

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
        secondary: false
      },
      moreSectionFilters: {},
      reset: false,
      setMoreSectionFilters: spy(),
      setReset: () => {}
    };

    const { component } = setupMockFormComponent(CheckboxFilter, { props: newProps, includeFormProvider: true });

    const checkbox = component.find("input[type='checkbox']").at(0);

    expect(checkbox).to.have.lengthOf(1);
    checkbox.simulate("change", { target: { checked: true } });

    expect(newProps.setMoreSectionFilters).to.have.not.been.called;
  });
});
