aws iam create-role \
	--role-name lambda-kinesis-role \
	--assume-role-policy-document file://trust-policy.json
