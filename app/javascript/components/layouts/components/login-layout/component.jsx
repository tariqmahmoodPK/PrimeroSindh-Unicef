import { Grid, Box } from "@material-ui/core";
import { makeStyles } from "@material-ui/core/styles";
import PropTypes from "prop-types";
import clsx from "clsx";

import ModuleLogo from "../../../module-logo";
import AgencyLogo from "../../../agency-logo";
import ICTLogo from "../../../../images/mohr_logo.jpg";
import primeroLogo from "../../../../images/primero-logo.png";
import TranslationsToggle from "../../../translations-toggle";
import Notifier from "../../../notifier";
import DemoIndicator from "../../../demo-indicator";
import { useApp } from "../../../application";

import { NAME } from "./constants";
import styles from "./styles.css";

const useStyles = makeStyles(styles);

const Component = ({ children }) => {
  const css = useStyles();
  const { demo } = useApp();

  // TODO: Module hardcoded till we figure out when to switch modules
  const primeroModule = "cp";
  const moduleClass = `${primeroModule}${demo ? "-demo" : ""}`;
  const classes = clsx({ [css.primeroBackground]: true, [css[moduleClass]]: true, [css.demo]: demo });

  return (
    <>
      <DemoIndicator isDemo={demo} />
      <Notifier />
      <Box className={classes}>
        <div className={css.content}>
          {/* <div className={css.loginHeader}>
            <ModuleLogo white />
          </div> */}
          <div className={css.box}>
            <img src={ICTLogo} height="200px" width="240px" alt="Logo" />
            <h2 className={css.head}>Child Protection - Information Management System</h2>
            <h3 className={css.head}>Ministry of Human Rights</h3>
          </div>
          <div className={css.authContainer}>
            <div className={css.auth}>
              <div className={css.formContainer}>
                <div className={css.form}>{children}</div>
              </div>
              <div className={css.loginLogo}>
                <img src={primeroLogo} width="240px" alt="Logo" />
                {/* <AgencyLogo alwaysFullLogo /> */}
              </div>
            </div>
          </div>
        </div>
        <Grid container className={css.footer}>
          <Grid item xs={2}>
            <TranslationsToggle />
          </Grid>
          <Grid item xs={8} />
        </Grid>
      </Box>
    </>
  );
};

Component.displayName = NAME;

Component.propTypes = {
  children: PropTypes.node
};

export default Component;
