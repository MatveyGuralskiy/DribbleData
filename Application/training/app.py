#---------------------------
#DribbleData Project
#Created by Matvey Guralskiy
#---------------------------
 
from flask import Flask, render_template, redirect, url_for
import boto3

app = Flask(__name__)

s3 = boto3.client('s3')
bucket_name = 'dribbledata-project'

@app.route('/')
def overview():
    return redirect(url_for('training'))

@app.route('/training', methods=['GET'])
def get_training_videos():
    response = s3.list_objects_v2(Bucket=bucket_name)
    videos = [obj['Key'] for obj in response.get('Contents', []) if obj['Key'].endswith('.mp4')]
    return render_template('training.html', videos=videos, bucket_name=bucket_name)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5002)
