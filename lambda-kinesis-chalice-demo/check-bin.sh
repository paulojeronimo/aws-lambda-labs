#!/usr/bin/env bash

check-bin() {
	local env_ok=true
	for bin in $@
	do
		type -P $bin &> /dev/null || {
			echo "\"$bin\" not found in your PATH!"
			env_ok=false
		}
	done
	$env_ok
}
