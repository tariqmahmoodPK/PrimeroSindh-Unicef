/* eslint-disable no-param-reassign */
import { createRef, useEffect } from "react";
import PropTypes from "prop-types";
import makeStyles from "@material-ui/core/styles/makeStyles";
import Highcharts from "highcharts/highmaps";
import data from "highcharts/modules/data.js";
import highmaps from "highcharts/modules/map.js";
import exporting from "highcharts/modules/exporting.js";
import offlineExporting from "highcharts/modules/offline-exporting.js";
import accessibility from "highcharts/modules/accessibility.js";
import geoJsonData from "./Gilgit-Baltistan.json";

import styles from "./styles.css";

const useStyles = makeStyles(styles);

const MapChart = ({ graphData }) => {
    highmaps(Highcharts);
    data(Highcharts);
    exporting(Highcharts);
    accessibility(Highcharts);
    offlineExporting(Highcharts);
    const css = useStyles();

    useEffect(() => {
        initChart()
    }, [])

    const initChart = () => {
        // Initialize the chart
        Highcharts.mapChart("mapChart", {
            chart: {
                map: geoJsonData,
            },
            xAxis: {
                labels: {
                    enabled: false
                }
            },
            title: {
                text: null,
            },

            mapNavigation: {
                enabled: true,
                buttonOptions: {
                    verticalAlign: "bottom",
                },
            },

            colorAxis: {
                tickPixelInterval: 1,
                minColor: "rgba(255, 186, 3, 1)",
                maxColor: "rgba(211, 0, 0, 1)", //"rgba(255, 159, 64)",
            },

            credits: {
                enabled: false,
            },
            exporting: { enabled: false },
            tooltip: {
                shared: true,
                crosshairs: true,
                backgroundColor: 'rgba(0,0,0,0.8)',
                bodyFontFamily: 'Raleway',
                titleFontFamily: 'Raleway',
                borderColor: 'rgba(0,0,0,0.8)',
                borderRadius: 10,
                useHTML: true,
                style: {
                    color: '#ffffff',
                    fontFamily: 'Raleway'
                },
                formatter(tooltip) {
                    const point = this.point;
                    if (point) {
                        let str = '<div style="font-size: 16px">';
                        str += '<b> ' + point.districts + '</b><br>';
                        str += '<div style="margin-top: 10px">';
                        str += `<div style="width: 12px;height: 12px;background-color: #ffffff;display: inline-block;margin-bottom: 0px; margin-right:5px">`;
                        str += `<div style="width: 10px;height: 10px;background: ${point.color};margin-left:1px;margin-top:1px"></div>`;
                        str += `</div>`;
                        str += '  <span style="font-size: 16px"><b>' + 'Cases' + ': ' + point.value + '   (' + point.percentage + '%)' + '</b></span>' + '<br>';
                        str += '</div>';
                        str += '</div>';
                        return str;
                    }
                }
            },
            series: [
                {
                    data: graphData,
                    keys: ["districts", "value", "percentage"],
                    joinBy: "districts",
                    name: "Cases by District",
                    states: {
                        hover: {
                            color: "rgb(106, 90, 205,0.5)",
                        },
                    },
                    dataLabels: {
                        enabled: true,
                        format: "{point.properties.districts}",
                    },
                },
            ],
        });
    }
    return <div id="mapChart" className={`${css.mapChart}`} />
};

Chart.displayName = "MapChart";

Chart.defaultProps = {
    showDetails: false
};

Chart.propTypes = {
    graphData: PropTypes.array,
};

export default MapChart;
