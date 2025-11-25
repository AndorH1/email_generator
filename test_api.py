#!/usr/bin/env python3
"""
Comprehensive API Testing Script for Email Signature Generator
Tests all endpoints and functionality
"""

import requests
import json
from datetime import datetime

# Configuration
BASE_URL = "http://localhost:8000/api"
TEST_USER = {
    "email": "test.user@example.com",
    "password": "testpass123",
    "full_name": "Test User"
}

# Test credentials (from seed data)
EXISTING_USER = {
    "email": "john.doe@example.com",
    "password": "password123"
}

ADMIN_USER = {
    "email": "admin@example.com",
    "password": "admin123"
}

class Colors:
    GREEN = '\033[92m'
    RED = '\033[91m'
    YELLOW = '\033[93m'
    BLUE = '\033[94m'
    END = '\033[0m'

def log_test(name):
    print(f"\n{Colors.BLUE}{'='*60}{Colors.END}")
    print(f"{Colors.BLUE}Testing: {name}{Colors.END}")
    print(f"{Colors.BLUE}{'='*60}{Colors.END}")

def log_success(message):
    print(f"{Colors.GREEN}✓ {message}{Colors.END}")

def log_error(message):
    print(f"{Colors.RED}✗ {message}{Colors.END}")

def log_info(message):
    print(f"{Colors.YELLOW}ℹ {message}{Colors.END}")

# Test Results Tracker
test_results = {"passed": 0, "failed": 0, "tests": []}

def record_test(name, passed, details=""):
    global test_results
    test_results["tests"].append({"name": name, "passed": passed, "details": details})
    if passed:
        test_results["passed"] += 1
        log_success(f"{name} - {details}")
    else:
        test_results["failed"] += 1
        log_error(f"{name} - {details}")

# ============================================================================
# Test 1: Health Check
# ============================================================================
def test_health_check():
    log_test("Health Check")
    try:
        response = requests.get(f"{BASE_URL.replace('/api', '')}/health")
        if response.status_code == 200:
            record_test("Health Check", True, "API is healthy")
            return True
        else:
            record_test("Health Check", False, f"Status code: {response.status_code}")
            return False
    except Exception as e:
        record_test("Health Check", False, str(e))
        return False

# ============================================================================
# Test 2: User Registration
# ============================================================================
def test_registration():
    log_test("User Registration")
    try:
        # Try to register a new user
        response = requests.post(f"{BASE_URL}/register", json=TEST_USER)
        
        if response.status_code == 201:
            data = response.json()
            record_test("User Registration", True, f"User created: {data.get('email')}")
            return True
        elif response.status_code == 400 and "already registered" in response.text:
            record_test("User Registration", True, "User already exists (expected)")
            return True
        else:
            record_test("User Registration", False, f"Unexpected response: {response.text}")
            return False
    except Exception as e:
        record_test("User Registration", False, str(e))
        return False

# ============================================================================
# Test 3: User Login
# ============================================================================
def test_login():
    log_test("User Login")
    try:
        response = requests.post(f"{BASE_URL}/login", json=EXISTING_USER)
        
        if response.status_code == 200:
            data = response.json()
            token = data.get("access_token")
            if token:
                record_test("User Login", True, "Token received")
                return token
            else:
                record_test("User Login", False, "No token in response")
                return None
        else:
            record_test("User Login", False, f"Status: {response.status_code}, {response.text}")
            return None
    except Exception as e:
        record_test("User Login", False, str(e))
        return None

# ============================================================================
# Test 4: Get Profile
# ============================================================================
def test_get_profile(token):
    log_test("Get User Profile")
    if not token:
        record_test("Get Profile", False, "No authentication token")
        return False
    
    try:
        headers = {"Authorization": f"Bearer {token}"}
        response = requests.get(f"{BASE_URL}/profile", headers=headers)
        
        if response.status_code == 200:
            data = response.json()
            record_test("Get Profile", True, f"Profile retrieved for user {data.get('user_id')}")
            return True
        else:
            record_test("Get Profile", False, f"Status: {response.status_code}")
            return False
    except Exception as e:
        record_test("Get Profile", False, str(e))
        return False

# ============================================================================
# Test 5: Update Profile
# ============================================================================
def test_update_profile(token):
    log_test("Update User Profile")
    if not token:
        record_test("Update Profile", False, "No authentication token")
        return False
    
    try:
        headers = {"Authorization": f"Bearer {token}"}
        update_data = {
            "job_title": "Senior Software Engineer",
            "phone": "+36 30 999 8888",
            "website": "https://updated-profile.com",
            "avatar_url": "https://i.pravatar.cc/150?img=99"
        }
        response = requests.put(f"{BASE_URL}/profile", headers=headers, json=update_data)
        
        if response.status_code == 200:
            data = response.json()
            if data.get("job_title") == update_data["job_title"]:
                record_test("Update Profile", True, f"Profile updated: {data.get('job_title')}")
                return True
            else:
                record_test("Update Profile", False, "Profile not updated correctly")
                return False
        else:
            record_test("Update Profile", False, f"Status: {response.status_code}")
            return False
    except Exception as e:
        record_test("Update Profile", False, str(e))
        return False

# ============================================================================
# Test 6: Get Templates
# ============================================================================
def test_get_templates(token):
    log_test("Get Templates")
    if not token:
        record_test("Get Templates", False, "No authentication token")
        return None
    
    try:
        headers = {"Authorization": f"Bearer {token}"}
        response = requests.get(f"{BASE_URL}/templates", headers=headers)
        
        if response.status_code == 200:
            templates = response.json()
            record_test("Get Templates", True, f"Retrieved {len(templates)} templates")
            return templates
        else:
            record_test("Get Templates", False, f"Status: {response.status_code}")
            return None
    except Exception as e:
        record_test("Get Templates", False, str(e))
        return None

# ============================================================================
# Test 7: Create Signature
# ============================================================================
def test_create_signature(token, templates):
    log_test("Create Signature")
    if not token:
        record_test("Create Signature", False, "No authentication token")
        return None
    
    if not templates or len(templates) == 0:
        record_test("Create Signature", False, "No templates available")
        return None
    
    try:
        headers = {"Authorization": f"Bearer {token}"}
        signature_data = {
            "template_id": templates[0]["id"],
            "data": {
                "full_name": "Test Signature User",
                "job_title": "QA Tester",
                "phone": "+36 30 111 2222",
                "website": "https://test-signature.com",
                "avatar_url": "https://i.pravatar.cc/150?img=50",
                "accent_color": "#ff6b6b"
            }
        }
        response = requests.post(f"{BASE_URL}/signatures", headers=headers, json=signature_data)
        
        if response.status_code == 201:
            data = response.json()
            record_test("Create Signature", True, f"Signature created with ID {data.get('id')}")
            return data.get("id")
        else:
            record_test("Create Signature", False, f"Status: {response.status_code}, {response.text}")
            return None
    except Exception as e:
        record_test("Create Signature", False, str(e))
        return None

# ============================================================================
# Test 8: Get User Signatures
# ============================================================================
def test_get_signatures(token):
    log_test("Get User Signatures")
    if not token:
        record_test("Get Signatures", False, "No authentication token")
        return None
    
    try:
        headers = {"Authorization": f"Bearer {token}"}
        response = requests.get(f"{BASE_URL}/signatures", headers=headers)
        
        if response.status_code == 200:
            signatures = response.json()
            record_test("Get Signatures", True, f"Retrieved {len(signatures)} signatures")
            return signatures
        else:
            record_test("Get Signatures", False, f"Status: {response.status_code}")
            return None
    except Exception as e:
        record_test("Get Signatures", False, str(e))
        return None

# ============================================================================
# Test 9: Export Signature
# ============================================================================
def test_export_signature(token, signature_id):
    log_test("Export Signature")
    if not token or not signature_id:
        record_test("Export Signature", False, "Missing token or signature ID")
        return False
    
    try:
        headers = {"Authorization": f"Bearer {token}"}
        response = requests.get(f"{BASE_URL}/signatures/{signature_id}/export", headers=headers)
        
        if response.status_code == 200:
            html = response.text
            if "<table" in html:
                record_test("Export Signature", True, f"HTML exported ({len(html)} chars)")
                return True
            else:
                record_test("Export Signature", False, "Invalid HTML format")
                return False
        else:
            record_test("Export Signature", False, f"Status: {response.status_code}")
            return False
    except Exception as e:
        record_test("Export Signature", False, str(e))
        return False

# ============================================================================
# Test 10: Admin Login and Template Creation
# ============================================================================
def test_admin_features():
    log_test("Admin Features")
    try:
        # Admin login
        response = requests.post(f"{BASE_URL}/login", json=ADMIN_USER)
        if response.status_code != 200:
            record_test("Admin Login", False, "Admin login failed")
            return False
        
        admin_token = response.json().get("access_token")
        record_test("Admin Login", True, "Admin logged in")
        
        # Create a template
        headers = {"Authorization": f"Bearer {admin_token}"}
        new_template = {
            "name": "Test Template",
            "html_template": "<div>{{full_name}} - {{job_title}}</div>",
            "is_public": True
        }
        response = requests.post(f"{BASE_URL}/templates", headers=headers, json=new_template)
        
        if response.status_code == 201:
            record_test("Admin Create Template", True, "Template created by admin")
            return True
        else:
            record_test("Admin Create Template", False, f"Status: {response.status_code}")
            return False
    except Exception as e:
        record_test("Admin Features", False, str(e))
        return False

# ============================================================================
# Main Test Runner
# ============================================================================
def run_all_tests():
    print(f"\n{Colors.BLUE}{'='*60}")
    print(f"Email Signature Generator - API Test Suite")
    print(f"Started at: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")
    print(f"{'='*60}{Colors.END}\n")
    
    # Run all tests
    test_health_check()
    test_registration()
    token = test_login()
    test_get_profile(token)
    test_update_profile(token)
    templates = test_get_templates(token)
    signature_id = test_create_signature(token, templates)
    test_get_signatures(token)
    test_export_signature(token, signature_id)
    test_admin_features()
    
    # Print summary
    print(f"\n{Colors.BLUE}{'='*60}")
    print(f"Test Summary")
    print(f"{'='*60}{Colors.END}")
    print(f"{Colors.GREEN}Passed: {test_results['passed']}{Colors.END}")
    print(f"{Colors.RED}Failed: {test_results['failed']}{Colors.END}")
    print(f"Total: {test_results['passed'] + test_results['failed']}")
    
    success_rate = (test_results['passed'] / (test_results['passed'] + test_results['failed']) * 100) if (test_results['passed'] + test_results['failed']) > 0 else 0
    print(f"\nSuccess Rate: {success_rate:.1f}%")
    
    if test_results['failed'] == 0:
        print(f"\n{Colors.GREEN}🎉 All tests passed!{Colors.END}\n")
    else:
        print(f"\n{Colors.YELLOW}⚠️  Some tests failed. Review the details above.{Colors.END}\n")
    
    return test_results['failed'] == 0

if __name__ == "__main__":
    success = run_all_tests()
    exit(0 if success else 1)
