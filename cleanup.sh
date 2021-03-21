#!/usr/bin/env bash
set -eou pipefail
BASE_DIR=`cd "$(dirname "$0")"; pwd`
cd "$BASE_DIR"

rm -rf build

source ./steps/aws-lambda-delete-function.sh || :
