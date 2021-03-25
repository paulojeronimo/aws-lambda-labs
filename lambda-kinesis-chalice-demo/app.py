from chalice import Chalice, Response
import boto3
import os
import json

app = Chalice(app_name='lambda-kinesis-chalice-demo')
app.debug = True

BUCKET_NAME = os.environ['BUCKET_NAME']
STREAM_NAME = os.environ['STREAM_NAME']

s3_client = boto3.client('s3')


def change_value_in_json_file(json_file, new_value):
    app.log.debug(f'TODO: change the current value in "{json_file}" to "{new_value}" ...')


@app.on_kinesis_record(stream=STREAM_NAME, starting_position='LATEST')
def handle_kinesis_record(event):
    for record in event:
        app.log.info("Record received: %s", record.data)
        json_data = json.loads(record.data)
        json_file = json_data['key'] + '.json'
        new_value = json_data['value']
        tmp_json_file = f'/tmp/{json_file}'
        try:
            s3_client.download_file(BUCKET_NAME, json_file, tmp_json_file)
        except Exception as e:
            app.log.error(f'An error occurred while getting "{json_file}" from "{BUCKET_NAME}"!')
            return
        app.log.info(f'File "{json_file}" found!')
        change_value_in_json_file(tmp_json_file, new_value)
