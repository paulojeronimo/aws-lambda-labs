#!/usr/bin/env bash
set -eou pipefail
BASE_DIR=`cd "$(dirname "$0")"; pwd`
cd "$BASE_DIR"

source ./common.sh

message_template='{
	"key": "key",
	"value": "value"
}'
default_value="This is a message sent at `date +%T`."

case $# in
	0)
		key=01
		value=$default_value
		;;
	1)
		key=$1
		value=$default_value
		;;
	2)
		key=$1
		value=$2
		;;
	*)
		echo "Invalid number of arguments (should be 0, 1 or 2)!"
		exit 1
esac

message=`jq ".key=\"$key\" | .value=\"$value\"" <<< "$message_template"`

aws kinesis put-record \
	--stream-name $stream_name \
	--partition-key 1 \
	--cli-binary-format raw-in-base64-out \
	--data "$message"
