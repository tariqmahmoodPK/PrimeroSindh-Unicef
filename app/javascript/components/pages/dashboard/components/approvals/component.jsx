import PropTypes from "prop-types";
import { Grid } from "@material-ui/core";

import Permission from "../../../../application/permission";
import { RESOURCES, ACTIONS, DASH_APPROVALS, DASH_APPROVALS_PENDING } from "../../../../../libs/permissions";
import { OptionsBox } from "../../../../dashboard";
import { DASHBOARD_TYPES } from "../../constants";
import { useI18n } from "../../../../i18n";
import { dashboardType, toApprovalsManager } from "../../utils";
import {
  getApprovalsAssessmentPending,
  getApprovalsClosurePending,
  getApprovalsCasePlanPending,
  getApprovalsActionPlanPending,
  getApprovalsGbvClosurePending,
  getApprovalsAssessment,
  getApprovalsCasePlan,
  getApprovalsClosure,
  getApprovalsActionPlan,
  getApprovalsGbvClosure
} from "../../selectors";
import { useApp } from "../../../../application";
import { useMemoizedSelector } from "../../../../../libs";

import { NAME } from "./constants";

const Component = ({ loadingIndicator }) => {
  const i18n = useI18n();
  const { approvalsLabels } = useApp();

  const approvalsAssessmentPending = useMemoizedSelector(state => getApprovalsAssessmentPending(state));
  const approvalsCasePlanPending = useMemoizedSelector(state => getApprovalsClosurePending(state));
  const approvalsClosurePending = useMemoizedSelector(state => getApprovalsCasePlanPending(state));
  const approvalsActionPlanPending = useMemoizedSelector(state => getApprovalsActionPlanPending(state));
  const approvalsGbvClosurePending = useMemoizedSelector(state => getApprovalsGbvClosurePending(state));
  const approvalsAssessment = useMemoizedSelector(state => getApprovalsAssessment(state));
  const approvalsCasePlan = useMemoizedSelector(state => getApprovalsCasePlan(state));
  const approvalsClosure = useMemoizedSelector(state => getApprovalsClosure(state));
  const approvalsActionPlan = useMemoizedSelector(state => getApprovalsActionPlan(state));
  const approvalsGbvClosure = useMemoizedSelector(state => getApprovalsGbvClosure(state));

  const pendingApprovalsItems = toApprovalsManager([
    approvalsAssessmentPending,
    approvalsCasePlanPending,
    approvalsClosurePending,
    approvalsActionPlanPending,
    approvalsGbvClosurePending
  ]);

  const approvalsDashHasData = Boolean(
    pendingApprovalsItems.get("indicators").size ||
      approvalsAssessment.size ||
      approvalsCasePlan.size ||
      approvalsClosure.size ||
      approvalsActionPlan.size ||
      approvalsGbvClosure.size
  );

  const dashboards = [
    {
      type: DASHBOARD_TYPES.OVERVIEW_BOX,
      actions: DASH_APPROVALS_PENDING,
      options: {
        items: pendingApprovalsItems,
        sumTitle: i18n.t("dashboard.pending_approvals"),
        withTotal: false
      }
    },
    {
      type: DASHBOARD_TYPES.OVERVIEW_BOX,
      actions: ACTIONS.DASH_APPROVALS_ASSESSMENT,
      options: {
        items: approvalsAssessment,
        sumTitle: approvalsLabels.get("assessment")
      }
    },
    {
      type: DASHBOARD_TYPES.OVERVIEW_BOX,
      actions: ACTIONS.DASH_APPROVALS_CASE_PLAN,
      options: {
        items: approvalsCasePlan,
        sumTitle: approvalsLabels.get("case_plan")
      }
    },
    {
      type: DASHBOARD_TYPES.OVERVIEW_BOX,
      actions: ACTIONS.DASH_APPROVALS_CLOSURE,
      options: {
        items: approvalsClosure,
        sumTitle: approvalsLabels.get("closure")
      }
    },
    {
      type: DASHBOARD_TYPES.OVERVIEW_BOX,
      actions: ACTIONS.DASH_APPROVALS_ACTION_PLAN,
      options: {
        items: approvalsActionPlan,
        sumTitle: approvalsLabels.get("action_plan")
      }
    },
    {
      type: DASHBOARD_TYPES.OVERVIEW_BOX,
      actions: ACTIONS.DASH_APPROVALS_GBV_CLOSURE,
      options: {
        items: approvalsGbvClosure,
        sumTitle: approvalsLabels.get("gbv_closure")
      }
    }
  ];

  const renderDashboards = () => {
    return dashboards.map(dashboard => {
      const { type, actions, options } = dashboard;
      const Dashboard = dashboardType(type);

      return (
        <Permission key={actions} resources={RESOURCES.dashboards} actions={actions}>
          <Grid item xs>
            <OptionsBox flat>
              <Dashboard {...options} />
            </OptionsBox>
          </Grid>
        </Permission>
      );
    });
  };

  return (
    <Permission resources={RESOURCES.dashboards} actions={DASH_APPROVALS}>
      <OptionsBox title={"Approvals for Case Closure"} hasData={approvalsDashHasData} {...loadingIndicator}>
        <Grid item md={12}>
          <Grid container>{renderDashboards()}</Grid>
        </Grid>
      </OptionsBox>
    </Permission>
  );
};

Component.displayName = NAME;

Component.propTypes = {
  loadingIndicator: PropTypes.object,
  userPermissions: PropTypes.object
};

export default Component;
