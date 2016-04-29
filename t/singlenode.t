#!/bin/bash
set -euo pipefail
source t/utils

mysql1=$(galera -e MYSQL_ROOT_PASSWORD=password)
cleanupid "$mysql1"

wait_for_synced "$mysql1"

sleep 1

version="$(sql "$mysql1" -u root -ppassword -e 'SELECT @@VERSION;' || true)"

if [ -z "$version" ]; then
	fail "Version not found, failing container"
	exit 1
else
	ok "Version $version"
fi

exit 0
