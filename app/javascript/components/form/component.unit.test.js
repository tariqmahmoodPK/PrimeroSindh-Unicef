import { fromJS } from "immutable";
import * as yup from "yup";

import { setupMountedComponent, spy } from "../../test";

import Form from "./component";
import { FORM_MODE_DIALOG } from "./constants";
import { FormSectionRecord, FieldRecord } from "./records";

import { FormSection } from ".";

describe("<Form>", () => {
  const formSubmit = spy();
  const FORM_ID = "test-form";

  const formSections = fromJS([
    FormSectionRecord({
      unique_id: "notes_section",
      fields: [
        FieldRecord({
          display_name: "Test Field 1",
          name: "test_field_1",
          type: "text_field"
        }),
        FieldRecord({
          display_name: "Test Field 2",
          name: "test_field_2",
          type: "textarea"
        })
      ]
    })
  ]);

  const props = {
    formSections,
    mode: FORM_MODE_DIALOG,
    onSubmit: formSubmit,
    validations: yup.object().shape({
      test_field_1: yup.string().required()
    }),
    formID: FORM_ID
  };

  it("renders form based on formSection props", () => {
    const { component } = setupMountedComponent(Form, props);

    expect(component.exists("input[name='test_field_1']")).to.be.true;
    expect(component.exists("textarea[name='test_field_2']")).to.be.true;
  });

  it("should set form with initial values", () => {
    const { component } = setupMountedComponent(Form, {
      ...props,
      initialValues: { test_field_2: "Hello" }
    });

    expect(component.find(FormSection).first().props().formMethods.getValues().test_field_2).to.equal("Hello");
  });

  it("should not submit form when invalid", async () => {
    const { component } = setupMountedComponent(Form, props);

    await component.find("form").simulate("submit");

    expect(formSubmit).not.to.have.been.called;
  });

  xit("should submit form when valid", async () => {
    const { component } = setupMountedComponent(Form, {
      ...props,
      initialValues: { test_field_1: "Hello" }
    });

    await component.find('input[name="test_field_1"]').simulate("change", {
      target: { name: "test_field_1", value: "value-change" }
    });

    await component.find("form").simulate("submit");

    expect(formSubmit).to.have.been.called;
  });
});
