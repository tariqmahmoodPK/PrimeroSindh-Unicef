/* eslint-disable dot-notation */
/* eslint-disable no-restricted-syntax */
/* eslint-disable guard-for-in */
import { useEffect } from "react";
import { useDispatch } from "react-redux";
import makeStyles from "@material-ui/core/styles/makeStyles";
import { Grid } from "@material-ui/core";

import { BarChart } from "../../../../charts";
import { fetchResCasesByAge } from "../../action-creators";
import { getResCasesByAge } from "../../selectors";
import { useMemoizedSelector } from "../../../../../libs";

import styles from "./styles.css";

const useStyles = makeStyles(styles);

const Component = () => {
  const css = useStyles();
  const dispatch = useDispatch();
  const data = useMemoizedSelector(state => getResCasesByAge(state));
  const stats = data.getIn(["data", "stats"]) ? data.getIn(["data", "stats"]).toJS() : null;

  useEffect(() => {
    dispatch(fetchResCasesByAge());
  }, []);

  let graphData;
  let chart_options = {
    scales: {
      xAxes: [
        {
          scaleLabel: {
            display: true,
            labelString: "Age (Years)",
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
    const labels = [];
    const one = [];
    const two = [];
    const three = [];
    const four = [];
    const five = [];

    for (const key in stats) {
      labels.push(key);
    }

    for (const key in stats) {
      one.push(stats[key]["Exploitation"]);
      two.push(stats[key]["Mental Violence"]);
      three.push(stats[key]["Neglect and Negligent Treatment"]);
      four.push(stats[key]["Physical Violence or Injury"]);
      five.push(stats[key]["Sexual Abuse and Sexual Exploitation"]);
    }

    graphData = {
      labels,
      datasets: [
        {
          label: "Exploitation",
          data: one,
          backgroundColor: "rgba(255, 99, 132)",
          stack: "Stack 0"
        },
        {
          label: "Mental Violence",
          data: two,
          backgroundColor: "rgba(255, 159, 64)",
          stack: "Stack 0"
        },
        {
          label: "Neglect and Negligent Treatment",
          data: three,
          backgroundColor: "rgba(75, 192, 192)",
          stack: "Stack 0"
        },
        {
          label: "Physical Violence or Injury",
          data: four,
          backgroundColor: "rgba(54, 162, 235)",
          stack: "Stack 0"
        },
        {
          label: "Sexual Abuse and Sexual Exploitation",
          data: five,
          backgroundColor: "rgba(153, 102, 255)",
          stack: "Stack 0"
        }
      ]
    };
  }

  return (
    <>
      {graphData && (
        <Grid item xl={12} md={12} xs={12}>
          <div className={css.container}>
            <h2>Closed Cases by Age and Protection Concern</h2>
            <div className={css.card} flat>
              <BarChart options={chart_options} data={graphData} showDetails />
            </div>
          </div>
        </Grid>
      )}
    </>
  );
};

Component.displayName = `RegResCasesAge`;

export default Component;
