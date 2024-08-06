#---------------------------
#DribbleData Project
#Created by Matvey Guralskiy
#---------------------------
from flask import Flask, render_template, redirect, url_for

app = Flask(__name__)

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/overview')
def overview():
    return redirect(url_for('index'))

if __name__ == '__main__':
    app.run(port=5000)
