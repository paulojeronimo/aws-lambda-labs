#!/usr/bin/env bash
set -eou pipefail
BASE_DIR=`cd "$(dirname "$0")"; pwd`
cd "$BASE_DIR"

source ./common.sh

init_fn=initialize-cleanup-options

process-options "$@"
process-cleanup
