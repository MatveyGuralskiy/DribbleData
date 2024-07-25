/*---------------------------
DribbleData Project
Created by Matvey Guralskiy
---------------------------*/

document.addEventListener('DOMContentLoaded', function () {
    const sendButton = document.getElementById('send-button');
    const messageInput = document.getElementById('message-input');
    const chatWindow = document.getElementById('chat-window');

    sendButton.addEventListener('click', function () {
        const message = messageInput.value;
        if (message) {
            const messageElement = document.createElement('div');
            messageElement.classList.add('message');
            messageElement.textContent = message;
            chatWindow.appendChild(messageElement);
            messageInput.value = '';
            chatWindow.scrollTop = chatWindow.scrollHeight;
        }
    });
});
