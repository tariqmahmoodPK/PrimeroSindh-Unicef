/* eslint-disable no-param-reassign */
import Chart from "chart.js";
import { createRef, useEffect } from "react";
import PropTypes from "prop-types";
import makeStyles from "@material-ui/core/styles/makeStyles";

import styles from "./styles.css";

const useStyles = makeStyles(styles);

const BarChart = ({ data, description, showDetails, options, showAxis, showLegend }) => {
  const css = useStyles();
  const chartRef = createRef();
  // let scales = null;

  useEffect(() => {
    const chatCtx = chartRef.current.getContext("2d");

    if (options) {
      options.scales.yAxes[0].ticks = {
        beginAtZero: true,
        min: 0,
        suggestedMin: 0,
        precision: 0
      };
    } else {
      options = {}
    }

    if (showAxis) {
      if (!options.scales) {
        options.scales = {}
      }
      if (data.yLabel) {
        options.scales.yAxes = [
          {
            display: showDetails,
            ticks: {
              beginAtZero: true,
              min: 0,
              suggestedMin: 0,
              precision: 0
            },
            scaleLabel: {
              display: true,
              labelString: data.yLabel || ""
            }
          }
        ]
      } if (data.xLabel) {
        options.scales.xAxes = [
          {
            display: showDetails,
            min: 0,
            suggestedMin: 0,
            ticks: {
              callback: value => {
                if (value?.length > 25) {
                  return value.substr(0, 25).concat("...");
                }

                return value;
              }
            },
            scaleLabel: {
              display: true,
              labelString: data.xLabel || ""
            }
          }
        ]
      }

    }
    /* eslint-disable no-new */
    const chartInstance = new Chart(chatCtx, {
      type: "bar",
      data,
      options: {
        ...options,
        responsive: true,
        animation: {
          duration: 0
        },
        maintainAspectRatio: false,
        legend: {
          display: showLegend === false ? false : true
        },
        tooltips: {
          callbacks: {
            label: (tooltipItem, chartData) => {
              const { label } = chartData.datasets[tooltipItem.datasetIndex];
              let { value } = tooltipItem;

              if (value === "0.1") {
                value = "0";
              }

              return `${label}: ${value}`;
            }
          }
        },
        // scales: scales
      }
    });

    return () => {
      chartInstance.destroy();
    };
  });

  return (
    <>
      {!showDetails ? <p className={css.description}>{description}</p> : null}
      <canvas id="reportGraph" ref={chartRef} height={!showDetails ? null : 400} />
    </>
  );
};

BarChart.displayName = "BarChart";

BarChart.defaultProps = {
  showDetails: false
};

BarChart.propTypes = {
  data: PropTypes.object,
  description: PropTypes.string,
  options: PropTypes.object,
  showDetails: PropTypes.bool
};

export default BarChart;
