-- Financed Input Delivery Records: tables, keys and business constraints.
-- Run once in a fresh PostgreSQL database.
BEGIN;
SET LOCAL standard_conforming_strings = on;
CREATE SCHEMA portfolio;
CREATE TABLE portfolio."sme" (
  "sme_id" bigint NOT NULL,
  "sme_name" text NOT NULL,
  "registered_on" date NOT NULL,
  CONSTRAINT "pk_sme" PRIMARY KEY ("sme_id")
);
CREATE TABLE portfolio."supplier" (
  "supplier_id" bigint NOT NULL,
  "supplier_name" text NOT NULL,
  "country_code" text NOT NULL,
  CONSTRAINT "pk_supplier" PRIMARY KEY ("supplier_id")
);
CREATE TABLE portfolio."purchase_order" (
  "order_id" bigint NOT NULL,
  "sme_id" bigint NOT NULL,
  "supplier_id" bigint NOT NULL,
  "ordered_on" date NOT NULL,
  "order_status" text NOT NULL,
  CONSTRAINT "pk_purchase_order" PRIMARY KEY ("order_id")
);
CREATE TABLE portfolio."input_item" (
  "item_id" bigint NOT NULL,
  "item_name" text NOT NULL,
  "unit_name" text NOT NULL,
  CONSTRAINT "pk_input_item" PRIMARY KEY ("item_id")
);
CREATE TABLE portfolio."delivery" (
  "delivery_id" bigint NOT NULL,
  "order_id" bigint NOT NULL,
  "item_id" bigint NOT NULL,
  "delivery_ref" text NOT NULL,
  "delivered_qty" numeric(18,2) NOT NULL,
  "delivered_at" timestamptz NOT NULL,
  "delivery_notes" text,
  CONSTRAINT "pk_delivery" PRIMARY KEY ("delivery_id"),
  CONSTRAINT "uq_delivery_0" UNIQUE ("delivery_ref")
);
CREATE TABLE portfolio."outbox_event" (
  "event_id" bigint NOT NULL,
  "delivery_id" bigint NOT NULL,
  "event_type" text NOT NULL,
  "created_at" timestamptz NOT NULL,
  CONSTRAINT "pk_outbox_event" PRIMARY KEY ("event_id")
);
ALTER TABLE portfolio."purchase_order" ADD CONSTRAINT "fk_purchase_order_0" FOREIGN KEY ("sme_id") REFERENCES portfolio."sme" ("sme_id");
ALTER TABLE portfolio."purchase_order" ADD CONSTRAINT "fk_purchase_order_1" FOREIGN KEY ("supplier_id") REFERENCES portfolio."supplier" ("supplier_id");
ALTER TABLE portfolio."delivery" ADD CONSTRAINT "fk_delivery_0" FOREIGN KEY ("order_id") REFERENCES portfolio."purchase_order" ("order_id");
ALTER TABLE portfolio."delivery" ADD CONSTRAINT "fk_delivery_1" FOREIGN KEY ("item_id") REFERENCES portfolio."input_item" ("item_id");
ALTER TABLE portfolio."outbox_event" ADD CONSTRAINT "fk_outbox_event_0" FOREIGN KEY ("delivery_id") REFERENCES portfolio."delivery" ("delivery_id");
ALTER TABLE portfolio."delivery" ADD CONSTRAINT "positive_delivery_qty" CHECK ("delivered_qty" > 0);
COMMIT;
