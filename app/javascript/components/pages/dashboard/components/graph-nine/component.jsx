/* eslint-disable no-restricted-syntax */
/* eslint-disable guard-for-in */
import { useEffect } from "react";
import { useDispatch } from "react-redux";
import makeStyles from "@material-ui/core/styles/makeStyles";
import { Grid } from "@material-ui/core";

import { BarChart } from "../../../../charts";
import { fetchGraphNine } from "../../action-creators";
import { getGraphNine } from "../../selectors";
import { useMemoizedSelector } from "../../../../../libs";

import styles from "./styles.css";

const useStyles = makeStyles(styles);

const Component = () => {
  const css = useStyles();
  const dispatch = useDispatch();
  const data = useMemoizedSelector(state => getGraphNine(state));
  const stats = data.getIn(["data", "stats"]) ? data.getIn(["data", "stats"]).toJS() : null;

  useEffect(() => {
    dispatch(fetchGraphNine());
  }, []);

  let graphData;
  let chart_options = {
    scales: {
      xAxes: [{
        scaleLabel: {
          display: true,
          labelString: "Agency",
          fontColor: "red"
        }
      }],
      yAxes: [{
        scaleLabel: {
          display: true,
          labelString: "Number Of Cases",
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
      reg.push(stats[key]["Reffered Cases"]);
    }
    for (const key in stats) {
      res.push(stats[key]["Resolved Cases"]);
    }
    graphData = {
      labels,
      datasets: [
        {
          label: "Closed",
          data: res,
          backgroundColor: "rgba(54, 162, 235)",
          stack: "Stack 0"
        },
        {
          label: "Reffered",
          data: reg,
          backgroundColor: "rgba(255, 159, 64",
          stack: "Stack 0"
        }
      ]
    };
  }

  return (
    <>
      {graphData && (
        <Grid item xl={6} md={6} xs={12}>
          <div className={css.container}>
            <h2>Referred and Closed Cases by Agency</h2>
            <div className={css.card} flat>
              <BarChart options={chart_options} data={graphData} showDetails />
            </div>
          </div>
        </Grid>
      )}
    </>
  );
};

Component.displayName = `GraphNine`;

export default Component;
