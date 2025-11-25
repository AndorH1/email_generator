// Dashboard page JavaScript

document.addEventListener('DOMContentLoaded', function () {
    loadSignatures();

    const logoutBtn = document.getElementById('logoutBtn');
    if (logoutBtn) {
        logoutBtn.addEventListener('click', handleLogout);
    }
});

// Load signatures
async function loadSignatures() {
    try {
        const signatures = await apiRequest(API_ENDPOINTS.signatures, {
            method: 'GET'
        });

        const container = document.getElementById('signaturesContainer');
        const noSignatures = document.getElementById('noSignatures');

        if (signatures.length === 0) {
            noSignatures.classList.remove('d-none');
            return;
        }

        noSignatures.classList.add('d-none');
        container.innerHTML = '';

        signatures.forEach(signature => {
            const card = createSignatureCard(signature);
            container.appendChild(card);
        });

    } catch (error) {
        console.error('Failed to load signatures:', error);
        alert('Failed to load signatures');
    }
}

// Create signature card
function createSignatureCard(signature) {
    const col = document.createElement('div');
    col.className = 'col-md-6 col-lg-4 mb-4';

    const date = new Date(signature.created_at).toLocaleDateString();

    // Proxy external images through our backend
    let html = signature.html_rendered;
    html = proxyImagesInHtml(html);

    col.innerHTML = `
        <div class="card signature-card shadow-sm h-100">
            <div class="card-body">
                <div class="signature-preview mb-3">
                    ${html}
                </div>
                <p class="text-muted small mb-2">Created: ${date}</p>
                <div class="d-grid gap-2">
                    <button class="btn btn-sm btn-primary" onclick="editSignature(${signature.id})">Edit</button>
                    <button class="btn btn-sm btn-outline-secondary" onclick="copySignature(${signature.id})">Copy HTML</button>
                    <button class="btn btn-sm btn-outline-danger" onclick="deleteSignature(${signature.id})">Delete</button>
                </div>
            </div>
        </div>
    `;

    return col;
}

// Proxy external images to avoid CORS/hotlinking issues
function proxyImagesInHtml(html) {
    // Replace img src URLs with proxied versions (except data URIs and already proxied URLs)
    return html.replace(/(<img[^>]+src=["'])([^"']+)(["'][^>]*>)/gi, function (match, prefix, url, suffix) {
        if (!url.startsWith('data:') && !url.includes('/api/image-proxy')) {
            return prefix + `${API_BASE_URL}/image-proxy?url=${encodeURIComponent(url)}` + suffix;
        }
        return match;
    });
}

// Edit signature
function editSignature(id) {
    window.location.href = `/editor?id=${id}`;
}

// Copy signature
async function copySignature(id) {
    try {
        const html = await apiRequest(API_ENDPOINTS.signatureExport(id), {
            method: 'GET'
        });

        // Convert response to text if it's not already
        const htmlText = typeof html === 'string' ? html : JSON.stringify(html);

        navigator.clipboard.writeText(htmlText).then(() => {
            alert('HTML copied to clipboard!');
        });

    } catch (error) {
        console.error('Failed to copy signature:', error);
        alert('Failed to copy signature');
    }
}

// Delete signature
async function deleteSignature(id) {
    if (!confirm('Are you sure you want to delete this signature? This action cannot be undone.')) {
        return;
    }

    try {
        await apiRequest(API_ENDPOINTS.signatureDetail(id), {
            method: 'DELETE'
        });

        alert('Signature deleted successfully!');
        loadSignatures(); // Reload the list

    } catch (error) {
        console.error('Failed to delete signature:', error);
        alert('Failed to delete signature: ' + error.message);
    }
}
