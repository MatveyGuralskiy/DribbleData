#---------------------------
# DribbleData Project
# Created by Matvey Guralskiy
#---------------------------
from flask import Flask, request, jsonify, render_template, redirect, url_for
from flask_bcrypt import Bcrypt
from flask_login import LoginManager, UserMixin, login_user, logout_user, login_required, current_user
from flask_socketio import SocketIO, emit
import boto3
from boto3.dynamodb.conditions import Key
import uuid
from datetime import datetime
import pytz
from dotenv import load_dotenv
import os

load_dotenv()

app = Flask(__name__)
app.config['SECRET_KEY'] = os.getenv('SECRET_KEY')
app.config['SESSION_COOKIE_SECURE'] = os.getenv('SESSION_COOKIE_SECURE') == 'True'
app.config['SESSION_COOKIE_HTTPONLY'] = os.getenv('SESSION_COOKIE_HTTPONLY') == 'True'
app.config['SESSION_COOKIE_SAMESITE'] = os.getenv('SESSION_COOKIE_SAMESITE')
bcrypt = Bcrypt(app)
socketio = SocketIO(app, cors_allowed_origins="*", manage_session=True)
login_manager = LoginManager()
login_manager.init_app(app)
login_manager.login_view = 'login'

# Initialize DynamoDB resource using DAX endpoint
dax_endpoint = os.getenv('DAX_ENDPOINT')
dynamodb = boto3.resource('dynamodb', region_name='us-east-1', endpoint_url=dax_endpoint)
users_table = dynamodb.Table('Users')
messages_table = dynamodb.Table('Messages')

class User(UserMixin):
    def __init__(self, user_id, username):
        self.id = user_id
        self.username = username

@login_manager.user_loader
def load_user(user_id):
    try:
        response = users_table.get_item(Key={'UserID': user_id})
        user = response.get('Item', None)
        if user:
            return User(user_id=user['UserID'], username=user['Username'])
    except Exception as e:
        print(f"Error loading user: {e}")
    return None

@app.route('/')
def overview():
    if current_user.is_authenticated:
        return redirect(url_for('chat'))
    return redirect(url_for('login'))

@app.route('/register', methods=['GET', 'POST'])
def register():
    if request.method == 'POST':
        data = request.get_json()
        username = data.get('username')
        password = data.get('password')
        if not username or not password:
            return jsonify({'error': 'Username and password are required'}), 400

        user_id = str(uuid.uuid4())
        hashed_password = bcrypt.generate_password_hash(password).decode('utf-8')

        try:
            users_table.put_item(Item={
                'UserID': user_id,
                'Username': username,
                'Password': hashed_password
            })
            return jsonify({'message': 'User registered successfully'}), 201
        except Exception as e:
            return jsonify({'error': str(e)}), 500

    return render_template('register.html')

@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        data = request.get_json()
        username = data.get('username')
        password = data.get('password')
        if not username or not password:
            return jsonify({'error': 'Username and password are required'}), 400

        try:
            response = users_table.scan(FilterExpression=Key('Username').eq(username))
            items = response.get('Items', [])
            if not items:
                return jsonify({'error': 'Invalid username or password'}), 401

            user = items[0]
            if bcrypt.check_password_hash(user.get('Password', ''), password):
                login_user(User(user_id=user['UserID'], username=user['Username']))
                return jsonify({'message': 'Login successful'}), 200
            else:
                return jsonify({'error': 'Invalid username or password'}), 401
        except Exception as e:
            return jsonify({'error': str(e)}), 500

    return render_template('login.html')

@app.route('/logout')
@login_required
def logout():
    logout_user()
    return redirect(url_for('login'))

@app.route('/chat')
@login_required
def chat():
    return render_template('chat.html', username=current_user.username)

@app.route('/get_messages')
@login_required
def get_messages():
    try:
        response = messages_table.scan()
        messages = response.get('Items', [])
        messages = sorted(messages, key=lambda x: x['Timestamp'])
    except Exception as e:
        return jsonify({'error': str(e)}), 500

    return jsonify({'messages': messages})

@socketio.on('send_message')
def handle_message(data):
    if current_user.is_authenticated:
        username = current_user.username
    else:
        username = 'Anonymous'
    
    message = data.get('message')
    if not message:
        emit('error', {'error': 'Message is required'})
        return
    
    tz = pytz.timezone('Asia/Jerusalem')
    timestamp = datetime.now(tz).isoformat()
    
    message_id = str(uuid.uuid4())
    try:
        messages_table.put_item(Item={
            'MessageID': message_id,
            'Username': username,
            'Message': message,
            'Timestamp': timestamp
        })
        emit('receive_message', {
            'username': username,
            'message': message,
            'timestamp': timestamp
        }, broadcast=True)
    except Exception as e:
        print(f"Error saving message: {e}")
        emit('error', {'error': str(e)})

if __name__ == '__main__':
    socketio.run(app, debug=True)
