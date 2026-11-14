# Portfolio 4 — NoSQL and Advanced Data Models

I used MongoDB collection delivery_snapshots for delivery_recorded and delivery_corrected events. These are fictional event examples based on delivery, purchase_order, sme, supplier.

## Document model

| Field | Meaning |
| --- | --- |
| _id | Unique string event ID |
| eventType | One of the two selected case event labels |
| occurredAt | Native BSON Date; sample timestamps are in 2030 |
| source | Original entity, primary key and saved JSON snapshot |
| embedded | Linked record snapshots read with the event |
| references | Keys for linked sources kept outside the embedded snapshots |
| details | Event metadata whose fields vary |

Related purchase_order, sme, supplier details are stored as snapshots with the event. This makes an event readable in one document. It duplicates some information, and later SQL changes do not automatically update the snapshots. PostgreSQL continues to enforce the relational rules.

## Example document

```javascript
{
    "_id": "event_000001",
    "schemaVersion": 1,
    "simulation": true,
    "eventType": "delivery_recorded",
    "occurredAt": ISODate("2030-01-01T10:00:00Z"),
    "source": {
        "entity": "delivery",
        "key": {
            "delivery_id": 5
        },
        "snapshot": {
            "delivery_id": 5,
            "order_id": 3,
            "item_id": 4,
            "delivery_ref": "DLV-2025-001",
            "delivered_qty": 125.5,
            "delivered_at": "2025-03-14T09:30:00+12:00",
            "delivery_notes": null
        }
    },
    "embedded": {
        "purchase_order": [
            {
                "key": {
                    "order_id": 3
                },
                "snapshot": {
                    "order_id": 3,
                    "sme_id": 1,
                    "supplier_id": 2,
                    "ordered_on": "2025-03-10",
                    "order_status": "open"
                },
                "via": [
                    "delivery.order_id → purchase_order"
                ]
            }
        ],
        "sme": [
            {
                "key": {
                    "sme_id": 1
                },
                "snapshot": {
                    "sme_id": 1,
                    "sme_name": "Northfield Foods",
                    "registered_on": "2024-02-12"
                },
                "via": [
                    "delivery.order_id → purchase_order.sme_id → sme"
                ]
            }
        ],
        "supplier": [
            {
                "key": {
                    "supplier_id": 2
                },
                "snapshot": {
                    "supplier_id": 2,
                    "supplier_name": "Harbor Grain Supply",
                    "country_code": "NZ"
                },
                "via": [
                    "delivery.order_id → purchase_order.supplier_id → supplier"
                ]
            }
        ]
    },
    "references": {},
    "details": {
        "channel": "web"
    }
}
```

## Queries and results

| Query | Returned documents |
| --- | --- |
| Find the first sample event type (up to five documents). | 1 |
| Find events for the first source record using nested key fields (up to five). | 2 |
| Find events in the sample time range using a MongoDB Date filter (up to five). | 2 |
| Count documents for each event type. | 2 |

## 1. Find the first sample event type (up to five documents).

```javascript
db.getCollection("delivery_snapshots").find({"eventType":"delivery_recorded"}).sort({_id:1}).limit(5).toArray();
```

Selected fields from the returned documents:

```json
[
  {
    "_id": "event_000001",
    "eventType": "delivery_recorded",
    "occurredAt": {
      "$date": "2030-01-01T10:00:00Z"
    },
    "source": {
      "delivery_id": 5
    }
  }
]
```

## 2. Find events for the first source record using nested key fields (up to five).

```javascript
db.getCollection("delivery_snapshots").find({"source.key.delivery_id":5}).sort({_id:1}).limit(5).toArray();
```

Selected fields from the returned documents:

```json
[
  {
    "_id": "event_000001",
    "eventType": "delivery_recorded",
    "occurredAt": {
      "$date": "2030-01-01T10:00:00Z"
    },
    "source": {
      "delivery_id": 5
    }
  },
  {
    "_id": "event_000002",
    "eventType": "delivery_corrected",
    "occurredAt": {
      "$date": "2030-01-01T10:01:00Z"
    },
    "source": {
      "delivery_id": 5
    }
  }
]
```

## 3. Find events in the sample time range using a MongoDB Date filter (up to five).

```javascript
db.getCollection("delivery_snapshots").find({"occurredAt":{"$gte":ISODate("2030-01-01T10:00:00Z"), "$lt":ISODate("2030-01-01T11:00:00Z")}}).sort({_id:1}).limit(5).toArray();
```

Selected fields from the returned documents:

```json
[
  {
    "_id": "event_000001",
    "eventType": "delivery_recorded",
    "occurredAt": {
      "$date": "2030-01-01T10:00:00Z"
    },
    "source": {
      "delivery_id": 5
    }
  },
  {
    "_id": "event_000002",
    "eventType": "delivery_corrected",
    "occurredAt": {
      "$date": "2030-01-01T10:01:00Z"
    },
    "source": {
      "delivery_id": 5
    }
  }
]
```

## 4. Count documents for each event type.

```javascript
db.getCollection("delivery_snapshots").aggregate([{"$group":{"_id":"$eventType", "documentCount":{"$sum":1}}}, {"$sort":{"_id":1}}]).toArray();
```

| _id | documentCount |
| --- | --- |
| delivery_corrected | 1 |
| delivery_recorded | 1 |

## Validation and suitability

MongoDB inserted 2 documents. An invalid date type was rejected with code 121 and a repeated event ID with 11000. The collection still contained 2 valid documents. The compound eventType/occurredAt index supports those access fields; this exercise does not measure its speed.

The details field can vary across event types, while the common fields have a validator. Events can be added as separate documents rather than growing one large history record.

## Run the script

Connect mongosh to a fresh exercise database and run Zakari_Martins_301911699_P4_MongoDB.js. It selects portfolio_nosql, creates the collection, inserts the sample documents and displays the query results. [Implementation evidence](screenshots/Zakari_Martins_301911699_P4_DocumentsAndQueries.png).

## References

- [MongoDB — data modelling](https://www.mongodb.com/docs/manual/data-modeling/)

