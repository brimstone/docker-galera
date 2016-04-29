#!/bin/bash
set -euo pipefail
source t/utils

mysql1=$(galera -e MYSQL_ROOT_PASSWORD=password)
cleanupid "$mysql1"

wait_for_synced "$mysql1"

mysql2=$(galera -e PEERS="$(cip "$mysql1")")
cleanupid "$mysql2"

wait_for_synced "$mysql2"

sleep 1

version="$(sql "$mysql2" -u root -ppassword -e 'SELECT @@VERSION;' || true)"

if [ -z "$version" ]; then
	echo "Version not found, failing container"
	exit 1
fi

version="$(sql "$mysql2" -u root -ppassword -e 'SELECT @@VERSION;' || true)"

if [ -z "$version" ]; then
	echo "Version not found, failing container"
	exit 1
fi

cluster_size="$(sql "$mysql2" -u root -ppassword -e "show status where Variable_name='wsrep_cluster_size';" | awk '{print $2}' || true)"

if [ "$cluster_size" != "2" ]; then
	echo "Cluster size is $cluster_size, expected 2"
	exit 1
fi

exit 0
