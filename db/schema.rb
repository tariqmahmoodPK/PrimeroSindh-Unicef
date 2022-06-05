# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_12_10_110557) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "ltree"
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "agencies", id: :serial, force: :cascade do |t|
    t.string "unique_id"
    t.string "agency_code", null: false
    t.integer "order", default: 0
    t.jsonb "name_i18n"
    t.jsonb "description_i18n"
    t.string "telephone"
    t.string "services", default: [], array: true
    t.boolean "logo_enabled", default: false, null: false
    t.boolean "disabled", default: false, null: false
    t.boolean "pdf_logo_option", default: false, null: false
    t.boolean "exclude_agency_from_lookups", default: false, null: false
    t.boolean "terms_of_use_enabled", default: false, null: false
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.index ["agency_code"], name: "index_agencies_on_agency_code", unique: true
    t.index ["services"], name: "index_agencies_on_services", using: :gin
    t.index ["unique_id"], name: "index_agencies_on_unique_id", unique: true
  end

  create_table "alerts", id: :serial, force: :cascade do |t|
    t.string "type"
    t.text "alert_for"
    t.date "date"
    t.string "form_sidebar_id"
    t.string "unique_id"
    t.integer "user_id"
    t.integer "agency_id"
    t.string "record_type"
    t.uuid "record_id"
    t.index ["agency_id"], name: "index_alerts_on_agency_id"
    t.index ["record_type", "record_id"], name: "index_alerts_on_record_type_and_record_id"
    t.index ["user_id"], name: "index_alerts_on_user_id"
  end

  create_table "attachments", force: :cascade do |t|
    t.string "attachment_type"
    t.string "record_type"
    t.uuid "record_id"
    t.string "field_name"
    t.string "description"
    t.date "date"
    t.string "comments"
    t.boolean "is_current", default: false, null: false
    t.jsonb "metadata"
    t.string "type_of_document"
    t.index ["field_name"], name: "index_attachments_on_field_name"
    t.index ["record_type", "record_id"], name: "index_attachments_on_record_type_and_record_id"
  end

  create_table "audit_logs", id: :serial, force: :cascade do |t|
    t.string "record_type"
    t.string "record_id"
    t.integer "user_id"
    t.string "action"
    t.string "resource_url"
    t.datetime "timestamp"
    t.jsonb "metadata"
    t.index ["metadata"], name: "index_audit_logs_on_metadata", using: :gin
    t.index ["record_type", "record_id"], name: "index_audit_logs_on_record_type_and_record_id"
    t.index ["user_id"], name: "index_audit_logs_on_user_id"
  end

  create_table "bulk_exports", id: :serial, force: :cascade do |t|
    t.string "status"
    t.string "owned_by"
    t.datetime "started_on"
    t.datetime "completed_on"
    t.string "format"
    t.string "record_type"
    t.string "model_range"
    t.jsonb "filters"
    t.jsonb "order"
    t.string "query"
    t.string "match_criteria"
    t.jsonb "custom_export_params"
    t.string "file_name"
    t.string "password_ciphertext"
    t.string "type"
  end

  create_table "cases", id: :uuid, default: -> { "public.gen_random_uuid()" }, force: :cascade do |t|
    t.jsonb "data", default: {}
    t.uuid "matched_tracing_request_id"
    t.string "matched_trace_id"
    t.uuid "duplicate_case_id"
    t.index ["data"], name: "index_cases_on_data", using: :gin
  end

  create_table "codes_of_conduct", force: :cascade do |t|
    t.datetime "created_on"
    t.string "created_by"
    t.string "title"
    t.text "content"
  end

  create_table "contact_informations", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "organization"
    t.string "phone"
    t.string "location"
    t.text "other_information"
    t.string "support_forum"
    t.string "email"
    t.string "position"
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
  end

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer "priority", default: 0, null: false
    t.integer "attempts", default: 0, null: false
    t.text "handler", null: false
    t.text "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string "locked_by"
    t.string "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["priority", "run_at"], name: "delayed_jobs_priority"
  end

  create_table "export_configurations", id: :serial, force: :cascade do |t|
    t.string "unique_id"
    t.string "export_id"
    t.jsonb "name_i18n"
    t.string "property_keys", default: [], array: true
    t.string "record_type", default: "Child"
    t.string "opt_out_field"
    t.string "property_keys_opt_out", default: [], array: true
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.index ["unique_id"], name: "index_export_configurations_on_unique_id", unique: true
  end

  create_table "fields", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "type"
    t.boolean "multi_select", default: false, null: false
    t.integer "form_section_id"
    t.boolean "visible", default: true, null: false
    t.boolean "mobile_visible", default: true, null: false
    t.boolean "hide_on_view_page", default: false, null: false
    t.boolean "show_on_minify_form", default: false, null: false
    t.boolean "editable", default: true, null: false
    t.boolean "disabled", default: false, null: false
    t.jsonb "display_name_i18n"
    t.jsonb "help_text_i18n"
    t.jsonb "guiding_questions_i18n"
    t.jsonb "tally_i18n"
    t.jsonb "tick_box_label_i18n"
    t.jsonb "option_strings_text_i18n"
    t.string "option_strings_source"
    t.integer "order"
    t.boolean "hidden_text_field", default: false, null: false
    t.integer "subform_section_id"
    t.integer "collapsed_field_for_subform_section_id"
    t.boolean "autosum_total", default: false, null: false
    t.string "autosum_group"
    t.string "selected_value"
    t.text "link_to_path"
    t.boolean "link_to_path_external", default: true, null: false
    t.string "field_tags", default: [], array: true
    t.string "custom_template"
    t.boolean "expose_unique_id", default: false, null: false
    t.boolean "required", default: false, null: false
    t.string "date_validation", default: "default_date_validation"
    t.boolean "date_include_time", default: false, null: false
    t.boolean "matchable", default: false, null: false
    t.jsonb "subform_section_configuration"
    t.boolean "mandatory_for_completion", default: false, null: false
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.index ["form_section_id"], name: "index_fields_on_form_section_id"
    t.index ["name"], name: "index_fields_on_name"
    t.index ["type"], name: "index_fields_on_type"
  end

  create_table "flags", id: :serial, force: :cascade do |t|
    t.string "record_id"
    t.string "record_type"
    t.date "date"
    t.text "message"
    t.string "flagged_by"
    t.boolean "removed", default: false, null: false
    t.text "unflag_message"
    t.datetime "created_at"
    t.boolean "system_generated_followup", default: false, null: false
    t.string "unflagged_by"
    t.date "unflagged_date"
    t.uuid "record_uuid"
    t.index ["record_type", "record_id"], name: "index_flags_on_record_type_and_record_id"
  end

  create_table "form_sections", id: :serial, force: :cascade do |t|
    t.string "unique_id"
    t.jsonb "name_i18n"
    t.jsonb "help_text_i18n"
    t.jsonb "description_i18n"
    t.string "parent_form"
    t.boolean "visible", default: true, null: false
    t.integer "order"
    t.integer "order_form_group"
    t.integer "order_subform"
    t.boolean "form_group_keyed", default: false, null: false
    t.string "form_group_id"
    t.boolean "editable", default: true, null: false
    t.boolean "core_form", default: false, null: false
    t.boolean "is_nested", default: false, null: false
    t.boolean "is_first_tab", default: false, null: false
    t.integer "initial_subforms"
    t.boolean "subform_prevent_item_removal", default: false, null: false
    t.boolean "subform_append_only", default: false, null: false
    t.string "subform_header_links", default: [], array: true
    t.boolean "display_help_text_view", default: false, null: false
    t.string "shared_subform"
    t.string "shared_subform_group"
    t.boolean "is_summary_section", default: false, null: false
    t.boolean "hide_subform_placeholder", default: false, null: false
    t.boolean "mobile_form", default: false, null: false
    t.text "header_message_link"
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.index ["unique_id"], name: "index_form_sections_on_unique_id", unique: true
  end

  create_table "form_sections_primero_modules", id: false, force: :cascade do |t|
    t.integer "primero_module_id"
    t.integer "form_section_id"
  end

  create_table "form_sections_roles", force: :cascade do |t|
    t.integer "role_id"
    t.integer "form_section_id"
    t.string "permission", default: "rw"
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.index ["id"], name: "index_form_sections_roles_on_id", unique: true
    t.index ["role_id", "form_section_id"], name: "index_form_sections_roles_on_role_id_and_form_section_id", unique: true
  end

  create_table "identity_providers", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "unique_id"
    t.string "provider_type"
    t.jsonb "configuration"
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.index ["configuration"], name: "index_identity_providers_on_configuration", using: :gin
    t.index ["unique_id"], name: "index_identity_providers_on_unique_id", unique: true
  end

  create_table "incidents", id: :uuid, default: -> { "public.gen_random_uuid()" }, force: :cascade do |t|
    t.jsonb "data", default: {}
    t.uuid "incident_case_id"
    t.index ["data"], name: "index_incidents_on_data", using: :gin
    t.index ["incident_case_id"], name: "index_incidents_on_incident_case_id"
  end

  create_table "locations", id: :serial, force: :cascade do |t|
    t.jsonb "name_i18n"
    t.jsonb "placename_i18n"
    t.string "location_code", null: false
    t.integer "admin_level"
    t.string "type"
    t.boolean "disabled", default: false, null: false
    t.ltree "hierarchy_path", default: "", null: false
    t.index ["hierarchy_path"], name: "index_locations_on_hierarchy_path", using: :gist
    t.index ["location_code"], name: "index_locations_on_location_code", unique: true
  end

  create_table "lookups", id: :serial, force: :cascade do |t|
    t.string "unique_id"
    t.jsonb "name_i18n"
    t.jsonb "lookup_values_i18n"
    t.boolean "locked", default: false, null: false
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.index ["unique_id"], name: "index_lookups_on_unique_id", unique: true
  end

  create_table "primero_configurations", id: :uuid, default: -> { "public.gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.string "version"
    t.string "created_by"
    t.datetime "created_on"
    t.string "applied_by"
    t.datetime "applied_on"
    t.jsonb "data", default: {}
    t.string "primero_version"
  end

  create_table "primero_modules", id: :serial, force: :cascade do |t|
    t.string "unique_id"
    t.integer "primero_program_id"
    t.jsonb "name", default: {}
    t.jsonb "description", default: {}
    t.string "associated_record_types", array: true
    t.boolean "core_resource", default: true
    t.jsonb "field_map"
    t.jsonb "module_options"
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.index ["primero_program_id"], name: "index_primero_modules_on_primero_program_id"
    t.index ["unique_id"], name: "index_primero_modules_on_unique_id", unique: true
  end

  create_table "primero_modules_roles", id: false, force: :cascade do |t|
    t.integer "role_id"
    t.integer "primero_module_id"
    t.index ["role_id", "primero_module_id"], name: "index_primero_modules_roles_on_role_id_and_primero_module_id", unique: true
  end

  create_table "primero_modules_saved_searches", id: :serial, force: :cascade do |t|
    t.integer "primero_module_id"
    t.integer "saved_search_id"
    t.index ["primero_module_id"], name: "index_primero_modules_saved_searches_on_primero_module_id"
    t.index ["saved_search_id"], name: "index_primero_modules_saved_searches_on_saved_search_id"
  end

  create_table "primero_programs", id: :serial, force: :cascade do |t|
    t.string "unique_id"
    t.jsonb "name_i18n"
    t.jsonb "description_i18n"
    t.date "start_date"
    t.date "end_date"
    t.boolean "core_resource", default: false, null: false
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
  end

  create_table "record_histories", id: :serial, force: :cascade do |t|
    t.string "record_id"
    t.string "record_type"
    t.datetime "datetime"
    t.string "user_name"
    t.string "action"
    t.jsonb "record_changes", default: {}
    t.index ["record_type", "record_id"], name: "index_record_histories_on_record_type_and_record_id"
  end

  create_table "reports", id: :serial, force: :cascade do |t|
    t.jsonb "name_i18n"
    t.jsonb "description_i18n"
    t.string "module_id"
    t.string "record_type"
    t.string "aggregate_by", default: [], array: true
    t.string "disaggregate_by", default: [], array: true
    t.string "aggregate_counts_from"
    t.jsonb "filters", default: [], array: true
    t.boolean "group_ages", default: false, null: false
    t.string "group_dates_by", default: "date"
    t.boolean "is_graph", default: false, null: false
    t.boolean "editable", default: true
    t.string "unique_id"
    t.boolean "disabled", default: false, null: false
    t.boolean "exclude_empty_rows", default: false, null: false
    t.string "x_axis"
    t.string "y_axis"
    t.index ["unique_id"], name: "index_reports_on_unique_id", unique: true
  end

  create_table "roles", id: :serial, force: :cascade do |t|
    t.string "unique_id"
    t.string "name"
    t.string "description"
    t.jsonb "permissions"
    t.string "group_permission", default: "self"
    t.boolean "referral", default: false, null: false
    t.boolean "transfer", default: false, null: false
    t.boolean "is_manager", default: false, null: false
    t.integer "reporting_location_level"
    t.boolean "disabled", default: false, null: false
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.index ["permissions"], name: "index_roles_on_permissions", using: :gin
    t.index ["unique_id"], name: "index_roles_on_unique_id", unique: true
  end

  create_table "saved_searches", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "record_type"
    t.integer "user_id"
    t.jsonb "filters"
    t.index ["user_id"], name: "index_saved_searches_on_user_id"
  end

  create_table "system_settings", id: :serial, force: :cascade do |t|
    t.string "default_locale", default: "en"
    t.string "locales", default: ["en"], array: true
    t.string "base_language", default: "en"
    t.string "case_code_format", default: [], array: true
    t.string "case_code_separator"
    t.jsonb "auto_populate_list", default: [], array: true
    t.jsonb "unhcr_needs_codes_mapping"
    t.jsonb "reporting_location_config"
    t.jsonb "age_ranges"
    t.jsonb "welcome_email_text_i18n"
    t.string "primary_age_range"
    t.string "location_limit_for_api"
    t.jsonb "approval_forms_to_alert"
    t.jsonb "changes_field_to_form"
    t.jsonb "export_config_id"
    t.string "duplicate_export_field"
    t.string "primero_version"
    t.jsonb "system_options"
    t.jsonb "approvals_labels_i18n"
    t.boolean "config_update_lock", default: false, null: false
    t.string "configuration_file_version"
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
  end

  create_table "traces", id: :uuid, default: -> { "public.gen_random_uuid()" }, force: :cascade do |t|
    t.jsonb "data", default: {}
    t.uuid "tracing_request_id"
    t.uuid "matched_case_id"
    t.index ["data"], name: "index_traces_on_data", using: :gin
    t.index ["matched_case_id"], name: "index_traces_on_matched_case_id"
    t.index ["tracing_request_id"], name: "index_traces_on_tracing_request_id"
  end

  create_table "tracing_requests", id: :uuid, default: -> { "public.gen_random_uuid()" }, force: :cascade do |t|
    t.jsonb "data", default: {}
    t.index ["data"], name: "index_tracing_requests_on_data", using: :gin
  end

  create_table "transitions", id: :uuid, default: -> { "public.gen_random_uuid()" }, force: :cascade do |t|
    t.string "type"
    t.string "status"
    t.string "record_id"
    t.string "record_type"
    t.string "transitioned_to"
    t.string "transitioned_to_remote"
    t.string "transitioned_to_agency"
    t.string "rejected_reason"
    t.text "notes"
    t.string "transitioned_by"
    t.string "service"
    t.string "service_record_id"
    t.boolean "remote", default: false, null: false
    t.string "type_of_export"
    t.boolean "consent_overridden", default: false, null: false
    t.boolean "consent_individual_transfer", default: false, null: false
    t.datetime "created_at"
    t.datetime "responded_at"
    t.text "rejection_note"
    t.index ["id", "type"], name: "index_transitions_on_id_and_type"
    t.index ["record_type", "record_id"], name: "index_transitions_on_record_type_and_record_id"
  end

  create_table "user_groups", id: :serial, force: :cascade do |t|
    t.string "unique_id"
    t.string "name"
    t.string "description"
    t.boolean "core_resource", default: false, null: false
    t.boolean "disabled", default: false, null: false
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.index ["unique_id"], name: "index_user_groups_on_unique_id", unique: true
  end

  create_table "user_groups_users", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.integer "user_group_id"
    t.index ["user_group_id"], name: "index_user_groups_users_on_user_group_id"
    t.index ["user_id"], name: "index_user_groups_users_on_user_id"
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "full_name"
    t.string "user_name"
    t.string "encrypted_password", default: "", null: false
    t.string "code"
    t.string "phone"
    t.string "email"
    t.integer "agency_id"
    t.string "position"
    t.string "location"
    t.string "reporting_location_code"
    t.integer "role_id"
    t.string "time_zone", default: "UTC"
    t.string "locale"
    t.boolean "send_mail", default: true
    t.boolean "disabled", default: false
    t.string "services", array: true
    t.string "agency_office"
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "identity_provider_id"
    t.jsonb "identity_provider_sync"
    t.integer "failed_attempts", default: 0
    t.string "unlock_token"
    t.datetime "locked_at"
    t.boolean "service_account", default: false, null: false
    t.datetime "code_of_conduct_accepted_on"
    t.bigint "code_of_conduct_id"
    t.integer "gender"
    t.index ["agency_id"], name: "index_users_on_agency_id"
    t.index ["code_of_conduct_id"], name: "index_users_on_code_of_conduct_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["identity_provider_id"], name: "index_users_on_identity_provider_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["role_id"], name: "index_users_on_role_id"
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
    t.index ["user_name"], name: "index_users_on_user_name", unique: true
  end

  create_table "webhooks", id: :uuid, default: -> { "public.gen_random_uuid()" }, force: :cascade do |t|
    t.jsonb "events", default: []
    t.string "url"
    t.string "auth_type"
    t.string "auth_secret_encrypted"
    t.string "role_unique_id"
    t.jsonb "metadata", default: {}
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.index ["events"], name: "index_webhooks_on_events", using: :gin
    t.index ["url"], name: "index_webhooks_on_url", unique: true
  end

  create_table "whitelisted_jwts", force: :cascade do |t|
    t.string "jti", null: false
    t.string "aud"
    t.datetime "exp", null: false
    t.bigint "user_id", null: false
    t.index ["jti"], name: "index_whitelisted_jwts_on_jti", unique: true
    t.index ["user_id"], name: "index_whitelisted_jwts_on_user_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "cases", "tracing_requests", column: "matched_tracing_request_id"
  add_foreign_key "fields", "form_sections", column: "subform_section_id"
  add_foreign_key "users", "codes_of_conduct", column: "code_of_conduct_id"
  add_foreign_key "whitelisted_jwts", "users", on_delete: :cascade
end
