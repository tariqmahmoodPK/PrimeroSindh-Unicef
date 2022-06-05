import PropTypes from "prop-types";
import { Button } from "@material-ui/core";

import { useI18n } from "../../../../../i18n";

const ReferAction = ({ index, handleReferral, values }) => {
  const i18n = useI18n();

  return (
    <Button
      key={`refer-option-${index}`}
      onClick={() => handleReferral()}
      color="primary"
      variant="contained"
      size="small"
      disableElevation
    >
      {values[index].service_status_referred ? i18n.t("buttons.referral_again") : i18n.t("buttons.referral")}
    </Button>
  );
};

ReferAction.displayName = "ReferAction";

ReferAction.propTypes = {
  handleReferral: PropTypes.func,
  index: PropTypes.number,
  values: PropTypes.object
};

export default ReferAction;
