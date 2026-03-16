package com.shopflow.model;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

/**
 * Cart is stored in the HTTP session, so it must be Serializable.
 */
public class Cart implements Serializable {

    private static final long serialVersionUID = 1L;

    // ── Inner class: one line in the cart ──────────────────────────────────
    public static class CartItem implements Serializable {
        private static final long serialVersionUID = 1L;

        private Product product;
        private int     quantity;

        public CartItem(Product product, int quantity) {
            this.product  = product;
            this.quantity = quantity;
        }

        public Product getProduct()           { return product; }
        public int     getQuantity()          { return quantity; }
        public void    setQuantity(int qty)   { this.quantity = qty; }

        public BigDecimal getSubtotal() {
            return product.getPrice().multiply(BigDecimal.valueOf(quantity));
        }
    }

    // ── Cart fields ────────────────────────────────────────────────────────
    private final List<CartItem> items = new ArrayList<>();

    // ── Operations ────────────────────────────────────────────────────────

    /** Add product or increment quantity if already present. */
    public void addItem(Product product, int qty) {
        for (CartItem item : items) {
            if (item.getProduct().getId() == product.getId()) {
                item.setQuantity(item.getQuantity() + qty);
                return;
            }
        }
        items.add(new CartItem(product, qty));
    }

    /** Remove a product from the cart entirely. */
    public void removeItem(int productId) {
        items.removeIf(item -> item.getProduct().getId() == productId);
    }

    /** Update quantity; removes item if qty <= 0. */
    public void updateQuantity(int productId, int newQty) {
        if (newQty <= 0) { removeItem(productId); return; }
        for (CartItem item : items) {
            if (item.getProduct().getId() == productId) {
                item.setQuantity(newQty);
                return;
            }
        }
    }

    public void clear() { items.clear(); }

    public List<CartItem> getItems() { return items; }

    public boolean isEmpty() { return items.isEmpty(); }

    public int getTotalItems() {
        return items.stream().mapToInt(CartItem::getQuantity).sum();
    }

    public BigDecimal getTotalPrice() {
        return items.stream()
                    .map(CartItem::getSubtotal)
                    .reduce(BigDecimal.ZERO, BigDecimal::add);
    }
}
