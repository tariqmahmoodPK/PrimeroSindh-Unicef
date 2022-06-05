import { fromJS, OrderedMap } from "immutable";

import ActionDialog from "../../../action-dialog";
import FormSection from "../../../form/components/form-section";
import FormSectionField from "../../../form/components/form-section-field";
import { setupMountedComponent } from "../../../../test";
import { ACTIONS } from "../../../../libs/permissions";
import { FormSectionRecord, FieldRecord } from "../../../record-form/records";

import ReportFiltersDialog from "./component";

describe("<ReportFiltersDialog /> - Component", () => {
  let component;

  const forms = {
    formSections: OrderedMap({
      1: FormSectionRecord({
        id: 1,
        unique_id: "incident_details_subform_section",
        name: { en: "Nested Incident Details Subform" },
        visible: false,
        fields: [2]
      }),
      2: FormSectionRecord({
        id: 2,
        unique_id: "incident_details_container",
        name: { en: "Incident Details" },
        visible: true,
        parent_form: "case",
        fields: [1]
      })
    }),
    fields: OrderedMap({
      1: FieldRecord({
        name: "incident_details",
        type: "subform"
      }),
      2: FieldRecord({
        name: "cp_incident_location_type_other",
        type: "text_field"
      })
    })
  };

  const props = {
    fields: [
      {
        id: "test_numeric_field",
        display_text: "Test numeric field",
        formSection: "Test form section",
        type: "numeric_field",
        option_strings_source: undefined,
        option_strings_text: null,
        tick_box_label: undefined
      }
    ],
    open: true,
    setOpen: () => {},
    selectedIndex: "0",
    setSelectedIndex: () => {},
    indexes: [
      {
        index: 0,
        data: { attribute: "test_numeric_field", constraint: "=", value: "10" }
      }
    ],
    onSuccess: () => {}
  };

  const initialState = fromJS({
    user: {
      permissions: {
        reports: [ACTIONS.MANAGE]
      }
    },
    forms,
    application: {
      ageRanges: {
        primero: ["0..5", "6..11", "12..17", "18..999"]
      }
    }
  });

  beforeEach(() => {
    ({ component } = setupMountedComponent(ReportFiltersDialog, props, initialState));
  });

  it("should render <ActionDialog>", () => {
    expect(component.find(ActionDialog)).to.have.lengthOf(1);
  });

  it("should render <FormSection>", () => {
    expect(component.find(FormSection)).to.have.lengthOf(1);
  });

  it("should render <FormSectionField>", () => {
    expect(component.find(FormSectionField)).to.have.lengthOf(3);
  });

  describe("should render SelectField in <FormSectionField>", () => {
    let testComponent;
    const options = [
      {
        id: "test_1",
        display_text: {
          en: "Test 1"
        }
      },
      {
        id: "test_2",
        display_text: {
          en: "Test 2"
        }
      }
    ];
    const newProps = {
      fields: [
        {
          id: "test_select_field",
          display_text: "Test Select Field",
          formSection: "Test form section",
          type: "select_box",
          option_strings_source: undefined,
          option_strings_text: options,
          tick_box_label: undefined
        }
      ],
      open: true,
      setOpen: () => {},
      selectedIndex: "0",
      setSelectedIndex: () => {},
      indexes: [
        {
          index: 0,
          data: { attribute: "test_select_field", constraint: true, value: [] }
        }
      ],
      onSuccess: () => {}
    };

    beforeEach(() => {
      ({ component: testComponent } = setupMountedComponent(ReportFiltersDialog, newProps, initialState));
    });

    describe("<FormSectionField> - SelectField", () => {
      it("renders selectField with options", () => {
        const valueFieldProps = testComponent.find(FormSectionField).at(2).props();
        const optionsEn = options.map(option => ({
          id: option.id,
          display_text: option.display_text[window.I18n.locale]
        }));

        expect(valueFieldProps.field.option_strings_text).to.deep.equal(optionsEn);
        expect(valueFieldProps.field.option_strings_text).to.have.lengthOf(2);
      });
    });
  });
});
