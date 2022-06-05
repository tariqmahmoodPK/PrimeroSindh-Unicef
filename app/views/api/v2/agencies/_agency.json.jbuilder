# frozen_string_literal: true

json.id agency.id
json.unique_id agency.unique_id
json.agency_code agency.agency_code
json.order agency.order
json.name FieldI18nService.fill_with_locales(agency.name_i18n)
json.description FieldI18nService.fill_with_locales(agency.description_i18n || {})
json.telephone agency.telephone
json.services agency.services
json.logo_enabled agency.logo_enabled
json.pdf_logo_option agency.pdf_logo_option
json.logo_full rails_blob_path(agency.logo_full, only_path: true) if agency.logo_full.attached?
json.logo_icon rails_blob_path(agency.logo_icon, only_path: true) if agency.logo_icon.attached?
json.terms_of_use rails_blob_path(agency.terms_of_use, only_path: true) if agency.terms_of_use.attached?
json.terms_of_use_enabled agency.terms_of_use_enabled
json.disabled agency.disabled
