import { useState } from "react";
import { useDispatch } from "react-redux";
import PropTypes from "prop-types";
import { FormLabel, TextField } from "@material-ui/core";

import { useI18n } from "../../../i18n";
import ActionDialog from "../../../action-dialog";
import { ACCEPTED, REJECTED, ACCEPT, REJECT } from "../../../../config";
import { selectRecord } from "../../../records";
import { useMemoizedSelector } from "../../../../libs";

import { approvalTransfer } from "./action-creators";
import { NAME } from "./constants";

const Component = ({
  openTransferDialog,
  close,
  approvalType,
  dialogName,
  recordId,
  recordType,
  pending,
  setPending,
  transferId
}) => {
  const i18n = useI18n();
  const dispatch = useDispatch();
  const [comment, setComment] = useState("");

  const record = useMemoizedSelector(state => selectRecord(state, { isEditOrShow: true, recordType, id: recordId }));

  const handleChangeComment = event => {
    setComment(event.target.value);
  };

  const handleCancel = event => {
    if (event) {
      event.stopPropagation();
    }

    close();
    setComment("");
  };

  const stopProp = event => {
    event.stopPropagation();
  };

  const actionBody = {
    data: {
      status: approvalType
    }
  };

  if (approvalType === REJECTED) {
    actionBody.data.rejected_reason = comment;
  }

  const message =
    approvalType === ACCEPTED
      ? i18n.t(`${recordType}.transfer_accepted_success`)
      : i18n.t(`${recordType}.transfer_accepted_rejected`, {
          record_id: record.get("case_id_display")
        });

  const handleOk = () => {
    setPending(true);

    dispatch(
      approvalTransfer({
        body: actionBody,
        dialogName,
        message,
        failureMessage: i18n.t(`${recordType}.request_approval_failure`),
        recordId,
        recordType,
        transferId
      })
    );
  };

  const successButtonProps = {
    color: "primary",
    variant: "contained",
    autoFocus: true
  };

  const commentField =
    approvalType === REJECTED ? (
      <>
        <FormLabel component="legend">{i18n.t(`${recordType}.transfer_reject_reason_label`)}</FormLabel>
        <TextField label="" multiline rows="4" defaultValue="" fullWidth onChange={handleChangeComment} />
      </>
    ) : null;

  const dialogContent = (
    // eslint-disable-next-line jsx-a11y/no-noninteractive-element-interactions,jsx-a11y/click-events-have-key-events
    <form noValidate autoComplete="off" onClick={stopProp}>
      <p>{i18n.t(`${recordType}.transfer_${approvalType}`)}</p>
      {commentField}
    </form>
  );

  const buttonLabel = approvalType === ACCEPTED ? ACCEPT : REJECT;

  return (
    <ActionDialog
      open={openTransferDialog}
      successHandler={handleOk}
      cancelHandler={handleCancel}
      dialogTitle=""
      pending={pending}
      omitCloseAfterSuccess
      confirmButtonLabel={i18n.t(`buttons.${buttonLabel}`)}
      confirmButtonProps={successButtonProps}
      onClose={close}
    >
      {dialogContent}
    </ActionDialog>
  );
};

Component.displayName = NAME;

Component.defaultProps = {
  openTransferDialog: false
};

Component.propTypes = {
  approvalType: PropTypes.string,
  close: PropTypes.func,
  dialogName: PropTypes.string,
  openTransferDialog: PropTypes.bool,
  pending: PropTypes.bool,
  recordId: PropTypes.string,
  recordType: PropTypes.string,
  setPending: PropTypes.func,
  transferId: PropTypes.string
};

export default Component;
