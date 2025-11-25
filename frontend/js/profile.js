// Profile page JavaScript

document.addEventListener('DOMContentLoaded', function () {
    loadProfile();

    const profileForm = document.getElementById('profileForm');
    if (profileForm) {
        profileForm.addEventListener('submit', handleProfileUpdate);
    }

    const logoutBtn = document.getElementById('logoutBtn');
    if (logoutBtn) {
        logoutBtn.addEventListener('click', handleLogout);
    }
});

// Load profile data
async function loadProfile() {
    try {
        const data = await apiRequest(API_ENDPOINTS.profile, {
            method: 'GET'
        });

        // Populate form fields
        document.getElementById('jobTitle').value = data.job_title || '';
        document.getElementById('phone').value = data.phone || '';
        document.getElementById('website').value = data.website || '';
        document.getElementById('avatarUrl').value = data.avatar_url || '';

    } catch (error) {
        showAlert('profileError', 'Failed to load profile: ' + error.message, 'danger');
    }
}

// Update profile
async function handleProfileUpdate(e) {
    e.preventDefault();

    const profileData = {
        job_title: document.getElementById('jobTitle').value,
        phone: document.getElementById('phone').value,
        website: document.getElementById('website').value,
        avatar_url: document.getElementById('avatarUrl').value
    };

    try {
        await apiRequest(API_ENDPOINTS.profile, {
            method: 'PUT',
            body: JSON.stringify(profileData)
        });

        showAlert('profileSuccess', 'Profile updated successfully!', 'success');

    } catch (error) {
        showAlert('profileError', 'Failed to update profile: ' + error.message, 'danger');
    }
}
