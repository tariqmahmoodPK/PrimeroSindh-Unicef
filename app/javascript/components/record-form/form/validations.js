/* eslint-disable import/prefer-default-export */
import { number, date, array, object, string, bool, lazy } from "yup";
import { addDays } from "date-fns";

import {
  NUMERIC_FIELD,
  DATE_FIELD,
  DOCUMENT_FIELD,
  SUBFORM_SECTION,
  NOT_FUTURE_DATE,
  TICK_FIELD,
  SELECT_FIELD
} from "../constants";

export const fieldValidations = (field, i18n) => {
  const { multi_select: multiSelect, name, type, required } = field;
  const validations = {};

  if (field.visible === false) {
    return validations;
  }

  if (NUMERIC_FIELD === type) {
    if (name.match(/age/i) && name.match(/child/i)) {
      validations[name] = number()
        .nullable()
        .transform(value => (Number.isNaN(value) ? null : value))
        .positive()
        .min(0, i18n.t("errors.models.child.child_age"))
        .max(17, i18n.t("errors.models.child.child_age"));
    } else if (name.match(/age/i) && !(name.match(/child/i))) {
      validations[name] = number()
        .nullable()
        .transform(value => (Number.isNaN(value) ? null : value))
        .positive()
        .min(0, i18n.t("errors.models.child.age"))
        .max(130, i18n.t("errors.models.child.age"));
    } else if (name.match(/phone_number/i)) {
      validations[name] = string()
        .nullable()
        .transform(value => (Number.isNaN(value) ? null : value))
        .min(6, "You can enter minimum 7 and maximum 11 digits only. Starting the number with '0' i.e. Zero")
        .max(10, "You can enter minimum 7 and maximum 11 digits only. Starting the number with '0' i.e. Zero");
    }
    else {
      validations[name] = number()
        .nullable()
        .transform(value => (Number.isNaN(value) ? null : value))
        .min(0)
        .max(2147483647);
    }
  } else if (DATE_FIELD === type) {
    validations[name] = date().nullable();
    if (field.date_validation === NOT_FUTURE_DATE) {
      validations[name] = validations[name].max(addDays(new Date(), 1), i18n.t("fields.future_date_not_valid"));
    }
  } else if (SUBFORM_SECTION === type) {
    const subformSchema = field.subform_section_id.fields.map(sf => {
      return fieldValidations(sf, i18n);
    });

    validations[name] = array().of(
      lazy(value => (value._destroy ? object() : object().shape(Object.assign({}, ...subformSchema))))
    );
  }

  if (DOCUMENT_FIELD === type) {
    validations[name] = array().of(
      object().shape({
        attachment: string()
          .nullable()
          .when(["_destroy", "attachment_url"], {
            is: (destroy, attachmentUrl) => destroy !== 0 && !destroy && !attachmentUrl,
            then: string().nullable().required(i18n.t("fields.file_upload_box.no_file_selected"))
          })
      })
    );
  }

  if (required) {
    const requiredMessage = i18n.t("form_section.required_field", {
      field: field.display_name[i18n.locale]
    });

    if (type === TICK_FIELD) {
      validations[name] = bool().required(requiredMessage).oneOf([true], requiredMessage);
    } else if (type === SELECT_FIELD && multiSelect) {
      validations[name] = array().required(requiredMessage).min(1, requiredMessage);
    } else {
      validations[name] = (validations[name] || string()).nullable().required(requiredMessage);
    }
  }

  return validations;
};
