/* eslint-disable no-plusplus */
/* eslint-disable no-restricted-syntax */
/* eslint-disable guard-for-in */
import { useEffect } from "react";
import { useDispatch } from "react-redux";
import makeStyles from "@material-ui/core/styles/makeStyles";
import { Grid } from "@material-ui/core";

import { BarChart } from "../../../../charts";
import { fetchGraphSixteen } from "../../action-creators";
import { getGraphSixteen } from "../../selectors";
import { useMemoizedSelector } from "../../../../../libs";

import styles from "./styles.css";

const useStyles = makeStyles(styles);

const bgColors = [
  "rgb(255, 99, 132)",
  "rgb(75, 192, 192)",
  "rgb(255, 205, 86)",
  "rgb(201, 203, 207)",
  "rgb(54, 162, 235)"
];

const Component = () => {
  const css = useStyles();
  const dispatch = useDispatch();
  const data = useMemoizedSelector(state => getGraphSixteen(state));
  const stats = data.getIn(["data"]) ? data.getIn(["data"]).toJS() : null;

  useEffect(() => {
    dispatch(fetchGraphSixteen());
  }, []);

  let graphData;
  let chart_options = {
      scales: {
        xAxes: [{
          scaleLabel: {
            display: true,
            labelString: "Case Status (Age)",
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

  if (stats && stats.data) {
    const datasets = [];
    let i = 0;

    for (const obj of stats.data) {
      datasets.push({
        label: obj.name,
        data: obj.data,
        backgroundColor: bgColors.length > i ? bgColors[i] : bgColors[0],
        stack: "Stack 0"
      });
      i++;
    }
    graphData = {
      labels: stats.labels,
      datasets
    };
  }

  return (
    <>
      {graphData && (
        <Grid item xl={6} md={6} xs={12}>
          <div className={css.container}>
            <h2>Registered and Resolved Child protection cases by age and Sex</h2>
            <div className={css.card} flat>
              <BarChart options={chart_options} data={graphData} showDetails />
            </div>
          </div>
        </Grid>
      )}
    </>
  );
};

Component.displayName = `GraphSixteen`;

export default Component;
