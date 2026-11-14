// Run once in mongosh against a fresh exercise database.
// These records are fictional events for the case study.
(async function () {
  db = db.getSiblingDB('portfolio_nosql');
  if ((await db.getCollectionNames()).includes("delivery_snapshots")) {
    throw new Error('The exercise collection already exists. Use a fresh database.');
  }

  // The validator checks the stable event fields while details can vary.
  await db.createCollection("delivery_snapshots", {
    validator: {
    "$jsonSchema": {
        "bsonType": "object",
        "required": [
            "_id",
            "schemaVersion",
            "simulation",
            "eventType",
            "occurredAt",
            "source",
            "embedded",
            "references",
            "details"
        ],
        "properties": {
            "_id": {
                "bsonType": "string",
                "minLength": 1
            },
            "schemaVersion": {
                "enum": [
                    1
                ]
            },
            "simulation": {
                "enum": [
                    true
                ]
            },
            "eventType": {
                "bsonType": "string",
                "enum": [
                    "delivery_recorded",
                    "delivery_corrected"
                ]
            },
            "occurredAt": {
                "bsonType": "date"
            },
            "source": {
                "bsonType": "object",
                "required": [
                    "entity",
                    "key",
                    "snapshot"
                ],
                "properties": {
                    "entity": {
                        "enum": [
                            "delivery"
                        ]
                    },
                    "key": {
                        "bsonType": "object",
                        "required": [
                            "delivery_id"
                        ]
                    },
                    "snapshot": {
                        "bsonType": "object"
                    }
                }
            },
            "embedded": {
                "bsonType": "object"
            },
            "references": {
                "bsonType": "object"
            },
            "details": {
                "bsonType": "object"
            }
        }
    }
},
    validationLevel: 'strict', validationAction: 'error'
  });

  // Insert the four example events and show their IDs.
  printjson(await db.getCollection("delivery_snapshots").insertMany([
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
    },
    {
        "_id": "event_000002",
        "schemaVersion": 1,
        "simulation": true,
        "eventType": "delivery_corrected",
        "occurredAt": ISODate("2030-01-01T10:01:00Z"),
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
            "channel": "mobile",
            "note": "Illustrative event-specific metadata",
            "attributes": [
                {
                    "entity": "delivery",
                    "key": {
                        "delivery_id": 5
                    },
                    "field": "delivery_notes",
                    "value": null
                }
            ],
            "examples": {
                "correction_details": "illustrative correction_details"
            }
        }
    }
]));
  await db.getCollection("delivery_snapshots").createIndex({eventType: 1, occurredAt: -1}, {name: 'event_type_time'});

  // 1. Find the first sample event type (up to five documents).
  printjson(await db.getCollection("delivery_snapshots").find({"eventType":"delivery_recorded"}).sort({_id:1}).limit(5).toArray());

  // 2. Find events for the first source record using nested key fields (up to five).
  printjson(await db.getCollection("delivery_snapshots").find({"source.key.delivery_id":5}).sort({_id:1}).limit(5).toArray());

  // 3. Find events in the sample time range using a MongoDB Date filter (up to five).
  printjson(await db.getCollection("delivery_snapshots").find({"occurredAt":{"$gte":ISODate("2030-01-01T10:00:00Z"), "$lt":ISODate("2030-01-01T11:00:00Z")}}).sort({_id:1}).limit(5).toArray());

  // 4. Count documents for each event type.
  printjson(await db.getCollection("delivery_snapshots").aggregate([{"$group":{"_id":"$eventType", "documentCount":{"$sum":1}}}, {"$sort":{"_id":1}}]).toArray());

  // A date stored as text should be rejected by the validator.
  try {
    await db.getCollection("delivery_snapshots").insertOne({...{
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
}, _id: 'invalid_date_example', occurredAt: 'not-a-date'});
  } catch (error) { print('Invalid date error: ' + error.code); }

  // Reusing an event ID should be rejected by the unique _id index.
  try { await db.getCollection("delivery_snapshots").insertOne({
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
}); }
  catch (error) { print('Duplicate ID error: ' + error.code); }

  print('Document count: ' + await db.getCollection("delivery_snapshots").countDocuments());
})().catch(error => { print(error.stack || String(error)); quit(1); });
