/* eslint-disable react/jsx-no-target-blank */
/* eslint-disable global-require */
import { useEffect } from "react";
import { useDispatch } from "react-redux";
import { Grid } from "@material-ui/core";
import { useI18n } from "../../i18n";
import PageContainer, { PageHeading, PageContent } from "../../page";
import { getPermissions } from "../../user/selectors";
import { getLoading, getErrors } from "../../index-table";
import { OfflineAlert } from "../../disable-offline";
import usePermissions, { ACTIONS, RESOURCES } from "../../permissions";
import { RECORD_PATH } from "../../../config";
import { useMemoizedSelector } from "../../../libs";
import { getCaseStatuses } from "./selectors"

import {
  Overview,
  SharedFromMyTeam,
  SharedWithMyTeam,
  WorkflowIndividualCases,
  Approvals,
  OverdueTasks,
  WorkflowTeamCases,
  ReportingLocation,
  ProtectionConcern,
  Flags,
  CasesBySocialWorker,
  CasesToAssign,
  ServicesPercentage,
  RegResCases,
  MonthlyRegResCases,
  HarmCases,
  DemographicsAnalysis,
  RegResCasesDept,
  RegResCasesAge,
  RegResCasesGender,
  CaseStatuses,
  StaffByGender,
  SocialServiceWorkforce,
  GraphOne,
  GraphTwo,
  GraphThree,
  GraphFour,
  GraphFive,
  GraphSix,
  GraphSeven,
  GraphEight,
  GraphNine,
  GraphTen,
  GraphEleven,
  GraphTwelve,
  GraphThirteen,
  GraphFourteen,
  GraphFifteen,
  GraphSixteen,
  GraphSeventeen,
  GraphEighteen,
  GraphNineteen,
  GraphTwenty,
  GraphTwentyOne,
  GraphTwentyTwo,
  GraphTwentyThree,
  GraphTwentyFour,
} from "./components";
import NAMESPACE from "./namespace";
import { NAME } from "./constants";
import { fetchDashboards, fetchFlags } from "./action-creators";
import Serv from "./direc.pdf";

const Dashboard = () => {
  const i18n = useI18n();
  const dispatch = useDispatch();
  const canFetchFlags = usePermissions(RESOURCES.dashboards, [ACTIONS.DASH_FLAGS]);

  useEffect(() => {
    dispatch(fetchDashboards());

    if (canFetchFlags) {
      dispatch(fetchFlags(RECORD_PATH.cases, true));
    }
  }, []);

  const userPermissions = useMemoizedSelector(state => getPermissions(state));
  const getRole = useMemoizedSelector(state => getCaseStatuses(state));
  let userRole = getRole.getIn(["data", "stats"]) ? getRole.getIn(["data", "stats"]).toJS() : null;
  const loading = useMemoizedSelector(state => getLoading(state, NAMESPACE));
  const errors = useMemoizedSelector(state => getErrors(state, NAMESPACE));
  const loadingFlags = useMemoizedSelector(state => getLoading(state, [NAMESPACE, "flags"]));
  const flagsErrors = useMemoizedSelector(state => getErrors(state, [NAMESPACE, "flags"]));
  let role;

  if (userRole) {
    role = userRole.Role;
  }

  const indicatorProps = {
    overlay: true,
    type: NAMESPACE,
    loading,
    errors
  };

  const flagsIndicators = {
    overlay: true,
    type: NAMESPACE,
    loading: loadingFlags,
    errors: flagsErrors
  };

  return (
    <PageContainer>
      <Grid container style={{ alignItems: 'center' }} item xl={12} md={12} xs={12}>
        <Grid item xl={6} md={6} xs={12}>
          <PageHeading title={i18n.t("navigation.home")} />
        </Grid>
        <Grid item xl={6} md={6} xs={12} style={{ textAlign: 'right' }}>
          <a
            style={{ fontSize: 20, fontWeight: 600, textAlign: 'right' }}
            href="/ICT-Resources.zip"
            download
          // target="_blank"
          >
            Resources
          </a>
        </Grid>
      </Grid>
      <PageContent>
        <OfflineAlert text={i18n.t("messages.dashboard_offline")} />
        <Grid container spacing={3}>
          <Grid item xl={12} md={12} xs={12}>
            <WorkflowIndividualCases loadingIndicator={indicatorProps} />
            <ServicesPercentage />
          </Grid>
          <GraphTwentyTwo />
          <MonthlyRegResCases />
          <RegResCases />
          <HarmCases />
          <GraphOne />
          <GraphFour />
          <GraphTwentyFour />
          <RegResCasesGender />
          <GraphTwentyThree />
          <RegResCasesDept />
          {role === "Referral" ? <GraphEleven /> : null}
          <RegResCasesAge />
          <StaffByGender />
          <SocialServiceWorkforce />
          {/* <GraphFive /> */}
          <GraphSix />
          {/* <GraphSeven />
            <GraphEight /> */}
          <GraphNine />
          <GraphTen />
          {role !== "Referral" ? <GraphEleven /> : null}
          {/* <GraphTwelve /> */}
          <GraphThirteen />
          {/* <GraphFourteen /> */}
          {/* <GraphFifteen /> */}
          <GraphSixteen />
          {/* <GraphSeventeen />
            <GraphEighteen />
            <GraphNineteen />
            <GraphTwenty /> */}

          {/* <GraphTwo />
          <GraphThree /> */}
          <GraphTwentyOne />
          <Grid item xl={12} md={12} xs={12}>
            {/* <DemographicsAnalysis /> */}
            {/* <CaseStatuses /> */}
            <CasesToAssign loadingIndicator={indicatorProps} />
            <Approvals loadingIndicator={indicatorProps} />
            <SharedFromMyTeam loadingIndicator={indicatorProps} />
            <SharedWithMyTeam loadingIndicator={indicatorProps} />
            <OverdueTasks loadingIndicator={indicatorProps} />
            <CasesBySocialWorker loadingIndicator={indicatorProps} />
            <WorkflowTeamCases loadingIndicator={indicatorProps} />
            <ReportingLocation loadingIndicator={indicatorProps} />
            <ProtectionConcern loadingIndicator={indicatorProps} />
          </Grid>
          {/* <Grid item xl={3} md={4} xs={12}>
            <Flags loadingIndicator={flagsIndicators} />
          </Grid> */}
        </Grid>
      </PageContent>
    </PageContainer>
  );
};

Dashboard.displayName = NAME;

export default Dashboard;
