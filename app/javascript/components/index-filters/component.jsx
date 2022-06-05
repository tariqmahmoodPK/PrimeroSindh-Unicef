import { useCallback, useState, useEffect } from "react";
import PropTypes from "prop-types";
import { useForm, FormProvider } from "react-hook-form";
import { useDispatch } from "react-redux";
import qs from "qs";
import isEmpty from "lodash/isEmpty";
import merge from "lodash/merge";
import { useLocation } from "react-router-dom";
import { push } from "connected-react-router";
import { Tabs, Tab } from "@material-ui/core";
import { makeStyles } from "@material-ui/core/styles";
import { fromJS } from "immutable";

import SavedSearches, { fetchSavedSearches } from "../saved-searches";
import SavedSearchesForm from "../saved-searches/SavedSearchesForm";
import { currentUser } from "../user";
import { useI18n } from "../i18n";
import { RECORD_PATH } from "../../config";
import { getReportingLocationConfig } from "../user/selectors";
import { DEFAULT_FILTERS } from "../record-list/constants";
import { useMemoizedSelector } from "../../libs";

import { filterType, compactFilters } from "./utils";
import {
  DEFAULT_SELECTED_RECORDS_VALUE,
  HIDDEN_FIELDS,
  PRIMARY_FILTERS,
  MY_CASES_FILTER_NAME,
  OR_FILTER_NAME
} from "./constants";
import { Search } from "./components/filter-types";
import { getFiltersByRecordType } from "./selectors";
import { applyFilters, setFilters } from "./action-creators";
import Actions from "./components/actions";
import styles from "./components/styles.css";
import MoreSection from "./components/more-section";

const useStyles = makeStyles(styles);

const Component = ({ recordType, defaultFilters, setSelectedRecords }) => {
  const css = useStyles();
  const i18n = useI18n();
  const [open, setOpen] = useState(false);
  const [rerender, setRerender] = useState(false);
  const [tabIndex, setTabIndex] = useState(0);
  const [moreSectionFilters, setMoreSectionFilters] = useState({});
  const location = useLocation();
  const queryParams = qs.parse(location.search.replace("?", ""));
  const [more, setMore] = useState(false);
  const [reset, setReset] = useState(false);
  const [filterToList, setFilterToList] = useState(DEFAULT_FILTERS);
  const dispatch = useDispatch();
  const defaultFiltersPlainObject = defaultFilters.toJS();

  const resetSelectedRecords = () => {
    setSelectedRecords(DEFAULT_SELECTED_RECORDS_VALUE);
  };

  const methods = useForm({
    defaultValues: isEmpty(queryParams) ? merge(defaultFiltersPlainObject, filterToList) : queryParams
  });

  const reportingLocationConfig = useMemoizedSelector(state => getReportingLocationConfig(state));
  const filters = useMemoizedSelector(state => getFiltersByRecordType(state, recordType));
  const userName = useMemoizedSelector(state => currentUser(state));

  const ownedByLocation = `${reportingLocationConfig.get("field_key")}${reportingLocationConfig.get("admin_level")}`;

  const addFilterToList = useCallback(data => setFilterToList({ ...filterToList, ...data }), [filterToList]);

  const allPrimaryFilters = filters.filter(f => PRIMARY_FILTERS.includes(f.field_name));
  const allDefaultFilters = filters.filter(f => [...defaultFilters.keys()].includes(f.field_name));

  const queryParamsKeys = Object.keys(queryParams);
  const moreSectionKeys = Object.keys(moreSectionFilters);
  const defaultFilterNames = allDefaultFilters.map(t => t.field_name);

  const isDateFieldFromValue = (field, keys) => {
    if (field.type !== "dates") {
      return false;
    }

    const datesOption = field?.options?.[i18n.locale];

    if (!datesOption) {
      return false;
    }

    return datesOption?.filter(dateOption => keys.includes(dateOption.id))?.length > 0;
  };

  const renderFilters = () => {
    let primaryFilters = filters;

    if (recordType === RECORD_PATH.cases) {
      const showMyCasesFilter = (field, keys) =>
        field.field_name === MY_CASES_FILTER_NAME && keys.includes(OR_FILTER_NAME);

      const selectedFromMoreSection = primaryFilters.filter(
        f =>
          moreSectionKeys.includes(f.field_name) ||
          showMyCasesFilter(f, moreSectionKeys) ||
          isDateFieldFromValue(f, moreSectionKeys)
      );

      const queryParamsFilter = primaryFilters.filter(
        f =>
          !more &&
          (queryParamsKeys.includes(f.field_name) ||
            showMyCasesFilter(f, queryParamsKeys) ||
            isDateFieldFromValue(f, queryParamsKeys)) &&
          !(
            defaultFilterNames.includes(f.field_name) || allPrimaryFilters.map(t => t.field_name).includes(f.field_name)
          )
      );

      const mergedFilters = fromJS([
        ...allPrimaryFilters,
        ...allDefaultFilters,
        ...queryParamsFilter,
        ...(!more ? selectedFromMoreSection : [])
      ]);

      primaryFilters = mergedFilters;
    }

    return primaryFilters.map(filter => {
      const Filter = filterType(filter.type);
      const secondary =
        moreSectionKeys.includes(filter.field_name) ||
        (filter.field_name === MY_CASES_FILTER_NAME && moreSectionKeys.includes(OR_FILTER_NAME)) ||
        isDateFieldFromValue(filter, moreSectionKeys);

      const mode = {
        secondary,
        defaultFilter: defaultFilterNames.includes(filter.field_name)
      };

      if (!Filter) return null;

      return (
        <Filter
          key={filter.field_name}
          filter={filter}
          moreSectionFilters={moreSectionFilters}
          setMoreSectionFilters={setMoreSectionFilters}
          reset={reset}
          setReset={setReset}
          mode={mode}
          addFilterToList={addFilterToList}
          filterToList={filterToList}
        />
      );
    });
  };

  useEffect(() => {
    [...HIDDEN_FIELDS, ownedByLocation].forEach(field => methods.register({ name: field }));

    methods.setValue("fields", "short");

    return () => {
      [...HIDDEN_FIELDS, ownedByLocation].forEach(field => methods.unregister({ name: field }));
    };
  }, []);

  useEffect(() => {
    if (tabIndex === 0) {
      methods.reset(merge(queryParams, filterToList));
    }
    if (tabIndex === 1) {
      dispatch(fetchSavedSearches());
    }
  }, [tabIndex]);

  useEffect(() => {
    if (rerender) {
      const filtersToApply = isEmpty(queryParams) ? defaultFiltersPlainObject : queryParams;

      Object.keys(methods.getValues()).forEach(value => {
        if (!Object.keys(filtersToApply).includes(value) && !isEmpty(value)) {
          methods.setValue(value, undefined);
        }
      });
      setMoreSectionFilters({});
      methods.reset(filtersToApply);
      resetSelectedRecords();
      dispatch(applyFilters({ recordType, data: compactFilters(filtersToApply) }));

      setRerender(false);
      setFilterToList(DEFAULT_FILTERS);
    }
  }, [rerender]);

  const tabs = [
    { name: i18n.t("saved_search.filters_tab"), selected: true },
    { name: i18n.t("saved_search.saved_searches_tab") }
  ];

  const handleSubmit = useCallback(data => {
    const payload = compactFilters(data);

    resetSelectedRecords();
    dispatch(applyFilters({ recordType, data: payload }));
  }, []);

  const handleSave = () => {
    setOpen(true);
  };

  const handleClear = useCallback(() => {
    resetSelectedRecords();
    methods.reset(defaultFiltersPlainObject);
    dispatch(setFilters({ recordType, data: defaultFiltersPlainObject }));

    dispatch(push({}));

    setMoreSectionFilters({});
    setReset(true);
    setMore(false);
    setFilterToList(DEFAULT_FILTERS);
  });

  const handleChangeTabs = (event, value) => setTabIndex(value);

  return (
    <div className={css.root}>
      <FormProvider {...methods} user={userName}>
        <form onSubmit={methods.handleSubmit(handleSubmit)}>
          <Search handleReset={handleClear} />
          <Tabs
            value={tabIndex}
            onChange={handleChangeTabs}
            TabIndicatorProps={{
              style: {
                backgroundColor: "transparent"
              }
            }}
            classes={{ root: css.tabs }}
            variant="fullWidth"
          >
            {tabs.map(({ name, selected, ...rest }) => (
              <Tab
                label={name}
                key={name}
                classes={{ root: css.tab, selected: css.tabselected }}
                selected={selected}
                {...rest}
              />
            ))}
          </Tabs>

          {tabIndex === 0 && (
            <>
              <Actions handleSave={handleSave} handleClear={handleClear} />
              {renderFilters()}
              <MoreSection
                addFilterToList={addFilterToList}
                allAvailable={filters}
                defaultFilters={allDefaultFilters}
                filterToList={filterToList}
                more={more}
                moreSectionFilters={moreSectionFilters}
                primaryFilters={allPrimaryFilters}
                recordType={recordType}
                setMore={setMore}
                setMoreSectionFilters={setMoreSectionFilters}
              />
            </>
          )}
          {tabIndex === 1 && (
            <SavedSearches recordType={recordType} setTabIndex={setTabIndex} setRerender={setRerender} />
          )}
        </form>
      </FormProvider>
      <SavedSearchesForm recordType={recordType} getValues={methods.getValues} open={open} setOpen={setOpen} />
    </div>
  );
};

Component.defaultProps = {
  defaultFilters: fromJS({})
};

Component.displayName = "IndexFilters";

Component.propTypes = {
  defaultFilters: PropTypes.object,
  recordType: PropTypes.string.isRequired,
  setSelectedRecords: PropTypes.func
};

export default Component;
