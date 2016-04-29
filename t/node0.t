#!/bin/bash
set -euo pipefail
source t/utils

backupdir="$(mktemp -d)"

diag "First node to build sql files and permissions"

mysql0=$(galera -e MYSQL_ROOT_PASSWORD=password -v "$backupdir:/var/backups/mysql" -e BACKUP_DELAY=10)
cleanupid "$mysql0"
wait_for_synced "$mysql0"
sleep 1

sql "$mysql0" -u root -ppassword -e 'CREATE DATABASE `data` \
; USE `data` \
; CREATE TABLE `table` (`key` VARCHAR(255), `value` VARCHAR(255)) \
; INSERT INTO `table` (`key`, `value`) VALUES ("foo", "bar") \
;'

diag "Waiting for backup"
starttime=$(date +%s)
until [ -f "$backupdir/mysql.sql" ]; do
	[ $(date +%s) -gt $[ $starttime + 60 ] ] && break
	echo "# waiting"
	sleep 2
done
if [ -f "$backupdir/mysql.sql" ]; then
	ok "Found backups"
else
	fail "No backup found, failing test"
	exit 1
fi

cat "$backupdir/data.sql" | diag

diag "Destroying node0"
docker rm -vf "$mysql0" >/dev/null


diag "End of life for first node"

diag "Creating node 1"

mysql1=$(galera -v "$backupdir:/var/backups/mysql" -e BACKUP_DELAY=10)
cleanupid "$mysql1"
wait_for_synced "$mysql1"
wait_for "$mysql1" "restored" "Done restoring"
sleep 1

foo="$(sql "$mysql1" -u root -ppassword data -e 'select value from `table` where `key`="foo"' || true)"
if [ "$foo" = "bar" ]; then
	ok "Found foo = bar"
else
	fail "Expected foo = bar, found $foo"
	exit
fi

diag "Clean up"

docker run --rm -it -v "$(dirname "$backupdir"):/docker" busybox rm -rf "/docker/$(basename "$backupdir")" >/dev/null 2>/dev/null
exit 0
