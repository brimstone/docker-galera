FROM brimstone/debian:wheezy


# downloaded from http://releases.galeracluster.com/GPG-KEY-galeracluster.com
ADD GPG-KEY-galeracluster.com /tmp/
# install galera and everything we need
# http://galeracluster.com/downloads/
RUN apt-key add /tmp/GPG-KEY-galeracluster.com \
 && echo "deb http://releases.galeracluster.com/debian wheezy main" > /etc/apt/sources.list.d/galera.list \
 && package net-tools rsync dnsutils mysql-wsrep-server-5.6 galera-3 procps galera-arbitrator-3 \
 && sed -i '/error.log/d' /etc/mysql/my.cnf \
 && rm /var/log/mysql/error.log \
 && echo '!includedir /etc/mysql/ssl.d/' >> /etc/mysql/my.cnf \
 && mkdir /etc/mysql/ssl.d \
 && rm /var/lib/mysql/ib_logfile*

ADD lowend.cnf /etc/mysql/conf.d/lowend.cnf

# Copy in our loader
ADD galera-loader /galera-loader

EXPOSE 3306
EXPOSE 4567
ENTRYPOINT ["/galera-loader"]
CMD []
