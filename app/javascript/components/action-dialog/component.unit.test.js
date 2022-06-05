import { Dialog, DialogActions, DialogContent, DialogTitle, IconButton, Typography } from "@material-ui/core";
import Add from "@material-ui/icons/Add";
import CheckIcon from "@material-ui/icons/Check";

import { setupMountedComponent } from "../../test";
import ActionButton from "../action-button";

import ActionDialog from "./component";

describe("<ActionDialog />", () => {
  let component;
  const props = {
    cancelHandler: () => {},
    children: [],
    confirmButtonLabel: "",
    confirmButtonProps: {},
    dialogActions: <></>,
    dialogSubHeader: "Test SubHeader",
    dialogSubtitle: "Test Subtitle",
    dialogText: "",
    dialogTitle: "",
    disableActions: false,
    disableBackdropClick: false,
    maxSize: "sm",
    omitCloseAfterSuccess: false,
    onClose: () => {},
    open: true,
    pending: false,
    successHandler: () => {}
  };

  beforeEach(() => {
    ({ component } = setupMountedComponent(ActionDialog, props, {}));
  });

  it("should render Dialog", () => {
    expect(component.find(Dialog)).to.have.lengthOf(1);
  });

  it("should render DialogActions", () => {
    expect(component.find(DialogActions)).to.have.lengthOf(1);
  });

  it("should render DialogContent", () => {
    expect(component.find(DialogContent)).to.have.lengthOf(1);
  });

  it("should render DialogTitle", () => {
    expect(component.find(DialogTitle)).to.have.lengthOf(1);
  });

  it("should render IconButton", () => {
    expect(component.find(IconButton)).to.have.lengthOf(1);
  });

  it("should render ActionButton", () => {
    expect(component.find(ActionButton)).to.have.lengthOf(2);
  });

  it("should accept valid props", () => {
    const actionDialogProps = { ...component.find(ActionDialog).props() };

    expect(component.find(ActionDialog)).to.have.lengthOf(1);
    [
      "cancelButtonProps",
      "cancelHandler",
      "children",
      "confirmButtonLabel",
      "confirmButtonProps",
      "dialogActions",
      "dialogSubHeader",
      "dialogSubtitle",
      "dialogText",
      "dialogTitle",
      "disableActions",
      "disableBackdropClick",
      "enabledSuccessButton",
      "maxSize",
      "omitCloseAfterSuccess",
      "onClose",
      "open",
      "pending",
      "successHandler",
      "showSuccessButton",
      "fetchArgs",
      "disableClose",
      "hideIcon"
    ].forEach(property => {
      expect(actionDialogProps).to.have.property(property);
      delete actionDialogProps[property];
    });
    expect(actionDialogProps).to.be.empty;
  });

  it("should render DialogSubtitle with it's correct value ", () => {
    expect(component.find(DialogTitle).text()).to.be.equal("Test Subtitle");
  });

  it("should render dialogSubHeader with it's correct value ", () => {
    expect(component.find(Typography).last().text()).to.be.equal("Test SubHeader");
  });

  it("should not render DialogSubtitle because isn't passed in props ", () => {
    delete props.dialogSubtitle;
    const { component: componentWithoutSubtitle } = setupMountedComponent(ActionDialog, props, {});

    expect(componentWithoutSubtitle.find(DialogTitle).text()).to.be.empty;
  });

  it("should not render dialogSubHeader because isn't passed in props ", () => {
    delete props.dialogSubHeader;
    const { component: componentWithoutSubtitle } = setupMountedComponent(ActionDialog, props, {});

    expect(componentWithoutSubtitle.find(Typography)).to.be.empty;
  });

  it("should render the default icon for the confirm button", () => {
    expect(component.find(CheckIcon)).to.have.lengthOf(1);
  });

  it("should render the icon prop for the confirm button", () => {
    const propsWithConfirmButton = {
      ...props,
      confirmButtonProps: { icon: <Add /> }
    };

    const { component: componentWithDifferentIcon } = setupMountedComponent(ActionDialog, propsWithConfirmButton, {});

    expect(componentWithDifferentIcon.find(Add)).to.have.lengthOf(1);
  });
});
