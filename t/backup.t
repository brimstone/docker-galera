#!/bin/bash
set -euo pipefail
source t/utils

backupdir="$(mktemp -d)"
chmod 755 $backupdir
mysql1=$(galera -e MYSQL_ROOT_PASSWORD=password -v "$backupdir:/var/backups/mysql" -e BACKUP_DELAY=10 -e BACKUP_COUNT=3)
cleanupid "$mysql1"

wait_for_synced "$mysql1"

sleep 1

version="$(sql "$mysql1" -u root -ppassword -e 'SELECT @@VERSION;' || true)"

if [ -z "$version" ]; then
	docker logs "$mysql1"
	fail "Version not found, failing container"
	exit 1
else
	ok "Version $version"
fi

echo "Waiting for backup"
starttime=$(date +%s)
until [ -f "$backupdir/mysql.sql" ]; do
	[ $(date +%s) -gt $[ $starttime + 60 ] ] && break
	echo "# waiting"
	sleep 2
done
if [ -f "$backupdir/mysql.sql" ]; then
	ok "Found backups"
	docker run --rm -it -v "$(dirname "$backupdir"):/docker" busybox rm -rf "/docker/$(basename "$backupdir")" >/dev/null 2>/dev/null
else
	docker logs "$mysql1"
	fail "No backup found, failing test"
	exit 1
fi


rm -rf "$backupdir"
exit 0
