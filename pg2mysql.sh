#!/bin/bash

# Functions
ok() { echo -e '\e[32m'$1'\e[m'; } # Green

EXPECTED_ARGS=5
E_BADARGS=65
MYSQL=`which mysql`

sed -i '' 's/SET/-- SET/g' $5
sed -i '' 's/SELECT/-- SELECT/g' $5
sed -i '' 's/public.//g' $5
sed -i '' '/schema_migrations/d' $5
sed -i '' 's/+[[:digit:]]\{2\}:[[:digit:]]\{2\}//g' $5

Q1="CREATE DATABASE IF NOT EXISTS $1;"
Q2="GRANT ALL ON *.* TO '$2'@'localhost' IDENTIFIED BY '$3';"
Q3="FLUSH PRIVILEGES;"
Q4="USE $1;"
Q5="SOURCE $4;"
Q6="SOURCE $5;"

SQL="${Q1}${Q2}${Q3}${Q4}${Q5}${Q6}"

if [ $# -ne $EXPECTED_ARGS ]
then
  echo "Usage: $0 dbname dbuser dbpass schemafile datafile"
  exit $E_BADARGS
fi

$MYSQL -uroot -ppassword -e "$SQL"

ok "Database $1 and user $2 created with a password $3 with schema imported from $4 and data migrated from $5"
