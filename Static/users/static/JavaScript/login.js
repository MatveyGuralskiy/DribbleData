/*---------------------------
DribbleData Project
Created by Matvey Guralskiy
---------------------------*/
document.getElementById('login-form').addEventListener('submit', function (event) {
    event.preventDefault(); // Prevent the default form submission

    const username = document.getElementById('username').value;
    const password = document.getElementById('password').value;

    fetch('/login', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({
            username: username,
            password: password
        })
    })
        .then(response => response.json())
        .then(data => {
            if (data.message === 'Login successful') {  // Check the message for successful login
                window.location.href = '/chat';  // Redirect on successful login
            } else {
                document.getElementById('login-error').textContent = data.error;  // Show error message
                document.getElementById('login-error').style.display = 'block';
            }
        })
        .catch(error => console.error('Error:', error));
});