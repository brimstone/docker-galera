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
- PEERS
- CLUSTERNAME
- MYSQL_ROOT_PASSWORD
- BUFFER_POOL_SIZE

Command arguments
-----------------
- garbd
