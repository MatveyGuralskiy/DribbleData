/*---------------------------
DribbleData Project
Created by Matvey Guralskiy
---------------------------*/

document.addEventListener('DOMContentLoaded', () => {
    // Fetch top 50 NBA players from the players microservice
    fetch('http://localhost:5000/top-50-players')
        .then(response => response.json())
        .then(data => {
            const playersList = document.getElementById('players-list');
            data.forEach(player => {
                const playerDiv = document.createElement('div');
                playerDiv.textContent = player.name;
                playersList.appendChild(playerDiv);
            });
        });

    // Fetch training videos from the videos microservice
    fetch('http://localhost:5002/training-videos')
        .then(response => response.json())
        .then(data => {
            const videosList = document.getElementById('videos-list');
            data.forEach(video => {
                const videoDiv = document.createElement('div');
                videoDiv.textContent = video;
                videosList.appendChild(videoDiv);
            });
        });

    // Registration form submission
    const registrationForm = document.getElementById('registration-form');
    registrationForm.addEventListener('submit', event => {
        event.preventDefault();
        const username = document.getElementById('username').value;
        const password = document.getElementById('password').value;
        fetch('http://localhost:5001/register', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({ username, password })
        })
            .then(response => response.json())
            .then(data => {
                alert(data.message);
            });
    });

    // Chat functionality
    const chatBox = document.getElementById('chat-box');
    const chatMessage = document.getElementById('chat-message');
    const sendMessage = document.getElementById('send-message');
    const socket = io('http://localhost:5001');

    sendMessage.addEventListener('click', () => {
        const message = chatMessage.value;
        socket.emit('message', { username: 'User1', message: message, room: 'general' });
        chatMessage.value = '';
    });

    socket.on('message', data => {
        const messageDiv = document.createElement('div');
        messageDiv.textContent = `${data.username}: ${data.message}`;
        chatBox.appendChild(messageDiv);
    });

    socket.emit('join', { username: 'User1', room: 'general' });
});
