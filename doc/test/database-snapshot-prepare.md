# Preparing test database for acceptance tests

This will guide you to prepare a sample database for acceptance specs. The goal of this database is to have the simplest setup as possible.
 
- Remember that database user/role should be postgres
    - If you use Heroku's [Postgresapp](http://postgresapp.com/), pay attention on your username/role. By default, it's your username.
- Use a [sanitized version of the database](https://github.com/fameandpartners/website/blob/3a0452d36903b5adee2d919a2b3ac157e996d171/README.md#sanitised-database)
- After running the SQL, ensure that you have the setup ready, and you're ready to dump your database using the sixth option of the [`./script/db`](https://github.com/fameandpartners/website/blob/3a0452d36903b5adee2d919a2b3ac157e996d171/README.md#local-database)

## Setup

- A single product:
    - id: 681
    - name: Connie
- A single user:
    - email: spree@example.com
    - password: 123456
- Test payment methods
    - This should be setup using your admin interface

## SQL

- Truncate some remanescent tables

```
truncate item_return_events;
truncate fabrication_events;
truncate line_item_updates;
truncate item_returns;
```

- Remove other products

```
DELETE
FROM spree_products AS sp
WHERE sp.id != 681;        
```

- Remove unnecessary Spree Product Properties

```
DELETE
FROM spree_product_properties AS spp
WHERE spp.product_id != 681;
```

-- Remove Spree Variants

```
DELETE
FROM spree_variants AS sv
WHERE sv.id NOT IN (
    SELECT v.id
    FROM spree_variants AS v
    WHERE v.product_id = 681
);
```

- Remove Spree Prices

```
DELETE                            
FROM spree_prices AS sp
WHERE sp.variant_id NOT IN (
    SELECT v.id
    FROM spree_variants AS v
    WHERE v.product_id = 681
);
```

- Remove Spree Option Values Variants

```
-- Remove spree_option_values_variants
DELETE
FROM spree_option_values_variants AS sovv
WHERE sovv.variant_id NOT IN (
    SELECT v.id
    FROM spree_variants AS v
    WHERE v.product_id = 681
);
```

## Useful Commands

- Vacuum the DB (Truncate empty spaces)

```bash
vacuumdb -d fame_website_development -e -f
```

- Calculate table size in human readable format (KB, MB, ...). [Source](https://wiki.postgresql.org/wiki/Disk_Usage#Finding_the_total_size_of_your_biggest_tables).
 
```
SELECT nspname || '.' || relname AS "relation",
    pg_size_pretty(pg_total_relation_size(C.oid)) AS "total_size"
  FROM pg_class C
  LEFT JOIN pg_namespace N ON (N.oid = C.relnamespace)
  WHERE nspname NOT IN ('pg_catalog', 'information_schema')
    AND C.relkind <> 'i'
    AND nspname !~ '^pg_toast'
  ORDER BY pg_total_relation_size(C.oid) DESC
  LIMIT 20;
```
