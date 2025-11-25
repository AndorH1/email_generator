-- Email Signature Generator Database Schema
-- MySQL Database Setup

-- Drop existing database if exists
DROP DATABASE IF EXISTS email_signature_db;

-- Create database
CREATE DATABASE email_signature_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Use the database
USE email_signature_db;

-- Users table
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    email VARCHAR(255) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    full_name VARCHAR(150) NOT NULL,
    role ENUM('STUDENT', 'ADMIN') DEFAULT 'STUDENT',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_email (email)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Profiles table
CREATE TABLE profiles (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL UNIQUE,
    job_title VARCHAR(100),
    phone VARCHAR(50),
    website VARCHAR(255),
    avatar_url VARCHAR(255),
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_user_id (user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Templates table
CREATE TABLE templates (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    html_template TEXT NOT NULL,
    thumbnail_url VARCHAR(255),
    is_public BOOLEAN DEFAULT TRUE,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Signatures table
CREATE TABLE signatures (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    template_id INT NOT NULL,
    data JSON,
    html_rendered TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (template_id) REFERENCES templates(id) ON DELETE CASCADE,
    INDEX idx_user_id (user_id),
    INDEX idx_template_id (template_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Insert sample templates
INSERT INTO templates (name, html_template, thumbnail_url, is_public) VALUES
(
    'Classic Professional',
    '<table cellpadding="0" cellspacing="0" style="font-family:Arial, sans-serif; font-size:14px; line-height:1.4;">
        <tr>
            <td style="padding-right:16px; vertical-align:top;">
                <img src="{{avatar_url}}" alt="Profile" width="80" height="80" style="border-radius:8px; display:block;">
            </td>
            <td style="vertical-align:top;">
                <div style="font-weight:700; font-size:16px; color:#333; margin-bottom:4px;">{{full_name}}</div>
                <div style="color:{{accent_color}}; font-size:13px; margin-bottom:8px;">{{job_title}}</div>
                <div style="color:#666; font-size:13px;">
                    <div style="margin-bottom:3px;">Phone: <a href="tel:{{phone}}" style="color:#666; text-decoration:none;">{{phone}}</a></div>
                    <div>Web: <a href="{{website}}" style="color:{{accent_color}}; text-decoration:none;">{{website}}</a></div>
                </div>
            </td>
        </tr>
    </table>',
    NULL,
    TRUE
),
(
    'Modern Minimal',
    '<table cellpadding="0" cellspacing="0" style="font-family:''Helvetica Neue'', Helvetica, Arial, sans-serif; font-size:14px;">
        <tr>
            <td>
                <div style="font-weight:600; font-size:18px; color:#1a1a1a; margin-bottom:2px;">{{full_name}}</div>
                <div style="font-size:14px; color:{{accent_color}}; margin-bottom:12px;">{{job_title}}</div>
                <div style="border-top:2px solid {{accent_color}}; padding-top:12px;">
                    <div style="color:#666; font-size:13px; margin-bottom:4px;">
                        <strong>Phone:</strong> <a href="tel:{{phone}}" style="color:#666; text-decoration:none;">{{phone}}</a>
                    </div>
                    <div style="color:#666; font-size:13px;">
                        <strong>Web:</strong> <a href="{{website}}" style="color:{{accent_color}}; text-decoration:none;">{{website}}</a>
                    </div>
                </div>
            </td>
        </tr>
    </table>',
    NULL,
    TRUE
),
(
    'Compact Business',
    '<table cellpadding="0" cellspacing="0" style="font-family:Arial, sans-serif; font-size:13px; border-left:3px solid {{accent_color}}; padding-left:12px;">
        <tr>
            <td>
                <div style="font-weight:700; font-size:15px; color:#222; margin-bottom:3px;">{{full_name}}</div>
                <div style="font-size:13px; color:#666; margin-bottom:8px;">{{job_title}}</div>
                <div style="font-size:12px; color:#888;">
                    <span style="margin-right:10px;">T: <a href="tel:{{phone}}" style="color:#888; text-decoration:none;">{{phone}}</a></span>
                    <span>W: <a href="{{website}}" style="color:{{accent_color}}; text-decoration:none;">{{website}}</a></span>
                </div>
            </td>
        </tr>
    </table>',
    NULL,
    TRUE
);

-- Create default admin user (password: admin123)
-- Note: In production, use proper password hashing
INSERT INTO users (email, password_hash, full_name, role) VALUES
('admin@example.com', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewY5lWJ.KKBqKqPe', 'Admin User', 'ADMIN');

-- Create profile for admin
INSERT INTO profiles (user_id) VALUES (1);

-- Show tables
SHOW TABLES;

-- Display table structures
DESCRIBE users;
DESCRIBE profiles;
DESCRIBE templates;
DESCRIBE signatures;
