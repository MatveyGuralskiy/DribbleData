#---------------------------
#DribbleData Project
#Created by Matvey Guralskiy
#---------------------------
from flask import Flask, render_template, redirect, url_for
import os

app = Flask(__name__)

@app.route('/')
def index():
    return render_template('index.html',
        base_url_service_1=os.getenv('BASE_URL_SERVICE_1'),
        base_url_service_2=os.getenv('BASE_URL_SERVICE_2'),
        base_url_service_3=os.getenv('BASE_URL_SERVICE_3'),
        base_url_service_4=os.getenv('BASE_URL_SERVICE_4'))

@app.route('/overview')
def overview():
    return redirect(url_for('index'))

if __name__ == '__main__':
    app.run(port=5000)
