import { fromJS } from "immutable";
import { NavLink } from "react-router-dom";

import { setupMountedComponent } from "../../test";
import { ROUTES, RECORD_PATH } from "../../config";
import TranslationsToggle from "../translations-toggle";
import AgencyLogo from "../agency-logo";
import ModuleLogo from "../module-logo";
import { ACTIONS } from "../../libs/permissions";
import Jewel from "../jewel";

import Nav from "./component";
import { FETCH_ALERTS } from "./actions";

describe("<Nav />", () => {
  let component;
  const ProvidedNav = () => <Nav />;
  const permissions = {
    cases: [ACTIONS.MANAGE],
    incidents: [ACTIONS.READ],
    dashboards: [ACTIONS.MANAGE, ACTIONS.DASH_TASKS],
    potential_matches: [ACTIONS.MANAGE],
    tracing_requests: [ACTIONS.READ],
    reports: [ACTIONS.MANAGE],
    metadata: [ACTIONS.MANAGE],
    users: [ACTIONS.MANAGE]
  };
  const initialState = fromJS({
    ui: { Nav: { drawerOpen: true } },
    application: {
      modules: {},
      online: true,
      agencies: [
        {
          unique_id: "agency_1",
          logo: { small: "/some/random.png" }
        }
      ]
    },
    user: {
      modules: [],
      agency: "agency_1",
      permissions
    }
  });

  beforeEach(() => {
    ({ component } = setupMountedComponent(ProvidedNav, { username: "joshua" }, initialState));
  });

  it("renders a module logo", () => {
    expect(component.find(ModuleLogo)).to.have.lengthOf(3);
  });

  it("renders an agency logo", () => {
    expect(component.find(AgencyLogo)).to.have.lengthOf(2);
  });

  it("renders translation toggle", () => {
    expect(component.find(TranslationsToggle)).to.have.lengthOf(2);
  });

  describe("nav links", () => {
    // TODO: These will change based on permissions
    it("renders home link", () => {
      expect(component.find(NavLink).findWhere(link => link.prop("to") === ROUTES.dashboard)).to.have.lengthOf(2);
    });

    it("renders tasks link", () => {
      expect(component.find(NavLink).findWhere(link => link.prop("to") === ROUTES.tasks)).to.have.lengthOf(2);
    });

    it("renders cases link", () => {
      expect(component.find(NavLink).findWhere(link => link.prop("to") === ROUTES.cases)).to.have.lengthOf(2);
    });

    it("renders incidents link", () => {
      expect(component.find(NavLink).findWhere(link => link.prop("to") === ROUTES.incidents)).to.have.lengthOf(2);
    });

    it("renders tracing requests link", () => {
      expect(component.find(NavLink).findWhere(link => link.prop("to") === ROUTES.tracing_requests)).to.have.lengthOf(
        2
      );
    });

    // TODO: Temporary removed
    // it("renders matches link", () => {
    //   expect(
    //     component
    //       .find(NavLink)
    //       .findWhere(link => link.prop("to") === ROUTES.matches)
    //   ).to.have.lengthOf(1);
    // });

    it("renders reports link", () => {
      expect(component.find(NavLink).findWhere(link => link.prop("to") === ROUTES.reports)).to.have.lengthOf(2);
    });

    it("renders exports link", () => {
      expect(component.find(NavLink).findWhere(link => link.prop("to") === ROUTES.exports)).to.have.lengthOf(2);
    });

    it("renders seetings link with alert", () => {
      const seetingsLink = component.find(NavLink).findWhere(link => link.prop("to") === ROUTES.admin_users);

      expect(seetingsLink).to.have.lengthOf(2);
      expect(seetingsLink.find(Jewel)).to.have.lengthOf(2);
    });
  });

  describe("when have restricted permission", () => {
    const restrictedPermissionInitialState = fromJS({
      ui: { Nav: { drawerOpen: true } },
      application: {
        modules: {},
        online: true,
        agencies: [
          {
            unique_id: "agency_1",
            logo: { small: "/some/random.png" }
          }
        ]
      },
      user: {
        modules: [],
        agency: "agency_1",
        permissions: {
          cases: [ACTIONS.READ]
        }
      }
    });

    beforeEach(() => {
      ({ component } = setupMountedComponent(ProvidedNav, { username: "username" }, restrictedPermissionInitialState));
    });

    it("renders cases link", () => {
      expect(component.find(NavLink).findWhere(link => link.prop("to") === ROUTES.cases)).to.have.lengthOf(2);
    });
    it("doesn't renders export link", () => {
      expect(component.find(NavLink).findWhere(link => link.prop("to") === ROUTES.exports)).to.have.lengthOf(0);
    });
  });

  describe("when component is rendered ", () => {
    const initialStateActions = fromJS({
      ui: {
        Nav: {
          drawerOpen: true,
          alerts: {
            data: {
              case: 2,
              incident: 0,
              tracing_request: 1
            }
          }
        }
      }
    });

    const expectedAction = {
      type: FETCH_ALERTS,
      api: {
        path: RECORD_PATH.alerts
      }
    };

    beforeEach(() => {
      ({ component } = setupMountedComponent(ProvidedNav, { username: "username" }, initialStateActions));
    });

    it("should fetch alerts", () => {
      const storeActions = component.props().store.getActions();

      expect(storeActions[0]).to.deep.equal(expectedAction);
    });
  });

  describe("when offline", () => {
    const userId = 1;
    const offlineInitialState = fromJS({
      ui: { Nav: { drawerOpen: true } },
      connectivity: {
        online: false,
        serverOnline: false
      },
      application: {
        modules: {},
        agencies: [
          {
            unique_id: "agency_1",
            logo: { small: "/some/random.png" }
          }
        ]
      },
      user: {
        id: userId,
        modules: [],
        agency: "agency_1",
        permissions: {
          cases: [ACTIONS.READ]
        }
      }
    });

    beforeEach(() => {
      ({ component } = setupMountedComponent(ProvidedNav, { username: "username" }, offlineInitialState));
    });

    it("renders a disabled my account link", () => {
      expect(
        component
          .find(NavLink)
          .findWhere(link => link.prop("to") === `${ROUTES.account}/${userId}` && link.prop("disabled"))
      ).to.have.lengthOf(2);
    });
  });
});
