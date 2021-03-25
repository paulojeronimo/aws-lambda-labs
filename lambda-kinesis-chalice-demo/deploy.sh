#!/usr/bin/env bash
set -eou pipefail
BASE_DIR=`cd "$(dirname "$0")"; pwd`
cd "$BASE_DIR"

./aws-setup.sh 'done' || ./aws-setup.sh

chalice deploy
