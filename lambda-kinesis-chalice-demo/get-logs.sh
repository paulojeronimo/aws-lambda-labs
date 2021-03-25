#!/usr/bin/env bash
set -eou pipefail
BASE_DIR=`cd "$(dirname "$0")"; pwd`
cd "$BASE_DIR"

chalice logs --follow -n handle_kinesis_record
