uuid_file=build/lambda-with-kinesis/uuid; \
! [ -f $uuid_file ] || aws lambda delete-event-source-mapping --uuid `cat $uuid_file`
