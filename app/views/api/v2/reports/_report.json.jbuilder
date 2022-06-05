# frozen_string_literal: true

fields = ReportFieldService.horizontal_fields(report) + ReportFieldService.vertical_fields(report)

report_hash = FieldI18nService.fill_keys(
  %i[name description],
  {
    id: report.id,
    name: report.name_i18n,
    description: report.description_i18n,
    graph: report.is_graph,
    graph_type: 'bar',
    x_axis: report.x_axis,
    y_axis: report.y_axis,
    exclude_empty_rows: report.exclude_empty_rows?,
    record_type: report.record_type,
    module_id: report.module_id,
    group_dates_by: report.group_dates_by,
    group_ages: report.group_ages,
    editable: report.editable,
    disabled: report.disabled,
    filters: report.filters,
    fields: fields.map { |f| FieldI18nService.fill_keys([:display_name], f) }
  }
)

json.merge!(report_hash)
json.merge!({ report_data: report.values_as_json_hash }) if report.values.present?
