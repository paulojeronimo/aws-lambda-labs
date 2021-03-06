message="Hello \"$USER\"! This is a message from lab lambda-with-kinesis at `date +%T`" &&
message=`echo -n "$message" | base64` &&
cat > input.txt <<EOF
{
    "Records": [
        {
            "kinesis": {
                "kinesisSchemaVersion": "1.0",
                "partitionKey": "1",
                "sequenceNumber": "49590338271490256608559692538361571095921575989136588898",
                "data": "$message",
                "approximateArrivalTimestamp": 1545084650.987
            },
            "eventSource": "aws:kinesis",
            "eventVersion": "1.0",
            "eventID": "shardId-000000000006:49590338271490256608559692538361571095921575989136588898",
            "eventName": "aws:kinesis:record",
            "invokeIdentityArn": "arn:aws:iam::$IAM:role/lambda-kinesis-role",
            "awsRegion": "$awsRegion",
            "eventSourceARN": "arn:aws:kinesis:$awsRegion:$IAM:stream/lambda-stream"
        }
    ]
}
EOF
