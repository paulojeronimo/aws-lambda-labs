aws iam create-role \
	--role-name lambda-role \
	--assume-role-policy-document file://trust-policy.json
