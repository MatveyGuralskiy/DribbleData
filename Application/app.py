#---------------------------
#DribbleData Project
#Created by Matvey Guralskiy
#---------------------------

from flask import Flask, render_template
from flask_socketio import SocketIO
from players_service import players_service
from training_service import training_service
from auth_chat_service import auth_chat_service, socketio

app = Flask(__name__)
app.secret_key = 'supersecretkey'

socketio.init_app(app)

app.register_blueprint(players_service)
app.register_blueprint(training_service)
app.register_blueprint(auth_chat_service)

@app.route('/')
def home():
    return render_template('index.html')

if __name__ == '__main__':
    socketio.run(app, debug=True)