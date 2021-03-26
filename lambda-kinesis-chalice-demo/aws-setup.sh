#!/usr/bin/env bash
set -eou pipefail
BASE_DIR=`cd "$(dirname "$0")"; pwd`
cd "$BASE_DIR"

source ./common.sh

create-bucket-files-dir() {
	mkdir -p $bucket_files_dir
}

generate-bucket-files-locally() {
	local file

	create-bucket-files-dir
	echo "Generating some files in \"$bucket_files_dir\" ..."
	for key in {01..10}
	do
		file=$bucket_files_dir/$key.json
		echo "{ \"key\": \"$key\", \"value\": \"value $key\" }" > $file
		echo "File \"$file\" created!"
	done
}

upload-files-to-bucket() {
	echo "Uploading files in \"$bucket_files_dir\" to S3 bucket \"$bucket\" ..."
	[ -d $bucket_files_dir ] || generate-bucket-files-locally
	aws s3 sync $bucket_files_dir s3://$bucket/
}

create-bucket() {
	case "${1:-}" in
		undo)
			echo "Emptying the S3 bucket \"$bucket\" and removing it ..."
			aws s3 rm s3://$bucket --recursive
			aws s3api delete-bucket --bucket $bucket
			;;
		*)
			echo "Creating the S3 bucket \"$bucket\" and sending some files to it ..."
			aws s3api create-bucket --bucket $bucket
			upload-files-to-bucket
	esac
}

create-stream() {
	case "${1:-}" in
		undo)
			echo "Deleting the Kinesis stream \"$stream_name\" ..."
			aws kinesis delete-stream --stream-name $stream_name
			;;
		*)
			echo "Creating the Kinesis stream \"$stream_name\" ..."
			aws kinesis create-stream --stream-name $stream_name --shard-count 1
	esac
}

check-bin aws
aws_setup_done=$build_dir/aws-setup.done
bucket_files_dir=$build_dir/bucket-files
mkdir -p build
op=${1:-do}
case "$op" in
	do)
		echo "Setting up the AWS ..."
		create-bucket
		create-stream
		touch "$aws_setup_done"
		;;
	undo)
		echo "Undoing the setup of the AWS ..."
		set +e # <- this will force the script to continue if some aws command below fails
		create-bucket undo
		create-stream undo
		rm -f "$aws_setup_done"
		;;
	is-done)
		[ -f "$aws_setup_done" ] || exit 1
		;;
	*)
		if type $op &> /dev/null
		then
			echo "Calling \"$op\" ..."
			$op
		else
			echo "Operation \"\" is not valid!"
		fi
esac
