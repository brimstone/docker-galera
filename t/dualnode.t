#!/bin/bash
set -euo pipefail
source t/utils

galera mysql-1 -e MYSQL_ROOT_PASSWORD=password >/dev/null

wait_for_synced mysql-1

galera mysql-2 -e PEERS="$(cip mysql-1)" >/dev/null

wait_for_synced mysql-2

sleep 1

version="$(sql mysql-1 -u root -ppassword -e 'SELECT @@VERSION;' || true)"

if [ -z "$version" ]; then
	echo "Version not found, failing container"
	exit 1
fi

version="$(sql mysql-2 -u root -ppassword -e 'SELECT @@VERSION;' || true)"

if [ -z "$version" ]; then
	echo "Version not found, failing container"
	exit 1
fi

cluster_size="$(sql mysql-2 -u root -ppassword -e "show status where Variable_name='wsrep_cluster_size';" | awk '{print $2}' || true)"

if [ "$cluster_size" != "2" ]; then
	echo "Cluster size is $cluster_size, expected 2"
	exit 1
fi

docker rm -vf mysql-1 >/dev/null
docker rm -vf mysql-2 >/dev/null

exit 0
