#---------------------------
#DribbleData Project
#Created by Matvey Guralskiy
#---------------------------

from flask import Blueprint, render_template, request, redirect, url_for, session
from flask_socketio import SocketIO, emit

auth_chat_service = Blueprint('auth_chat_service', __name__)
socketio = SocketIO()

@auth_chat_service.route('/register', methods=['GET', 'POST'])
def register():
    if request.method == 'POST':
        username = request.form['username']
        password = request.form['password']
        return redirect(url_for('auth_chat_service.login'))
    return render_template('register.html')

@auth_chat_service.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        username = request.form['username']
        password = request.form['password']
        return redirect(url_for('auth_chat_service.chat'))
    return render_template('login.html')

@auth_chat_service.route('/chat')
def chat():
    if 'username' not in session:
        return redirect(url_for('auth_chat_service.login'))
    return render_template('chat.html', username=session['username'])

@socketio.on('message')
def handle_message(data):
    emit('message', data, broadcast=True)
