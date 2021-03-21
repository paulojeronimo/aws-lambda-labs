#!/usr/bin/env bash
set -eou pipefail
BASE_DIR=`cd "$(dirname "$0")"; pwd`
cd "$BASE_DIR"

source config.sh 2>&- || source config.sample.sh

./cleanup.sh

mkdir -p build && cd $_
current_dir="."
while read step
do
	cd "$BASE_DIR/build/$current_dir"
	echo -n "$ "
	cat "$BASE_DIR"/steps/$step
	source "$BASE_DIR"/steps/$step
	current_dir=${PWD##$BASE_DIR/build}
	current_dir=${current_dir#/}
done < "$BASE_DIR"/steps/order.txt
