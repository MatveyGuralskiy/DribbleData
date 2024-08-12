#---------------------------
# DribbleData Project
# Created by Matvey Guralskiy
#---------------------------

import boto3
import os

def lambda_handler(event, context):
    eks_client = boto3.client('eks')
    cluster_name = os.getenv('CLUSTER_NAME')
    nodegroup_name = os.getenv('NODEGROUP_NAME')
    
    response = eks_client.update_nodegroup_config(
        clusterName=cluster_name,
        nodegroupName=nodegroup_name,
        scalingConfig={
            'minSize': 1,
            'maxSize': 3,
            'desiredSize': 2
        }
    )
    
    return response