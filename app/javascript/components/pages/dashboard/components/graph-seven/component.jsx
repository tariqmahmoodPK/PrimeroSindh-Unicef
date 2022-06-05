/* eslint-disable no-restricted-syntax */
/* eslint-disable guard-for-in */
import { useEffect } from "react";
import { useDispatch } from "react-redux";
import makeStyles from "@material-ui/core/styles/makeStyles";

import { BarChart } from "../../../../charts";
import { fetchGraphSeven } from "../../action-creators";
import { getGraphSeven } from "../../selectors";
import { useMemoizedSelector } from "../../../../../libs";

import styles from "./styles.css";

const useStyles = makeStyles(styles);

const Component = () => {
  const css = useStyles();
  const dispatch = useDispatch();
  const data = useMemoizedSelector(state => getGraphSeven(state));
  const stats = data.getIn(["data", "stats"]) ? data.getIn(["data", "stats"]).toJS() : null;

  useEffect(() => {
    dispatch(fetchGraphSeven());
  }, []);

  let graphData;

  if (stats) {
    const labels = [];
    const reg = [];
    const res = [];

    for (const key in stats) {
      labels.push(key);
    }
    for (const key in stats) {
      reg.push(stats[key].registered_cases);
    }
    for (const key in stats) {
      res.push(stats[key].resolved_cases);
    }
    graphData = {
      labels,
      datasets: [
        {
          label: "Resolved",
          data: res,
          backgroundColor: "rgba(54, 162, 235, 0.5)",
          borderColor: "rgb(54, 162, 235)",
          borderWidth: 1,
          stack: "Stack 0"
        },
        {
          label: "Registered",
          data: reg,
          backgroundColor: "rgba(255, 159, 64, 0.5)",
          borderColor: "rgb(255, 159, 64)",
          borderWidth: 1,
          stack: "Stack 0"
        }
      ]
    };
  }

  return (
    <>
      {graphData && (
        <div className={css.container}>
          <h2>Registered and Resolved Cases by District</h2>
          <div className={css.card} flat>
            <BarChart data={graphData} showDetails />
          </div>
        </div>
      )}
    </>
  );
};

Component.displayName = `GraphSeven`;

export default Component;
