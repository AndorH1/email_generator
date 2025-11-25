// API Configuration
const API_BASE_URL = 'http://localhost:8000/api';

// API Endpoints
const API_ENDPOINTS = {
    register: `${API_BASE_URL}/register`,
    login: `${API_BASE_URL}/login`,
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
