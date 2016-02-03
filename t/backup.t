#!/bin/bash
set -euo pipefail
source t/utils

galera mysql-1 -e MYSQL_ROOT_PASSWORD=password -v $PWD/backups:/var/backups/mysql -e BACKUP_DELAY=10 >/dev/null

wait_for_synced mysql-1

sleep 1

version="$(sql mysql-1 -u root -ppassword -e 'SELECT @@VERSION;' || true)"

if [ -z "$version" ]; then
	fail "Version not found, failing container"
	exit 1
else
	ok "Version $version"
fi

echo "Waiting for backup"
starttime=$(date +%s)
until [ -f backups/mysql.sql ]; do
	[ $(date +%s) -gt $[ $starttime + 60 ] ] && break
	echo "# waiting"
	sleep 2
done
if [ -f backups/mysql.sql ]; then
	ok "Found backups"
	docker run --rm -it -v $PWD:/docker busybox rm -rf /docker/backups
else
	fail "No backup found, failing test"
	exit 1
fi


docker rm -vf mysql-1 >/dev/null
exit 0
