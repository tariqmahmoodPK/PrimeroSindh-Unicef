import { useEffect } from "react";
import { useDispatch } from "react-redux";
import makeStyles from "@material-ui/core/styles/makeStyles";

import { fetchRegisteredCasesByProtectionConcern } from "../../action-creators";
import { getRegisteredCasesByProtectionConcern } from "../../selectors";
import { useMemoizedSelector } from "../../../../../libs";

import styles from "./styles.css";

const useStyles = makeStyles(styles);

const Component = () => {
  const css = useStyles();
  const dispatch = useDispatch();
  const data = useMemoizedSelector(state => getRegisteredCasesByProtectionConcern(state));
  const stats = data.getIn(["data", "stats"]) ? data.getIn(["data", "stats"]).toJS() : null;

  useEffect(() => {
    dispatch(fetchRegisteredCasesByProtectionConcern());
  }, []);

  return (
    <>
      {stats && (
        <>
          <h2>Percentage of Children who have Received Child Protection Services by Protection Concern</h2>
          <div className={css.container}>
            <div className={css.card} style={{ backgroundColor: "rgb(255, 99, 132)" }} flat>
              <div className={css.perc}>
                {stats.physically_or_mentally_abused.percentage}% ({stats.physically_or_mentally_abused.cases})
              </div>
              <div className={css.text}>Physical Violence or Injury</div>
            </div>
            <div className={css.card} style={{ backgroundColor: "rgb(54, 162, 235)" }} flat>
              <div className={css.perc}>
                {stats.street_child.percentage}% ({stats.street_child.cases})
              </div>
              <div className={css.text}>Mental Violence</div>
            </div>
            <div className={css.card} style={{ backgroundColor: "rgb(128, 0, 128)" }} flat>
              <div className={css.perc}>
                {stats.neglect_or_negligent_treatment.percentage}% ({stats.neglect_or_negligent_treatment.cases})
              </div>
              <div className={css.text}>Neglect and Negligent Treatment</div>
            </div>
            <div className={css.card} style={{ backgroundColor: "rgb(255, 205, 86)" }} flat>
              <div className={css.perc}>
                {stats.exploitation.percentage}% ({stats.exploitation.cases})
              </div>
              <div className={css.text}>Exploitation</div>
            </div>
            <div className={css.card} style={{ backgroundColor: "rgb(54, 170, 89)" }} flat>
              <div className={css.perc}>
                {stats.sexual_abuse_or_exploitation.percentage}% ({stats.sexual_abuse_or_exploitation.cases})
              </div>
              <div className={css.text}>Sexual Abuse and Sexual Exploitation</div>
            </div>
          </div>
        </>
      )}
    </>
  );
};

Component.displayName = `ServicesPercentage`;

export default Component;
