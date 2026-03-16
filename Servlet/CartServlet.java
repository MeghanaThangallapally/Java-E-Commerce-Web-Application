package com.shopflow.servlet;

import com.shopflow.dao.ProductDAO;
import com.shopflow.model.Cart;
import com.shopflow.model.Product;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/cart")
public class CartServlet extends HttpServlet {

    private final ProductDAO productDAO = new ProductDAO();

    // ── View cart ──────────────────────────────────────────────────────────
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        Cart cart = getOrCreateCart(req);
        req.setAttribute("cart", cart);
        req.getRequestDispatcher("/jsp/cart.jsp").forward(req, resp);
    }

    // ── Cart actions: add | remove | update | clear ────────────────────────
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");
        String action = req.getParameter("action");
        Cart   cart   = getOrCreateCart(req);

        try {
            switch (action == null ? "" : action) {

                case "add": {
                    int productId = Integer.parseInt(req.getParameter("productId"));
                    int qty       = parseQty(req.getParameter("quantity"), 1);
                    Product p = productDAO.getProductById(productId);
                    if (p != null && p.isInStock()) {
                        cart.addItem(p, qty);
                        req.getSession().setAttribute("cartSuccess", "Item added to cart!");
                    }
                    resp.sendRedirect(req.getContextPath() + "/products");
                    return;
                }

                case "remove": {
                    int productId = Integer.parseInt(req.getParameter("productId"));
                    cart.removeItem(productId);
                    break;
                }

                case "update": {
                    int productId = Integer.parseInt(req.getParameter("productId"));
                    int newQty    = parseQty(req.getParameter("quantity"), 1);
                    cart.updateQuantity(productId, newQty);
                    break;
                }

                case "clear":
                    cart.clear();
                    break;

                default:
                    break;
            }

        } catch (NumberFormatException e) {
            // bad param — ignore
        } catch (Exception e) {
            req.setAttribute("error", "Cart error: " + e.getMessage());
        }

        resp.sendRedirect(req.getContextPath() + "/cart");
    }

    // ── Session cart helper ────────────────────────────────────────────────
    private Cart getOrCreateCart(HttpServletRequest req) {
        HttpSession session = req.getSession(true);
        Cart cart = (Cart) session.getAttribute("cart");
        if (cart == null) {
            cart = new Cart();
            session.setAttribute("cart", cart);
        }
        return cart;
    }

    private int parseQty(String raw, int fallback) {
        try { return Math.max(1, Integer.parseInt(raw)); }
        catch (NumberFormatException e) { return fallback; }
    }
}
