# Financed Input Delivery Records — SQL queries

## 1. Show related delivery, purchase_order, input_item, sme, supplier records (up to 20).

```sql
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
```

| delivery_delivery_id | delivery_delivery_ref | purchase_order_order_id | purchase_order_ordered_on | input_item_item_id | input_item_item_name | sme_sme_id | sme_sme_name | supplier_supplier_id | supplier_supplier_name |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 5 | DLV-2025-001 | 3 | 2025-03-10 | 4 | Organic wheat | 1 | Northfield Foods | 2 | Harbor Grain Supply |

## 2. Find delivery records where delivered_at matches "2025-03-14T09:30:00+12:00" (up to 20).

```sql
SELECT * FROM portfolio."delivery"
WHERE "delivered_at" IS NOT DISTINCT FROM '2025-03-14T09:30:00+12:00'
ORDER BY "delivery_id"
LIMIT 20;
```

| delivery_id | order_id | item_id | delivery_ref | delivered_qty | delivered_at | delivery_notes |
| --- | --- | --- | --- | --- | --- | --- |
| 5 | 3 | 4 | DLV-2025-001 | 125.5 | 2025-03-13T21:30:00+00:00 | NULL |

## 3. Count delivery records for each order_id (up to 20 groups).

```sql
SELECT "order_id", count(*) AS record_count
FROM portfolio."delivery"
GROUP BY "order_id"
ORDER BY record_count DESC, "order_id" NULLS LAST
LIMIT 20;
```

| order_id | record_count |
| --- | --- |
| 3 | 1 |

## 4. Find delivery records where delivered_at matches "2025-03-14T09:30:00+12:00" (up to 20).

```sql
SELECT * FROM portfolio."delivery"
WHERE "delivered_at" IS NOT DISTINCT FROM '2025-03-14T09:30:00+12:00'
ORDER BY "delivery_id"
LIMIT 20;
```

| delivery_id | order_id | item_id | delivery_ref | delivered_qty | delivered_at | delivery_notes |
| --- | --- | --- | --- | --- | --- | --- |
| 5 | 3 | 4 | DLV-2025-001 | 125.5 | 2025-03-13T21:30:00+00:00 | NULL |


## Index comparison

| Phase | Median (ms) | Three runs (ms) | Plan nodes | Buffer hits |
| --- | --- | --- | --- | --- |
| Before index | 2.412 | 2.358, 2.412, 2.639 | Sort → Seq Scan | 274 |
| After index | 0.318 | 0.318, 0.318, 0.412 | Sort → Bitmap Heap Scan → Bitmap Index Scan | 55 |

The median execution time changed from 2.412 ms to 0.318 ms. The measured plan used p2_filter_idx. The results matched in both phases. An index adds storage and write-maintenance costs; timings depend on the selected lookup and environment.

## Execution plans

### Before index, run 1

```text
Sort (actual time=2.328..2.331 rows=50 loops=1)
  Seq Scan on delivery (actual time=0.016..2.288 rows=50 loops=1)
Planning Time: 0.389 ms
Execution Time: 2.358 ms
```

### Before index, run 2

```text
Sort (actual time=2.382..2.385 rows=50 loops=1)
  Seq Scan on delivery (actual time=0.016..2.344 rows=50 loops=1)
Planning Time: 0.354 ms
Execution Time: 2.412 ms
```

### Before index, run 3

```text
Sort (actual time=2.609..2.612 rows=50 loops=1)
  Seq Scan on delivery (actual time=0.016..2.568 rows=50 loops=1)
Planning Time: 0.402 ms
Execution Time: 2.639 ms
```

### After index, run 1

```text
Sort (actual time=0.259..0.261 rows=50 loops=1)
  Bitmap Heap Scan on delivery (actual time=0.034..0.22 rows=50 loops=1)
    Bitmap Index Scan using p2_filter_idx (actual time=0.016..0.016 rows=50 loops=1)
Planning Time: 0.542 ms
Execution Time: 0.318 ms
```

### After index, run 2

```text
Sort (actual time=0.259..0.262 rows=50 loops=1)
  Bitmap Heap Scan on delivery (actual time=0.033..0.22 rows=50 loops=1)
    Bitmap Index Scan using p2_filter_idx (actual time=0.016..0.016 rows=50 loops=1)
Planning Time: 0.581 ms
Execution Time: 0.318 ms
```

### After index, run 3

```text
Sort (actual time=0.328..0.332 rows=50 loops=1)
  Bitmap Heap Scan on delivery (actual time=0.043..0.272 rows=50 loops=1)
    Bitmap Index Scan using p2_filter_idx (actual time=0.021..0.021 rows=50 loops=1)
Planning Time: 0.769 ms
Execution Time: 0.412 ms
```

## Reproduce

Use a fresh database with the Portfolio 1 schema and sample data. Run Zakari_Martins_301911699_P2_Queries.sql, then Zakari_Martins_301911699_P2_Optimisation.sql. The optimisation script creates a separate performance table and runs EXPLAIN (ANALYZE, BUFFERS).

[Query screenshot](screenshots/Zakari_Martins_301911699_P2_QueryResults.png) · [Index comparison](screenshots/Zakari_Martins_301911699_P2_IndexComparison.png)

## References

- [PostgreSQL — EXPLAIN](https://www.postgresql.org/docs/17/using-explain.html)

