package com.shopflow.servlet;

import com.shopflow.dao.OrderDAO;
import com.shopflow.dao.ProductDAO;
import com.shopflow.dao.UserDAO;
import com.shopflow.model.Product;
import com.shopflow.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.math.BigDecimal;

@WebServlet("/admin/*")
public class AdminServlet extends HttpServlet {

    private final ProductDAO productDAO = new ProductDAO();
    private final OrderDAO   orderDAO   = new OrderDAO();
    private final UserDAO    userDAO    = new UserDAO();

    // ── Dispatch by path ───────────────────────────────────────────────────
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        if (!isAdmin(req, resp)) return;
        String path = getPath(req);

        switch (path) {
            case "/dashboard":
            case "":
                loadDashboard(req, resp);
                break;
            case "/products":
                req.setAttribute("products", productDAO.getAllProducts());
                req.getRequestDispatcher("/jsp/admin/productManagement.jsp").forward(req, resp);
                break;
            case "/orders":
                req.setAttribute("orders", orderDAO.getAllOrders());
                req.getRequestDispatcher("/jsp/admin/orders.jsp").forward(req, resp);
                break;
            default:
                resp.sendRedirect(req.getContextPath() + "/admin/dashboard");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        if (!isAdmin(req, resp)) return;
        req.setCharacterEncoding("UTF-8");
        String action = req.getParameter("action");
        if (action == null) { resp.sendRedirect(req.getContextPath() + "/admin/dashboard"); return; }

        switch (action) {
            case "addProduct":    addProduct(req, resp);    break;
            case "updateProduct": updateProduct(req, resp); break;
            case "deleteProduct": deleteProduct(req, resp); break;
            case "updateOrder":   updateOrder(req, resp);   break;
            default:
                resp.sendRedirect(req.getContextPath() + "/admin/dashboard");
        }
    }

    // ── Dashboard ──────────────────────────────────────────────────────────
    private void loadDashboard(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            req.setAttribute("totalProducts", productDAO.getAllProducts().size());
            req.setAttribute("totalOrders",   orderDAO.getAllOrders().size());
            req.setAttribute("totalUsers",    userDAO.getAllUsers().size());
            req.setAttribute("recentOrders",  orderDAO.getAllOrders().stream().limit(5).toList());
            req.getRequestDispatcher("/jsp/admin/dashboard.jsp").forward(req, resp);
        } catch (Exception e) {
            req.setAttribute("error", "Dashboard load failed.");
            req.getRequestDispatcher("/jsp/admin/dashboard.jsp").forward(req, resp);
        }
    }

    // ── Product CRUD ───────────────────────────────────────────────────────
    private void addProduct(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        try {
            Product p = buildProductFromRequest(req, new Product());
            productDAO.addProduct(p);
        } catch (Exception e) { /* log */ }
        resp.sendRedirect(req.getContextPath() + "/admin/products");
    }

    private void updateProduct(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        try {
            int     id = Integer.parseInt(req.getParameter("productId"));
            Product p  = productDAO.getProductById(id);
            if (p != null) {
                buildProductFromRequest(req, p);
                productDAO.updateProduct(p);
            }
        } catch (Exception e) { /* log */ }
        resp.sendRedirect(req.getContextPath() + "/admin/products");
    }

    private void deleteProduct(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        try {
            int id = Integer.parseInt(req.getParameter("productId"));
            productDAO.deleteProduct(id);
        } catch (Exception e) { /* log */ }
        resp.sendRedirect(req.getContextPath() + "/admin/products");
    }

    // ── Order management ───────────────────────────────────────────────────
    private void updateOrder(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        try {
            int    orderId = Integer.parseInt(req.getParameter("orderId"));
            String status  = req.getParameter("status");
            orderDAO.updateOrderStatus(orderId, status);
        } catch (Exception e) { /* log */ }
        resp.sendRedirect(req.getContextPath() + "/admin/orders");
    }

    // ── Helpers ────────────────────────────────────────────────────────────
    private Product buildProductFromRequest(HttpServletRequest req, Product p) {
        p.setName(req.getParameter("name").trim());
        p.setCategory(req.getParameter("category").trim());
        p.setPrice(new BigDecimal(req.getParameter("price")));
        p.setStock(Integer.parseInt(req.getParameter("stock")));
        p.setDescription(req.getParameter("description"));
        p.setImageUrl(req.getParameter("imageUrl"));
        return p;
    }

    private boolean isAdmin(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        HttpSession session = req.getSession(false);
        if (session != null) {
            User user = (User) session.getAttribute("user");
            if (user != null && user.isAdmin()) return true;
        }
        resp.sendRedirect(req.getContextPath() + "/login");
        return false;
    }

    private String getPath(HttpServletRequest req) {
        String info = req.getPathInfo();
        return info == null ? "" : info;
    }
}
