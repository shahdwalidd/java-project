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

@WebServlet("/update-product")
public class UpdateProductServlet extends HttpServlet {

    private static final Logger logger         = LoggerFactory.getLogger(UpdateProductServlet.class);
    private final ProductService productService = new ProductService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("loggedInUser");
        if (!user.isAdmin()) {
            response.sendError(403, "Access denied");
            return;
        }

        String idParam = request.getParameter("id");
        if (!ValidationUtil.isValidLong(idParam)) {
            response.sendError(400, "Invalid product ID");
            return;
        }

        Product product = productService.getProductById(Long.parseLong(idParam));
        if (product == null) {
            response.sendError(404, "Product not found");
            return;
        }

        request.setAttribute("product", product);
        request.getRequestDispatcher("/views/product/update-product.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("loggedInUser");
        if (!user.isAdmin()) {
            response.sendError(403, "Access denied");
            return;
        }

        String idParam     = request.getParameter("id");
        String name        = request.getParameter("name");
        String description = request.getParameter("description");
        String priceStr    = request.getParameter("price");
        String imageUrl    = request.getParameter("imageUrl");

        if (!ValidationUtil.isValidLong(idParam)) {
            response.sendError(400, "Invalid product ID");
            return;
        }

        Long productId = Long.parseLong(idParam);
        Product existing = productService.getProductById(productId);
        if (existing == null) {
            response.sendError(404, "Product not found");
            return;
        }

        List<String> errors = ValidationUtil.validateProduct(name, priceStr);
        if (!errors.isEmpty()) {
            request.setAttribute("error", errors.get(0));
            request.setAttribute("product", existing);
            request.getRequestDispatcher("/views/product/update-product.jsp").forward(request, response);
            return;
        }

        Product product = new Product();
        product.setId(productId);
        product.setName(name.trim());
        product.setDescription(description != null ? description.trim() : "");
        product.setPrice(new BigDecimal(priceStr));
        product.setImageUrl(imageUrl != null ? imageUrl.trim() : "");

        productService.updateProduct(product);
        logger.info("Product {} updated by admin: {}", productId, user.getEmail());
        response.sendRedirect(request.getContextPath() + "/home");
    }
}
