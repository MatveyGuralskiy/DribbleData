#---------------------------
#DribbleData Project
#Created by Matvey Guralskiy
#---------------------------
 
from flask import Flask, render_template, redirect, url_for
import boto3
import os
from dotenv import load_dotenv

dotenv_path = os.path.join(os.path.dirname(__file__), '../.env')
load_dotenv(dotenv_path)

app = Flask(__name__)

s3 = boto3.client('s3')
bucket_name = 'dribbledata-project'

@app.route('/training', methods=['GET'])
def get_training_videos():
    response = s3.list_objects_v2(Bucket=bucket_name)
    videos = [obj['Key'] for obj in response.get('Contents', []) if obj['Key'].endswith('.mp4')]
    return render_template('training.html',         
        base_url_service_1=os.getenv('BASE_URL_SERVICE_1'),
        base_url_service_2=os.getenv('BASE_URL_SERVICE_2'),
        base_url_service_3=os.getenv('BASE_URL_SERVICE_3'),
        base_url_service_4=os.getenv('BASE_URL_SERVICE_4'), videos=videos, bucket_name=bucket_name)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5002)
