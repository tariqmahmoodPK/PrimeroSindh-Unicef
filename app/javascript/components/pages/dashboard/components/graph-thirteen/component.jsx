/* eslint-disable no-restricted-syntax */
/* eslint-disable guard-for-in */
import { useEffect } from "react";
import { useDispatch } from "react-redux";
import makeStyles from "@material-ui/core/styles/makeStyles";
import { Grid } from "@material-ui/core";

import { BarChart } from "../../../../charts";
import { fetchGraphThirteen } from "../../action-creators";
import { getGraphThirteen } from "../../selectors";
import { useMemoizedSelector } from "../../../../../libs";

import styles from "./styles.css";

const useStyles = makeStyles(styles);

const Component = () => {
  const css = useStyles();
  const dispatch = useDispatch();
  const data = useMemoizedSelector(state => getGraphThirteen(state));
  const stats = data.getIn(["data", "stats"]) ? data.getIn(["data", "stats"]).toJS() : null;

  useEffect(() => {
    dispatch(fetchGraphThirteen());
  }, []);

  let graphData;
  let chart_options = {
    scales: {
      xAxes: [
        {
          scaleLabel: {
            display: true,
            labelString: "District",
            fontColor: "red"
          }
        }
      ],
      yAxes: [
        {
          scaleLabel: {
            display: true,
            labelString: "Number Of Cases",
            fontColor: "green"
          }
        }
      ]
    }
  };

  if (stats) {
    const dataset = [];

    const colors = [
      "rgb(255, 99, 132)",
      "rgb(75, 192, 192)",
      "rgb(255, 205, 86)",
      "rgb(201, 203, 207)",
      "rgb(54, 162, 235)"
    ];

    for (let i = 0; i < stats.dataset.length; i++) {
      const t = {
        label: stats.dataset[i].name,
        data: stats.dataset[i].data,
        backgroundColor: colors[i],
        stack: "Stack 0"
      };

      dataset.push(t);
    }

    graphData = {
      labels: stats.labels,
      datasets: dataset
    };
  }

  return (
    <>
      {graphData && (
        <Grid item xl={6} md={6} xs={12}>
          <div className={css.container}>
            <h2>Transferred Cases by District</h2>
            <div className={css.card} flat>
              <BarChart options={chart_options} data={graphData} showDetails />
            </div>
          </div>
        </Grid>
      )}
    </>
  );
};

Component.displayName = `GraphThirteen`;

export default Component;
