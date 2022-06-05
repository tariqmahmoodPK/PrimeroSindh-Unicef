/* eslint-disable no-restricted-syntax */
/* eslint-disable guard-for-in */
import { useEffect } from "react";
import { useDispatch } from "react-redux";
import makeStyles from "@material-ui/core/styles/makeStyles";
import Grid from "@material-ui/core/Grid"
import { MapChart } from "../../../../charts";
import { fetchGraphTwentyOne } from "../../action-creators";
import { getGraphTwentyOne } from "../../selectors";
import { useMemoizedSelector } from "../../../../../libs";

import styles from "./styles.css";

const useStyles = makeStyles(styles);

const Component = () => {
    const css = useStyles();
    const dispatch = useDispatch();
    const data = useMemoizedSelector(state => getGraphTwentyOne(state));
    const stats = data.getIn(["data", "stats"]) ? data.getIn(["data", "stats"]).toJS() : null;

    useEffect(() => {
        dispatch(fetchGraphTwentyOne());
    }, []);
    let graphData;

    if (stats) {
        graphData = stats
    }

    return (
        <>
            {graphData && <Grid item xl={6} md={6} xs={12}>
                <h2 className={css.text}>Map of Registered Cases by District</h2>
                <div className={css.container}>
                    <div className={css.card} flat>
                        <MapChart graphData={graphData} />
                    </div>
                </div>
            </Grid>}
        </>
    );
};

Component.displayName = `GraphTwentyOne`;

export default Component;
