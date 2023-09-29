// app/assets/javascripts/emptyfields.js

document.getElementById('login-form').addEventListener('submit', function (event) {
    var emailField = document.querySelector('input[name="email_id"]');
    var passwordField = document.querySelector('input[name="password"]');

    if (emailField.value.trim() === '' || passwordField.value.trim() === '') {
      alert('Please fill in both email and password fields.');
      event.preventDefault(); // Prevent form submission
    }
  });