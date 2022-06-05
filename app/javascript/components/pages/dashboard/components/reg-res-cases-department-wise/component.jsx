/* eslint-disable no-restricted-syntax */
/* eslint-disable guard-for-in */
import { useEffect } from "react";
import { useDispatch } from "react-redux";
import makeStyles from "@material-ui/core/styles/makeStyles";
import { Grid } from "@material-ui/core";

import { BarChart } from "../../../../charts";
import { fetchRegisteredAndResolvedCasesDept } from "../../action-creators";
import { getRegisteredAndResolvedCasesDept } from "../../selectors";
import { useMemoizedSelector } from "../../../../../libs";

import styles from "./styles.css";

const useStyles = makeStyles(styles);

const Component = () => {
  const css = useStyles();
  const dispatch = useDispatch();
  const data = useMemoizedSelector(state => getRegisteredAndResolvedCasesDept(state));
  const stats = data.getIn(["data", "stats"]) ? data.getIn(["data", "stats"]).toJS() : null;
  // const stats = data ? data.toJS() : null;

  useEffect(() => {
    dispatch(fetchRegisteredAndResolvedCasesDept());
  }, []);

  let graphData;
  let chart_options = {
      scales: {
        xAxes: [{
          scaleLabel: {
            display: true,
            labelString: "Department",
            fontColor: "red"
          }
        }],
        yAxes: [{
          scaleLabel: {
            display: true,
            labelString: "Number of Cases",
            fontColor: "green"
          }
        }]
      }
    }

  if (stats) {
    const labels = [];
    const reg = [];

    for (const key in stats) {
      labels.push(key);
    }
    for (const key in stats) {
      reg.push(stats[key]);
    }
    graphData = {
      labels,
      datasets: [
        {
          label: "Cases",
          data: reg,
          backgroundColor: "rgba(54, 162, 235, 0.5)",
          borderColor: "rgb(54, 162, 235)",
          borderWidth: 1
        }
      ]
    };
  }

  return (
    <>
      {graphData && (
        <Grid item xl={6} md={6} xs={12}>
          <div className={css.container}>
            <h2>Cases Referred/Resolved - Department Wise</h2>
            <div className={css.card} flat>
              <BarChart options={chart_options} data={graphData} showDetails />
            </div>
          </div>
        </Grid>
      )}
    </>
  );
};

Component.displayName = `RegResCasesDept`;

export default Component;
