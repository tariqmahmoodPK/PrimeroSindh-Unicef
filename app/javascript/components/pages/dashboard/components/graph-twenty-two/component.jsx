/* eslint-disable no-restricted-syntax */
/* eslint-disable guard-for-in */
import { useEffect } from "react";
import { useDispatch } from "react-redux";
import makeStyles from "@material-ui/core/styles/makeStyles";
import Grid from '@material-ui/core/Grid';
import { BarChart } from "../../../../charts";
import { fetchCaseStatuses } from "../../action-creators";
import { getCaseStatuses } from "../../selectors";
import { useMemoizedSelector } from "../../../../../libs";

import styles from "./styles.css";

const useStyles = makeStyles(styles);

const Component = () => {
  const css = useStyles();
  const dispatch = useDispatch();
  const data = useMemoizedSelector(state => getCaseStatuses(state));
  const stats = data.getIn(["data", "stats"]) ? data.getIn(["data", "stats"]).toJS() : null;

  useEffect(() => {
    dispatch(fetchCaseStatuses());
  }, []);

  let graphData;


  let chartOptions = {
    scales: {
      xAxes: [{
        scaleLabel: {
          display: true,
          labelString: "Cases Status",
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
    const { data } = stats
    const labels = [];
    const reg = [];
    for (const key in data) {
      labels.push(key);
    }
    for (const key in data) {
      reg.push(data[key]);
    }

    graphData = {
      labels,
      datasets: [
        {
          label: "Cases",
          data: reg,
          backgroundColor: ["blue", "red", "green", "orange", "purple", "cyan"]
        }
      ]
    };
  }

  return (
    stats && <Grid item md={6} xl={6}>
      <div className={css.container}>
        <h2>Cases at a Glance</h2>
        <div className={css.card} flat>
          <BarChart data={graphData} options={chartOptions} showDetails showLegend={false} />
        </div>
      </div>
    </Grid>
  );
};

Component.displayName = `GraphTwentyTwo`;

export default Component;
