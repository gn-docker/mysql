#!/bin/bash

VOLUME_HOME="/var/lib/mysql"
CONF_FILE="/etc/mysql/my.cnf"
LOG="/var/log/mysql/error.log"

StartMySQL ()
{
  /usr/bin/mysqld_safe > /dev/null 2>&1 &

  LOOP_LIMIT=30
  echo "========================================================================" >> ${LOG}
  for (( i=0 ; ; i++ )); do
    if [ ${i} -eq ${LOOP_LIMIT} ]; then
      echo "Time out. Error log is shown as below:" >> ${LOG}
      exit 1
    fi
    echo "=> Waiting for confirmation of MySQL service startup, trying ${i}/${LOOP_LIMIT} ..." >> ${LOG}
    sleep 5
    mysql -uroot -e "status" > /dev/null 2>&1 && break
  done
  echo "========================================================================" >> ${LOG}
}

CreateMySQLUsers ()
{
  StartMySQL
  ADMIN=${MYSQL_ADMIN_USER}
  ADMIN_PASS=${MYSQL_ADMIN_PASSWORD}
  DB_USER=${MYSQL_DATABASE_USER}
  DB_USER_PASS=${MYSQL_DATABASE_PASSWORD}

  echo "========================================================================" >> ${LOG}
  echo "Creating '${ADMIN}' user ..." >> ${LOG}
  mysql -uroot -e "CREATE USER '${ADMIN}'@'%' IDENTIFIED BY '${ADMIN_PASS}'"
  mysql -uroot -e "GRANT ALL PRIVILEGES ON *.* TO '${ADMIN}'@'%' WITH GRANT OPTION"
  echo "Creating ${DB_USER} user ..." >> ${LOG}
  mysql -uroot -e "CREATE USER '${DB_USER}'@'%' IDENTIFIED BY '${DB_USER_PASS}'"
  mysql -uroot -e "GRANT ALL PRIVILEGES ON *.* TO '${DB_USER}'@'%' WITH GRANT OPTION"
  mysql -uroot -e "GRANT ALL PRIVILEGES ON *.* TO '${DB_USER}'@'%' WITH GRANT OPTION"

  echo "=> Done!" >> ${LOG}

  echo "You can now connect to this MySQL Server using:" >> ${LOG}
  echo "" >> ${LOG}
  echo "    mysql -u$ADMIN -p -h<host> -P<port>" >> ${LOG}
  echo ""
  echo "========================================================================" >> ${LOG}

  mysqladmin -uroot shutdown
}

if [[ ! -d $VOLUME_HOME/mysql ]]; then
  echo "========================================================================" >> ${LOG}
  echo "=> An empty or uninitialized MySQL volume is detected in $VOLUME_HOME" >> ${LOG}
  echo "=> Installing MySQL ..." >> ${LOG}
  if [ ! -f /usr/share/mysql/my-default.cnf ] ; then
    cp $CONF_FILE /usr/share/mysql/my-default.cnf
  fi
  mysql_install_db --user=mysql --ldata=/var/lib/mysql/
  echo "=> Done!" >> ${LOG}
  echo "========================================================================" >> ${LOG}
  CreateMySQLUsers
else
  echo "=> Using an existing volume of MySQL" >> ${LOG}
fi

chmod a+rx /
chown mysql:mysql -R /var/lib/mysql
chown mysql:mysql -R /var/log/mysql
exec mysqld_safe
