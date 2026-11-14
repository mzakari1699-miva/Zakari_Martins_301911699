# Martins Zakari — MIT 8103

Student ID: 301911699

Financed Input Delivery Records. Entities: SME, supplier, purchase order, input item, delivery; each order links an SME and supplier, and each delivery links an order and an input item. Rule: delivery reference is UNIQUE. Useful SQL query: delivered quantity by item and order. A SQL transaction records a delivery and outbox event; a consumer appends a MongoDB snapshot of the delivery, its order, SME, and supplier.

The portfolio is being generated. Completed stages will appear in the commit history.
