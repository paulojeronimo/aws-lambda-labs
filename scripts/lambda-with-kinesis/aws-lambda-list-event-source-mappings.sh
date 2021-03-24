aws lambda list-event-source-mappings \
	--function-name ProcessKinesisRecords \
	--event-source arn:aws:kinesis:$awsRegion:$IAM:stream/lambda-stream |
	jq -r '.EventSourceMappings[0].UUID' > uuid
