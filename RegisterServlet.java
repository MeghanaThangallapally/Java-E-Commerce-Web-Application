package com.shopflow.servlet;

import com.shopflow.dao.UserDAO;
import com.shopflow.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.regex.Pattern;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();
    private static final Pattern EMAIL_PATTERN =
            Pattern.compile("^[\\w._%+\\-]+@[\\w.\\-]+\\.[a-zA-Z]{2,}$");

    // ── Show register page ─────────────────────────────────────────────────
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.getRequestDispatcher("/jsp/register.jsp").forward(req, resp);
    }

    // ── Handle registration form ───────────────────────────────────────────
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");
        String name     = req.getParameter("name");
        String email    = req.getParameter("email");
        String password = req.getParameter("password");
        String confirm  = req.getParameter("confirmPassword");

        // ── Validation ──────────────────────────────────────────────────
        String error = validate(name, email, password, confirm);
        if (error != null) {
            req.setAttribute("error", error);
            req.setAttribute("name", name);
            req.setAttribute("email", email);
            req.getRequestDispatcher("/jsp/register.jsp").forward(req, resp);
            return;
        }

        try {
            // Duplicate email check
            if (userDAO.emailExists(email.trim())) {
                req.setAttribute("error", "An account with this email already exists.");
                req.getRequestDispatcher("/jsp/register.jsp").forward(req, resp);
                return;
            }

            User user = new User();
            user.setName(name.trim());
            user.setEmail(email.trim().toLowerCase());
            user.setPassword(password);   // DAO will hash it
            user.setRole("user");

            boolean created = userDAO.registerUser(user);
            if (created) {
                req.getSession().setAttribute("successMessage", "Account created! Please log in.");
                resp.sendRedirect(req.getContextPath() + "/login");
            } else {
                req.setAttribute("error", "Registration failed. Please try again.");
                req.getRequestDispatcher("/jsp/register.jsp").forward(req, resp);
            }

        } catch (Exception e) {
            req.setAttribute("error", "Server error. Please try again.");
            req.getRequestDispatcher("/jsp/register.jsp").forward(req, resp);
        }
    }

    // ── Validation helper ──────────────────────────────────────────────────
    private String validate(String name, String email, String password, String confirm) {
        if (name == null || name.isBlank())           return "Name is required.";
        if (name.trim().length() < 2)                 return "Name must be at least 2 characters.";
        if (email == null || email.isBlank())          return "Email is required.";
        if (!EMAIL_PATTERN.matcher(email).matches())   return "Please enter a valid email address.";
        if (password == null || password.length() < 6) return "Password must be at least 6 characters.";
        if (!password.equals(confirm))                 return "Passwords do not match.";
        return null;
    }
}
