#!/usr/bin/env bash
set -eou pipefail
BASE_DIR=`cd "$(dirname "$0")"; pwd`
cd "$BASE_DIR"

source ./common.sh

check-bin chalice

chalice_delete_log=`mktemp`
(
	set -e

	echo "Deleting the application from AWS ..."
	chalice delete 2> $chalice_delete_log || {
		echo "There was some problem when calling 'chalice delete'."
		echo "Read the file \"$chalice_delete_log\""
	}
)

case "${1:-}" in
	-a|--all) ./aws-setup.sh undo
esac
