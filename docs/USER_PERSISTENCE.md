# User Session Persistence Guide

## Overview

This application uses **localStorage** to persist user sessions in the browser, similar to AsyncStorage in React Native mobile development.

## How It Works

### 1. Login Flow

```javascript
// When user logs in (frontend/js/auth.js)
localStorage.setItem('auth_token', jwtToken);        // Save JWT token
localStorage.setItem('user_data', JSON.stringify(userData));  // Cache user data
localStorage.setItem('last_login', new Date().toISOString()); // Track login time
```

### 2. Session Check on Page Load

```javascript
// Every page load (frontend/js/main.js)
const token = localStorage.getItem('auth_token');
if (!token) {
    window.location.href = 'login.html';  // Redirect if not logged in
}
```

### 3. Authenticated API Requests

```javascript
// Automatic token injection (frontend/js/main.js)
headers['Authorization'] = `Bearer ${token}`;
```

### 4. Logout Flow

```javascript
// Clear session (frontend/js/main.js)
localStorage.removeItem('auth_token');
localStorage.removeItem('user_data');
```

## Storage Types Comparison

| Feature | localStorage | sessionStorage | Cookies | IndexedDB |
|---------|-------------|----------------|---------|-----------|
| **Capacity** | ~5-10 MB | ~5-10 MB | ~4 KB | ~50+ MB |
| **Persistence** | Permanent* | Tab session only | Configurable | Permanent* |
| **Expiration** | Never | On tab close | Yes | Never |
| **Server Access** | No | No | Yes (httpOnly) | No |
| **Security** | Medium | Medium | High (httpOnly) | Medium |
| **Use Case** | Auth tokens | Temp data | Sensitive cookies | Large data |

*Until user clears browser data

## Current Implementation

### Files Modified:

1. **`frontend/js/config.js`** - Storage keys configuration
2. **`frontend/js/auth.js`** - Login/Register with persistence
3. **`frontend/js/main.js`** - Session management utilities
4. **`frontend/login.html`** - "Remember Me" checkbox

### Storage Keys:

```javascript
STORAGE_KEYS = {
    token: 'auth_token',           // JWT authentication token
    user: 'user_data',             // Cached user profile data
    remember: 'remember_me',       // Saved email for "Remember Me"
    lastLogin: 'last_login'        // Last login timestamp
}
```

## Features Implemented

### ✅ 1. Persistent Login
- User stays logged in after browser refresh
- Token stored in localStorage
- Valid for 7 days (configurable in backend)

### ✅ 2. Remember Me
- Checkbox on login page
- Saves email address for next login
- Preserved even after logout

### ✅ 3. User Data Caching
- Profile data cached after first fetch
- Reduces API calls
- Auto-updated when profile changes

### ✅ 4. Session Validation
- Check if JWT token is expired
- Auto-redirect to login if invalid
- Token parsed to check expiration time

### ✅ 5. Last Login Tracking
- Timestamp saved on each login
- Can be used for session timeout logic

## Usage Examples

### Get Current User (with cache)

```javascript
// Fetch user data (uses cache if available)
const user = await getCurrentUser();
console.log(user.full_name);

// Force refresh from API
const freshUser = await getCurrentUser(true);
```

### Check Session Validity

```javascript
if (isSessionValid()) {
    console.log('User is logged in');
} else {
    window.location.href = 'login.html';
}
```

### Manual Token Management

```javascript
// Get token
const token = localStorage.getItem('auth_token');

// Check if user is logged in
const isLoggedIn = !!token;

// Clear session
localStorage.clear();
```

## Security Considerations

### ✅ Current Security Features:

1. **JWT Tokens**: Signed tokens, tamper-proof
2. **HTTPS Required**: Use SSL in production
3. **Token Expiration**: 7-day lifetime
4. **CORS Protection**: Backend validates origins

### ⚠️ localStorage Vulnerabilities:

| Threat | Risk | Mitigation |
|--------|------|------------|
| **XSS Attacks** | High | Sanitize all user input, CSP headers |
| **Browser Access** | Medium | Encrypt sensitive data |
| **Token Theft** | High | Use HTTPS, short token lifetime |
| **No Automatic Expiry** | Low | Implement token validation |

## Best Practices

### ✅ DO:

- ✅ Use HTTPS in production
- ✅ Implement token refresh before expiration
- ✅ Validate token on every API call
- ✅ Clear tokens on logout
- ✅ Use Content Security Policy (CSP)
- ✅ Set short token expiration (1-7 days)

### ❌ DON'T:

- ❌ Store passwords in localStorage
- ❌ Store credit card info
- ❌ Use localStorage for highly sensitive data
- ❌ Forget to clear tokens on logout
- ❌ Use HTTP (no SSL) with tokens

## Advanced: Token Refresh Implementation

For production, implement automatic token refresh:

### Backend: Add Refresh Token Endpoint

```python
# backend/app/api/auth.py

@router.post("/refresh")
async def refresh_token(refresh_token: str):
    # Validate refresh token
    # Generate new access token
    return {"access_token": new_token}
```

### Frontend: Auto-Refresh Before Expiration

```javascript
// frontend/js/main.js

async function refreshAccessToken() {
    const refreshToken = localStorage.getItem('refresh_token');
    
    const response = await fetch(API_ENDPOINTS.refresh, {
        method: 'POST',
        headers: {'Content-Type': 'application/json'},
        body: JSON.stringify({refresh_token: refreshToken})
    });
    
    const data = await response.json();
    localStorage.setItem('auth_token', data.access_token);
}

// Call before token expires
setupTokenRefresh();
```

## Comparison with Mobile Development

### React Native AsyncStorage vs Web localStorage

| Feature | AsyncStorage (Mobile) | localStorage (Web) |
|---------|----------------------|-------------------|
| **API** | Promise-based | Synchronous |
| **Storage** | Device storage | Browser storage |
| **Access** | App only | Per domain |
| **Size** | ~6 MB | ~5-10 MB |
| **Persistence** | Always | Until cleared |

### Example Comparison:

**React Native:**
```javascript
import AsyncStorage from '@react-native-async-storage/async-storage';

// Save
await AsyncStorage.setItem('@auth_token', token);

// Retrieve
const token = await AsyncStorage.getItem('@auth_token');

// Remove
await AsyncStorage.removeItem('@auth_token');
```

**Web (Current Implementation):**
```javascript
// Save
localStorage.setItem('auth_token', token);

// Retrieve
const token = localStorage.getItem('auth_token');

// Remove
localStorage.removeItem('auth_token');
```

## Alternative: sessionStorage

For more secure, temporary sessions:

```javascript
// Use sessionStorage instead (cleared on tab close)
sessionStorage.setItem('auth_token', token);

// Auto-logout when browser tab closes
// More secure for public computers
```

## Alternative: Cookies with httpOnly

Most secure option (requires backend changes):

```python
# Backend sets cookie
response.set_cookie(
    key="access_token",
    value=token,
    httponly=True,  # Not accessible by JavaScript
    secure=True,    # HTTPS only
    samesite="lax"  # CSRF protection
)
```

```javascript
// Frontend - no manual storage needed
// Browser automatically sends cookie with requests
fetch(API_URL, {credentials: 'include'});
```

## Debugging Session Issues

### Check Current Session:

```javascript
// Open browser console (F12)

// View all stored data
console.log('Token:', localStorage.getItem('auth_token'));
console.log('User:', JSON.parse(localStorage.getItem('user_data')));
console.log('Last Login:', localStorage.getItem('last_login'));

// Check if token is valid
console.log('Session Valid:', isSessionValid());
```

### Clear Session Manually:

```javascript
// Clear everything
localStorage.clear();

// Or clear specific items
localStorage.removeItem('auth_token');
```

### Check Token Expiration:

```javascript
const token = localStorage.getItem('auth_token');
const payload = JSON.parse(atob(token.split('.')[1]));
const expDate = new Date(payload.exp * 1000);
console.log('Token expires:', expDate.toLocaleString());
```

## Production Recommendations

1. **Use HTTPS**: Essential for token security
2. **Implement Token Refresh**: Extend sessions without re-login
3. **Add Session Timeout**: Auto-logout after inactivity
4. **Monitor Failed Requests**: Detect expired tokens
5. **Use httpOnly Cookies**: For maximum security
6. **Implement 2FA**: Two-factor authentication
7. **Log Security Events**: Track login attempts
8. **Rate Limit Login**: Prevent brute force attacks

## Summary

The current implementation uses **localStorage** for persistent user sessions, similar to mobile AsyncStorage. It includes:

- ✅ JWT token persistence
- ✅ User data caching
- ✅ "Remember Me" functionality
- ✅ Session validation
- ✅ Last login tracking
- ✅ Automatic token injection in API calls

This provides a good balance between user experience and security for a student project. For production, consider implementing token refresh, httpOnly cookies, and additional security measures.
