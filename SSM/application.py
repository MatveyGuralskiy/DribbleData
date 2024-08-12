#---------------------------
# DribbleData Project
# Created by Matvey Guralskiy
#---------------------------

import boto3
import os

ENV_FILE = "../Application/.env"

def upload_ssm_parameters(env_file):
    ssm_client = boto3.client('ssm', region_name='us-east-1')

    try:
        with open(env_file, 'r') as file:
            for line in file:
                if line.startswith('#'):
                    continue
                
                if '=' in line:
                    key, value = line.strip().split('=', 1)
                    if key and value:
                        ssm_client.put_parameter(
                            Name=f"/dribble-data/{key}",
                            Value=value,
                            Type="String",
                            Overwrite=True
                        )
                        print(f"Uploaded: {key} = {value}")
    except FileNotFoundError:
        print(f"Error: The file {env_file} was not found.")

if __name__ == "__main__":
    upload_ssm_parameters(ENV_FILE)