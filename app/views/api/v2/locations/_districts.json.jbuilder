json.merge!(
  id: location.id,
  code: location.location_code,
  type: location.type,
  admin_level: location.admin_level,
  name: location.placename_i18n
)
