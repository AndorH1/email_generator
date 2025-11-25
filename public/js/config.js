// API Configuration
// Auto-detect API URL based on current host, or fallback to localhost:8080
const API_BASE_URL = window.location.hostname === 'localhost' || window.location.hostname === '127.0.0.1'
    ? `http://${window.location.hostname}:${window.location.port || 8080}/api`
    : 'http://localhost:8080/api';

// API Endpoints
const API_ENDPOINTS = {
    register: `${API_BASE_URL}/register`,
    login: `${API_BASE_URL}/login`,
    logout: `${API_BASE_URL}/logout`,
    profile: `${API_BASE_URL}/profile`,
    templates: `${API_BASE_URL}/templates`,
    signatures: `${API_BASE_URL}/signatures`,
    signatureDetail: (id) => `${API_BASE_URL}/signatures/${id}`,
    signatureExport: (id) => `${API_BASE_URL}/signatures/${id}/export`
};

// Local Storage Keys
const STORAGE_KEYS = {
    token: 'auth_token',
    user: 'user_data',
    remember: 'remember_me',
    lastLogin: 'last_login'
};
