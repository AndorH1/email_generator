<?php

namespace Database\Seeders;

use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;
use App\Models\Template;

class TemplateSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        Template::create([
            'name' => 'Classic Professional',
            'html_template' => '<table cellpadding="0" cellspacing="0" style="font-family:Arial, sans-serif; font-size:14px; line-height:1.4;">
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
            'is_public' => true,
        ]);

        Template::create([
            'name' => 'Modern Minimal',
            'html_template' => '<table cellpadding="0" cellspacing="0" style="font-family:\'Helvetica Neue\', Helvetica, Arial, sans-serif; font-size:14px;">
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
            'is_public' => true,
        ]);

        Template::create([
            'name' => 'Compact Business',
            'html_template' => '<table cellpadding="0" cellspacing="0" style="font-family:Arial, sans-serif; font-size:13px; border-left:3px solid {{accent_color}}; padding-left:12px;">
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
            'is_public' => true,
        ]);
    }
}
