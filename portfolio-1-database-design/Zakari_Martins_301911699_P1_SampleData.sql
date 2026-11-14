-- Fictional sample records for Financed Input Delivery Records.
BEGIN;
SET LOCAL standard_conforming_strings = on;
INSERT INTO portfolio."sme" ("sme_id", "sme_name", "registered_on") VALUES (1, 'Northfield Foods', '2024-02-12');
INSERT INTO portfolio."supplier" ("supplier_id", "supplier_name", "country_code") VALUES (2, 'Harbor Grain Supply', 'NZ');
INSERT INTO portfolio."input_item" ("item_id", "item_name", "unit_name") VALUES (4, 'Organic wheat', 'kg');
INSERT INTO portfolio."purchase_order" ("order_id", "sme_id", "supplier_id", "ordered_on", "order_status") VALUES (3, 1, 2, '2025-03-10', 'open');
INSERT INTO portfolio."delivery" ("delivery_id", "order_id", "item_id", "delivery_ref", "delivered_qty", "delivered_at", "delivery_notes") VALUES (5, 3, 4, 'DLV-2025-001', 125.5, '2025-03-14T09:30:00+12:00', NULL);
INSERT INTO portfolio."outbox_event" ("event_id", "delivery_id", "event_type", "created_at") VALUES (6, 5, 'delivery_recorded', '2025-03-14T09:30:01+12:00');
COMMIT;
