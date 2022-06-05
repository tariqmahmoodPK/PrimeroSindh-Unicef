import PropTypes from "prop-types";
import { Grid } from "@material-ui/core";

import TransitionStatus from "../TransitionStatus";
import { useI18n } from "../../i18n";
import { TRANSFER_REQUEST_SUMMARY_NAME } from "../constants";

const Summary = ({ transition, classes }) => {
  const i18n = useI18n();
  const transitionStatus = transition.status ? (
    <Grid item md={2} xs={4}>
      <TransitionStatus status={transition.status} />
    </Grid>
  ) : null;

  return (
    <Grid container spacing={2}>
      <Grid item md={10} xs={8}>
        <div className={classes.wrapper}>
          <div className={classes.titleHeader}>{i18n.t("transition.type.transferRequest")}</div>

          {/* TODO: The date should be localized */}
          <div className={classes.date}>{i18n.localizeDate(transition.created_at)}</div>
        </div>
      </Grid>
      {transitionStatus}
    </Grid>
  );
};

Summary.displayName = TRANSFER_REQUEST_SUMMARY_NAME;

Summary.propTypes = {
  classes: PropTypes.object.isRequired,
  transition: PropTypes.object.isRequired
};

export default Summary;
