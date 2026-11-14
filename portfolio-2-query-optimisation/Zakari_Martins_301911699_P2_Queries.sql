-- Show related delivery, purchase_order, input_item, sme, supplier records (up to 20).
SELECT t0."delivery_id" AS "delivery_delivery_id",
       t0."delivery_ref" AS "delivery_delivery_ref",
       t1."order_id" AS "purchase_order_order_id",
       t1."ordered_on" AS "purchase_order_ordered_on",
       t4."item_id" AS "input_item_item_id",
       t4."item_name" AS "input_item_item_name",
       t2."sme_id" AS "sme_sme_id",
       t2."sme_name" AS "sme_sme_name",
       t3."supplier_id" AS "supplier_supplier_id",
       t3."supplier_name" AS "supplier_supplier_name"
FROM portfolio."delivery" t0
JOIN portfolio."purchase_order" t1 ON t0."order_id" = t1."order_id"
JOIN portfolio."sme" t2 ON t1."sme_id" = t2."sme_id"
JOIN portfolio."supplier" t3 ON t1."supplier_id" = t3."supplier_id"
JOIN portfolio."input_item" t4 ON t0."item_id" = t4."item_id"
ORDER BY t0."delivery_id", t1."order_id", t4."item_id", t2."sme_id", t3."supplier_id"
LIMIT 20;

EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON)
SELECT t0."delivery_id" AS "delivery_delivery_id",
       t0."delivery_ref" AS "delivery_delivery_ref",
       t1."order_id" AS "purchase_order_order_id",
       t1."ordered_on" AS "purchase_order_ordered_on",
       t4."item_id" AS "input_item_item_id",
       t4."item_name" AS "input_item_item_name",
       t2."sme_id" AS "sme_sme_id",
       t2."sme_name" AS "sme_sme_name",
       t3."supplier_id" AS "supplier_supplier_id",
       t3."supplier_name" AS "supplier_supplier_name"
FROM portfolio."delivery" t0
JOIN portfolio."purchase_order" t1 ON t0."order_id" = t1."order_id"
JOIN portfolio."sme" t2 ON t1."sme_id" = t2."sme_id"
JOIN portfolio."supplier" t3 ON t1."supplier_id" = t3."supplier_id"
JOIN portfolio."input_item" t4 ON t0."item_id" = t4."item_id"
ORDER BY t0."delivery_id", t1."order_id", t4."item_id", t2."sme_id", t3."supplier_id"
LIMIT 20;

-- Find delivery records where delivered_at matches "2025-03-14T09:30:00+12:00" (up to 20).
SELECT * FROM portfolio."delivery"
WHERE "delivered_at" IS NOT DISTINCT FROM '2025-03-14T09:30:00+12:00'
ORDER BY "delivery_id"
LIMIT 20;

EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON)
SELECT * FROM portfolio."delivery"
WHERE "delivered_at" IS NOT DISTINCT FROM '2025-03-14T09:30:00+12:00'
ORDER BY "delivery_id"
LIMIT 20;

-- Count delivery records for each order_id (up to 20 groups).
SELECT "order_id", count(*) AS record_count
FROM portfolio."delivery"
GROUP BY "order_id"
ORDER BY record_count DESC, "order_id" NULLS LAST
LIMIT 20;

EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON)
SELECT "order_id", count(*) AS record_count
FROM portfolio."delivery"
GROUP BY "order_id"
ORDER BY record_count DESC, "order_id" NULLS LAST
LIMIT 20;

-- Find delivery records where delivered_at matches "2025-03-14T09:30:00+12:00" (up to 20).
SELECT * FROM portfolio."delivery"
WHERE "delivered_at" IS NOT DISTINCT FROM '2025-03-14T09:30:00+12:00'
ORDER BY "delivery_id"
LIMIT 20;

EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON)
SELECT * FROM portfolio."delivery"
WHERE "delivered_at" IS NOT DISTINCT FROM '2025-03-14T09:30:00+12:00'
ORDER BY "delivery_id"
LIMIT 20;
