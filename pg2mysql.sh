#!/bin/bash

EXPECTED_ARGS=7
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

while read line
  do
  table=`echo $line | cut -d',' -f1`
  cols=`echo $line | cut -d',' -f2`
  sed -i '' "/ ${table} /{$cols;}" $6
done < $7

Q1="CREATE DATABASE IF NOT EXISTS $NEWDBASE;"
Q2="CREATE USER $NEWUSER@$HOST IDENTIFIED BY '$NEWPASS';"
Q3="GRANT ALL PRIVILEGES ON $NEWDBASE.* TO $NEWUSER@$HOST;"
Q4="FLUSH PRIVILEGES;"

Q5="USE $NEWDBASE;"
TMP="set sql_mode='';"
Q6="SOURCE $5;"
Q7="SOURCE $6;"

SQL1="${Q1}${Q2}${Q3}${Q4}"
SQL2="${Q5}${TMP}${Q6}${Q7}"

if [ $# -ne $EXPECTED_ARGS ]
then
  echo "Usage: $0 dbname dbuser dbpass dbPort schemafile datafile colConfig"
  exit $E_BADARGS
fi

$MYSQL -uroot -p -P$PORT -h$HOST -e "$SQL1"

$MYSQL -u$NEWUSER -p$NEWPASS -P$PORT -h$HOST -D$NEWDBASE -e "$SQL2"


echo "Database $NEWDBASE and user $NEWUSER created with a password $NEWPASS with schema imported from $5 and data migrated from $6"
