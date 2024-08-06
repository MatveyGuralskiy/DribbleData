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
            if (data.message) {
                window.location.href = '/'; // Redirect on successful login
            } else {
                document.getElementById('login-error').style.display = 'block'; // Show error message
            }
        })
        .catch(error => console.error('Error:', error));
});