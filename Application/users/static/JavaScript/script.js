/*---------------------------
DribbleData Project
Created by Matvey Guralskiy
---------------------------*/
document.getElementById('register-form').addEventListener('submit', function (event) {
    event.preventDefault();
    const username = document.getElementById('username').value;
    const password = document.getElementById('password').value;

    fetch('/register', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
        },
        body: JSON.stringify({ username, password }),
    })
        .then(response => {
            if (response.ok) {
                window.location.href = '/login';
            } else {
                document.getElementById('register-error').style.display = 'block';
            }
        })
        .catch(error => {
            console.error('Error:', error);
        });
});