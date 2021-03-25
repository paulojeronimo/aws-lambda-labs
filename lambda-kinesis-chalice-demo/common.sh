#!/usr/bin/env bash

AWS_CLI_USE_PROFILE=${AWS_CLI_USE_PROFILE:-false}
AWS_CLI_PROFILE=${AWS_PROFILE:-someprofile}

env='.stages.dev.environment_variables'
bucket=`jq -r $env.BUCKET_NAME .chalice/config.json`
stream_name=`jq -r $env.STREAM_NAME .chalice/config.json`
build_dir=build
mkdir -p $build_dir

aws() {
    local aws_bin=$(which aws)
    if $AWS_CLI_USE_PROFILE
    then
        $aws_bin "$@" --profile "$AWS_CLI_PROFILE"
    else
        $aws_bin "$@"
    fi
}
