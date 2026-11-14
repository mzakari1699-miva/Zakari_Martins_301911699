# Portfolio 1 — Database Design and Modelling

I organised the data into sme, supplier, purchase_order, input_item, delivery, outbox_event. The design document explains the fields, keys, relationships and business rules. The normalisation document shows the sample tables at 1NF, 2NF and 3NF.

## Database checks

| Table | Rows |
| --- | --- |
| sme | 1 |
| supplier | 1 |
| purchase_order | 1 |
| input_item | 1 |
| delivery | 1 |
| outbox_event | 1 |

The 14 invalid inserts were rejected at their expected constraints, and the valid sample rows remained unchanged.

## Files

- [Design](Zakari_Martins_301911699_P1_Design.md)
- [ER diagram](Zakari_Martins_301911699_P1_ERDiagram.md)
- [Normalisation](Zakari_Martins_301911699_P1_Normalisation.md)
- [Schema](Zakari_Martins_301911699_P1_Schema.sql)
- [Sample data](Zakari_Martins_301911699_P1_SampleData.sql)
- [Constraint tests](Zakari_Martins_301911699_P1_ConstraintTests.sql)
- [Table and constraint evidence](screenshots/Zakari_Martins_301911699_P1_DatabaseResults.png)

## Run the SQL

Create a fresh PostgreSQL database. Run the schema first, then the sample data. Run the deliberately invalid statements in ConstraintTests.sql individually outside a transaction; each is expected to produce an error.

## References

- [PostgreSQL — constraints](https://www.postgresql.org/docs/17/ddl-constraints.html)

