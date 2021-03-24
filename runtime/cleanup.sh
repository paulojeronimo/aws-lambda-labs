#!/usr/bin/env bash
set -eou pipefail
BASE_DIR=`cd "$(dirname "$0")"; pwd`
cd "$BASE_DIR"

source ./common.sh

before_process_options_fn=initialize-cleanup-options

process-options "$@"
process-cleanup
