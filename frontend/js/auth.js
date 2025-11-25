// Authentication JavaScript

document.addEventListener('DOMContentLoaded', function () {
    const loginForm = document.getElementById('loginForm');
    const registerForm = document.getElementById('registerForm');

    if (loginForm) {
        loginForm.addEventListener('submit', handleLogin);

        // Pre-fill email if "Remember Me" was checked
        const rememberedEmail = localStorage.getItem(STORAGE_KEYS.remember);
        const emailInput = document.getElementById('email');
        const rememberMe = document.getElementById('rememberMe');

        if (rememberedEmail && emailInput) {
            emailInput.value = rememberedEmail;
            if (rememberMe) {
                rememberMe.checked = true;
            }
        }
    }

    if (registerForm) {
        registerForm.addEventListener('submit', handleRegister);
    }
});

// Login handler
async function handleLogin(e) {
    e.preventDefault();

    const email = document.getElementById('email').value;
    const password = document.getElementById('password').value;

    try {
        const response = await fetch(API_ENDPOINTS.login, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({ email, password })
        });

        const data = await response.json();

        if (!response.ok) {
            throw new Error(data.detail || 'Login failed');
        }

        // Save token
        localStorage.setItem(STORAGE_KEYS.token, data.access_token);

        // Save user email if remember me is checked
        const rememberMe = document.getElementById('rememberMe');
        if (rememberMe && rememberMe.checked) {
            localStorage.setItem(STORAGE_KEYS.remember, email);
        } else {
            localStorage.removeItem(STORAGE_KEYS.remember);
        }

        // Save last login timestamp
        localStorage.setItem(STORAGE_KEYS.lastLogin, new Date().toISOString());

        // Redirect to dashboard
        window.location.href = 'dashboard.html';

    } catch (error) {
        showAlert('loginError', error.message, 'danger');
    }
}

// Register handler
async function handleRegister(e) {
    e.preventDefault();

    const fullName = document.getElementById('fullName').value;
    const email = document.getElementById('email').value;
    const password = document.getElementById('password').value;
    const confirmPassword = document.getElementById('confirmPassword').value;

    // Validate passwords match
    if (password !== confirmPassword) {
        showAlert('registerError', 'Passwords do not match', 'danger');
        return;
    }

    try {
        const response = await fetch(API_ENDPOINTS.register, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({
                full_name: fullName,
                email: email,
                password: password
            })
        });

        const data = await response.json();

        if (!response.ok) {
            throw new Error(data.detail || 'Registration failed');
        }

        // Registration successful - now login
        const loginResponse = await fetch(API_ENDPOINTS.login, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({ email, password })
        });

        const loginData = await loginResponse.json();

        if (loginResponse.ok) {
            localStorage.setItem(STORAGE_KEYS.token, loginData.access_token);
            window.location.href = 'dashboard.html';
        } else {
            // Registration succeeded but login failed - redirect to login page
            window.location.href = 'login.html';
        }

    } catch (error) {
        showAlert('registerError', error.message, 'danger');
    }
}
