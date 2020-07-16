# pg2mysql
Migrate data from postgres to mysql

## Dump from postgres

pg_dump -h localhost -p 5432 -U username -W  --data-only --column-inserts dbName > db.sql

The dump is generated in the form of insert queries

## Execute script

pg2mysql takes following parameters

1. New Database name
2. New user
3. New user password
4. Schema file containing table creation queries
5. data file -> exported from pg_dump command in the form of all insert queries

## Example:

./pg2mysql.sh newDBname newDBuser newDBpass schemafile db.sql

$ ./pg2mysql.sh testDB foo bar testDB.sql db.sql
Enter password:
Database testDB and user foo created with a password bar with schema imported from testDB.sql and data migrated from db.sql

## What the script does
1. Comments everything except INSERT queries
2. Converts postgres timestamp to mysql timestamp
