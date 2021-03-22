#!/usr/bin/env bash

print-step() {
	local count=${count:-$1}
	local step=${step:-$2}

	printf -- '---- Step %02d ----\n' $count
	echo -n "$ "
	cat "$BASE_DIR"/scripts/$step
}

run-step() {
	local error=`mktemp`
	local exit_on_error=${exit_on_error:-true}

	print-step
	if ! source "$BASE_DIR"/scripts/$step 2> $error
	then
		cat $error
		! $exit_on_error || exit 1
	fi
	sleep 1
}

for-each-step() {
	local fn=${1:-}
	local steps=${steps:-runtime-tutorial}
	local steps_file=${steps_file:-"$BASE_DIR"/steps/$steps.txt}
	local debug=${debug:-false}
	local count=1

	! $debug ||
		echo "Line $LINENO in commons.sh: steps_file=$steps_file"
	[ "$fn" ] || {
		echo "For each step what do I need to do?"
		return 1
	}
	type $fn &> /dev/null || {
		echo "Function \"$fn\" is undefined!"
		return 1
	}
	while IFS= read -r step
	do
		! [ "$fn" ] || $fn
		echo
		(( ++count ))
	done < <(grep -v -e '^#' -e '^$' "$steps_file")
}
