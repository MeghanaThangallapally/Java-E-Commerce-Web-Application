package com.shopflow.servlet;

import com.shopflow.dao.UserDAO;
import com.shopflow.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

    // ── Show login page ────────────────────────────────────────────────────
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // Already logged in → redirect home
        if (req.getSession(false) != null && req.getSession().getAttribute("user") != null) {
            resp.sendRedirect(req.getContextPath() + "/jsp/products.jsp");
            return;
        }
        req.getRequestDispatcher("/jsp/login.jsp").forward(req, resp);
    }

    // ── Handle login form submission ───────────────────────────────────────
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");
        String email    = req.getParameter("email");
        String password = req.getParameter("password");

        // Basic validation
        if (email == null || password == null || email.isBlank() || password.isBlank()) {
            req.setAttribute("error", "Email and password are required.");
            req.getRequestDispatcher("/jsp/login.jsp").forward(req, resp);
            return;
        }

        try {
            User user = userDAO.loginUser(email.trim(), password);

            if (user != null) {
                // Invalidate old session and create a fresh one (session fixation prevention)
                req.getSession(false);
                HttpSession session = req.getSession(true);
                session.setAttribute("user", user);
                session.setAttribute("userId", user.getId());
                session.setAttribute("userName", user.getName());
                session.setAttribute("userRole", user.getRole());
                session.setMaxInactiveInterval(30 * 60); // 30 min

                // Admin → admin dashboard, user → product listing
                if (user.isAdmin()) {
                    resp.sendRedirect(req.getContextPath() + "/admin/dashboard");
                } else {
                    resp.sendRedirect(req.getContextPath() + "/products");
                }

            } else {
                req.setAttribute("error", "Invalid email or password.");
                req.getRequestDispatcher("/jsp/login.jsp").forward(req, resp);
            }

        } catch (Exception e) {
            req.setAttribute("error", "Server error. Please try again.");
            req.getRequestDispatcher("/jsp/login.jsp").forward(req, resp);
        }
    }
}
