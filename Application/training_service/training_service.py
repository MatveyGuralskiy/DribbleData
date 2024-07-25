#---------------------------
#DribbleData Project
#Created by Matvey Guralskiy
#---------------------------
 
from flask import Blueprint, render_template
import boto3

training_service = Blueprint('training_service', __name__)

@training_service.route('/training')
def get_training_videos():
    s3 = boto3.client('s3')
    bucket_name = 'your-s3-bucket-name'
    response = s3.list_objects_v2(Bucket=bucket_name)
    videos = response.get('Contents', [])
    return render_template('training.html', videos=videos, bucket_name=bucket_name)