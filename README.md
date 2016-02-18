MySQL Container
===============

Container for MySQL:5.6 databsase

Install
-------

And example is given for GNI database.

```
sudo mkdir -p /opt/gni/backup
sudo mkdir /opt/gni/mysql
sudo mkdir /opt/gni/log
sudo mkdir /opt/gni/config
cd /opt/gni
sudo chown 301:301 -R mysql
sudo chown 301:301 -R log

Copy start/restart/stop scripts from script directory to
/usr/local/bin directory on the host

copy my.cnf and production.env to /opt/gni/conf

run gni-mysql-start script
```

Create databases:

Copy GNI backup `*.sql.gz` file to /opt/gni/backup on the node

```
docker exec gni-mysql /create-gni-db.sh
```

