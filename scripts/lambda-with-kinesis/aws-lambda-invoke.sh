aws lambda invoke \
	--function-name ProcessKinesisRecords \
	--payload fileb://input.txt out.txt
