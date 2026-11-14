# Financed Input Delivery Records — database design

My case study records sme, supplier, purchase_order, input_item, delivery, outbox_event.

## Users

- SME procurement staff
- Supplier representatives
- Receiving staff
- Database students

## Main operations

- Create purchase orders linking an SME and a supplier.
- Record deliveries linking a purchase order and an input item.
- Query delivered quantity by item and order.
- Record an outbox event atomically with a delivery and consume it into a MongoDB snapshot.

## Entities

| Entity | Information stored |
| --- | --- |
| sme | An SME placing purchase orders. |
| supplier | A supplier providing ordered input items. |
| purchase_order | An order linking one SME to one supplier. |
| input_item | A type of input item that can be delivered. |
| delivery | A recorded quantity of an input item delivered against a purchase order. |
| outbox_event | A durable event record written atomically with a delivery. |

## sme

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| sme_id | BIGINT | PK | Yes |
| sme_name | TEXT |  | Yes |
| registered_on | DATE |  | Yes |


## supplier

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| supplier_id | BIGINT | PK | Yes |
| supplier_name | TEXT |  | Yes |
| country_code | TEXT |  | Yes |


## purchase_order

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| order_id | BIGINT | PK | Yes |
| sme_id | BIGINT | FK | Yes |
| supplier_id | BIGINT | FK | Yes |
| ordered_on | DATE |  | Yes |
| order_status | TEXT |  | Yes |
- sme_id → sme.sme_id
- supplier_id → supplier.supplier_id

## input_item

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| item_id | BIGINT | PK | Yes |
| item_name | TEXT |  | Yes |
| unit_name | TEXT |  | Yes |


## delivery

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| delivery_id | BIGINT | PK | Yes |
| order_id | BIGINT | FK | Yes |
| item_id | BIGINT | FK | Yes |
| delivery_ref | TEXT | Unique | Yes |
| delivered_qty | NUMERIC(18,2) |  | Yes |
| delivered_at | TIMESTAMPTZ |  | Yes |
| delivery_notes | TEXT |  | No |
- order_id → purchase_order.order_id
- item_id → input_item.item_id
- Unique key: (delivery_ref).

## outbox_event

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| event_id | BIGINT | PK | Yes |
| delivery_id | BIGINT | FK | Yes |
| event_type | TEXT |  | Yes |
| created_at | TIMESTAMPTZ |  | Yes |
- delivery_id → delivery.delivery_id

## Relationships and business rules

- Every delivery reference is globally unique.
- A delivery must record a quantity greater than zero.
- Every purchase order references an existing SME.
- Every purchase order references an existing supplier.
- Every delivery references an existing purchase order.
- Every delivery references an existing input item.
- Every outbox event references an existing delivery.

## Assumptions

- All primary keys are single-column identifiers from one globally unique identifier domain.
- Each delivery row records one item against one purchase order; separate rows represent separate recorded deliveries.
- Delivery references are globally unique, and delivered quantities must be positive.
- Each delivery creates one delivery_recorded outbox event in the same SQL transaction.
- A later correction, if needed, is represented by a separate delivery_corrected event rather than overwriting the original snapshot.
- The normalisation example follows delivery to its order and item, then describes the order's SME and supplier links without repeating those ancestor roles in delivery.

