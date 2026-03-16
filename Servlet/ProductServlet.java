package com.shopflow.servlet;

import com.shopflow.dao.ProductDAO;
import com.shopflow.model.Product;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/products")
public class ProductServlet extends HttpServlet {

    private final ProductDAO productDAO = new ProductDAO();

    // ── Product listing / search ───────────────────────────────────────────
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String keyword  = req.getParameter("search");
        String category = req.getParameter("category");

        try {
            List<Product> products;

            if (keyword != null && !keyword.isBlank()) {
                products = productDAO.searchProducts(keyword.trim());
                req.setAttribute("search", keyword.trim());

            } else if (category != null && !category.isBlank()) {
                products = productDAO.getProductsByCategory(category.trim());
                req.setAttribute("selectedCategory", category.trim());

            } else {
                products = productDAO.getAllProducts();
            }

            req.setAttribute("products",   products);
            req.setAttribute("categories", productDAO.getAllCategories());
            req.getRequestDispatcher("/jsp/products.jsp").forward(req, resp);

        } catch (Exception e) {
            req.setAttribute("error", "Could not load products.");
            req.getRequestDispatcher("/jsp/products.jsp").forward(req, resp);
        }
    }

    // ── Product detail page (GET /products?id=5) ──────────────────────────
    // Handled by checking for an "id" param before the listing logic.
    // Alternatively expose /product/{id} with a separate servlet.
}
