#!/usr/bin/env python3
"""Generate password hashes for test users"""
import sys
sys.path.append('/Users/andrashegyeli/DiakProjekt/email-signature-generator/backend')

from passlib.context import CryptContext

pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")

passwords = {
    "admin123": pwd_context.hash("admin123"),
    "password123": pwd_context.hash("password123"),
}

print("Password hashes:")
for pwd, hash in passwords.items():
    print(f"\n{pwd}:")
    print(f"  {hash}")
