#!/bin/bash

BASE_URL="http://127.0.0.1:8080/api"

echo "================================"
echo "Testing Email Signature Generator API"
echo "================================"
echo ""

# Test 1: User Registration
echo "1. Testing User Registration..."
REGISTER_RESPONSE=$(curl -s -X POST "$BASE_URL/register" \
  -H "Content-Type: application/json" \
  -d '{"email":"testuser@example.com","password":"password123","full_name":"Test User"}')
echo "Response: $REGISTER_RESPONSE"
echo ""

# Test 2: User Login
echo "2. Testing User Login..."
LOGIN_RESPONSE=$(curl -s -X POST "$BASE_URL/login" \
  -H "Content-Type: application/json" \
  -d '{"email":"testuser@example.com","password":"password123"}')
echo "Response: $LOGIN_RESPONSE"

# Extract token
TOKEN=$(echo $LOGIN_RESPONSE | grep -o '"access_token":"[^"]*"' | cut -d'"' -f4)
echo "Token: $TOKEN"
echo ""

# Test 3: Get Profile
echo "3. Testing Get Profile..."
PROFILE_RESPONSE=$(curl -s -X GET "$BASE_URL/profile" \
  -H "Authorization: Bearer $TOKEN")
echo "Response: $PROFILE_RESPONSE"
echo ""

# Test 4: Update Profile
echo "4. Testing Update Profile..."
UPDATE_PROFILE_RESPONSE=$(curl -s -X PUT "$BASE_URL/profile" \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"job_title":"Software Engineer","phone":"+1234567890","website":"https://example.com"}')
echo "Response: $UPDATE_PROFILE_RESPONSE"
echo ""

# Test 5: Get Templates
echo "5. Testing Get Templates..."
TEMPLATES_RESPONSE=$(curl -s -X GET "$BASE_URL/templates" \
  -H "Authorization: Bearer $TOKEN")
echo "Response: $TEMPLATES_RESPONSE"
echo ""

# Test 6: Create Signature
echo "6. Testing Create Signature..."
CREATE_SIGNATURE_RESPONSE=$(curl -s -X POST "$BASE_URL/signatures" \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "template_id": 1,
    "data": {
      "full_name": "Test User",
      "job_title": "Software Engineer",
      "phone": "+1234567890",
      "website": "https://example.com",
      "avatar_url": "https://via.placeholder.com/80",
      "accent_color": "#007bff"
    }
  }')
echo "Response: $CREATE_SIGNATURE_RESPONSE"

# Extract signature ID
SIGNATURE_ID=$(echo $CREATE_SIGNATURE_RESPONSE | grep -o '"id":[0-9]*' | head -1 | cut -d':' -f2)
echo "Signature ID: $SIGNATURE_ID"
echo ""

# Test 7: Get All Signatures
echo "7. Testing Get All Signatures..."
SIGNATURES_RESPONSE=$(curl -s -X GET "$BASE_URL/signatures" \
  -H "Authorization: Bearer $TOKEN")
echo "Response: $SIGNATURES_RESPONSE"
echo ""

# Test 8: Get Single Signature
echo "8. Testing Get Single Signature..."
SINGLE_SIGNATURE_RESPONSE=$(curl -s -X GET "$BASE_URL/signatures/$SIGNATURE_ID" \
  -H "Authorization: Bearer $TOKEN")
echo "Response: $SINGLE_SIGNATURE_RESPONSE"
echo ""

# Test 9: Export Signature
echo "9. Testing Export Signature..."
EXPORT_RESPONSE=$(curl -s -X GET "$BASE_URL/signatures/$SIGNATURE_ID/export" \
  -H "Authorization: Bearer $TOKEN")
echo "HTML Output (first 200 chars): ${EXPORT_RESPONSE:0:200}..."
echo ""

# Test 10: Update Signature
echo "10. Testing Update Signature..."
UPDATE_SIGNATURE_RESPONSE=$(curl -s -X PUT "$BASE_URL/signatures/$SIGNATURE_ID" \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "template_id": 2,
    "data": {
      "full_name": "Test User Updated",
      "job_title": "Senior Software Engineer",
      "phone": "+1234567890",
      "website": "https://example.com",
      "avatar_url": "https://via.placeholder.com/80",
      "accent_color": "#28a745"
    }
  }')
echo "Response: $UPDATE_SIGNATURE_RESPONSE"
echo ""

# Test 11: Delete Signature
echo "11. Testing Delete Signature..."
DELETE_RESPONSE=$(curl -s -X DELETE "$BASE_URL/signatures/$SIGNATURE_ID" \
  -H "Authorization: Bearer $TOKEN" -w "\nHTTP Status: %{http_code}")
echo "Response: $DELETE_RESPONSE"
echo ""

# Test 12: Logout
echo "12. Testing Logout..."
LOGOUT_RESPONSE=$(curl -s -X POST "$BASE_URL/logout" \
  -H "Authorization: Bearer $TOKEN")
echo "Response: $LOGOUT_RESPONSE"
echo ""

echo "================================"
echo "All tests completed!"
echo "================================"
