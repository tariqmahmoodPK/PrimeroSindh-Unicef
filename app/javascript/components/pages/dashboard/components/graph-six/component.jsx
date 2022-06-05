/* eslint-disable no-plusplus */
/* eslint-disable no-restricted-syntax */
/* eslint-disable guard-for-in */
import { useEffect } from "react";
import { useDispatch } from "react-redux";
import makeStyles from "@material-ui/core/styles/makeStyles";
import { Grid } from "@material-ui/core";

import { BarChart } from "../../../../charts";
import { fetchGraphSix } from "../../action-creators";
import { getGraphSix } from "../../selectors";
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
  const data = useMemoizedSelector(state => getGraphSix(state));
  const stats = data.getIn(["data", "stats"]) ? data.getIn(["data", "stats"]).toJS() : null;

  useEffect(() => {
    dispatch(fetchGraphSix());
  }, []);

  let graphData;

  if (stats) {
    const datasets = [];
    let i = 0;

    for (const obj of stats.data) {
      datasets.push({
        label: obj.name,
        data: obj.dataset,
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
            <h2>Services Provided by Age and Protection Concern</h2>
            <div className={css.card} flat>
              <BarChart data={graphData} showDetails />
            </div>
          </div>
        </Grid>
      )}
    </>
  );
};

Component.displayName = `GraphSix`;

export default Component;
