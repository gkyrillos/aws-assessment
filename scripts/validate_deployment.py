import boto3
import requests
import sys
import os
import time
import argparse

parser = argparse.ArgumentParser(description='AWS validation script')
parser.add_argument('--client-id', dest='client_id', help='Cognito user pool client ID', required=False)
parser.add_argument('--api-gw-url', dest='api_gw_url', help='Api-gateway URL', required=False)
parser.add_argument('--username', dest='username', help='The username for authentication', required=False)
parser.add_argument('--cognito-region', dest='cognito_region', help='The region Cognito is deployed into', required=False)
args = parser.parse_args()

USERNAME = args.username or 'gkyrillos'
COGNITO_REGION = args.cognito_region or 'us-east-1'
USER_POOL_CLIENT_ID = args.client_id or os.environ.get('USER_POOL_CLIENT_ID')
API_GATEWAY_URL = args.api_gw_url or os.environ.get('API_GATEWAY_URL')
PARAMETER_NAME = f"/cognito/{USERNAME}/password"

try:
  session = boto3.Session(profile_name='gkyrillos')
except Exception:
  session = boto3.Session()

def get_ssm_password(username):
  try:
    print(f"Trying to get the ssm password for {username}")
    start_time = time.perf_counter()
    ssm = session.client('ssm', region_name=COGNITO_REGION)
    response = ssm.get_parameter(Name=PARAMETER_NAME, WithDecryption=True)
    end_time = time.perf_counter()
    print(f"Password for user {username} retrieved successfully and it took {(end_time - start_time)*1000:.1f}ms")
    return response['Parameter']['Value']
  except Exception as e:
    print(f"get_ssm_parameter error: {str(e)}")
    sys.exit(1)

def get_id_token(username, password):
  try:
    print(f"Getting the ID token for user {username}")
    start_time = time.perf_counter()
    client = session.client('cognito-idp', region_name=COGNITO_REGION)
    response = client.initiate_auth(
      ClientId=USER_POOL_CLIENT_ID,
      AuthFlow='USER_PASSWORD_AUTH',
      AuthParameters={
        'USERNAME': username,
        'PASSWORD': password
      }
    )
    end_time = time.perf_counter()
    print(f"Token for user {username} retrieved successfully and it took {(end_time - start_time)*1000:.1f}ms")
    return response['AuthenticationResult']['IdToken']
  except Exception as e:
    print(f"get_jwt error: {str(e)}")
    sys.exit(1)

def hit_route(route, token):
  try:
    headers = {
      'Authorization': f"Bearer {token}",
      'Content-Type': 'application/json'
    }
    payload = {"message": "Hello from my github pipeline"}
    url = f"{API_GATEWAY_URL}/{route}"
    print(f"Trying to hit route {url}")
    start_time = time.perf_counter()
    response = requests.post(url, json=payload, headers=headers)
    end_time = time.perf_counter()

    if response.status_code == 200:
      print(f"I hit {url} successfully and it took {(end_time - start_time)*1000:.1f}ms")
      print(response.text)
      return True
    else:
      print(f"API error: {response.status_code}")
      print(response.text)
      return False
  except Exception as e:
    print(f"hit_greet error: {str(e)}")

def validate():
  routes = ['greet', 'dispatch']
  all_passed = True
  password = get_ssm_password(USERNAME)
  token = get_id_token(USERNAME, password)

  for route in routes:
    success = hit_route(route, token)
    if not success:
      all_passed = False
  if not all_passed:
    print("Validation failed")
    sys.exit(1)
  print("Validation succeeded")


if __name__ == "__main__":
  validate()
