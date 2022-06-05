import { useEffect } from "react";
import { connect } from "react-redux";
import PropTypes from "prop-types";
import MUIDataTable from "mui-datatables";
import { Card, CardContent } from "@material-ui/core";
import makeStyles from "@material-ui/core/styles/makeStyles";

import { useI18n } from "../../i18n";
import PageContainer, { PageHeading, PageContent } from "../../page";

import styles from "./styles.css";
import { fetchPotentialMatches } from "./action-creators";
import { selectPotentialMatches } from "./selectors";

const useStyles = makeStyles(styles);

const PotentialMatches = ({ getPotentialMatches, potentialMatches }) => {
  useEffect(() => {
    getPotentialMatches();
  }, []);

  const css = useStyles();
  const i18n = useI18n();

  const columns = [
    i18n.t("potential_match.inquirer_id"),
    i18n.t("potential_match.name"),
    i18n.t("potential_match.inquiry_date"),
    i18n.t("potential_match.inquirer_tr_name")
  ];
  const options = {
    responsive: "vertical",
    fixedHeader: false,
    elevation: 0,
    filter: false,
    download: false,
    search: false,
    print: false,
    viewColumns: false,
    serverSide: true,
    pagination: false,
    selectableRows: "none"
  };

  const tracingRequestTableOptions = {
    columns,
    options,
    data: [
      [
        potentialMatches.get("tracingRequestId"),
        potentialMatches.get("relationName"),
        potentialMatches.get("inquiryDate"),
        ""
      ]
    ]
  };

  const matchesTableOptions = {
    columns: [
      { label: i18n.t("potential_match.child_id"), name: "caseId", id: true },
      { label: i18n.t("potential_match.child_age"), name: "age" },
      { label: i18n.t("potential_match.child_gender"), name: "sex" },
      { label: i18n.t("potential_match.social_worker"), name: "user" },
      { label: i18n.t("potential_match.social_worker_agency"), name: "agency" },
      { label: i18n.t("potential_match.score"), name: "score" },
      ""
    ],
    options,
    data: potentialMatches.get("matches") ? potentialMatches.get("matches").toJS() : []
  };

  return (
    <PageContainer>
      <PageHeading title="Matches" />
      <PageContent>
        <Card>
          <CardContent>
            <h4>
              {i18n.t("potential_matches.display", {
                type: i18n.t("forms.record_types.tracing_request"),
                id: potentialMatches.get("tracingRequestId")
              })}
            </h4>
            <div className={css.firstTable}>
              <MUIDataTable {...tracingRequestTableOptions} />
            </div>
            <div className={css.lastTable}>
              <MUIDataTable {...matchesTableOptions} />
            </div>
          </CardContent>
        </Card>
      </PageContent>
    </PageContainer>
  );
};

PotentialMatches.displayName = "PotentialMatches";

PotentialMatches.propTypes = {
  getPotentialMatches: PropTypes.func.isRequired,
  potentialMatches: PropTypes.object.isRequired
};

const mapStateToProps = state => {
  return {
    potentialMatches: selectPotentialMatches(state)
  };
};

const mapDispatchToProps = {
  getPotentialMatches: fetchPotentialMatches
};

export default connect(mapStateToProps, mapDispatchToProps)(PotentialMatches);
