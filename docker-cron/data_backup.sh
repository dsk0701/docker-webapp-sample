#!/bin/bash -e


DATE=`date +%Y%m%d`
# DATE=`date +%Y%m%d-%H:%M`

echo "Start backup."
echo "PGPASSWORD=**** pg_dumpall -h ${DB_1_PORT_5432_TCP_ADDR} -p ${DB_1_PORT_5432_TCP_PORT} -U ${DB_1_ENV_POSTGRES_USER} > /backups/dumpall-${DATE}.sql"
PGPASSWORD=${DB_1_ENV_POSTGRES_PASSWORD} pg_dumpall -h ${DB_1_PORT_5432_TCP_ADDR} -p ${DB_1_PORT_5432_TCP_PORT} -U ${DB_1_ENV_POSTGRES_USER} > /backups/dumpall-${DATE}.sql
echo "Finish backup."

