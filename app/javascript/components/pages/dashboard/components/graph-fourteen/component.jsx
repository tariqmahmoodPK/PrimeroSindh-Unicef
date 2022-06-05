/* eslint-disable no-plusplus */
/* eslint-disable no-restricted-syntax */
/* eslint-disable guard-for-in */
import { useEffect } from "react";
import { useDispatch } from "react-redux";
import makeStyles from "@material-ui/core/styles/makeStyles";
import { Grid } from "@material-ui/core";

import { Chart } from "../../../../charts";
import { fetchGraphFourteen } from "../../action-creators";
import { getGraphFourteen } from "../../selectors";
import { useMemoizedSelector } from "../../../../../libs";

import styles from "./styles.css";

const useStyles = makeStyles(styles);

const Component = () => {
  const css = useStyles();
  const dispatch = useDispatch();
  const data = useMemoizedSelector(state => getGraphFourteen(state));
  const stats = data ? data.toJS() : null;
  // const stats = data.getIn(["data", "stats"]) ? data.getIn(["data", "stats"]).toJS() : null;

  useEffect(() => {
    dispatch(fetchGraphFourteen());
  }, []);

  let graphData;
  const colors = ["rgb(255, 99, 132)", "rgb(54, 162, 235)", "rgb(255, 205, 86)"];
  const bgColors = [];
  const chartOptions = {
    scales: {
      xAxes: [
        {
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
        }
      ],
      yAxes: [
        {
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
        }
      ]
    }
  };

  if (stats && stats.data && stats.data.labels) {
    for (let i = 0; i < stats.data.labels.length; i++) {
      bgColors.push(colors[i % colors.length]);
    }
    graphData = {
      labels: stats.data.labels,
      datasets: [
        {
          label: stats.data.labels,
          data: stats.data.dataset,
          backgroundColor: bgColors,
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
            <h2>Rejected transfers, by district</h2>
            <div className={css.card} flat>
              <Chart type="pie" options={chartOptions} data={graphData} showDetails />
            </div>
          </div>
        </Grid>
      )}
    </>
  );
};

Component.displayName = `GraphFourteen`;

export default Component;
