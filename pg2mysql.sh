#!/bin/bash

EXPECTED_ARGS=6
E_BADARGS=65
MYSQL=`which mysql`

NEWDBASE=$1
NEWUSER=$2
NEWPASS=$3

PORT=$4
HOST='localhost'

sed -i '' 's/SET/-- SET/g' $6
sed -i '' 's/SELECT/-- SELECT/g' $6
sed -i '' 's/public.//g' $6
sed -i '' '/schema_migrations/d' $6
sed -i '' 's/+[[:digit:]]\{2\}:[[:digit:]]\{2\}//g' $6

Q1="CREATE DATABASE IF NOT EXISTS $NEWDBASE;"
Q2="GRANT ALL ON $NEWDBASE.* TO '$NEWUSER'@'$HOST' IDENTIFIED BY '$NEWPASS';"
Q3="FLUSH PRIVILEGES;"

Q4="USE $NEWDBASE;"
Q5="SOURCE $5;"
Q6="SOURCE $6;"

SQL1="${Q1}${Q2}${Q3}"
SQL2="${Q4}${Q5}${Q6}"

if [ $# -ne $EXPECTED_ARGS ]
then
  echo "Usage: $0 dbname dbuser dbpass dbPort schemafile datafile"
  exit $E_BADARGS
fi

$MYSQL -uroot -p -P$PORT -h$HOST -e "$SQL1"

$MYSQL -u$NEWUSER -p$NEWPASS -P$PORT -h$HOST -D$NEWDBASE -e "$SQL2"


echo "Database $NEWDBASE and user $NEWUSER created with a password $NEWPASS with schema imported from $5 and data migrated from $6"
