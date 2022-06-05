import PropTypes from "prop-types";
import { Link } from "react-router-dom";
import { makeStyles } from "@material-ui/core";
import { Draggable } from "react-beautiful-dnd";
import findKey from "lodash/findKey";
import VpnKeyIcon from "@material-ui/icons/VpnKey";
import clsx from "clsx";

import { useI18n } from "../../../../../i18n";
import { MODULES, RECORD_PATH } from "../../../../../../config/constants";
import styles from "../../styles.css";
import DragIndicator from "../drag-indicator";

const useStyles = makeStyles(styles);

const Component = ({ name, modules, parentForm, uniqueID, id, index, editable, isDragDisabled }) => {
  const i18n = useI18n();
  const css = useStyles();
  const nameStyles = clsx({
    [css.formName]: true,
    [css.protected]: !editable
  });

  const formSectionModules = modules.map(module => findKey(MODULES, value => module === value))?.join(", ");

  const renderIcon = !editable ? <VpnKeyIcon className={css.rotateIcon} /> : null;

  return (
    <Draggable draggableId={uniqueID} index={index} isDragDisabled={isDragDisabled}>
      {provided => (
        <div ref={provided.innerRef} {...provided.draggableProps} className={css.row}>
          <div>
            <DragIndicator {...provided.dragHandleProps} isDragDisabled={isDragDisabled} />
          </div>
          <div className={nameStyles}>
            {renderIcon}
            <Link to={`${RECORD_PATH.forms}/${id}/edit`}>{name}</Link>
          </div>
          <div>{i18n.t(`forms.record_types.${parentForm}`)}</div>
          <div>{formSectionModules}</div>
        </div>
      )}
    </Draggable>
  );
};

Component.displayName = "TableRow";

Component.defaultProps = {
  isDragDisabled: false
};

Component.propTypes = {
  editable: PropTypes.bool.isRequired,
  id: PropTypes.number.isRequired,
  index: PropTypes.number.isRequired,
  isDragDisabled: PropTypes.bool,
  modules: PropTypes.array.isRequired,
  name: PropTypes.string.isRequired,
  parentForm: PropTypes.string.isRequired,
  uniqueID: PropTypes.string.isRequired
};

export default Component;
