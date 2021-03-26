#!/usr/bin/env bash

source ./check-bin.sh

aws() {
    local aws_bin=$(which aws)
    if $AWS_CLI_USE_PROFILE
    then
		! $AWS_CLI_PRINT_CMDS || set -x
        $aws_bin "$@" --profile "$AWS_CLI_PROFILE"
		{ set +x; } 2> /dev/null
    else
		! $AWS_CLI_PRINT_CMDS || set -x
        $aws_bin "$@"
		{ set +x; } 2> /dev/null
    fi
}

AWS_CLI_USE_PROFILE=${AWS_CLI_USE_PROFILE:-false}
AWS_CLI_PROFILE=${AWS_PROFILE:-someprofile}
AWS_CLI_PRINT_CMDS=${AWS_CLI_PRINT_CMDS:-true}

check-bin jq

env='.stages.dev.environment_variables'
bucket=`jq -r $env.BUCKET_NAME .chalice/config.json`
stream_name=`jq -r $env.STREAM_NAME .chalice/config.json`
build_dir=build

mkdir -p $build_dir
