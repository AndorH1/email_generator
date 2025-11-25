// Main JavaScript file for general functionality

document.addEventListener('DOMContentLoaded', function () {
    console.log('Email Signature Generator loaded');

    // Check authentication on protected pages
    const protectedPages = ['dashboard.html', 'editor.html', 'profile.html'];
    const currentPage = window.location.pathname.split('/').pop();

    if (protectedPages.includes(currentPage)) {
        const token = localStorage.getItem(STORAGE_KEYS.token);
        if (!token) {
            window.location.href = 'login.html';
        }
    }

    // Setup logout button if exists
    const logoutBtn = document.getElementById('logoutBtn');
    if (logoutBtn) {
        logoutBtn.addEventListener('click', handleLogout);
    }
});

// Logout handler
function handleLogout(e) {
    e.preventDefault();

    // Keep "Remember Me" email, clear everything else
    const rememberedEmail = localStorage.getItem(STORAGE_KEYS.remember);

    localStorage.removeItem(STORAGE_KEYS.token);
    localStorage.removeItem(STORAGE_KEYS.user);
    localStorage.removeItem(STORAGE_KEYS.lastLogin);

    // Restore remembered email if it existed
    if (rememberedEmail) {
        localStorage.setItem(STORAGE_KEYS.remember, rememberedEmail);
    }

    window.location.href = 'index.html';
}

// Helper function to show alerts
function showAlert(elementId, message, type = 'danger') {
    const alertElement = document.getElementById(elementId);
    if (alertElement) {
        alertElement.textContent = message;
        alertElement.className = `alert alert-${type}`;
        alertElement.classList.remove('d-none');

        // Auto-hide after 5 seconds
        setTimeout(() => {
            alertElement.classList.add('d-none');
        }, 5000);
    }
}

// Helper function for API requests
async function apiRequest(url, options = {}) {
    const token = localStorage.getItem(STORAGE_KEYS.token);

    const headers = {
        'Content-Type': 'application/json',
        ...options.headers
    };

    if (token) {
        headers['Authorization'] = `Bearer ${token}`;
    }

    try {
        const response = await fetch(url, {
            ...options,
            headers
        });

        if (!response.ok) {
            // Try to parse error message
            const contentType = response.headers.get('content-type');
            if (contentType && contentType.includes('application/json')) {
                const data = await response.json();
                throw new Error(data.detail || 'Request failed');
            } else {
                throw new Error(`Request failed with status ${response.status}`);
            }
        }

        // Handle empty responses (204 No Content)
        if (response.status === 204 || response.headers.get('content-length') === '0') {
            return null;
        }

        // Only parse JSON if there's content
        const contentType = response.headers.get('content-type');
        if (contentType && contentType.includes('application/json')) {
            return await response.json();
        }

        // Return text for other content types
        return await response.text();
    } catch (error) {
        console.error('API request error:', error);
        throw error;
    }
}

// Get current user data (with caching)
async function getCurrentUser(forceRefresh = false) {
    // Check cache first
    if (!forceRefresh) {
        const cachedUser = localStorage.getItem(STORAGE_KEYS.user);
        if (cachedUser) {
            try {
                return JSON.parse(cachedUser);
            } catch (e) {
                console.error('Failed to parse cached user data');
            }
        }
    }

    // Fetch from API
    try {
        const profile = await apiRequest(API_ENDPOINTS.profile, {
            method: 'GET'
        });

        // Cache the user data
        localStorage.setItem(STORAGE_KEYS.user, JSON.stringify(profile));
        return profile;
    } catch (error) {
        console.error('Failed to fetch user data:', error);
        return null;
    }
}

// Check if user session is still valid
function isSessionValid() {
    const token = localStorage.getItem(STORAGE_KEYS.token);
    if (!token) return false;

    // Check if token is expired (JWT tokens contain expiration)
    try {
        const payload = JSON.parse(atob(token.split('.')[1]));
        const expirationTime = payload.exp * 1000; // Convert to milliseconds
        return Date.now() < expirationTime;
    } catch (e) {
        // If can't parse, assume valid (will fail on API call)
        return true;
    }
}

// Auto-refresh token before expiration (optional)
function setupTokenRefresh() {
    const token = localStorage.getItem(STORAGE_KEYS.token);
    if (!token) return;

    try {
        const payload = JSON.parse(atob(token.split('.')[1]));
        const expirationTime = payload.exp * 1000;
        const timeUntilExpiration = expirationTime - Date.now();

        // Refresh 5 minutes before expiration
        const refreshTime = timeUntilExpiration - (5 * 60 * 1000);

        if (refreshTime > 0) {
            setTimeout(() => {
                console.log('Token expiring soon. Please login again.');
                // In a real app, you'd call a refresh token endpoint here
            }, refreshTime);
        }
    } catch (e) {
        console.error('Failed to setup token refresh');
    }
}
