import { useEffect } from "react";
import { useDispatch } from "react-redux";
import makeStyles from "@material-ui/core/styles/makeStyles";
import { fetchDemographicsAnalysis } from "../../action-creators";
import { getDemographicsAnalysis, getCaseStatuses } from "../../selectors";
import { useMemoizedSelector } from "../../../../../libs";
import { GraphTwo, GraphThree } from "../../components"
import styles from "./styles.css";
import Grid from "@material-ui/core/Grid";

const useStyles = makeStyles(styles);

const Component = () => {
  const css = useStyles();
  const dispatch = useDispatch();
  const data = useMemoizedSelector(state => getDemographicsAnalysis(state));
  const getRole = useMemoizedSelector(state => getCaseStatuses(state));
  const stats = data.get("dataset") ? data.get("dataset").toJS() : null;
  let userRole = getRole.getIn(["data", "stats"]) ? getRole.getIn(["data", "stats"]).toJS() : null;
  let role;

  if (userRole) {
    role = userRole.role;
  }

  useEffect(() => {
    dispatch(fetchDemographicsAnalysis());
  }, []);

  return (
    stats && (
      <div>
        {(role === "CP Manager" || role === "CPO" || role === "CPI In-charge" || role === "FTR Manager") && (
          <div className={css.container}>
            <Grid item md={6} xl={6}>
              <div className={`${css.box} ${css.mr}`}>
                <h2>Demographical Analysis</h2>
                <div className={css.container}>
                  <div className={css.card} style={{ backgroundColor: "rgb(165, 129, 248)" }} flat>
                    <div className={css.perc}>{stats["No. of Minority Cases"]}</div>
                    <div className={css.text}>No. of Minority Cases (Religious / Ethnic)</div>
                  </div>

                  <div className={css.card} style={{ backgroundColor: "rgb(254, 194, 66)" }} flat>
                    <div className={css.perc}>{stats["No. of Children with Disabilities (CWB)"]}</div>
                    <div className={css.text}>No. of Cases with CwD</div>
                  </div>

                  <div className={css.card} style={{ backgroundColor: "rgb(84, 177, 81)" }} flat>
                    <div className={css.perc}>{stats["No. of BISP Beneficiaries"]}</div>
                    <div className={css.text}>No. of Cases with BISP Beneficiaries</div>
                  </div>
                </div>
              </div>
            </Grid>
            <Grid item md={6} xl={6}>
              <div className={`${css.box} ${css.ml}`}>
                <h2>Cases with Court Orders​</h2>
                <div className={css.container}>
                  <div className={css.card} style={{ backgroundColor: "rgba(54, 162, 235, 0.5)" }} flat>
                    <GraphTwo />
                  </div>

                  <div className={css.card} style={{ backgroundColor: "rgba(54, 162, 235, 0.5)" }} flat>
                    <GraphThree />
                  </div>
                </div>
              </div>
            </Grid>
          </div>
        )}
      </div>
    )
  );
};

Component.displayName = `DemographicsAnalysis`;

export default Component;
