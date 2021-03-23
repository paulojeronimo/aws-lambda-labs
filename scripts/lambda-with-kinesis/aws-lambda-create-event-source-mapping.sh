aws lambda create-event-source-mapping \
	--function-name ProcessKinesisRecords \
	--event-source  arn:aws:kinesis:$awsRegion:$IAM:stream/lambda-stream \
	--batch-size 100 \
	--starting-position LATEST
