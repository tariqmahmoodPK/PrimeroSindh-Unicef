/* eslint-disable react/display-name */
/* eslint-disable react/no-multi-comp */
import { useEffect } from "react";
import PropTypes from "prop-types";
import { useDispatch } from "react-redux";
import { object, string } from "yup";
import { Formik } from "formik";
import { fromJS } from "immutable";
import startCase from "lodash/startCase";

import { RECORD_TYPES } from "../../../../../config";
import { getEnabledAgencies } from "../../../../application";
import { setServiceToRefer } from "../../../../record-form/action-creators";
import { getServiceToRefer } from "../../../../record-form";
import { useI18n } from "../../../../i18n";
import { saveReferral } from "../../action-creators";
import { useMemoizedSelector } from "../../../../../libs";

import MainForm from "./main-form";
import {
  AGENCY_FIELD,
  LOCATION_FIELD,
  NAME,
  NOTES_FIELD,
  REFERRAL_FIELD,
  REMOTE_SYSTEM_FIELD,
  SERVICE_FIELD,
  SERVICE_RECORD_FIELD,
  SERVICE_SECTION_FIELDS,
  TRANSITIONED_TO_FIELD
} from "./constants";

const ReferralForm = ({
  canConsentOverride,
  providedConsent,
  recordType,
  record,
  referral,
  referralRef,
  setPending,
  disabled,
  setDisabled
}) => {
  const i18n = useI18n();
  const dispatch = useDispatch();

  const serviceToRefer = useMemoizedSelector(state => getServiceToRefer(state));
  const services = serviceToRefer.get(SERVICE_SECTION_FIELDS.type, "");

  const agencies = useMemoizedSelector(state => {
    return getEnabledAgencies(state, services);
  });

  const referralFromService = serviceToRefer?.size
    ? {
        [SERVICE_FIELD]: serviceToRefer.get(SERVICE_SECTION_FIELDS.type),
        [AGENCY_FIELD]: serviceToRefer.get(SERVICE_SECTION_FIELDS.implementingAgency),
        [LOCATION_FIELD]: serviceToRefer.get(SERVICE_SECTION_FIELDS.deliveryLocation),
        [TRANSITIONED_TO_FIELD]: serviceToRefer.get(SERVICE_SECTION_FIELDS.implementingAgencyIndividual),
        [SERVICE_RECORD_FIELD]: serviceToRefer.get(SERVICE_SECTION_FIELDS.uniqueId)
      }
    : {};

  useEffect(() => {
    const selectedAgencyId = serviceToRefer.get(SERVICE_SECTION_FIELDS.implementingAgency, "");
    const selectedAgency = agencies.find(current => current.get("unique_id") === selectedAgencyId);

    if (selectedAgency?.size) {
      referralFromService[AGENCY_FIELD] = selectedAgencyId;
    } else {
      referralFromService[AGENCY_FIELD] = "";
    }
  }, [agencies]);

  useEffect(() => {
    return () => dispatch(setServiceToRefer(fromJS({})));
  }, []);

  const mainFormProps = {
    providedConsent,
    canConsentOverride,
    disabled,
    setDisabled,
    recordType,
    recordModuleID: record?.get("module_id"),
    referral,
    isReferralFromService: Object.keys(referralFromService).length > 0
  };

  const validationSchema = object().shape({
    [TRANSITIONED_TO_FIELD]: string().required(i18n.t("referral.user_mandatory_label"))
  });

  const formProps = {
    initialValues: {
      [REFERRAL_FIELD]: false,
      [REMOTE_SYSTEM_FIELD]: false,
      [SERVICE_FIELD]: "",
      [AGENCY_FIELD]: "",
      [LOCATION_FIELD]: "",
      [TRANSITIONED_TO_FIELD]: "",
      [NOTES_FIELD]: "",
      ...referralFromService
    },
    ref: referralRef,
    onSubmit: (values, { setSubmitting }) => {
      const recordId = record.get("id");

      setPending(true);

      dispatch(
        saveReferral(
          recordId,
          recordType,
          {
            data: {
              ...values,
              consent_overridden: canConsentOverride || values[REFERRAL_FIELD]
            }
          },
          i18n.t("referral.success", { record_type: startCase(RECORD_TYPES[recordType]), id: recordId })
        )
      );
      setSubmitting(false);
    },
    render: props => <MainForm formProps={props} rest={mainFormProps} />,
    validateOnBlur: false,
    validateOnChange: false,
    validationSchema
  };

  return <Formik {...formProps} />;
};

ReferralForm.displayName = NAME;

ReferralForm.propTypes = {
  canConsentOverride: PropTypes.bool,
  disabled: PropTypes.bool,
  providedConsent: PropTypes.bool,
  record: PropTypes.object,
  recordType: PropTypes.string.isRequired,
  referral: PropTypes.object,
  referralRef: PropTypes.object,
  setDisabled: PropTypes.func,
  setPending: PropTypes.func
};

export default ReferralForm;
