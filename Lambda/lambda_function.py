import boto3
from datetime import datetime, timedelta
from dateutil import parser, tz

def lambda_handler(event, context):
    dynamodb = boto3.resource('dynamodb', region_name='us-east-1')
    table = dynamodb.Table('Messages')
    
    utc_zone = tz.UTC
    now = datetime.utcnow().replace(tzinfo=utc_zone)
    # For every 5 minutes cutoff_time = now - timedelta(minutes=5)
    cutoff_time = now - timedelta(hours=24)
    
    response = table.scan()
    items = response.get('Items', [])
    
    for item in items:
        message_time = item['Timestamp']
        
        message_datetime = parser.isoparse(message_time)
        
        if message_datetime < cutoff_time:
            table.delete_item(
                Key={
                    'MessageID': item['MessageID']
                }
            )
    
    return {
        'statusCode': 200,
        'body': 'Old messages deleted successfully'
    }
