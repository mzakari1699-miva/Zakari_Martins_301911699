-- Run these deliberately invalid statements one at a time, outside a transaction.
-- Each should fail at the named constraint; the sample rows should remain unchanged.

-- 1. duplicate sme pk. Expected: pk_sme, SQLSTATE 23505.
INSERT INTO portfolio."sme" ("sme_id", "sme_name", "registered_on")
VALUES (1, 'East Ridge Produce', '2024-05-01');

-- 2. null sme name. Expected: sme_name, SQLSTATE 23502.
INSERT INTO portfolio."sme" ("sme_id", "sme_name", "registered_on")
VALUES (10, NULL, '2024-05-01');

-- 3. duplicate supplier pk. Expected: pk_supplier, SQLSTATE 23505.
INSERT INTO portfolio."supplier" ("supplier_id", "supplier_name", "country_code")
VALUES (2, 'Valley Milling', 'AU');

-- 4. duplicate order pk. Expected: pk_purchase_order, SQLSTATE 23505.
INSERT INTO portfolio."purchase_order" ("order_id", "sme_id", "supplier_id", "ordered_on", "order_status")
VALUES (3, 1, 2, '2025-03-11', 'open');

-- 5. unknown order sme. Expected: fk_purchase_order_0, SQLSTATE 23503.
INSERT INTO portfolio."purchase_order" ("order_id", "sme_id", "supplier_id", "ordered_on", "order_status")
VALUES (11, 999, 2, '2025-03-11', 'open');

-- 6. unknown order supplier. Expected: fk_purchase_order_1, SQLSTATE 23503.
INSERT INTO portfolio."purchase_order" ("order_id", "sme_id", "supplier_id", "ordered_on", "order_status")
VALUES (12, 1, 999, '2025-03-11', 'open');

-- 7. duplicate item pk. Expected: pk_input_item, SQLSTATE 23505.
INSERT INTO portfolio."input_item" ("item_id", "item_name", "unit_name")
VALUES (4, 'Barley', 'kg');

-- 8. duplicate delivery pk. Expected: pk_delivery, SQLSTATE 23505.
INSERT INTO portfolio."delivery" ("delivery_id", "order_id", "item_id", "delivery_ref", "delivered_qty", "delivered_at", "delivery_notes")
VALUES (5, 3, 4, 'DLV-2025-002', 10, '2025-03-15T10:00:00+12:00', NULL);

-- 9. duplicate delivery ref. Expected: uq_delivery_0, SQLSTATE 23505.
INSERT INTO portfolio."delivery" ("delivery_id", "order_id", "item_id", "delivery_ref", "delivered_qty", "delivered_at", "delivery_notes")
VALUES (13, 3, 4, 'DLV-2025-001', 10, '2025-03-15T10:00:00+12:00', NULL);

-- 10. unknown delivery order. Expected: fk_delivery_0, SQLSTATE 23503.
INSERT INTO portfolio."delivery" ("delivery_id", "order_id", "item_id", "delivery_ref", "delivered_qty", "delivered_at", "delivery_notes")
VALUES (14, 999, 4, 'DLV-2025-003', 10, '2025-03-15T10:00:00+12:00', NULL);

-- 11. unknown delivery item. Expected: fk_delivery_1, SQLSTATE 23503.
INSERT INTO portfolio."delivery" ("delivery_id", "order_id", "item_id", "delivery_ref", "delivered_qty", "delivered_at", "delivery_notes")
VALUES (15, 3, 999, 'DLV-2025-004', 10, '2025-03-15T10:00:00+12:00', NULL);

-- 12. nonpositive delivery qty. Expected: positive_delivery_qty, SQLSTATE 23514.
INSERT INTO portfolio."delivery" ("delivery_id", "order_id", "item_id", "delivery_ref", "delivered_qty", "delivered_at", "delivery_notes")
VALUES (16, 3, 4, 'DLV-2025-005', 0, '2025-03-15T10:00:00+12:00', NULL);

-- 13. duplicate outbox pk. Expected: pk_outbox_event, SQLSTATE 23505.
INSERT INTO portfolio."outbox_event" ("event_id", "delivery_id", "event_type", "created_at")
VALUES (6, 5, 'delivery_recorded', '2025-03-14T09:30:01+12:00');

-- 14. unknown outbox delivery. Expected: fk_outbox_event_0, SQLSTATE 23503.
INSERT INTO portfolio."outbox_event" ("event_id", "delivery_id", "event_type", "created_at")
VALUES (17, 999, 'delivery_recorded', '2025-03-15T10:00:00+12:00');
