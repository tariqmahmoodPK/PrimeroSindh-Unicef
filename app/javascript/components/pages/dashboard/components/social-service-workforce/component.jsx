/* eslint-disable no-restricted-syntax */
/* eslint-disable guard-for-in */
import { useEffect } from "react";
import { useDispatch } from "react-redux";
import makeStyles from "@material-ui/core/styles/makeStyles";
import { Grid } from "@material-ui/core";

import { BarChart } from "../../../../charts";
import { fetchSocialServiceWorkforce } from "../../action-creators";
import { getSocialServiceWorkforce } from "../../selectors";
import { useMemoizedSelector } from "../../../../../libs";

import styles from "./styles.css";

const useStyles = makeStyles(styles);

const Component = () => {
  const css = useStyles();
  const dispatch = useDispatch();
  const data = useMemoizedSelector(state => getSocialServiceWorkforce(state));
  const stats = data.get("data") ? data.get("data").toJS() : null;

  useEffect(() => {
    dispatch(fetchSocialServiceWorkforce());
  }, []);

  let graphData;
  let chart_options = {
      scales: {
        xAxes: [{
          scaleLabel: {
            display: true,
            labelString: "District",
            fontColor: "red"
          }
        }],
        yAxes: [{
          scaleLabel: {
            display: true,
            labelString: "Number of Officers",
            fontColor: "green"
          }
        }]
      }
    }

  if (stats && stats.data) {
    const dataset = [];

    for (const obj of stats.data) {
      dataset.push({
        label: obj.name,
        data: obj.data,
        backgroundColor: obj.backgroundColor,
        borderColor: obj.borderColor,
        borderWidth: 1,
        stack: "Stack 0"
      });
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
            <h2>District wise social service workforce</h2>
            <div className={css.card} flat>
              <BarChart options={chart_options} data={graphData} showDetails />
            </div>
          </div>
        </Grid>
      )}
    </>
  );
};

Component.displayName = `SocialServiceWorkforce`;

export default Component;
