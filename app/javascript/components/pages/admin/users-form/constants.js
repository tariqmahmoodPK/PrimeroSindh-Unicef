export const USER_CONFIRMATION_DIALOG = "userConfirmationDialog";
export const IDENTITY_PROVIDER_ID = "identity_provider_unique_id";
export const USER_GROUP_UNIQUE_IDS = "user_group_unique_ids";
export const USERGROUP_PRIMERO_GBV = "usergroup-primero-gbv";
export const ROLE_OPTIONS = [
  { id: "role-cp-administrator", display_text: "CP Administrator" },
  { id: "role-cp-case-worker", display_text: "CP Case Worker" },
  { id: "role-cp-manager", display_text: "CP Manager" },
  { id: "role-cp-user-manager", display_text: "CP User Manager" },
  { id: "role-gbv-social-worker", display_text: "GBV Social Worker" },
  { id: "role-gbv-manager", display_text: "GBV Manager" },
  { id: "role-gbv-user-manager", display_text: "GBV User Manager" },
  { id: "role-gbv-caseworker", display_text: "GBV Caseworker" },
  {
    id: "role-gbv-mobile-caseworker",
    display_text: "GBV Mobile Caseworker"
  },
  {
    id: "role-gbv-case-management-supervisor",
    display_text: "GBV Case Management Supervisor"
  },
  {
    id: "role-gbv-program-manager",
    display_text: "GBV Program Manager"
  },
  {
    id: "role-gbv-organization-focal-point",
    display_text: "GBV Organization Focal Point"
  },
  {
    id: "role-agency-user-administrator",
    display_text: "Agency User Administrator"
  },
  {
    id: "role-gbv-agency-user-administrator",
    display_text: "GBV Agency User Administrator"
  },
  {
    id: "role-gbv-system-administrator",
    display_text: "GBV System Administrator"
  },
  { id: "role-referral", display_text: "Referral" },
  { id: "role-transfer", display_text: "Transfer" },
  { id: "role-ftr-manager", display_text: "FTR Manager" },
  { id: "role-superuser", display_text: "Superuser" }
];

export const GENDER_OPTIONS = [
  { id: 'male', display_text: 'Male' },
  { id: 'female', display_text: 'Female' },
  { id: 'transgender', display_text: 'Transgender' }
];

export const PASSWORD_MODAL = "passwordModal";
export const PASSWORD_SELF_OPTION = "self";
export const PASSWORD_USER_OPTION = "user";
export const FORM_ID = "user-form";
export const FIELD_NAMES = Object.freeze({
  FULL_NAME: "full_name",
  USER_NAME: "user_name",
  CODE: "code",
  PASSWORD_SETTING: "password_setting",
  PASSWORD: "password",
  PASSWORD_CONFIRMATION: "password_confirmation",
  CHANGE_PASSWORD: "change_password",
  LOCALE: "locale",
  ROLE_UNIQUE_ID: "role_unique_id",
  USER_GROUP_UNIQUE_IDS: "user_group_unique_ids",
  SERVICES: "services",
  PHONE: "phone",
  EMAIL: "email",
  AGENCY_ID: "agency_id",
  AGENCY_OFFICE: "agency_office",
  POSITION: "position",
  LOCATION: "location",
  DISABLED: "disabled",
  SEND_MAIL: "send_mail",
  GENDER: "gender"
});
