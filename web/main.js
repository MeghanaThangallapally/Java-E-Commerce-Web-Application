/* ============================================================
   ShopFlow  |  main.js
   ============================================================ */

/* ── Toast notification ──────────────────────────────────── */
function showToast(message, type = 'success') {
    let toast = document.getElementById('toast');
    if (!toast) {
        toast = document.createElement('div');
        toast.id = 'toast';
        document.body.appendChild(toast);
    }
    toast.textContent = message;
    toast.className   = type === 'error' ? 'error' : '';
    toast.style.display = 'block';
    clearTimeout(toast._timer);
    toast._timer = setTimeout(() => { toast.style.display = 'none'; }, 3000);
}

/* ── Cart: update quantity inline ────────────────────────── */
function changeQty(productId, delta) {
    const input = document.getElementById('qty-' + productId);
    if (!input) return;
    let val = parseInt(input.value) + delta;
    if (val < 1) val = 1;
    input.value = val;
}

/* ── Cart: submit update form for a specific product ─────── */
function updateCart(productId) {
    const input = document.getElementById('qty-' + productId);
    if (!input) return;
    const form = document.getElementById('form-' + productId);
    if (form) form.submit();
}

/* ── Confirm before delete / remove ─────────────────────── */
function confirmAction(message, formId) {
    if (confirm(message)) {
        const form = document.getElementById(formId);
        if (form) form.submit();
    }
}

/* ── Product search: live filter (client-side fallback) ─── */
function filterProducts() {
    const keyword  = document.getElementById('searchInput')?.value.toLowerCase() || '';
    const cards    = document.querySelectorAll('.product-card');
    cards.forEach(card => {
        const name = card.dataset.name?.toLowerCase() || '';
        const cat  = card.dataset.category?.toLowerCase() || '';
        card.style.display = (name.includes(keyword) || cat.includes(keyword)) ? '' : 'none';
    });
}

/* ── Admin: toggle add-product form ─────────────────────── */
function toggleAddForm() {
    const form = document.getElementById('addProductForm');
    if (!form) return;
    form.style.display = form.style.display === 'none' ? 'block' : 'none';
}

/* ── Admin: populate edit-product form ──────────────────── */
function editProduct(id, name, category, price, stock, description, imageUrl) {
    document.getElementById('editId')?.setAttribute('value', id);
    document.getElementById('editName')?.setAttribute('value', name);
    document.getElementById('editCategory')?.setAttribute('value', category);
    document.getElementById('editPrice')?.setAttribute('value', price);
    document.getElementById('editStock')?.setAttribute('value', stock);
    document.getElementById('editDescription')?.setAttribute('value', description);
    document.getElementById('editImageUrl')?.setAttribute('value', imageUrl || '');
    const modal = document.getElementById('editModal');
    if (modal) modal.style.display = 'flex';
}

function closeModal(id) {
    const modal = document.getElementById(id);
    if (modal) modal.style.display = 'none';
}

/* ── Close modal on backdrop click ──────────────────────── */
document.addEventListener('click', function (e) {
    if (e.target.classList.contains('modal-overlay')) {
        e.target.style.display = 'none';
    }
});

/* ── Active nav link ─────────────────────────────────────── */
document.addEventListener('DOMContentLoaded', function () {
    const path  = window.location.pathname;
    const links = document.querySelectorAll('.navbar-links a');
    links.forEach(link => {
        if (link.href && path.includes(link.getAttribute('href'))) {
            link.classList.add('active');
        }
    });

    /* Auto-dismiss alerts after 4 seconds */
    document.querySelectorAll('.alert').forEach(el => {
        setTimeout(() => {
            el.style.transition = 'opacity .5s';
            el.style.opacity = '0';
            setTimeout(() => el.remove(), 500);
        }, 4000);
    });
});

/* ── Cart count badge live update ────────────────────────── */
function updateCartBadge(count) {
    const badge = document.getElementById('cartBadge');
    if (!badge) return;
    if (count > 0) {
        badge.textContent = count;
        badge.style.display = 'inline-flex';
    } else {
        badge.style.display = 'none';
    }
}

/* ── Price formatter ─────────────────────────────────────── */
function formatPrice(amount) {
    return '₹' + parseFloat(amount).toFixed(2).replace(/\B(?=(\d{3})+(?!\d))/g, ',');
}
