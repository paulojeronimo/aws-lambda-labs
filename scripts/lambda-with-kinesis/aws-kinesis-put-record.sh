aws kinesis put-record \
	--stream-name lambda-stream \
	--partition-key 1 \
	--cli-binary-format raw-in-base64-out \
	--data "Hello, this is a test from aws-lambda-labs at `date +%T`."
