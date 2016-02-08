Galera
======

[![Build Status](https://travis-ci.org/brimstone/docker-galera.svg?branch=master)](https://travis-ci.org/brimstone/docker-galera)

This is a container for running a MySQL server with wsrep extensions provided by Galera.

This is currently using:

Package         |Version
----------------|-------
mysql-server    |5.6
wsrep API       |25
galera provider |3

Environment Variables
---------------------
Name               |Default|Description
-------------------|-------|-----------
BACKUP_DELAY       |1h     |Backups are performed this frequently to /var/mysql/backups
BUFFER_POOL_SIZE   |102m   |This maps directly to `innodb_buffer_poll_size`. The default is the smallest allowed by mysql.
CLUSTERNAME        |galera |This maps directly to `wsrep_cluster_name`. Every node in the cluster needs the same clustername.
MAX_CONNECTIONS    |151    |This maps directly to `max_connections`. This is the MySQL default.
MYSQL_ROOT_PASSWORD|(none) |If this is set, the root password is changed to this, and all hosts are allowed.
PEERS              |(none) |This maps directly to `wsrep_cluster_address`. IF this is set, galera expects a another galera server responding at this address at start.

Command arguments
-----------------
- garbd
