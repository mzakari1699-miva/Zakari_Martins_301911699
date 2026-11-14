# Financed Input Delivery Records — ER diagram

```mermaid
erDiagram
    direction LR
    sme {
        bigint sme_id PK
        text sme_name
        date registered_on
    }
    supplier {
        bigint supplier_id PK
        text supplier_name
        text country_code
    }
    purchase_order {
        bigint order_id PK
        bigint sme_id FK
        bigint supplier_id FK
        date ordered_on
        text order_status
    }
    input_item {
        bigint item_id PK
        text item_name
        text unit_name
    }
    delivery {
        bigint delivery_id PK
        bigint order_id FK
        bigint item_id FK
        text delivery_ref UK
        numeric delivered_qty
        timestamptz delivered_at
        text delivery_notes "Optional"
    }
    outbox_event {
        bigint event_id PK
        bigint delivery_id FK
        text event_type
        timestamptz created_at
    }
    sme ||--o{ purchase_order : "sme_id"
    supplier ||--o{ purchase_order : "supplier_id"
    purchase_order ||--o{ delivery : "order_id"
    input_item ||--o{ delivery : "item_id"
    delivery ||--o{ outbox_event : "delivery_id"
```

PK identifies a record; FK links to another table; UK marks a single-field unique value. The relationship ends show exactly one, zero or one, or zero or many records. Composite unique keys and conditional rules are listed in the schema and design.

[Diagram image](../images/Zakari_Martins_301911699_ERDiagram.png)
