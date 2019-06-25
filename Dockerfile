FROM debian:stretch
MAINTAINER yohan <783b8c87@scimetis.net>
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get -y install mysql-server
RUN deluser mysql && addgroup --system --gid 120 mysql && adduser --no-create-home --system --uid 113 --ingroup mysql mysql
RUN /usr/bin/install -m 755 -o mysql -g root -d /var/run/mysqld
RUN chown -R mysql. /var/lib/mysql /run/mysqld
RUN mv /etc/mysql/mariadb.conf.d/50-mysqld_safe.cnf /root/
RUN mv /etc/mysql/mariadb.conf.d/50-server.cnf /root/
RUN mv /etc/mysql/debian.cnf /root/
COPY 50-server.cnf /etc/mysql/mariadb.conf.d/
COPY debian.cnf /etc/mysql/
## Workaround for this mysqld_safe bug is not working : https://bugs.mysql.com/bug.php?id=57690
## We are no longer using mysqld_safe and mysqld no longer has this bug anyway.
## RUN ln -s /dev/stderr /tmp/errorlog.err
## Useful ?
ENV CONF=/etc/mysql/my.cnf MYADMIN="/usr/bin/mysqladmin --defaults-file=/etc/mysql/debian.cnf" HOME=/etc/mysql/
## docker stop is not working (kills MySQL) when using mysqld_safe
#ENTRYPOINT ["/bin/bash"]
##ENTRYPOINT ["/usr/bin/mysqld_safe"]
ENTRYPOINT ["/usr/sbin/mysqld", "--basedir=/usr", "--datadir=/var/lib/mysql", "--plugin-dir=/usr/lib/mysql/plugin", "--user=mysql", "--log-error=/dev/stderr", "--pid-file=/var/run/mysqld/mysqld.pid", "--socket=/var/run/mysqld/mysqld.sock", "--port=3306"]
