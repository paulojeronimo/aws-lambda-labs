#!/usr/bin/env bash
set -eou pipefail
BASE_DIR=`cd "$(dirname "$0")"; pwd`
cd "$BASE_DIR"

cleanup_needed=false
[ ! -f .cleanup_needed ] || cleanup_needed=true

cleanup_forced=false
case "${1:-}" in
	-f|--forced) cleanup_forced=true
esac

if $cleanup_forced || $cleanup_needed
then
	rm -rf build
	source ./steps/aws-iam-detach-role-policy.sh || :
	source ./steps/aws-iam-delete-role.sh || :
	source ./steps/aws-lambda-delete-function.sh || :
	rm -f .cleanup_needed
else
	echo "Clean up is not needed!"
fi
