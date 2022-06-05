/* eslint-disable no-restricted-syntax */
/* eslint-disable guard-for-in */
import { useEffect } from "react";
import { useDispatch } from "react-redux";
import makeStyles from "@material-ui/core/styles/makeStyles";
import { Grid } from "@material-ui/core";

import { Chart } from "../../../../charts";
import { fetchGraphTen } from "../../action-creators";
import { getGraphTen } from "../../selectors";
import { useMemoizedSelector } from "../../../../../libs";

import styles from "./styles.css";

const useStyles = makeStyles(styles);

const Component = () => {
  const css = useStyles();
  const dispatch = useDispatch();
  const data = useMemoizedSelector(state => getGraphTen(state));
  const stats = data ? data.toJS() : null;

  useEffect(() => {
    dispatch(fetchGraphTen());
  }, []);

  let graphData;

  if (stats && stats.data) {
    graphData = {
      labels: stats.labels,
      datasets: [
        {
          label: stats.labels,
          data: stats.data,
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
            <h2>Cases receiving CP services by sex</h2>
            <div className={css.card} flat>
              <Chart type="doughnut" data={graphData} showDetails />
            </div>
          </div>
        </Grid>
      )}
    </>
  );
};

Component.displayName = `GraphTen`;

export default Component;
