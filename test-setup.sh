#!/bin/bash

# Test Script for Email Signature Generator Setup
# This script verifies all components are working correctly

echo "=========================================="
echo "Email Signature Generator - Setup Test"
echo "=========================================="
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Test counter
PASSED=0
FAILED=0

# Test 1: Check Docker is running
echo -n "1. Checking Docker... "
if docker ps &> /dev/null; then
    echo -e "${GREEN}✓ Docker is running${NC}"
    ((PASSED++))
else
    echo -e "${RED}✗ Docker is not running${NC}"
    ((FAILED++))
fi

# Test 2: Check MySQL container
echo -n "2. Checking MySQL container... "
if docker ps | grep -q "email_signature_db"; then
    echo -e "${GREEN}✓ MySQL container is running${NC}"
    ((PASSED++))
else
    echo -e "${RED}✗ MySQL container is not running${NC}"
    echo -e "${YELLOW}   Run: docker-compose up -d${NC}"
    ((FAILED++))
fi

# Test 3: Check MySQL connection
echo -n "3. Testing MySQL connection... "
if docker exec email_signature_db mysql -uroot -ppassword -e "SELECT 1;" &> /dev/null; then
    echo -e "${GREEN}✓ MySQL is accepting connections${NC}"
    ((PASSED++))
else
    echo -e "${RED}✗ Cannot connect to MySQL${NC}"
    echo -e "${YELLOW}   Wait a few seconds and try again${NC}"
    ((FAILED++))
fi

# Test 4: Check database exists
echo -n "4. Checking database exists... "
if docker exec email_signature_db mysql -uroot -ppassword -e "USE email_signature_db;" &> /dev/null; then
    echo -e "${GREEN}✓ email_signature_db exists${NC}"
    ((PASSED++))
else
    echo -e "${RED}✗ Database email_signature_db not found${NC}"
    ((FAILED++))
fi

# Test 5: Check PHP is installed
echo -n "5. Checking PHP installation... "
if command -v php &> /dev/null; then
    PHP_VERSION=$(php -v | head -n 1)
    echo -e "${GREEN}✓ $PHP_VERSION${NC}"
    ((PASSED++))
else
    echo -e "${RED}✗ PHP is not installed${NC}"
    ((FAILED++))
fi

# Test 6: Check Composer is installed
echo -n "6. Checking Composer installation... "
if command -v composer &> /dev/null; then
    COMPOSER_VERSION=$(composer --version | head -n 1)
    echo -e "${GREEN}✓ $COMPOSER_VERSION${NC}"
    ((PASSED++))
else
    echo -e "${RED}✗ Composer is not installed${NC}"
    ((FAILED++))
fi

# Test 7: Check vendor directory exists
echo -n "7. Checking Laravel dependencies... "
if [ -d "vendor" ]; then
    echo -e "${GREEN}✓ Dependencies installed${NC}"
    ((PASSED++))
else
    echo -e "${RED}✗ Dependencies not installed${NC}"
    echo -e "${YELLOW}   Run: composer install${NC}"
    ((FAILED++))
fi

# Test 8: Check .env file exists
echo -n "8. Checking .env configuration... "
if [ -f ".env" ]; then
    echo -e "${GREEN}✓ .env file exists${NC}"
    ((PASSED++))
else
    echo -e "${RED}✗ .env file not found${NC}"
    echo -e "${YELLOW}   Run: cp .env.example .env && php artisan key:generate${NC}"
    ((FAILED++))
fi

# Test 9: Check if migrations have been run
echo -n "9. Checking database migrations... "
if docker exec email_signature_db mysql -uroot -ppassword email_signature_db -e "SHOW TABLES;" 2>/dev/null | grep -q "users"; then
    TABLE_COUNT=$(docker exec email_signature_db mysql -uroot -ppassword email_signature_db -e "SHOW TABLES;" 2>/dev/null | tail -n +2 | wc -l)
    echo -e "${GREEN}✓ $TABLE_COUNT tables found${NC}"
    ((PASSED++))
else
    echo -e "${RED}✗ Migrations not run${NC}"
    echo -e "${YELLOW}   Run: php artisan migrate${NC}"
    ((FAILED++))
fi

# Test 10: Check if templates are seeded
echo -n "10. Checking template data... "
TEMPLATE_COUNT=$(docker exec email_signature_db mysql -uroot -ppassword email_signature_db -e "SELECT COUNT(*) FROM templates;" 2>/dev/null | tail -n 1)
if [ "$TEMPLATE_COUNT" -ge 3 ]; then
    echo -e "${GREEN}✓ $TEMPLATE_COUNT templates found${NC}"
    ((PASSED++))
else
    echo -e "${RED}✗ Templates not seeded${NC}"
    echo -e "${YELLOW}   Run: php artisan db:seed --class=TemplateSeeder${NC}"
    ((FAILED++))
fi

# Summary
echo ""
echo "=========================================="
echo "Test Results"
echo "=========================================="
echo -e "${GREEN}Passed: $PASSED${NC}"
echo -e "${RED}Failed: $FAILED${NC}"
echo ""

if [ $FAILED -eq 0 ]; then
    echo -e "${GREEN}✓ All tests passed! Your setup is ready.${NC}"
    echo ""
    echo "Start the Laravel server:"
    echo "  php artisan serve --port=8080"
    echo ""
    echo "Then open: http://localhost:8080"
    exit 0
else
    echo -e "${YELLOW}⚠ Some tests failed. Follow the suggestions above.${NC}"
    exit 1
fi
