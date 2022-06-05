/* eslint-disable no-restricted-syntax */
/* eslint-disable guard-for-in */
import { useEffect } from "react";
import { useDispatch } from "react-redux";
import makeStyles from "@material-ui/core/styles/makeStyles";
import { Grid } from "@material-ui/core";

import { BarChart } from "../../../../charts";
import { fetchGraphOne } from "../../action-creators";
import { getGraphOne } from "../../selectors";
import { useMemoizedSelector } from "../../../../../libs";

import styles from "./styles.css";

const useStyles = makeStyles(styles);

const Component = () => {
  const css = useStyles();
  const dispatch = useDispatch();
  const data = useMemoizedSelector(state => getGraphOne(state));
  const stats = data.getIn(["data", "stats"]) ? data.getIn(["data", "stats"]).toJS() : null;

  useEffect(() => {
    dispatch(fetchGraphOne());
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
          backgroundColor: ["blue", "red", "green", "orange", "purple", "cyan", "brown", "grey", "hotPink", "skyBlue", "yellow", "darkBlue", "pink"]
        }
      ]
    };
  }

  return (
    <>
      {graphData && (
        <Grid item xl={6} md={6} xs={12}>
          <div className={css.container}>
            <h2>Case Referrals (by Agency)</h2>
            <div className={css.card} flat>
              <BarChart options={chart_options} data={graphData} showDetails showLegend={false} />
            </div>
          </div>
        </Grid>
      )}
    </>
  );
};

Component.displayName = `GraphOne`;

export default Component;
