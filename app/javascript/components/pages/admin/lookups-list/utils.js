/* eslint-disable
import/prefer-default-export, react/display-name, jsx-a11y/click-events-have-key-events, react/no-multi-comp */

export const columns = (i18n, css) => [
  {
    label: "id",
    name: "id",
    options: {
      display: false
    }
  },
  {
    label: i18n.t("lookup.name"),
    name: "name",
    options: {
      customBodyRender: (value, tableMeta) => (
        <div role="button" tabIndex={tableMeta.rowIndex} className={css.lookupName}>
          {value}
        </div>
      )
    }
  },
  {
    label: i18n.t("lookup.values"),
    name: "values",
    options: {
      sort: false,
      customBodyRender: (value, tableMeta) => {
        return (
          <div role="button" tabIndex={tableMeta.rowIndex} className={css.truncateValues}>
            <div>{value}</div>
          </div>
        );
      }
    }
  }
];
