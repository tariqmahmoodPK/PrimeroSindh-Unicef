# frozen_string_literal: true

module Indicators
  class Case
    OPEN_ENABLED = [
      SearchFilters::Value.new(field_name: 'record_state', value: true),
      SearchFilters::Value.new(field_name: 'status', value: Record::STATUS_OPEN)
    ].freeze

    CLOSED_ENABLED = [
      SearchFilters::Value.new(field_name: 'record_state', value: true),
      SearchFilters::Value.new(field_name: 'status', value: Record::STATUS_CLOSED)
    ].freeze

    OPEN_CLOSED_ENABLED = [
      SearchFilters::Value.new(field_name: 'record_state', value: true),
      SearchFilters::ValueList.new(field_name: 'status', values: [Record::STATUS_OPEN, Record::STATUS_CLOSED])
    ].freeze

    OPEN = QueriedIndicator.new(
      name: 'total',
      record_model: Child,
      queries: OPEN_ENABLED
    ).freeze

    # NEW = TODO: Cases that have just been assigned to me. Need extra work.

    UPDATED = QueriedIndicator.new(
      name: 'new_or_updated',
      record_model: Child,
      queries: OPEN_ENABLED + [
        SearchFilters::Value.new(field_name: 'not_edited_by_owner', value: true)
      ]
    ).freeze

    def self.closed_recently
      QueriedIndicator.new(
        name: 'closed_recently',
        record_model: Child,
        queries: [
          SearchFilters::Value.new(field_name: 'record_state', value: true),
          SearchFilters::Value.new(field_name: 'status', value: Record::STATUS_CLOSED),
          SearchFilters::DateRange.new(
            field_name: 'date_closure', from: QueriedIndicator.recent_past, to: QueriedIndicator.present
          )
        ],
        scope_to_owner: true
      )
    end

    WORKFLOW = FacetedIndicator.new(
      name: 'workflow',
      facet: 'workflow',
      record_model: Child,
      scope: OPEN_CLOSED_ENABLED,
      scope_to_owner: true
    ).freeze

    WORKFLOW_TEAM = PivotedIndicator.new(
      name: 'workflow_team',
      record_model: Child,
      pivots: %w[owned_by workflow],
      scope: OPEN_CLOSED_ENABLED
    ).freeze

    CASES_BY_SOCIAL_WORKER = [
      FacetedIndicator.new(
        name: 'cases_by_social_worker_total',
        record_model: Child,
        facet: 'owned_by',
        scope: OPEN_ENABLED
      ),
      FacetedIndicator.new(
        name: 'cases_by_social_worker_new_or_updated',
        record_model: Child,
        facet: 'owned_by',
        scope: OPEN_ENABLED + [
          SearchFilters::Value.new(field_name: 'not_edited_by_owner', value: true)
        ]
      )
    ]

    RISK = FacetedIndicator.new(
      name: 'risk_level',
      facet: 'risk_level',
      record_model: Child,
      scope: OPEN_ENABLED
    ).freeze

    APPROVALS_ASSESSMENT_PENDING = QueriedIndicator.new(
      name: 'approval_assessment_pending',
      record_model: Child,
      scope_to_owner: true,
      queries: OPEN_ENABLED + [
        SearchFilters::Value.new(field_name: 'approval_status_assessment', value: Approval::APPROVAL_STATUS_PENDING)
      ]
    ).freeze

    APPROVALS_ASSESSMENT_PENDING_GROUP = QueriedIndicator.new(
      name: 'approval_assessment_pending_group',
      record_model: Child,
      queries: OPEN_ENABLED + [
        SearchFilters::Value.new(field_name: 'approval_status_assessment', value: Approval::APPROVAL_STATUS_PENDING)
      ]
    ).freeze

    APPROVALS_ASSESSMENT_REJECTED = QueriedIndicator.new(
      name: 'approval_assessment_rejected',
      record_model: Child,
      scope_to_owner: true,
      queries: OPEN_ENABLED + [
        SearchFilters::Value.new(field_name: 'approval_status_assessment', value: Approval::APPROVAL_STATUS_REJECTED)
      ]
    ).freeze

    APPROVALS_ASSESSMENT_APPROVED = QueriedIndicator.new(
      name: 'approval_assessment_approved',
      record_model: Child,
      scope_to_owner: true,
      queries: OPEN_ENABLED + [
        SearchFilters::Value.new(field_name: 'approval_status_assessment', value: Approval::APPROVAL_STATUS_APPROVED)
      ]
    ).freeze

    APPROVALS_CASE_PLAN_PENDING = QueriedIndicator.new(
      name: 'approval_case_plan_pending',
      record_model: Child,
      scope_to_owner: true,
      queries: OPEN_ENABLED + [
        SearchFilters::Value.new(field_name: 'approval_status_case_plan', value: Approval::APPROVAL_STATUS_PENDING)
      ]
    ).freeze

    APPROVALS_CASE_PLAN_PENDING_GROUP = QueriedIndicator.new(
      name: 'approval_case_plan_pending_group',
      record_model: Child,
      queries: OPEN_ENABLED + [
        SearchFilters::Value.new(field_name: 'approval_status_case_plan', value: Approval::APPROVAL_STATUS_PENDING)
      ]
    ).freeze

    APPROVALS_CASE_PLAN_REJECTED = QueriedIndicator.new(
      name: 'approval_case_plan_rejected',
      record_model: Child,
      scope_to_owner: true,
      queries: OPEN_ENABLED + [
        SearchFilters::Value.new(field_name: 'approval_status_case_plan', value: Approval::APPROVAL_STATUS_REJECTED)
      ]
    ).freeze

    APPROVALS_CASE_PLAN_APPROVED = QueriedIndicator.new(
      name: 'approval_case_plan_approved',
      record_model: Child,
      scope_to_owner: true,
      queries: OPEN_ENABLED + [
        SearchFilters::Value.new(field_name: 'approval_status_case_plan', value: Approval::APPROVAL_STATUS_APPROVED)
      ]
    ).freeze

    APPROVALS_CLOSURE_PENDING = QueriedIndicator.new(
      name: 'approval_closure_pending',
      record_model: Child,
      scope_to_owner: true,
      queries: OPEN_ENABLED + [
        SearchFilters::Value.new(field_name: 'approval_status_closure', value: Approval::APPROVAL_STATUS_PENDING)
      ]
    ).freeze

    APPROVALS_CLOSURE_PENDING_GROUP = QueriedIndicator.new(
      name: 'approval_closure_pending_group',
      record_model: Child,
      queries: OPEN_ENABLED + [
        SearchFilters::Value.new(field_name: 'approval_status_closure', value: Approval::APPROVAL_STATUS_PENDING)
      ]
    ).freeze

    APPROVALS_CLOSURE_REJECTED = QueriedIndicator.new(
      name: 'approval_closure_rejected',
      record_model: Child,
      scope_to_owner: true,
      queries: OPEN_ENABLED + [
        SearchFilters::Value.new(field_name: 'approval_status_closure', value: Approval::APPROVAL_STATUS_REJECTED)
      ]
    ).freeze

    APPROVALS_CLOSURE_APPROVED = QueriedIndicator.new(
      name: 'approval_closure_approved',
      record_model: Child,
      scope_to_owner: true,
      queries: OPEN_ENABLED + [
        SearchFilters::Value.new(field_name: 'approval_status_closure', value: Approval::APPROVAL_STATUS_APPROVED)
      ]
    ).freeze

    APPROVALS_ACTION_PLAN_PENDING = QueriedIndicator.new(
      name: 'approval_action_plan_pending',
      record_model: Child,
      scope_to_owner: true,
      queries: OPEN_ENABLED + [
        SearchFilters::Value.new(field_name: 'approval_status_action_plan', value: Approval::APPROVAL_STATUS_PENDING)
      ]
    ).freeze

    APPROVALS_ACTION_PLAN_PENDING_GROUP = QueriedIndicator.new(
      name: 'approval_action_plan_pending_group',
      record_model: Child,
      queries: OPEN_ENABLED + [
        SearchFilters::Value.new(field_name: 'approval_status_action_plan', value: Approval::APPROVAL_STATUS_PENDING)
      ]
    ).freeze

    APPROVALS_ACTION_PLAN_REJECTED = QueriedIndicator.new(
      name: 'approval_action_plan_rejected',
      record_model: Child,
      scope_to_owner: true,
      queries: OPEN_ENABLED + [
        SearchFilters::Value.new(field_name: 'approval_status_action_plan', value: Approval::APPROVAL_STATUS_REJECTED)
      ]
    ).freeze

    APPROVALS_ACTION_PLAN_APPROVED = QueriedIndicator.new(
      name: 'approval_action_plan_approved',
      record_model: Child,
      scope_to_owner: true,
      queries: OPEN_ENABLED + [
        SearchFilters::Value.new(field_name: 'approval_status_action_plan', value: Approval::APPROVAL_STATUS_APPROVED)
      ]
    ).freeze

    APPROVALS_GBV_CLOSURE_PENDING = QueriedIndicator.new(
      name: 'approval_gbv_closure_pending',
      record_model: Child,
      scope_to_owner: true,
      queries: OPEN_ENABLED + [
        SearchFilters::Value.new(field_name: 'approval_status_gbv_closure', value: Approval::APPROVAL_STATUS_PENDING)
      ]
    ).freeze

    APPROVALS_GBV_CLOSURE_PENDING_GROUP = QueriedIndicator.new(
      name: 'approval_gbv_closure_pending_group',
      record_model: Child,
      queries: OPEN_ENABLED + [
        SearchFilters::Value.new(field_name: 'approval_status_gbv_closure', value: Approval::APPROVAL_STATUS_PENDING)
      ]
    ).freeze

    APPROVALS_GBV_CLOSURE_REJECTED = QueriedIndicator.new(
      name: 'approval_gbv_closure_rejected',
      record_model: Child,
      scope_to_owner: true,
      queries: OPEN_ENABLED + [
        SearchFilters::Value.new(field_name: 'approval_status_gbv_closure', value: Approval::APPROVAL_STATUS_REJECTED)
      ]
    ).freeze

    APPROVALS_GBV_CLOSURE_APPROVED = QueriedIndicator.new(
      name: 'approval_gbv_closure_approved',
      record_model: Child,
      scope_to_owner: true,
      queries: OPEN_ENABLED + [
        SearchFilters::Value.new(field_name: 'approval_status_gbv_closure', value: Approval::APPROVAL_STATUS_APPROVED)
      ]
    ).freeze

    def self.tasks_overdue_assessment
      FacetedIndicator.new(
        name: 'tasks_overdue_assessment',
        facet: 'owned_by',
        record_model: Child,
        scope: OPEN_ENABLED + [
          SearchFilters::DateRange.new(
            field_name: 'assessment_due_dates', from: FacetedIndicator.dawn_of_time, to: FacetedIndicator.present
          )
        ]
      )
    end

    def self.tasks_overdue_case_plan
      FacetedIndicator.new(
        name: 'tasks_overdue_case_plan',
        facet: 'owned_by',
        record_model: Child,
        scope: OPEN_ENABLED + [
          SearchFilters::DateRange.new(
            field_name: 'case_plan_due_dates', from: FacetedIndicator.dawn_of_time, to: FacetedIndicator.present
          )
        ]
      )
    end

    def self.tasks_overdue_services
      FacetedIndicator.new(
        name: 'tasks_overdue_services',
        facet: 'owned_by',
        record_model: Child,
        scope: OPEN_ENABLED + [
          SearchFilters::DateRange.new(
            field_name: 'service_due_dates', from: FacetedIndicator.dawn_of_time, to: FacetedIndicator.present
          )
        ]
      )
    end

    def self.tasks_overdue_followups
      FacetedIndicator.new(
        name: 'tasks_overdue_followups',
        facet: 'owned_by',
        record_model: Child,
        scope: OPEN_ENABLED + [
          SearchFilters::DateRange.new(
            field_name: 'followup_due_dates', from: FacetedIndicator.dawn_of_time, to: FacetedIndicator.present
          )
        ]
      )
    end

    PROTECTION_CONCERNS_OPEN_CASES = FacetedIndicator.new(
      name: 'protection_concerns_open_cases',
      facet: 'protection_concerns',
      record_model: Child,
      scope: OPEN_ENABLED
    ).freeze

    def self.protection_concerns_new_this_week
      FacetedIndicator.new(
        name: 'protection_concerns_new_this_week',
        facet: 'protection_concerns',
        record_model: Child,
        scope: OPEN_ENABLED + [
          SearchFilters::DateRange.new({ field_name: 'created_at' }.merge(FacetedIndicator.this_week))
        ]
      )
    end

    PROTECTION_CONCERNS_ALL_CASES = FacetedIndicator.new(
      name: 'protection_concerns_all_cases',
      facet: 'protection_concerns',
      record_model: Child,
      scope: [SearchFilters::Value.new(field_name: 'record_state', value: true)]
    ).freeze

    def self.protection_concerns_closed_this_week
      FacetedIndicator.new(
        name: 'protection_concerns_closed_this_week',
        facet: 'protection_concerns',
        record_model: Child,
        scope: [
          SearchFilters::Value.new(field_name: 'record_state', value: true),
          SearchFilters::Value.new(field_name: 'status', value: Record::STATUS_CLOSED),
          SearchFilters::DateRange.new({ field_name: 'date_closure' }.merge(FacetedIndicator.this_week))
        ]
      )
    end

    SHARED_WITH_OTHERS_REFERRALS = QueriedIndicator.new(
      name: 'shared_with_others_referrals',
      record_model: Child,
      queries: OPEN_ENABLED + [
        SearchFilters::Value.new(field_name: 'referred_users_present', value: true)
      ],
      scope_to_owner: true
    ).freeze

    SHARED_WITH_OTHERS_PENDING_TRANSFERS = QueriedIndicator.new(
      name: 'shared_with_others_pending_transfers',
      record_model: Child,
      scope_to_owner: true,
      queries: OPEN_ENABLED + [
        SearchFilters::Value.new(field_name: 'transfer_status', value: Transition::STATUS_INPROGRESS)
      ]
    ).freeze

    SHARED_WITH_OTHERS_REJECTED_TRANSFERS = QueriedIndicator.new(
      name: 'shared_with_others_rejected_transfers',
      record_model: Child,
      scope_to_owner: true,
      queries: OPEN_ENABLED + [
        SearchFilters::Value.new(field_name: 'transfer_status', value: Transition::STATUS_REJECTED)
      ]
    ).freeze

    SHARED_WITH_ME_TOTAL_REFERRALS = QueriedIndicator.new(
      name: 'shared_with_me_total_referrals',
      record_model: Child,
      queries: OPEN_ENABLED,
      scope_to_referred: true
    ).freeze

    SHARED_WITH_ME_NEW_REFERRALS = QueriedIndicator.new(
      name: 'shared_with_me_new_referrals',
      record_model: Child,
      queries: OPEN_ENABLED,
      scope_to_referred: true,
      scope_to_not_last_update: true
    ).freeze

    SHARED_WITH_ME_TRANSFERS_AWAITING_ACCEPTANCE = QueriedIndicator.new(
      name: 'shared_with_me_transfers_awaiting_acceptance',
      record_model: Child,
      queries: OPEN_ENABLED,
      scope_to_transferred: true
    ).freeze

    GROUP_OVERVIEW_OPEN = QueriedIndicator.new(
      name: 'group_overview_open',
      record_model: Child,
      queries: OPEN_ENABLED
    ).freeze

    GROUP_OVERVIEW_CLOSED = QueriedIndicator.new(
      name: 'group_overview_closed',
      record_model: Child,
      queries: CLOSED_ENABLED
    ).freeze

    SHARED_FROM_MY_TEAM_REFERRALS = FacetedIndicator.new(
      name: 'shared_from_my_team_referrals',
      facet: 'owned_by',
      include_zeros: false,
      record_model: Child,
      scope: OPEN_ENABLED + [
        SearchFilters::Value.new(field_name: 'referred_users_present', value: true)
      ],
      scope_to_owned_by_groups: true
    ).freeze

    SHARED_FROM_MY_TEAM_PENDING_TRANSFERS = FacetedIndicator.new(
      name: 'shared_from_my_team_pending_transfers',
      facet: 'owned_by',
      include_zeros: false,
      record_model: Child,
      scope: OPEN_ENABLED + [
        SearchFilters::Value.new(field_name: 'transfer_status', value: Transition::STATUS_INPROGRESS)
      ],
      scope_to_owned_by_groups: true
    ).freeze

    SHARED_FROM_MY_TEAM_REJECTED_TRANSFERS = FacetedIndicator.new(
      name: 'shared_from_my_team_rejected_transfers',
      facet: 'owned_by',
      include_zeros: false,
      record_model: Child,
      scope: OPEN_ENABLED + [
        SearchFilters::Value.new(field_name: 'transfer_status', value: Transition::STATUS_REJECTED)
      ],
      scope_to_owned_by_groups: true
    ).freeze

    SHARED_WITH_MY_TEAM_REFERRALS = FacetedIndicator.new(
      name: 'shared_with_my_team_referrals',
      record_model: Child,
      facet: 'referred_users',
      queries: OPEN_ENABLED + [
        SearchFilters::Value.new(field_name: 'referred_users_present', value: true)
      ]
    ).freeze

    SHARED_WITH_MY_TEAM_PENDING_TRANSFERS = FacetedIndicator.new(
      name: 'shared_with_my_team_pending_transfers',
      record_model: Child,
      facet: 'transferred_to_users',
      queries: OPEN_ENABLED + [
        SearchFilters::Value.new(field_name: 'transfer_status', value: Transition::STATUS_INPROGRESS)
      ]
    ).freeze

    WITH_INCIDENTS = QueriedIndicator.new(
      name: 'with_incidents',
      record_model: Child,
      queries: OPEN_ENABLED + [
        SearchFilters::Value.new(field_name: 'has_incidents', value: true)
      ]
    ).freeze

    WITH_NEW_INCIDENTS = QueriedIndicator.new(
      name: 'with_new_incidents',
      record_model: Child,
      scope_to_owner: true,
      queries: OPEN_ENABLED + [
        SearchFilters::Value.new(field_name: 'current_alert_types', value: Alertable::INCIDENT_FROM_CASE)
      ]
    ).freeze

    WITHOUT_INCIDENTS = QueriedIndicator.new(
      name: 'without_incidents',
      record_model: Child,
      queries: OPEN_ENABLED + [
        SearchFilters::Value.new(field_name: 'has_incidents', value: false)
      ]
    ).freeze

    NATIONAL_ADMIN_SUMMARY_OPEN = QueriedIndicator.new(
      name: 'open',
      record_model: Child,
      queries: OPEN_ENABLED
    ).freeze

    def self.reporting_location_indicators(role)
      reporting_location_config = role&.reporting_location_config ||
                                  SystemSettings.current.reporting_location_config
      admin_level = reporting_location_config&.admin_level || ReportingLocation::DEFAULT_ADMIN_LEVEL
      field_key = reporting_location_config&.field_key || ReportingLocation::DEFAULT_FIELD_KEY
      facet_name = "#{field_key}#{admin_level}"

      [
        FacetedIndicator.new(
          name: 'reporting_location_open',
          facet: facet_name,
          record_model: Child,
          scope: OPEN_ENABLED
        ),
        FacetedIndicator.new(
          name: 'reporting_location_open_last_week',
          facet: facet_name,
          record_model: Child,
          scope: OPEN_ENABLED + [
            SearchFilters::DateRange.new({ field_name: 'created_at' }.merge(FacetedIndicator.last_week))
          ]
        ),
        FacetedIndicator.new(
          name: 'reporting_location_open_this_week',
          facet: facet_name,
          record_model: Child,
          scope: OPEN_ENABLED + [
            SearchFilters::DateRange.new({ field_name: 'created_at' }.merge(FacetedIndicator.this_week))
          ]
        ),
        FacetedIndicator.new(
          name: 'reporting_location_closed_last_week',
          facet: facet_name,
          record_model: Child,
          scope: CLOSED_ENABLED + [
            SearchFilters::DateRange.new({ field_name: 'created_at' }.merge(FacetedIndicator.last_week))
          ]
        ),
        FacetedIndicator.new(
          name: 'reporting_location_closed_this_week',
          facet: facet_name,
          record_model: Child,
          scope: CLOSED_ENABLED + [
            SearchFilters::DateRange.new({ field_name: 'created_at' }.merge(FacetedIndicator.this_week))
          ]
        )
      ]
    end

    def self.cases_to_assign
      # TODO: Candidate for caching.
      risk_levels = (Lookup.find_by(unique_id: 'lookup-risk-level')&.lookup_values || []).map { |value| value['id'] }
      risk_level_indicators(risk_levels) + overdue_risk_level_indicators(risk_levels)
    end

    def self.risk_level_indicators(risk_levels)
      [QueriedIndicator.new(
        name: 'cases_none',
        include_zeros: true,
        scope_to_owner: true,
        record_model: Child,
        queries: OPEN_ENABLED + [
          SearchFilters::NotValue.new(field_name: 'risk_level', values: risk_levels)
        ]
      )] + risk_levels.map { |risk_level| risk_level_indicator(risk_level) }
    end

    def self.overdue_risk_level_indicators(risk_levels)
      [QueriedIndicator.new(
        name: 'overdue_cases_none',
        include_zeros: true,
        scope_to_owner: true,
        record_model: Child,
        queries: overdue_none_risk_level_queries(risk_levels)
      )] + risk_levels.map { |risk_level| overdue_risk_level_indicator(risk_level) }
    end

    def self.risk_level_indicator(risk_level)
      QueriedIndicator.new(
        name: "cases_#{risk_level}",
        include_zeros: true,
        scope_to_owner: true,
        record_model: Child,
        queries: OPEN_ENABLED + [
          SearchFilters::Value.new(field_name: 'risk_level', value: risk_level)
        ]
      )
    end

    def self.overdue_risk_level_indicator(risk_level)
      QueriedIndicator.new(
        name: "overdue_cases_#{risk_level}",
        include_zeros: true,
        scope_to_owner: true,
        record_model: Child,
        queries: overdue_risk_level_queries(risk_level)
      )
    end

    def self.overdue_none_risk_level_queries(risk_levels)
      OPEN_ENABLED + [
        SearchFilters::NotValue.new(field_name: 'risk_level', values: risk_levels),
        SearchFilters::DateRange.new(
          field_name: 'reassigned_transferred_on',
          from: Time.at(0),
          to: Time.now - SystemSettings.current.timeframe_hours_to_assign.hour
        )
      ]
    end

    def self.overdue_risk_level_queries(risk_level)
      timeframe = SystemSettings.current.timeframe_hours_to_assign.hour
      timeframe = SystemSettings.current.timeframe_hours_to_assign_high.hour if risk_level == 'high'

      OPEN_ENABLED + [
        SearchFilters::DateRange.new(
          field_name: 'reassigned_transferred_on',
          from: Time.at(0),
          to: Time.now - timeframe
        ),
        SearchFilters::Value.new(field_name: 'risk_level', value: risk_level)
      ]
    end

    def self.new_this_week
      QueriedIndicator.new(
        name: 'new_this_week',
        record_model: Child,
        queries: OPEN_ENABLED + [
          SearchFilters::DateRange.new({ field_name: 'created_at' }.merge(QueriedIndicator.this_week))
        ]
      )
    end

    def self.new_last_week
      QueriedIndicator.new(
        name: 'new_last_week',
        record_model: Child,
        queries: OPEN_ENABLED + [
          SearchFilters::DateRange.new({ field_name: 'created_at' }.merge(QueriedIndicator.last_week))
        ]
      )
    end

    def self.closed_this_week
      QueriedIndicator.new(
        name: 'closed_this_week',
        record_model: Child,
        queries: CLOSED_ENABLED + [
          SearchFilters::DateRange.new({ field_name: 'created_at' }.merge(QueriedIndicator.this_week))
        ].freeze
      )
    end

    def self.closed_last_week
      QueriedIndicator.new(
        name: 'closed_last_week',
        record_model: Child,
        queries: CLOSED_ENABLED + [
          SearchFilters::DateRange.new({ field_name: 'created_at' }.merge(QueriedIndicator.last_week))
        ].freeze
      )
    end
  end
end
