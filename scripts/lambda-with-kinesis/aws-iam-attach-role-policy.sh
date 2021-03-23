aws iam attach-role-policy \
	--role-name lambda-kinesis-role \
	--policy-arn arn:aws:iam::aws:policy/service-role/AWSLambdaKinesisExecutionRole &&
sleep 4
