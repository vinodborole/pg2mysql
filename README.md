# pg2mysql
Migrate data from postgres to mysql

## Dump from postgres (only data)

pg_dump -h localhost -p 5432 -U username -W  --data-only --column-inserts dbName > db.sql

The dump is generated in the form of insert queries

## Execute script

pg2mysql takes following parameters

1. New Mysql Database to be created
2. New Mysql user to be created with privileges for new database
3. New Mysql user password for the new Mysql user
4. Port
5. Mysql compatible Schema file (Create Table queries)
6. Data file -> exported from pg_dump command that contains all insert queries

## Example:

./pg2mysql.sh newMysqlDBname newMysqlDBuser newMysqlDBpass port schemafile db.sql

$ ./pg2mysql.sh testDB foo bar 3306 testDB.sql db.sql
Enter password:
Database testDB and user foo created with a password bar with schema imported from testDB.sql and data migrated from db.sql

## What the script does
1. Comments everything except INSERT queries
2. Converts postgres timestamp to mysql timestamp
