# Financed Input Delivery Records — normalisation

The example uses the saved sample records. The full set of fields is in the design and schema.

## Starting grouped records

| order_id | delivery records (list) |
| --- | --- |
| 3 | [5] |


The record IDs are grouped in a list. In 1NF, each record has its own row and each cell holds one value.

## 1NF: one value per cell

| delivery.delivery_id | delivery.order_id | delivery.item_id | delivery.delivery_ref | purchase_order.order_id | purchase_order.sme_id | purchase_order.supplier_id | purchase_order.order_status |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 5 | 3 | 4 | DLV-2025-001 | 3 | 1 | 2 | open |

Key: delivery_id.

## 2NF: depend on the whole key

The declared candidate keys do not introduce a partial dependency here, so the 1NF rows stay unchanged at this step.

## delivery_example

| delivery.delivery_id | delivery.order_id | delivery.item_id | delivery.delivery_ref | purchase_order.order_id | purchase_order.sme_id | purchase_order.supplier_id | purchase_order.order_status |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 5 | 3 | 4 | DLV-2025-001 | 3 | 1 | 2 | open |

## 3NF: store each entity’s details once

The entity keys determine their own descriptions. Related records keep foreign keys rather than repeating those descriptions.

## sme

| sme_id | sme_name | registered_on |
| --- | --- | --- |
| 1 | Northfield Foods | 2024-02-12 |

## supplier

| supplier_id | supplier_name | country_code |
| --- | --- | --- |
| 2 | Harbor Grain Supply | NZ |

## purchase_order

| order_id | sme_id | supplier_id | ordered_on | order_status |
| --- | --- | --- | --- | --- |
| 3 | 1 | 2 | 2025-03-10 | open |

## input_item

| item_id | item_name | unit_name |
| --- | --- | --- |
| 4 | Organic wheat | kg |

## delivery

| delivery_id | order_id | item_id | delivery_ref | delivered_qty | delivered_at | delivery_notes |
| --- | --- | --- | --- | --- | --- | --- |
| 5 | 3 | 4 | DLV-2025-001 | 125.5 | 2025-03-13T21:30:00+00:00 | NULL |

## outbox_event

| event_id | delivery_id | event_type | created_at |
| --- | --- | --- | --- |
| 6 | 5 | delivery_recorded | 2025-03-13T21:30:01+00:00 |

## Dependencies

- sme: (sme_id) → sme_name, registered_on
- supplier: (supplier_id) → supplier_name, country_code
- purchase_order: (order_id) → sme_id, supplier_id, ordered_on, order_status
- input_item: (item_id) → item_name, unit_name
- delivery: (delivery_id) → order_id, item_id, delivery_ref, delivered_qty, delivered_at, delivery_notes
- outbox_event: (event_id) → delivery_id, event_type, created_at

Joining the decomposed sample tables reproduces the original 1 example rows. The design assumes the declared keys describe the relevant business dependencies.
