# List all transfers for this record
 
**URL** : `/api/v2/cases/:recordId/transfers`

**Method** : `GET`

**Authentication** : YES

**Authorization** : The user must be authorized to view this record.

**Parameters** : No parameters 

## Success Response

**Condition** : The user is authorized to view this record. 

**Code** : `200 OK`

**Content** :

```json
{
    "data": [
        {
            "id": "8165ff68-e406-4258-bb77-004b1f148290",
            "type": "Transfer",
            "status": "inprogress",
            "record_id": "437189fc-cd1c-46ee-8d56-2891fc736050",
            "record_type": "Child",
            "transitioned_to": "primero_cp",
            "transitioned_by": "primero",
            "created_at": "2019-09-16T18:37:16.078Z"
        }
    ]
}
```
## Error Response

**Condition** : User isn't authorized to view this record.

**Code** : `403 Forbidden`

**Content** :

```json
{
  "errors": [
    {
      "code": 403,
      "resource": "/api/v2/cases/749e9c6e-60db-45ec-8f5a-69da7c223a79/transfers",
      "message": "Forbidden"
    }
  ]
}
```