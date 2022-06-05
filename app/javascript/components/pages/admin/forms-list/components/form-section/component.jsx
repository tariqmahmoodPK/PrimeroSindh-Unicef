import PropTypes from "prop-types";
import { makeStyles } from "@material-ui/core";
import { Droppable } from "react-beautiful-dnd";
import clsx from "clsx";

import { useI18n } from "../../../../../i18n";
import styles from "../../styles.css";
import TableRow from "../table-row";
import { displayNameHelper } from "../../../../../../libs";

const useStyles = makeStyles(styles);

const Component = ({ group, collection, isDragDisabled }) => {
  const i18n = useI18n();
  const css = useStyles();
  const classes = clsx(css.row, css.header);

  return (
    <Droppable droppableId={`fs-${collection}`} type="formSection">
      {provided => (
        <div className={css.container} ref={provided.innerRef} {...provided.draggableProps}>
          <div className={classes}>
            <div />
            <div>{i18n.t("form_section.form_name")}</div>
            <div>{i18n.t("form_section.record_type")}</div>
            <div>{i18n.t("form_section.module")}</div>
          </div>
          {group
            .toList()
            .sortBy(form => form.order)
            .map((formSection, index) => {
              const {
                name,
                module_ids: modules,
                parent_form: parentForm,
                unique_id: uniqueID,
                editable,
                id
              } = formSection;

              return (
                <TableRow
                  name={displayNameHelper(name, i18n.locale)}
                  modules={modules}
                  parentForm={parentForm}
                  index={index}
                  uniqueID={uniqueID}
                  key={uniqueID}
                  editable={editable}
                  id={id}
                  isDragDisabled={isDragDisabled}
                />
              );
            })}
          {provided.placeholder}
        </div>
      )}
    </Droppable>
  );
};

Component.displayName = "FormSection";

Component.defaultProps = {
  isDragDisabled: false
};

Component.propTypes = {
  collection: PropTypes.string.isRequired,
  group: PropTypes.object.isRequired,
  isDragDisabled: PropTypes.bool
};

export default Component;
