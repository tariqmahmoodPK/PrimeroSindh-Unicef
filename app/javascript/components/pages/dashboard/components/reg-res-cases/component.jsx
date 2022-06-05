/* eslint-disable no-restricted-syntax */
/* eslint-disable guard-for-in */
import { useEffect } from "react";
import { useDispatch } from "react-redux";
import makeStyles from "@material-ui/core/styles/makeStyles";
import { Grid } from "@material-ui/core";

import { BarChart } from "../../../../charts";
import { fetchRegisteredAndResolvedCasesByDistricts } from "../../action-creators";
import { getRegisteredAndResolvedCasesByDistricts } from "../../selectors";
import { useMemoizedSelector } from "../../../../../libs";

import styles from "./styles.css";

const useStyles = makeStyles(styles);

const Component = () => {
  const css = useStyles();
  const dispatch = useDispatch();
  const data = useMemoizedSelector(state => getRegisteredAndResolvedCasesByDistricts(state));
  const stats = data.getIn(["data", "stats"]) ? data.getIn(["data", "stats"]).toJS() : null;

  useEffect(() => {
    dispatch(fetchRegisteredAndResolvedCasesByDistricts());
  }, []);

  let graphData;
  let chart_options = {
    scales: {
      xAxes: [{
        scaleLabel: {
          display: true,
          labelString: "Registered and Closed Cases",
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
    const res = [];

    for (const key in stats) {
      labels.push(key);
    }
    for (const key in stats) {
      reg.push(stats[key].registered_cases);
    }
    for (const key in stats) {
      res.push(stats[key].resolved_cases);
    }
    graphData = {
      labels,
      datasets: [
        {
          label: "Closed",
          data: res,
          backgroundColor: "rgba(54, 162, 235, 0.5)",
          borderColor: "rgb(54, 162, 235)",
          borderWidth: 1,
          stack: "Stack 0"
        },
        {
          label: "Registered",
          data: reg,
          backgroundColor: "rgba(255, 159, 64, 0.5)",
          borderColor: "rgb(255, 159, 64)",
          borderWidth: 1,
          stack: "Stack 0"
        }
      ]
    };
  }

  return (
    <>
      {graphData && (
        <Grid item md={6} xl={6}>
          <div className={css.container}>
            <h2>Registered and Closed Cases by District</h2>
            <div className={css.card} flat>
              <BarChart options={chart_options} data={graphData} showDetails />
            </div>
          </div>
        </Grid>
      )}
    </>
  );
};

Component.displayName = `RegResCases`;

export default Component;
