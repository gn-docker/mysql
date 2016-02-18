#!/bin/bash

if [ "$(ls ${MYSQL_BACKUP_DIR} | grep gz)" ]; then
  echo "Creating GNI databases..."
  cd ${MYSQL_BACKUP_DIR}
  shopt -s nullglob
  for f in *.gz
  do
    db=${f%.sql.gz}
    echo "  loading '$db'"
    mysql -uroot -e "DROP DATABASE IF EXISTS $db"
    mysql -uroot -e "CREATE DATABASE $db"
    gunzip -c $f | mysql -uroot $db
  done
else
  echo "======================================================================="
  echo "GNA DB Backup directory '${MYSQL_BACKUP_DIR}' does not exist or empty"
  echo "======================================================================="
fi
