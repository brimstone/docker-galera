FROM brimstone/debian:jessie

CMD []
ENTRYPOINT ["/galera-loader"]

EXPOSE 3306
EXPOSE 4567

ENV PEERS="" \
    CLUSTERNAME=galera \
    MYSQL_ROOT_PASSWORD="" \
    BUFFER_POOL_SIZE=102m \
    MAX_CONNECTIONS=151 \
    BACKUP_DELAY=1h \
    BACKUP_COUNT=5

# downloaded from http://releases.galeracluster.com/GPG-KEY-galeracluster.com
ADD GPG-KEY-galeracluster.com /tmp/
# install galera and everything we need
# http://galeracluster.com/downloads/
RUN apt-key add /tmp/GPG-KEY-galeracluster.com \
 && echo "deb http://releases.galeracluster.com/debian jessie main" \
	> /etc/apt/sources.list.d/galera.list \
 && package net-tools rsync dnsutils procps \
    mysql-wsrep-server-5.6=5.6.* galera-3=25* galera-arbitrator-3=25* \
 && sed -i '/error.log/d' /etc/mysql/my.cnf \
 && rm /var/log/mysql/error.log \
 && echo '!includedir /etc/mysql/ssl.d/' >> /etc/mysql/my.cnf \
 && mkdir /etc/mysql/ssl.d \
 && rm /var/lib/mysql/ib_logfile*

# Copy in our loader
ADD galera-loader /galera-loader
