// Editor page JavaScript

let templates = [];
let currentTemplate = null;
let editingSignatureId = null;

document.addEventListener('DOMContentLoaded', function () {
    loadTemplates();

    const templateSelect = document.getElementById('templateSelect');
    const previewBtn = document.getElementById('previewBtn');
    const signatureForm = document.getElementById('signatureForm');
    const copyBtn = document.getElementById('copyBtn');
    const downloadBtn = document.getElementById('downloadBtn');

    if (templateSelect) {
        templateSelect.addEventListener('change', handleTemplateChange);
    }

    if (previewBtn) {
        previewBtn.addEventListener('click', updatePreview);
    }

    if (signatureForm) {
        signatureForm.addEventListener('submit', handleSaveSignature);
    }

    if (copyBtn) {
        copyBtn.addEventListener('click', copyToClipboard);
    }

    if (downloadBtn) {
        downloadBtn.addEventListener('click', downloadHTML);
    }
});

// Load templates
async function loadTemplates() {
    try {
        templates = await apiRequest(API_ENDPOINTS.templates, {
            method: 'GET'
        });

        const templateSelect = document.getElementById('templateSelect');
        templateSelect.innerHTML = '<option value="">Select a template</option>';

        templates.forEach(template => {
            const option = document.createElement('option');
            option.value = template.id;
            option.textContent = template.name;
            templateSelect.appendChild(option);
        });

        // After templates are loaded, check if we're editing an existing signature
        const urlParams = new URLSearchParams(window.location.search);
        editingSignatureId = urlParams.get('id');

        if (editingSignatureId) {
            // Load existing signature data
            await loadExistingSignature(editingSignatureId);
        } else {
            // Load profile data to prefill form
            await loadProfileData();
        }

    } catch (error) {
        showAlert('editorError', 'Failed to load templates: ' + error.message, 'danger');
    }
}

// Handle template change
function handleTemplateChange(e) {
    const templateId = parseInt(e.target.value);
    currentTemplate = templates.find(t => t.id === templateId);
    updatePreview();
}

// Load profile data
async function loadProfileData() {
    try {
        const profile = await apiRequest(API_ENDPOINTS.profile, {
            method: 'GET'
        });

        // Prefill form with profile data including full name
        if (profile.full_name) document.getElementById('full_name').value = profile.full_name;
        if (profile.job_title) document.getElementById('job_title').value = profile.job_title;
        if (profile.phone) document.getElementById('phone').value = profile.phone;
        if (profile.website) document.getElementById('website').value = profile.website;
        if (profile.avatar_url) document.getElementById('avatar_url').value = profile.avatar_url;

    } catch (error) {
        console.error('Failed to load profile data:', error);
    }
}

// Load existing signature data
async function loadExistingSignature(signatureId) {
    try {
        const signature = await apiRequest(API_ENDPOINTS.signatureDetail(signatureId), {
            method: 'GET'
        });

        // Populate form with existing signature data
        if (signature.data.full_name) document.getElementById('full_name').value = signature.data.full_name;
        if (signature.data.job_title) document.getElementById('job_title').value = signature.data.job_title;
        if (signature.data.phone) document.getElementById('phone').value = signature.data.phone;
        if (signature.data.website) document.getElementById('website').value = signature.data.website;
        if (signature.data.avatar_url) document.getElementById('avatar_url').value = signature.data.avatar_url;
        if (signature.data.accent_color) document.getElementById('accent_color').value = signature.data.accent_color;

        // Set the template
        if (signature.template_id) {
            document.getElementById('templateSelect').value = signature.template_id;
            currentTemplate = templates.find(t => t.id === signature.template_id);
            if (currentTemplate) {
                updatePreview();
            }
        }

        // Change page title to indicate editing
        const pageTitle = document.querySelector('h2');
        if (pageTitle) {
            pageTitle.textContent = 'Edit Signature';
        }

    } catch (error) {
        console.error('Failed to load signature:', error);
        showAlert('editorError', 'Failed to load signature: ' + error.message, 'danger');
        // Fall back to loading profile data
        loadProfileData();
    }
}

// Update preview
function updatePreview() {
    if (!currentTemplate) {
        return;
    }

    const avatarUrl = document.getElementById('avatar_url').value;

    // Warn about non-direct image URLs
    if (avatarUrl && !isDirectImageUrl(avatarUrl)) {
        showAlert('editorError',
            '⚠️ Warning: This doesn\'t appear to be a direct image URL. It may not display in email clients.',
            'warning');
    }

    const data = {
        full_name: document.getElementById('full_name').value || 'Your Name',
        job_title: document.getElementById('job_title').value || 'Your Title',
        phone: document.getElementById('phone').value || '+36 30 123 4567',
        website: document.getElementById('website').value || 'https://example.com',
        avatar_url: avatarUrl || 'https://via.placeholder.com/72',
        accent_color: document.getElementById('accent_color').value || '#0d6efd'
    };

    let html = currentTemplate.html_template;

    // Replace placeholders
    for (const [key, value] of Object.entries(data)) {
        const placeholder = new RegExp(`{{${key}}}`, 'g');
        html = html.replace(placeholder, value);
    }

    document.getElementById('signaturePreview').innerHTML = html;
}

// Check if URL is a direct image URL
function isDirectImageUrl(url) {
    if (!url) return false;

    // Check if URL ends with common image extensions
    const imageExtensions = ['.jpg', '.jpeg', '.png', '.gif', '.webp', '.svg'];
    const lowerUrl = url.toLowerCase();

    // Also check for known problematic domains
    const problematicDomains = ['photos.google.com', 'drive.google.com', 'dropbox.com/s'];

    if (problematicDomains.some(domain => lowerUrl.includes(domain))) {
        return false;
    }

    return imageExtensions.some(ext => lowerUrl.endsWith(ext)) ||
        lowerUrl.includes('imgur.com') ||
        lowerUrl.includes('postimages.org') ||
        lowerUrl.includes('i.pravatar.cc') ||
        lowerUrl.includes('via.placeholder.com');
}

// Save signature (Create or Update)
async function handleSaveSignature(e) {
    e.preventDefault();

    if (!currentTemplate) {
        showAlert('editorError', 'Please select a template first', 'warning');
        return;
    }

    const data = {
        full_name: document.getElementById('full_name').value,
        job_title: document.getElementById('job_title').value,
        phone: document.getElementById('phone').value,
        website: document.getElementById('website').value,
        avatar_url: document.getElementById('avatar_url').value,
        accent_color: document.getElementById('accent_color').value
    };

    try {
        if (editingSignatureId) {
            // Update existing signature
            await apiRequest(API_ENDPOINTS.signatureDetail(editingSignatureId), {
                method: 'PUT',
                body: JSON.stringify({
                    template_id: currentTemplate.id,
                    data: data
                })
            });
            alert('Signature updated successfully!');
        } else {
            // Create new signature
            await apiRequest(API_ENDPOINTS.signatures, {
                method: 'POST',
                body: JSON.stringify({
                    template_id: currentTemplate.id,
                    data: data
                })
            });
            alert('Signature saved successfully!');
        }

        window.location.href = 'dashboard.html';

    } catch (error) {
        showAlert('editorError', 'Failed to save signature: ' + error.message, 'danger');
    }
}

// Copy to clipboard
function copyToClipboard() {
    const preview = document.getElementById('signaturePreview');
    const html = preview.innerHTML;

    navigator.clipboard.writeText(html).then(() => {
        alert('HTML copied to clipboard!');
    }).catch(err => {
        console.error('Failed to copy:', err);
        alert('Failed to copy to clipboard');
    });
}

// Download HTML
function downloadHTML() {
    const preview = document.getElementById('signaturePreview');
    const html = preview.innerHTML;

    const blob = new Blob([html], { type: 'text/html' });
    const url = URL.createObjectURL(blob);
    const a = document.createElement('a');
    a.href = url;
    a.download = 'email-signature.html';
    document.body.appendChild(a);
    a.click();
    document.body.removeChild(a);
    URL.revokeObjectURL(url);
}
