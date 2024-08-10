/*---------------------------
DribbleData Project
Created by Matvey Guralskiy
---------------------------*/
$(document).ready(function () {
    const socket = io('http://localhost:5001');

    function loadMessages() {
        $.get('/get_messages', function (data) {
            if (data.messages) {
                $('#messages').empty();
                data.messages.forEach(function (message) {
                    $('#messages').append(`<div class="message"><span class="username">${message.Username}</span>: <span
    class="text">${message.Message}</span> <span class="timestamp">${message.Timestamp}</span></div>`);
                });
                $('#messages').scrollTop($('#messages')[0].scrollHeight);
            }
        }).fail(function (jqXHR, textStatus, errorThrown) {
            console.error('Failed to load messages:', textStatus, errorThrown);
        });
    }

    loadMessages();
    setInterval(loadMessages, 3000);

    $('#messageForm').submit(function (e) {
        e.preventDefault();
        const message = $('#message-input').val();
        if (message) {
            console.log('Sending message:', message);
            socket.emit('send_message', { message: message }, function (response) {
                console.log('Server acknowledged message:', response);
            });
            $('#message-input').val('');
        } else {
            console.error('Message is empty');
        }
    });

    socket.on('receive_message', function (data) {
        console.log('Received message:', data);
        $('#messages').append(`<div class="message"><span class="username">${data.username}</span>: <span
    class="text">${data.message}</span> <span class="timestamp">${data.timestamp}</span></div>`);
        $('#messages').scrollTop($('#messages')[0].scrollHeight);
    });

    socket.on('error', function (data) {
        console.error('Socket.io error:', data);
    });
});