# Update an existing role

Merge the values submitted in this call into an existing role.

**URL** : `/api/v2/roles/:id`

**Method** : `PATCH`

**Authentication** : YES

**Authorization** : The user must be authorized to edit roles in Primero.

**Parameters** :

* `data` A JSON representation of the role fields that will be updated.

```json
{
  "data": {
    "unique_id": "role_test_01",
    "name": "CP Administrator 00",
    "description": "Administrator_description",
    "group_permission": "all",
    "referral": false,
    "module_unique_ids": [
      "primeromodule-cp",
      "primeromodule-gbv"
    ],
    "form_section_unique_ids": [
      "activities",
      "partner_details"
    ],
    "permissions": {
      "agency": [
        "read",
        "write"
      ],
      "role": [
        "read",
        "write"
      ],
      "objects": {
        "agency": [
          "role-cp-case-worker",
          "id_2"
        ],
        "role": [
          "role-cp-case-worker",
          "id_2"
        ]
      }
    }
  }
}
```

## Success Response

**Condition** : User can update roles.

**Code** : `200 OK`

**Content** : A JSON representation of the role that has been updated.

```json
{
  "data": {
    "unique_id": "role_test_01",
    "name": "CP Administrator 00",
    "description": "Administrator_description",
    "group_permission": "all",
    "referral": false,
    "transfer": false,
    "is_manager": true,
    "module_unique_ids": [
      "primeromodule-cp",
      "primeromodule-gbv"
    ],
    "form_section_unique_ids": [
      "activities",
      "partner_details"
    ],
    "permissions": {
      "agency": [
        "read",
        "write"
      ],
      "role": [
        "read",
        "write"
      ],
      "objects": {
        "agency": [
          "role-cp-case-worker",
          "id_2"
        ],
        "role": [
          "role-cp-case-worker",
          "id_2"
        ]
      }
    }
  }
}
```

## Error Response

**Condition** : User isn't authorized to update roles.

**Code** : `403 Forbidden`

**Content** :

```json
{
  "errors": [
    {
      "code": 403,
      "resource": "/api/v2/roles/100",
      "message": "Forbidden"
    }
  ]
}
```

---

**Condition** : A role with the provided id doesn't exist in the database.

**Code** : `404 Not Found`

**Content** :

```json
{
  "errors": [
    {
      "code": 404,
      "resource": "/api/v2/roles/thisdoesntexist",
      "message": "Not Found"
    }
  ]
}
```

---