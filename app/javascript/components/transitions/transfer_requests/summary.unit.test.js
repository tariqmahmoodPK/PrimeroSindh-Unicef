import { setupMountedComponent } from "../../../test";

import TransferRequestSummary from "./summary";

describe("<TransferRequestSummary />", () => {
  let component;
  const props = {
    transition: {
      id: "4142488e-ccd9-4ac5-a3c1-c3c0fd063fc8",
      record_id: "6b0018e7-d421-4d6b-80bf-ca4cbf488907",
      record_type: "case",
      created_at: "2019-10-21T16:13:33.890Z",
      notes: "This is a note",
      status: "done",
      type: "TransferRequest",
      consent_overridden: false,
      consent_individual_transfer: true,
      transitioned_by: "primero",
      transitioned_to: "primero_cp"
    },
    classes: {
      wrapper: "wrapperStyle",
      titleHeader: "titleHeaderStyle",
      date: "dateStyle"
    }
  };

  beforeEach(() => {
    ({ component } = setupMountedComponent(TransferRequestSummary, props));
  });

  it("renders divs with its corresponding class", () => {
    expect(component.find("div.wrapperStyle")).to.have.lengthOf(1);
    expect(component.find("div.titleHeaderStyle")).to.have.lengthOf(1);
    expect(component.find("div.dateStyle")).to.have.lengthOf(1);
  });
});
