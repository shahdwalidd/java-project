package com.ecommerce.controller.product;

import com.ecommerce.model.Product;
import com.ecommerce.model.User;
import com.ecommerce.service.ProductService;
import com.ecommerce.util.ValidationUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;

@WebServlet("/add-product")
public class AddProductServlet extends HttpServlet {

    private static final Logger logger         = LoggerFactory.getLogger(AddProductServlet.class);
    private final ProductService productService = new ProductService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("loggedInUser");
        if (!user.isAdmin()) {
            response.sendError(403, "Access denied");
            return;
        }
        request.getRequestDispatcher("/views/product/add-product.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("loggedInUser");
        if (!user.isAdmin()) {
            response.sendError(403, "Access denied");
            return;
        }

        String name        = request.getParameter("name");
        String description = request.getParameter("description");
        String priceStr    = request.getParameter("price");
        String imageUrl    = request.getParameter("imageUrl");

        List<String> errors = ValidationUtil.validateProduct(name, priceStr);
        if (!errors.isEmpty()) {
            request.setAttribute("error", errors.get(0));
            request.getRequestDispatcher("/views/product/add-product.jsp").forward(request, response);
            return;
        }

        Product product = new Product();
        product.setName(name.trim());
        product.setDescription(description != null ? description.trim() : "");
        product.setPrice(new BigDecimal(priceStr));
        product.setImageUrl(imageUrl != null ? imageUrl.trim() : "");

        productService.addProduct(product);
        logger.info("Product '{}' added by admin: {}", name, user.getEmail());
        response.sendRedirect(request.getContextPath() + "/home");
    }
}
