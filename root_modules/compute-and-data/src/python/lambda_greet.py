import boto3
import uuid
import json
import os
from datetime import datetime, timezone

REGION = os.environ.get('REGION')
TABLE_NAME = os.environ.get('TABLE_NAME')
TOPIC_ARN = os.environ.get('TOPIC_ARN')
TOPIC_REGION = os.environ.get('TOPIC_REGION')

dynamodb = boto3.resource('dynamodb', region_name=REGION)
sns = boto3.client('sns', region_name=TOPIC_REGION)

# {"email": "your_email@example.com",
# "source": "Lambda",
# "region": "the_executing_region",
# “repo”: “https://github.com/{user}/aws-assessment”}

def lambda_handler(event, context):
  user_email = event.get('email', 'kyrillosgr@live.com')
  repo_url = event.get('repo', 'https://github.com/gkyrillos/aws-assessment')

  try:
    table = dynamodb.Table(TABLE_NAME)
    item = {
      'id': str(uuid.uuid4()),
      'message': f'Using Lambda to test the /greet route from region {REGION}!',
      'timestamp': datetime.now(timezone.utc).isoformat(),
      'email': user_email
    }
    table.put_item(Item=item)

    verification_payload = {
      "email": user_email,
      "source": "Lambda",
      "region": REGION,
      "repo": repo_url
    }
    sns.publish(
      TopicArn=TOPIC_ARN,
      Subject="Candidate Verification",
      Message=json.dumps(verification_payload)
    )
    return {
      'statusCode': 200,
      'headers': {'Content-Type': 'application/json'},
      'body': json.dumps({
        'status': 'OK',
        'region': REGION
      })
    }

  except Exception as e:
    print(f"Error occured: {str(e)}")
    return {
      'statusCode': 500,
      'body': json.dumps({
        'error': json.dumps(str(e))
      })
    }
