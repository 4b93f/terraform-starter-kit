import boto3, os

sqs = boto3.client('sqs')
def handler(event, context):
    sqs.send_message(
        QueueUrl=os.environ["SQS_URL"],
        MessageBody="hello from lambda"
    )
    
    return {"statusCode": 200,"body": "Message sent to SQS queue"}
