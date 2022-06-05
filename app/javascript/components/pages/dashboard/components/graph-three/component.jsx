/* eslint-disable no-prototype-builtins */
/* eslint-disable no-restricted-syntax */
/* eslint-disable guard-for-in */
import { useEffect } from "react";
import { useDispatch } from "react-redux";
import makeStyles from "@material-ui/core/styles/makeStyles";
import { Grid } from "@material-ui/core";

import { fetchGraphThree } from "../../action-creators";
import { getGraphThree } from "../../selectors";
import { useMemoizedSelector } from "../../../../../libs";

import styles from "./styles.css";

const useStyles = makeStyles(styles);

const Component = () => {
  const css = useStyles();
  const dispatch = useDispatch();
  const data = useMemoizedSelector(state => getGraphThree(state));
  const stats = data.get("data") ? data.get("data").toJS() : null;

  useEffect(() => {
    dispatch(fetchGraphThree());
  }, []);

  return (
    <>
      {stats && stats.hasOwnProperty("cases_with_custody_order") && (
        <div>
          <div flat>
            <div className={css.num}>{stats.cases_with_custody_order}</div>
            <div className={css.text}>Cases with custody and placement orders</div>
          </div>
        </div>
      )}
    </>
  );
};

Component.displayName = `GraphThree`;

export default Component;
