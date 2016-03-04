#!/bin/bash
set -euo pipefail
source t/utils

backupdir="$(mktemp -d)"
MAX=$RANDOM
mysql1=$(galera -e MAX_CONNECTIONS="$MAX" -e MYSQL_ROOT_PASSWORD=password -v "$backupdir:/var/backups/mysql" -e BACKUP_DELAY=10)

wait_for_synced "$mysql1"

sleep 1

max_connections="$(sql "$mysql1" -u root -ppassword -e 'show variables like "max_connections";' | awk '{print $2}' || true)"

if [ "$max_connections" = "$MAX" ]; then
	ok "Max connections: $max_connections"
else
	fail "Max Connections not set to '$MAX' found '$max_connections', failing container"
	exit 1
fi

docker rm -vf "$mysql1" >/dev/null
exit 0
