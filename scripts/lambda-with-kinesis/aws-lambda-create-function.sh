aws lambda create-function \
	--function-name ProcessKinesisRecords \
	--zip-file fileb://function.zip \
	--handler index.handler \
	--runtime nodejs12.x \
	--role arn:aws:iam::$IAM:role/lambda-kinesis-role
