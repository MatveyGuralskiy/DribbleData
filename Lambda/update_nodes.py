#---------------------------
# DribbleData Project
# Created by Matvey Guralskiy
#---------------------------
# Before You Archive this script RENAME him to 'index.py'

import boto3

# Initialize the Boto3 clients
ec2_client = boto3.client('ec2')
ssm_client = boto3.client('ssm')

# Define the tag to search for
tag_key = 'eks:cluster-name'
tag_value = 'EKS-Dribbledata'

def get_instance_ids_with_tag(tag_key, tag_value):
    """Retrieve the instance IDs with a specific tag."""
    instances = ec2_client.describe_instances(
        Filters=[
            {
                'Name': f'tag:{tag_key}',
                'Values': [tag_value]
            }
        ]
    )
    
    instance_ids = []
    for reservation in instances['Reservations']:
        for instance in reservation['Instances']:
            instance_ids.append(instance['InstanceId'])
    
    return instance_ids

def is_instance_ready(instance_id):
    """Check if the instance is in a running state."""
    instance = ec2_client.describe_instances(InstanceIds=[instance_id])
    state = instance['Reservations'][0]['Instances'][0]['State']['Name']
    return state == 'running'

def update_packages_on_instance(instance_id):
    """Update all packages and install all available updates on the instance."""
    # Command for Amazon Linux 2
    command = (
        "sudo yum update -y && "
        "sudo yum upgrade -y"
    )

    # Send command via SSM
    response = ssm_client.send_command(
        InstanceIds=[instance_id],
        DocumentName='AWS-RunShellScript',
        Parameters={'commands': [command]},
    )
    return response

def lambda_handler(event, context):
    """Lambda function handler."""
    try:
        # Get instance IDs
        instance_ids = get_instance_ids_with_tag(tag_key, tag_value)

        # Update packages on each instance
        for instance_id in instance_ids:
            if is_instance_ready(instance_id):
                response = update_packages_on_instance(instance_id)
                print(f"Update command sent to instance {instance_id}. Response: {response}")
            else:
                print(f"Instance {instance_id} is not in a running state.")
                
        return {
            'statusCode': 200,
            'body': 'Commands sent successfully'
        }
    
    except Exception as e:
        print(f"Error: {str(e)}")
        return {
            'statusCode': 500,
            'body': f'Error: {str(e)}'
        }