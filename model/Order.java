package com.shopflow.model;

import java.math.BigDecimal;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

public class Order {

    // ── Inner class: one line item inside an order ─────────────────────────
    public static class OrderItem {

        private int        id;
        private int        orderId;
        private Product    product;
        private int        quantity;
        private BigDecimal price;      // price at time of purchase

        public OrderItem() {}

        public OrderItem(Product product, int quantity, BigDecimal price) {
            this.product  = product;
            this.quantity = quantity;
            this.price    = price;
        }

        public int        getId()                    { return id; }
        public void       setId(int id)              { this.id = id; }

        public int        getOrderId()               { return orderId; }
        public void       setOrderId(int orderId)    { this.orderId = orderId; }

        public Product    getProduct()               { return product; }
        public void       setProduct(Product p)      { this.product = p; }

        public int        getQuantity()              { return quantity; }
        public void       setQuantity(int qty)       { this.quantity = qty; }

        public BigDecimal getPrice()                 { return price; }
        public void       setPrice(BigDecimal price) { this.price = price; }

        public BigDecimal getSubtotal() {
            return price.multiply(BigDecimal.valueOf(quantity));
        }
    }

    // ── Order fields ───────────────────────────────────────────────────────
    private int             id;
    private int             userId;
    private String          userName;   // denormalised for display
    private BigDecimal      totalAmount;
    private String          status;     // Processing | Shipped | Delivered | Cancelled
    private Timestamp       orderDate;
    private List<OrderItem> items = new ArrayList<>();

    public Order() {}

    // ── Getters & Setters ──────────────────────────────────────────────────

    public int getId()                            { return id; }
    public void setId(int id)                     { this.id = id; }

    public int getUserId()                        { return userId; }
    public void setUserId(int userId)             { this.userId = userId; }

    public String getUserName()                   { return userName; }
    public void setUserName(String userName)      { this.userName = userName; }

    public BigDecimal getTotalAmount()            { return totalAmount; }
    public void setTotalAmount(BigDecimal total)  { this.totalAmount = total; }

    public String getStatus()                     { return status; }
    public void setStatus(String status)          { this.status = status; }

    public Timestamp getOrderDate()               { return orderDate; }
    public void setOrderDate(Timestamp orderDate) { this.orderDate = orderDate; }

    public List<OrderItem> getItems()             { return items; }
    public void setItems(List<OrderItem> items)   { this.items = items; }

    public void addItem(OrderItem item)           { items.add(item); }
}
