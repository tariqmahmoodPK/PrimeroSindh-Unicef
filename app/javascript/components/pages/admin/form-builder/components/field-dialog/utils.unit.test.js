import { fromJS } from "immutable";
import uuid from "uuid";

import { SEPARATOR, TEXT_FIELD, TICK_FIELD, SELECT_FIELD, DATE_FIELD } from "../../../../../form";
import { NEW_FIELD } from "../../constants";
import { stub } from "../../../../../../test";

import * as utils from "./utils";

describe("pages/admin/<FormBuilder />/components/<FieldDialog /> - utils", () => {
  const formMode = fromJS({
    isNew: false,
    isEdit: true
  });

  describe("getFormField", () => {
    const i18n = { t: value => value };

    it("should return the form sections for TEXT_FIELD type", () => {
      const formSections = utils.getFormField({
        field: fromJS({
          type: TEXT_FIELD,
          name: "owned_by"
        }),
        i18n,
        formMode
      });

      expect(formSections.forms.size).to.be.equal(2);
    });

    it("should return the form sections for TICK_FIELD type", () => {
      const formSections = utils.getFormField({
        field: fromJS({
          type: TICK_FIELD,
          name: "test"
        }),
        i18n,
        formMode
      });

      expect(formSections.forms.size).to.be.equal(2);
    });
  });

  describe("toggleHideOnViewPage", () => {
    it("should toggle the value of hide_on_view_page property", () => {
      const field1 = { name: "field_1", visible: true };
      const expected = { ...field1, hide_on_view_page: false };

      expect(
        utils.toggleHideOnViewPage({
          ...field1,
          hide_on_view_page: true
        })
      ).to.deep.equal(expected);
    });

    it("should return the form sections for SEPARATOR type", () => {
      const i18n = { t: value => value };
      const formSections = utils.getFormField({
        field: fromJS({
          type: SEPARATOR,
          name: "test"
        }),
        i18n,
        formMode
      });

      expect(formSections.forms.size).to.be.equal(2);
    });
  });
});

describe("addWithIndex", () => {
  it("should add an element on an specific index array", () => {
    const original = ["a", "b", "c"];
    const expected = ["a", "b", "d", "c"];

    expect(utils.addWithIndex(original, 2, "d")).to.deep.equals(expected);
  });
});

describe("buildDataToSave", () => {
  before(() => {
    stub(uuid, "v4").returns("b8e93-0cce-415b-ad2b-d06bb454b66f");
  });

  after(() => {
    uuid.v4.restore();
  });

  it("should set the data for update", () => {
    const selectedField = fromJS({
      name: "referral_person_phone",
      type: TEXT_FIELD
    });
    const fieldName = selectedField.get("name");
    const data = {
      referral_person_phone: {
        display_name: { en: "Contact Number aj" },
        guiding_questions: { en: "" },
        help_text: { en: "e" },
        mobile_visible: true,
        required: false,
        show_on_minify_form: false,
        visible: true,
        disabled: false
      }
    };

    expect(utils.buildDataToSave(selectedField, data[fieldName], "en")).to.deep.equals(data);
  });

  describe("when its a new field", () => {
    const objectData = {
      display_name: { en: "test field" },
      guiding_questions: { en: "" },
      help_text: { en: "e" },
      mobile_visible: true,
      required: false,
      show_on_minify_form: false,
      visible: true,
      multi_select: false,
      date_include_time: false,
      disabled: false
    };

    it("should set the data for create", () => {
      const selectedField = fromJS({ name: NEW_FIELD, type: TEXT_FIELD });

      expect(utils.buildDataToSave(selectedField, objectData, 1)).to.deep.equal({
        test_field_454b66f: {
          ...objectData,
          type: TEXT_FIELD,
          name: "test_field_454b66f",
          order: 2
        }
      });
    });

    it("should set the data for create SELECT_FIELD", () => {
      const selectedField = fromJS({
        name: NEW_FIELD,
        type: SELECT_FIELD,
        multi_select: true
      });
      const objectDataSelectField = {
        ...objectData,
        multi_select: true
      };

      expect(utils.buildDataToSave(selectedField, objectDataSelectField, 1)).to.deep.equals({
        test_field_454b66f: {
          ...objectDataSelectField,
          type: SELECT_FIELD,
          name: "test_field_454b66f",
          order: 2
        }
      });
    });

    it("should set the data for create DATE_FIELD", () => {
      const selectedField = fromJS({
        name: NEW_FIELD,
        type: DATE_FIELD,
        date_include_time: true
      });

      const objectDataDateTimeField = {
        ...objectData,
        date_include_time: true
      };

      expect(utils.buildDataToSave(selectedField, objectDataDateTimeField, 1)).to.deep.equals({
        test_field_454b66f: {
          ...objectDataDateTimeField,
          type: DATE_FIELD,
          name: "test_field_454b66f",
          order: 2
        }
      });
    });

    it("should replace the special characters with underscore for the field_name in the DB", () => {
      const selectedField = fromJS({
        name: NEW_FIELD,
        type: TEXT_FIELD
      });
      const data = {
        display_name: { en: "TEST field*name 1" },
        guiding_questions: { en: "" },
        help_text: { en: "e" },
        mobile_visible: true,
        required: false,
        show_on_minify_form: false,
        visible: true
      };
      const expected = "test_field_name_1_454b66f";

      expect(Object.keys(utils.buildDataToSave(selectedField, data, "en", 1))[0]).to.deep.equals(expected);
    });
  });
});

describe("subformContainsFieldName", () => {
  const subform = fromJS({
    id: 1,
    unique_id: "subform_1",
    fields: [{ id: 1, name: "field_1" }]
  });

  const subformField = fromJS({
    name: "subform_field_2"
  });

  it("return false if the subform does not have the field name", () => {
    expect(utils.subformContainsFieldName(subform, "field_2")).to.be.false;
  });

  it("return true if the subform have the field name", () => {
    expect(utils.subformContainsFieldName(subform, "field_1")).to.be.true;
  });

  it("return true if the subform field is new", () => {
    expect(utils.subformContainsFieldName(subform, NEW_FIELD, subformField)).to.be.true;
  });
});

describe("generateUniqueId", () => {
  it("returns the name of the duplicated data with a generated key of 7 characters", () => {
    stub(uuid, "v4").returns("b8e93-0cce-415b-ad2b-d06bb454b66f");

    const data = "new field";
    const generatedName = utils.generateUniqueId(data);

    expect(generatedName).to.equal("new_field_454b66f");
    expect(generatedName.split("_")[2]).to.have.lengthOf(7);
    uuid.v4.restore();
  });
});

describe("mergeTranslationKeys", () => {
  const defaultValues = {
    id: 1,
    display_name: {
      en: "Hello",
      es: "",
      fr: "Test fr"
    },
    help_text: {
      en: "Help Text",
      es: "",
      fr: "Test fr"
    }
  };

  it("should return defaultValues if there are not currValues (first render)", () => {
    const expected = defaultValues;

    expect(utils.mergeTranslationKeys(defaultValues, undefined)).to.deep.equals(expected);
    expect(utils.mergeTranslationKeys(defaultValues, {})).to.deep.equals(expected);
  });

  describe("when isSubform is false", () => {
    it("should merge translatable keys into defaultValues for fields or subform fields", () => {
      const currentValues = {
        id: 1,
        display_name: {
          en: "Hello",
          es: "Hola",
          fr: ""
        },
        help_text: {
          en: "Help Text",
          es: "Texto de ayuda",
          fr: ""
        }
      };

      const expected = {
        id: 1,
        display_name: {
          en: "Hello",
          es: "Hola",
          fr: "Test fr"
        },
        help_text: {
          en: "Help Text",
          es: "Texto de ayuda",
          fr: "Test fr"
        }
      };

      expect(utils.mergeTranslationKeys(defaultValues, currentValues)).to.deep.equals(expected);
    });
  });

  describe("when isSubform is true", () => {
    it("should merge translatable keys into defaultValues  for subforms", () => {
      const defaultSubformValues = {
        id: 1,
        name: {
          en: "Name",
          es: "",
          fr: "Nom"
        },
        description: {
          en: "Description",
          es: "",
          fr: "Description"
        }
      };

      const currentValues = {
        id: 1,
        name: {
          en: "Name",
          es: "Nombre",
          fr: ""
        },
        description: {
          en: "Description",
          es: "Descripcion",
          fr: ""
        }
      };

      const expected = {
        id: 1,
        name: {
          en: "Name",
          es: "Nombre",
          fr: "Nom"
        },
        description: {
          en: "Description",
          es: "Descripcion",
          fr: "Description"
        }
      };

      expect(utils.mergeTranslationKeys(defaultSubformValues, currentValues, true)).to.deep.equals(expected);
    });
  });
});
