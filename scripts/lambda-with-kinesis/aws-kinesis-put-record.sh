aws kinesis put-record \
	--stream-name lambda-stream \
	--partition-key 1 \
	--data "Hello, this is a test from aws-lambda-labs at `date +%T`."
