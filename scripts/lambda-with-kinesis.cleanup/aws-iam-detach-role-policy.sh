aws iam detach-role-policy \
	--role-name lambda-kinesis-role \
	--policy-arn arn:aws:iam::aws:policy/service-role/AWSLambdaKinesisExecutionRole
