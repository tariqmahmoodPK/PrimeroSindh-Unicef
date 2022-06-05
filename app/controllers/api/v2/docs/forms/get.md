# Query for forms

Shows a list of all forms that are accessible to this user. The user can filter the form list by record type and module.

**URL** : `/api/v2/forms`

**Method** : `GET`

**Authentication** : YES

**Authorization** :The user must be authorized to view forms in Primero.

**Parameters** : 

* `record_type` Optional. Filters by the record type of the form.
* `module_id` Optional. Filter forms by module.

## Success Response

**Condition** : User can see one or more forms. 

**Code** : `200 OK`

**Content** :

```json
{
  "data": [
    {
           "id": 20,
           "unique_id": "cp_individual_details",
           "name": {
               "en": "CP Individual Details"
           },
           "description": {
               "en": "CP Individual Details"
           },
           "parent_form": "incident",
           "visible": true,
           "order": 15,
           "order_form_group": 30,
           "order_subform": 0,
           "form_group_id": "cp_individual_details",
           "editable": true,
           "initial_subforms": 0,
           "form_group_name": {
             "en": "Identification / Registration"
           },
           "fields": [
               {
                   "id": 153,
                   "name": "age",
                   "type": "numeric_field",
                   "form_section_id": 20,
                   "visible": true,
                   "mobile_visible": true,
                   "show_on_minify_form": true,
                   "editable": true,
                   "display_name": {
                       "en": "Age"
                   },
                   "order": 0,
                   "link_to_path_external": true,
                   "date_validation": "default_date_validation",
                   "matchable": true
               }
            ]
    }
  ]
}
```
## Error Response

**Condition** : User isn't authorized to query for forms. 

**Code** : `403 Forbidden`

**Content** :

```json
{
  "errors": [
    {
      "code": 403,
      "resource": "/api/v2/forms",
      "message": "Forbidden"
    }
  ]
}
```
