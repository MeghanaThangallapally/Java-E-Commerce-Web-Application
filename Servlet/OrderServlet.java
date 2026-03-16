package com.shopflow.servlet;

import com.shopflow.dao.OrderDAO;
import com.shopflow.model.Cart;
import com.shopflow.model.Order;
import com.shopflow.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/orders")
public class OrderServlet extends HttpServlet {

    private final OrderDAO orderDAO = new OrderDAO();

    // ── View user's order history ──────────────────────────────────────────
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        User user = getLoggedInUser(req, resp);
        if (user == null) return;

        try {
            List<Order> orders = orderDAO.getOrdersByUser(user.getId());
            req.setAttribute("orders", orders);
            req.getRequestDispatcher("/jsp/orders.jsp").forward(req, resp);

        } catch (Exception e) {
            req.setAttribute("error", "Could not load orders.");
            req.getRequestDispatcher("/jsp/orders.jsp").forward(req, resp);
        }
    }

    // ── Place a new order (checkout) ───────────────────────────────────────
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        User user = getLoggedInUser(req, resp);
        if (user == null) return;

        HttpSession session = req.getSession();
        Cart cart = (Cart) session.getAttribute("cart");

        if (cart == null || cart.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/cart");
            return;
        }

        try {
            int orderId = orderDAO.placeOrder(user.getId(), cart);

            if (orderId > 0) {
                cart.clear();                               // empty the session cart
                session.setAttribute("lastOrderId", orderId);
                resp.sendRedirect(req.getContextPath() + "/orders?success=true");
            } else {
                // -1 means insufficient stock for at least one item
                req.setAttribute("error", "One or more items are out of stock.");
                req.setAttribute("cart", cart);
                req.getRequestDispatcher("/jsp/cart.jsp").forward(req, resp);
            }

        } catch (Exception e) {
            req.setAttribute("error", "Order failed. Please try again.");
            req.setAttribute("cart", cart);
            req.getRequestDispatcher("/jsp/cart.jsp").forward(req, resp);
        }
    }

    // ── Auth helper ────────────────────────────────────────────────────────
    private User getLoggedInUser(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return null;
        }
        return (User) session.getAttribute("user");
    }
}
