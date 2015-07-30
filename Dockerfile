FROM brimstone/debian:wheezy


# downloaded from http://releases.galeracluster.com/GPG-KEY-galeracluster.com
ADD GPG-KEY-galeracluster.com /tmp/
# install galera and everything we need
# http://galeracluster.com/downloads/
RUN apt-key add /tmp/GPG-KEY-galeracluster.com \
 && echo "deb http://releases.galeracluster.com/debian wheezy main" > /etc/apt/sources.list.d/galera.list \
 && echo "mysql-wsrep-server  mysql-server/root_password password" | debconf-set-selections \
 && echo "mysql-wsrep-server  mysql-server/root_password_again password" | debconf-set-selections \
 && package net-tools rsync dnsutils mysql-wsrep-server galera-3

ADD lowend.cnf /etc/mysql/conf.d/lowend.cnf

# Copy in our loader
ADD galera-loader /galera-loader

EXPOSE 3306
ENTRYPOINT ["/galera-loader"]
CMD []
