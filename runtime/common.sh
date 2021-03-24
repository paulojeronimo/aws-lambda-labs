#!/usr/bin/env bash

source ./config.sh 2>&- || source ./config.sample.sh

set-steps() {
	local cleanup_steps=${cleanup_steps:-false}
	[ "${1:-}" ] || {
		echo "Which steps to follow?"
		exit 1
	}
	steps=$1
	! $cleanup_steps || steps=$steps.cleanup
	steps_file="$LABS_DIR"/steps/$steps.txt
	[ -f "$steps_file" ] || {
		echo "File \"$steps_file\" was not found!"
		exit 1
	}
	set_steps_called=true
}

initialize-default-options() {
	debug=${DEBUG:-false}
	set_steps_called=false
	steps=${steps:-$DEFAULT_STEPS}
	steps_file="$LABS_DIR"/steps/$steps.txt
	cd "$LABS_DIR"
}

after-process-default-options() {
	echo -e "Steps file: $steps_file\n"
}

after-process-cleanup-options() {
	$set_steps_called || set-steps $steps
	after-process-default-options
}

initialize-cleanup-options() {
	initialize-default-options
	cleanup_needed=false
	[ ! -f .cleanup_needed ] || cleanup_needed=true
	cleanup_forced=false
	cleanup_steps=true
	exit_on_error=false
	check_process_options_fn=check-cleanup-options
	after_process_options_fn=after-process-cleanup-options
}

check-cleanup-options() {
	case "$1" in
		-f|--forced) cleanup_forced=true;;
		-s|--steps)
			shift
			set-steps $1
			;;
	esac
}

check-default-options() {
	case "$1" in
		-s|--steps)
			shift
			set-steps $1
			;;
	esac
}

process-options() {
	local before_process_options_fn=${before_process_options_fn:-initialize-default-options}
	local check_process_options_fn=${check_process_options_fn:-check-default-options}
	local after_process_options_fn=${after_process_options_fn:-after-process-default-options}

	$before_process_options_fn
	while [ "${1:-}" ] 
	do
		$check_process_options_fn "$@"
		shift
	done
	! [ "$after_process_options_fn" ] || $after_process_options_fn
}

process-cleanup() {
	if $cleanup_forced || $cleanup_needed
	then
		for-each-step perform-step
		rm -f "$LABS_DIR"/.cleanup_needed
	else
		echo "Clean up is not needed!"
	fi
}

print-step() {
	local count=${count:-$1}
	local step=${step:-$2}

	printf -- '---- Step %02d ----\n' $count
	cat "$LABS_DIR"/scripts/$steps/$step
}

perform-step() {
	local error=`mktemp`
	local exit_on_error=${exit_on_error:-true}

	print-step
	if ! source "$LABS_DIR"/scripts/$steps/$step 2> $error
	then
		cat $error
		! $exit_on_error || exit 1
	fi
	sleep $SLEEP_TIME_BETWEEN_STEPS
}

for-each-step() {
	local fn=${1:-}
	local steps=${steps:-$DEFAULT_STEPS}
	local steps_file=${steps_file:-"$LABS_DIR"/steps/$steps.txt}
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
	! [ "$fn" = perform-step ] || touch "$LABS_DIR"/.cleanup_needed
}
