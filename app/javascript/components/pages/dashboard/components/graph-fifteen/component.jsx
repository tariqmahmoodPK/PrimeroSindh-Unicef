/* eslint-disable no-restricted-syntax */
/* eslint-disable guard-for-in */
import { useEffect } from "react";
import { useDispatch } from "react-redux";
import makeStyles from "@material-ui/core/styles/makeStyles";
import { Grid } from "@material-ui/core";

import { Chart } from "../../../../charts";
import { fetchGraphFifteen } from "../../action-creators";
import { getGraphFifteen } from "../../selectors";
import { useMemoizedSelector } from "../../../../../libs";

import styles from "./styles.css";

const useStyles = makeStyles(styles);

const Component = () => {
  const css = useStyles();
  const dispatch = useDispatch();
  const data = useMemoizedSelector(state => getGraphFifteen(state));
  const stats = data ? data.toJS() : null;

  useEffect(() => {
    dispatch(fetchGraphFifteen());
  }, []);

  let graphData;
  let chart_options = {
      scales: {
        xAxes: [{
          ticks: {
            display: false
          },
          gridLines: {
            display: false
          },
          scaleLabel: {
            display: false,
            labelString: "Time in Seconds",
            fontColor: "red"
          }
        }],
        yAxes: [{
          ticks: {
            display: false
          },
          gridLines: {
            display: false
          },
          scaleLabel: {
            display: false,
            labelString: "Speed in Miles per Hour",
            fontColor: "green"
          }
        }]
      }
    }

  if (stats && stats.data && stats.data.labels) {
    const t = [];

    for (const obj of stats.data.dataset) {
      t.push(obj.count);
    }
    graphData = {
      labels: stats.data.labels,
      datasets: [
        {
          label: stats.data.labels,
          data: t,
          backgroundColor: ["rgb(255, 99, 132)", "rgb(54, 162, 235)", "rgb(255, 205, 86)"],
          hoverOffset: 4
        }
      ]
    };
  }

  return (
    <>
      {graphData && (
        <Grid item xl={6} md={6} xs={12}>
          <div className={css.container}>
            <h2>Cases by Forms of Physical Violence</h2>
            <div className={css.card} flat>
              <Chart type="pie" options={chart_options} data={graphData} showDetails />
            </div>
          </div>
        </Grid>
      )}
    </>
  );
};

Component.displayName = `GraphFifteen`;

export default Component;
