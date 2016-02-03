#!/bin/bash
set -euo pipefail
source t/utils

galera mysql-1 -e MYSQL_ROOT_PASSWORD=password >/dev/null

wait_for_synced mysql-1

#wait_for_ready mysql-1
sleep 1

version="$(sql mysql-1 -u root -ppassword -e 'SELECT @@VERSION;' || true)"

if [ -z "$version" ]; then
	fail "Version not found, failing container"
	exit 1
else
	ok "Version $version"
fi

docker rm -vf mysql-1 >/dev/null
exit 0
