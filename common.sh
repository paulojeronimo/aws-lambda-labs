#!/usr/bin/env bash

print-step() {
	local count=${count:-$1}
	local step=${step:-$2}
	printf -- '---- Step %02d ----\n' $count
	echo -n "$ "
	cat "$BASE_DIR"/steps/$step
}

run-step() {
	print-step
	source "$BASE_DIR"/steps/$step
	sleep 1
}

for-each-step() {
	local fn=${1:-}
	local count=1
	[ "$fn" ] || {
		echo "For each step what do I need to do?"
		return 1
	}
	while read step
	do
		! [ "$fn" ] || $fn
		echo
		(( ++count ))
	done < <(grep -v -e '^#' -e '^$' "$BASE_DIR"/steps/order.txt)
}
