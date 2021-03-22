#!/usr/bin/env bash
set -eou pipefail
BASE_DIR=`cd "$(dirname "$0")"; pwd`
cd "$BASE_DIR"

source ./common.sh

cleanup_needed=false; [ ! -f .cleanup_needed ] || cleanup_needed=true
debug=${DEBUG:-false}
cleanup_forced=false
exit_on_error=false
steps=runtime-tutorial

while [ "${1:-}" ] 
do
	case "${1:-}" in
		-f|--forced) cleanup_forced=true;;
		-s|--steps)
			shift
			[ "${1:-}" ] || {
				echo "Which steps to follow (without \".cleanup.txt\" extension)?"
				exit 1
			}
			steps=$1
			steps_file="$BASE_DIR"/steps/$steps.cleanup.txt
			[ -f "$steps_file" ] || {
				echo "File \"$steps_file\" was not found!"
				exit 1
			}
			;;
	esac
	shift
done

steps=$steps.cleanup

if $cleanup_forced || $cleanup_needed
then
	for-each-step run-step
	rm -f "$BASE_DIR"/.cleanup_needed
else
	echo "Clean up is not needed!"
fi
