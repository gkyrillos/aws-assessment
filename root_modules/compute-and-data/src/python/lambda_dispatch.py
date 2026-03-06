import boto3
import os
import json

ecs = boto3.client('ecs')

def lambda_handler(event, context):
    response = ecs.run_task(
        cluster=os.environ['CLUSTER_NAME'],
        taskDefinition=os.environ['TASK_DEFINITION_ARN'],
        launchType='FARGATE',
        networkConfiguration={
            'awsvpcConfiguration': {
                'subnets': [os.environ['SUBNET_ID']],
                'securityGroups': [os.environ['SECURITY_GROUP_ID']],
                'assignPublicIp': 'ENABLED'
            }
        }
    )
    return {
        'statusCode': 200,
        'body': json.dumps({'message': 'ECS Task Dispatched', 'taskArn': response['tasks'][0]['taskArn']})
    }
