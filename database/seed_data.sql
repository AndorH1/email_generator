-- Seed data for Email Signature Generator
-- Use this after running schema.sql

USE email_signature_db;

-- Insert sample users (passwords are all 'password123')
-- Password hash generated with bcrypt for 'password123'
INSERT INTO users (email, password_hash, full_name, role) VALUES
('john.doe@example.com', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewY5lWJ.KKBqKqPe', 'John Doe', 'STUDENT'),
('jane.smith@example.com', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewY5lWJ.KKBqKqPe', 'Jane Smith', 'STUDENT'),
('bob.wilson@example.com', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewY5lWJ.KKBqKqPe', 'Bob Wilson', 'STUDENT'),
('alice.brown@example.com', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewY5lWJ.KKBqKqPe', 'Alice Brown', 'STUDENT'),
('teacher@example.com', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewY5lWJ.KKBqKqPe', 'Teacher Admin', 'ADMIN');

-- Insert profiles for users (user_id 1 is already created by schema.sql for admin)
INSERT INTO profiles (user_id, job_title, phone, website, avatar_url) VALUES
(2, 'Software Developer', '+36 30 123 4567', 'https://johndoe.dev', 'https://i.pravatar.cc/150?img=12'),
(3, 'UX Designer', '+36 30 234 5678', 'https://janesmith.design', 'https://i.pravatar.cc/150?img=45'),
(4, 'Project Manager', '+36 30 345 6789', 'https://bobwilson.com', 'https://i.pravatar.cc/150?img=33'),
(5, 'Marketing Specialist', '+36 30 456 7890', 'https://alicebrown.io', 'https://i.pravatar.cc/150?img=47'),
(6, 'Computer Science Teacher', '+36 30 567 8901', 'https://school.edu', 'https://i.pravatar.cc/150?img=60');

-- Insert more template variations
INSERT INTO templates (name, html_template, thumbnail_url, is_public) VALUES
(
    'Creative Designer',
    '<table cellpadding="0" cellspacing="0" style="font-family:''Segoe UI'', Tahoma, Geneva, Verdana, sans-serif; font-size:14px; max-width:500px;">
        <tr>
            <td style="padding:20px; background:linear-gradient(135deg, {{accent_color}} 0%, #667eea 100%); border-radius:12px;">
                <table cellpadding="0" cellspacing="0" style="width:100%;">
                    <tr>
                        <td style="text-align:center; padding-bottom:15px;">
                            <img src="{{avatar_url}}" alt="Profile" width="100" height="100" style="border-radius:50%; border:4px solid white; display:block; margin:0 auto;">
                        </td>
                    </tr>
                    <tr>
                        <td style="text-align:center;">
                            <div style="font-weight:700; font-size:20px; color:white; margin-bottom:5px;">{{full_name}}</div>
                            <div style="font-size:15px; color:#f0f0f0; margin-bottom:15px;">{{job_title}}</div>
                            <div style="font-size:13px; color:white; line-height:1.6;">
                                <div style="margin-bottom:5px;">Phone: {{phone}}</div>
                                <div>Web: <a href="{{website}}" style="color:white; text-decoration:underline;">{{website}}</a></div>
                            </div>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>',
    NULL,
    TRUE
),
(
    'Corporate Blue',
    '<table cellpadding="0" cellspacing="0" style="font-family:Arial, sans-serif; font-size:13px; color:#333;">
        <tr>
            <td style="padding-right:20px; border-right:3px solid {{accent_color}}; vertical-align:top;">
                <img src="{{avatar_url}}" alt="Profile" width="100" height="100" style="display:block;">
            </td>
            <td style="padding-left:20px; vertical-align:top;">
                <div style="font-weight:700; font-size:17px; color:{{accent_color}}; margin-bottom:5px;">{{full_name}}</div>
                <div style="font-size:14px; color:#666; margin-bottom:10px; font-style:italic;">{{job_title}}</div>
                <table cellpadding="0" cellspacing="0" style="font-size:12px; color:#555;">
                    <tr>
                        <td style="padding:3px 10px 3px 0; font-weight:600;">Phone:</td>
                        <td style="padding:3px 0;"><a href="tel:{{phone}}" style="color:#555; text-decoration:none;">{{phone}}</a></td>
                    </tr>
                    <tr>
                        <td style="padding:3px 10px 3px 0; font-weight:600;">Website:</td>
                        <td style="padding:3px 0;"><a href="{{website}}" style="color:{{accent_color}}; text-decoration:none;">{{website}}</a></td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>',
    NULL,
    TRUE
),
(
    'Elegant Simple',
    '<table cellpadding="0" cellspacing="0" style="font-family:''Georgia'', serif; font-size:14px;">
        <tr>
            <td>
                <div style="border-bottom:2px solid {{accent_color}}; padding-bottom:10px; margin-bottom:10px;">
                    <div style="font-weight:700; font-size:20px; color:#2c3e50;">{{full_name}}</div>
                    <div style="font-size:15px; color:{{accent_color}}; font-style:italic;">{{job_title}}</div>
                </div>
                <div style="font-size:13px; color:#555; line-height:1.8;">
                    <div>Phone: <a href="tel:{{phone}}" style="color:#555; text-decoration:none;">{{phone}}</a></div>
                    <div>Link: <a href="{{website}}" style="color:{{accent_color}}; text-decoration:none;">Visit Website</a></div>
                </div>
            </td>
        </tr>
    </table>',
    NULL,
    TRUE
);

-- Insert sample signatures for users
INSERT INTO signatures (user_id, template_id, data, html_rendered) VALUES
(
    2,
    1,
    '{"full_name": "John Doe", "job_title": "Software Developer", "phone": "+36 30 123 4567", "website": "https://johndoe.dev", "avatar_url": "https://i.pravatar.cc/150?img=12", "accent_color": "#0d6efd"}',
    '<table cellpadding="0" cellspacing="0" style="font-family:Arial, sans-serif; font-size:14px; line-height:1.4;"><tr><td style="padding-right:16px; vertical-align:top;"><img src="https://i.pravatar.cc/150?img=12" alt="Profile" width="80" height="80" style="border-radius:8px; display:block;"></td><td style="vertical-align:top;"><div style="font-weight:700; font-size:16px; color:#333; margin-bottom:4px;">John Doe</div><div style="color:#0d6efd; font-size:13px; margin-bottom:8px;">Software Developer</div><div style="color:#666; font-size:13px;"><div style="margin-bottom:3px;">Phone: <a href="tel:+36 30 123 4567" style="color:#666; text-decoration:none;">+36 30 123 4567</a></div><div>Web: <a href="https://johndoe.dev" style="color:#0d6efd; text-decoration:none;">https://johndoe.dev</a></div></div></td></tr></table>'
),
(
    2,
    4,
    '{"full_name": "John Doe", "job_title": "Senior Developer", "phone": "+36 30 123 4567", "website": "https://johndoe.dev", "avatar_url": "https://i.pravatar.cc/150?img=12", "accent_color": "#7952b3"}',
    '<table cellpadding="0" cellspacing="0" style="font-family:''Segoe UI'', Tahoma, Geneva, Verdana, sans-serif; font-size:14px; max-width:500px;"><tr><td style="padding:20px; background:linear-gradient(135deg, #7952b3 0%, #667eea 100%); border-radius:12px;"><table cellpadding="0" cellspacing="0" style="width:100%;"><tr><td style="text-align:center; padding-bottom:15px;"><img src="https://i.pravatar.cc/150?img=12" alt="Profile" width="100" height="100" style="border-radius:50%; border:4px solid white; display:block; margin:0 auto;"></td></tr><tr><td style="text-align:center;"><div style="font-weight:700; font-size:20px; color:white; margin-bottom:5px;">John Doe</div><div style="font-size:15px; color:#f0f0f0; margin-bottom:15px;">Senior Developer</div><div style="font-size:13px; color:white; line-height:1.6;"><div style="margin-bottom:5px;">📞 +36 30 123 4567</div><div>🌐 <a href="https://johndoe.dev" style="color:white; text-decoration:underline;">https://johndoe.dev</a></div></div></td></tr></table></td></tr></table>'
),
(
    3,
    2,
    '{"full_name": "Jane Smith", "job_title": "UX Designer", "phone": "+36 30 234 5678", "website": "https://janesmith.design", "avatar_url": "https://i.pravatar.cc/150?img=45", "accent_color": "#d63384"}',
    '<table cellpadding="0" cellspacing="0" style="font-family:''Helvetica Neue'', Helvetica, Arial, sans-serif; font-size:14px;"><tr><td><div style="font-weight:600; font-size:18px; color:#1a1a1a; margin-bottom:2px;">Jane Smith</div><div style="font-size:14px; color:#d63384; margin-bottom:12px;">UX Designer</div><div style="border-top:2px solid #d63384; padding-top:12px;"><div style="color:#666; font-size:13px; margin-bottom:4px;"><strong>Phone:</strong> <a href="tel:+36 30 234 5678" style="color:#666; text-decoration:none;">+36 30 234 5678</a></div><div style="color:#666; font-size:13px;"><strong>Web:</strong> <a href="https://janesmith.design" style="color:#d63384; text-decoration:none;">https://janesmith.design</a></div></div></td></tr></table>'
),
(
    4,
    3,
    '{"full_name": "Bob Wilson", "job_title": "Project Manager", "phone": "+36 30 345 6789", "website": "https://bobwilson.com", "avatar_url": "https://i.pravatar.cc/150?img=33", "accent_color": "#198754"}',
    '<table cellpadding="0" cellspacing="0" style="font-family:Arial, sans-serif; font-size:13px; border-left:3px solid #198754; padding-left:12px;"><tr><td><div style="font-weight:700; font-size:15px; color:#222; margin-bottom:3px;">Bob Wilson</div><div style="font-size:13px; color:#666; margin-bottom:8px;">Project Manager</div><div style="font-size:12px; color:#888;"><span style="margin-right:10px;">T: <a href="tel:+36 30 345 6789" style="color:#888; text-decoration:none;">+36 30 345 6789</a></span><span>W: <a href="https://bobwilson.com" style="color:#198754; text-decoration:none;">https://bobwilson.com</a></span></div></td></tr></table>'
),
(
    5,
    6,
    '{"full_name": "Alice Brown", "job_title": "Marketing Specialist", "phone": "+36 30 456 7890", "website": "https://alicebrown.io", "avatar_url": "https://i.pravatar.cc/150?img=47", "accent_color": "#fd7e14"}',
    '<table cellpadding="0" cellspacing="0" style="font-family:''Georgia'', serif; font-size:14px;"><tr><td><div style="border-bottom:2px solid #fd7e14; padding-bottom:10px; margin-bottom:10px;"><div style="font-weight:700; font-size:20px; color:#2c3e50;">Alice Brown</div><div style="font-size:15px; color:#fd7e14; font-style:italic;">Marketing Specialist</div></div><div style="font-size:13px; color:#555; line-height:1.8;"><div>📱 <a href="tel:+36 30 456 7890" style="color:#555; text-decoration:none;">+36 30 456 7890</a></div><div>🔗 <a href="https://alicebrown.io" style="color:#fd7e14; text-decoration:none;">Visit Website</a></div></div></td></tr></table>'
);

-- Show counts
SELECT 'Users created:' as info, COUNT(*) as count FROM users;
SELECT 'Profiles created:' as info, COUNT(*) as count FROM profiles;
SELECT 'Templates available:' as info, COUNT(*) as count FROM templates;
SELECT 'Signatures created:' as info, COUNT(*) as count FROM signatures;
