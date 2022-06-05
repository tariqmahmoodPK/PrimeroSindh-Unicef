import PropTypes from "prop-types";
import { Field } from "formik";
import { TextField } from "formik-material-ui";

import { useI18n } from "../../../../i18n";
import SearchableSelect from "../../../../searchable-select";

import { NOTES_FIELD } from "./constants";

const FormInternal = ({ fields, disabled, isReferralFromService }) => {
  const i18n = useI18n();
  const internalFields = fields.map(f => {
    if (!Object.keys(f).includes("options")) {
      return (
        <Field
          key={f.id}
          component={TextField}
          name={f.id}
          label={f.label}
          margin="normal"
          disabled={f.id === NOTES_FIELD && isReferralFromService ? false : disabled}
          InputLabelProps={{
            shrink: true
          }}
          fullWidth
          autoComplete="off"
        />
      );
    }
    const searchableValue = field => {
      const { value } = field;
      const selected = f.options?.find(option => option.value === value);

      return value !== "" ? selected : null;
    };

    const searchTextFieldProps = (field, form) => {
      const { id, label, required } = field;
      const { errors } = form;

      return {
        label,
        required,
        error: errors?.[id],
        helperText: errors?.[id],
        margin: "dense",
        placeholder: i18n.t("transfer.select_label"),
        InputLabelProps: {
          htmlFor: id,
          shrink: true
        }
      };
    };

    return (
      <Field
        key={f.id}
        name={f.id}
        render={({ field, form, ...other }) => {
          const handleChange = data => f.onChange(data, field, form);

          return (
            <>
              <SearchableSelect
                id={f.id}
                name={f.id}
                isDisabled={disabled}
                options={f.options}
                defaultValues={searchableValue(field)}
                onChange={handleChange}
                TextFieldProps={searchTextFieldProps(f, form)}
                {...other}
                onBlur={field.onBlur}
                onOpen={f.onMenuOpen}
                isLoading={f.isLoading}
              />
            </>
          );
        }}
      />
    );
  });

  return <>{internalFields}</>;
};

FormInternal.displayName = "ReferralFormInternal";

FormInternal.propTypes = {
  disabled: PropTypes.bool,
  fields: PropTypes.array,
  isReferralFromService: PropTypes.bool
};

export default FormInternal;
