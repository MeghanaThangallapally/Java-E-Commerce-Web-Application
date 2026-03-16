package com.shopflow.dao;

import com.shopflow.model.Cart;
import com.shopflow.model.Order;
import com.shopflow.model.Order.OrderItem;
import com.shopflow.model.Product;
import com.shopflow.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class OrderDAO {

    private final ProductDAO productDAO = new ProductDAO();

    // ── Place a new order (full transaction) ───────────────────────────────

    /**
     * Inserts order + order_items rows and deducts stock — all in one transaction.
     * Returns the new order ID on success, or -1 on failure.
     */
    public int placeOrder(int userId, Cart cart) throws SQLException {
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            // 1. Insert order header
            int orderId = insertOrderHeader(conn, userId, cart.getTotalPrice());

            // 2. Insert each line item and deduct stock
            for (Cart.CartItem item : cart.getItems()) {
                insertOrderItem(conn, orderId, item);
                boolean ok = productDAO.deductStock(conn, item.getProduct().getId(), item.getQuantity());
                if (!ok) {
                    conn.rollback();
                    return -1;   // insufficient stock
                }
            }

            conn.commit();
            return orderId;

        } catch (SQLException e) {
            if (conn != null) conn.rollback();
            throw e;
        } finally {
            if (conn != null) { conn.setAutoCommit(true); conn.close(); }
        }
    }

    // ── Orders for a specific user ─────────────────────────────────────────

    public List<Order> getOrdersByUser(int userId) throws SQLException {
        List<Order> orders = new ArrayList<>();
        String sql = "SELECT * FROM orders WHERE user_id = ? ORDER BY order_date DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Order o = mapOrderRow(rs);
                    o.setItems(getItemsByOrderId(o.getId()));
                    orders.add(o);
                }
            }
        }
        return orders;
    }

    // ── All orders (admin) ─────────────────────────────────────────────────

    public List<Order> getAllOrders() throws SQLException {
        List<Order> orders = new ArrayList<>();
        String sql = "SELECT o.*, u.name AS user_name " +
                     "FROM orders o JOIN users u ON o.user_id = u.id " +
                     "ORDER BY o.order_date DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Order o = mapOrderRow(rs);
                o.setUserName(rs.getString("user_name"));
                o.setItems(getItemsByOrderId(o.getId()));
                orders.add(o);
            }
        }
        return orders;
    }

    // ── Get single order ───────────────────────────────────────────────────

    public Order getOrderById(int orderId) throws SQLException {
        String sql = "SELECT * FROM orders WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, orderId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Order o = mapOrderRow(rs);
                    o.setItems(getItemsByOrderId(o.getId()));
                    return o;
                }
            }
        }
        return null;
    }

    // ── Update order status (admin) ────────────────────────────────────────

    public boolean updateOrderStatus(int orderId, String status) throws SQLException {
        String sql = "UPDATE orders SET status = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, status);
            ps.setInt(2, orderId);
            return ps.executeUpdate() == 1;
        }
    }

    // ── Private helpers ────────────────────────────────────────────────────

    private int insertOrderHeader(Connection conn, int userId, java.math.BigDecimal total) throws SQLException {
        String sql = "INSERT INTO orders (user_id, total_amount, status) VALUES (?, ?, 'Processing')";
        try (PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, userId);
            ps.setBigDecimal(2, total);
            ps.executeUpdate();
            try (ResultSet keys = ps.getGeneratedKeys()) {
                if (keys.next()) return keys.getInt(1);
            }
        }
        throw new SQLException("Failed to insert order header");
    }

    private void insertOrderItem(Connection conn, int orderId, Cart.CartItem item) throws SQLException {
        String sql = "INSERT INTO order_items (order_id, product_id, quantity, price) VALUES (?,?,?,?)";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            ps.setInt(2, item.getProduct().getId());
            ps.setInt(3, item.getQuantity());
            ps.setBigDecimal(4, item.getProduct().getPrice());
            ps.executeUpdate();
        }
    }

    private List<OrderItem> getItemsByOrderId(int orderId) throws SQLException {
        List<OrderItem> items = new ArrayList<>();
        String sql = "SELECT oi.*, p.name, p.image_url FROM order_items oi " +
                     "JOIN products p ON oi.product_id = p.id WHERE oi.order_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, orderId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Product p = new Product();
                    p.setId(rs.getInt("product_id"));
                    p.setName(rs.getString("name"));
                    p.setImageUrl(rs.getString("image_url"));

                    OrderItem item = new OrderItem();
                    item.setOrderId(orderId);
                    item.setProduct(p);
                    item.setQuantity(rs.getInt("quantity"));
                    item.setPrice(rs.getBigDecimal("price"));
                    items.add(item);
                }
            }
        }
        return items;
    }

    private Order mapOrderRow(ResultSet rs) throws SQLException {
        Order o = new Order();
        o.setId(rs.getInt("id"));
        o.setUserId(rs.getInt("user_id"));
        o.setTotalAmount(rs.getBigDecimal("total_amount"));
        o.setStatus(rs.getString("status"));
        o.setOrderDate(rs.getTimestamp("order_date"));
        return o;
    }
}
