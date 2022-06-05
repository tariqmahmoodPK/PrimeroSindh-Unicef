import { Box, Divider, Grid } from "@material-ui/core";
import PropTypes from "prop-types";

import { useI18n } from "../../i18n";
import TransitionUser from "../TransitionUser";
import { TRANSFER_REQUEST_DETAILS_NAME } from "../constants";

const Details = ({ transition, classes }) => {
  const i18n = useI18n();

  return (
    <Grid container spacing={2}>
      <Grid item md={6} xs={12}>
        <TransitionUser label="transition.recipient" transitionUser={transition.transitioned_to} classes={classes} />
      </Grid>
      <Grid item md={6} xs={12}>
        <TransitionUser label="transition.requested_by" transitionUser={transition.transitioned_by} classes={classes} />
      </Grid>
      <Grid item md={12} xs={12}>
        <Box>
          <Divider />
          <div className={classes.transtionLabel}>{i18n.t("transition.notes")}</div>
          <div className={classes.transtionValue}>{transition.notes}</div>
        </Box>
      </Grid>
    </Grid>
  );
};

Details.displayName = TRANSFER_REQUEST_DETAILS_NAME;

Details.propTypes = {
  classes: PropTypes.object.isRequired,
  transition: PropTypes.object.isRequired
};

export default Details;
