# Update an existing lookup

Merge the values submitted in this call into an existing lookup.
If a nested values has a true value for a key '_delete', then the value will be deleted from the server.

**URL** : `/api/v2/lookups/:id`

**Method** : `PATCH`

**Authentication** : YES

**Authorization** : The user must be authorized to edit lookups in Primero.

**Parameters** :

* `data` A JSON representation of the lookup fields that will be updated.

```json
{
  "data": {
    "unique_id": "lookup-nationality",
    "name": {
      "en": "Nationality"
    },
    "values": [
      {
        "id": "nationality1",
        "display_text": {
          "en": "Nationality",
          "fr": "",
          "es": ""
        },
        "_delete": true
      },
      {
        "id": "nationality3",
        "display_text": {
          "en": "Nationality3",
          "fr": "",
          "es": ""
        }
      },
      {
        "id": "nationality2",
        "display_text": {
          "en": "Nationality2",
          "fr": "",
          "es": ""
        }
      }
    ]
  }
}
```

## Success Response

**Condition** : User can update lookups.

**Code** : `200 OK`

**Content** : A JSON representation of the lookup that has been updated.

```json
{
  "data": {
    "id": 10,
    "unique_id": "lookup-nationality",
    "name": {
     "en": "Nationality"
    },
    "values": {
      "en": [
        {
          "id": "nationality3",
          "display_text": "Nationality3"
        },
        {
          "id": "nationality2",
          "display_text": "Nationality2"
        }
      ]
    }
  }
}
```

## Error Response

**Condition** : User isn't authorized to update lookups.

**Code** : `403 Forbidden`

**Content** :

```json
{
  "errors": [
    {
      "code": 403,
      "resource": "/api/v2/lookups/100",
      "message": "Forbidden"
    }
  ]
}
```

---

**Condition** : A lookup with the provided id doesn't exist in the database.

**Code** : `404 Not Found`

**Content** :

```json
{
  "errors": [
    {
      "code": 404,
      "resource": "/api/v2/lookups/200",
      "message": "Not Found"
    }
  ]
}
```

---

**Condition** : The parameters would create an invalid lookup.

**Code** : `422 Unprocessable Entity`

**Content** :

```json
{
  "errors": [
    {
      "code": 422,
      "resource": "/api/v2/lookups",
      "message": "Name must not be blank",
      "detail": "name"
    }
  ]
}
```