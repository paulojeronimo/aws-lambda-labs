#!/usr/bin/env bash
set -eou pipefail
BASE_DIR=`cd "$(dirname "$0")"; pwd`
DEBUG=${DEBUG:-false}
cd "$BASE_DIR"

! $DEBUG ||
	echo "$0 $@ called!"

source ./common.sh

setup_done=$build_dir/aws-setup.done
bucket_files_dir=$build_dir/bucket-files

generate-bucket-files() {
	mkdir -p $bucket_files_dir
	for key in {01..10}
	do
		echo "{ \"key\": \"$key\", \"value\": \"value $key\" }" \
			> $bucket_files_dir/$key.json
	done
}

upload-files-to-bucket() {
	[ -d $bucket_files_dir ] || generate-bucket-files
	aws s3 sync $bucket_files_dir s3://$bucket/
}

mkdir -p build
op=${1:-setup}
case "$op" in
	setup)
		set -x
		aws s3api create-bucket --bucket $bucket
		upload-files-to-bucket
		aws kinesis create-stream --stream-name $stream_name --shard-count 1
		touch "$setup_done"
		;;
	'done')
		[ -f "$setup_done" ] || exit 1
		;;
	reverse)
		set -x +e
		aws s3 rm s3://$bucket --recursive
		aws s3api delete-bucket --bucket $bucket
		aws kinesis delete-stream --stream-name $stream_name
		rm -f "$setup_done"
		;;
	upload-files-to-bucket)
		$op
esac
