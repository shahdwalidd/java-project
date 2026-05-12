package com.ecommerce.controller.product;

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

@WebServlet("/delete-product")
public class DeleteProductServlet extends HttpServlet {

    private static final Logger  logger         = LoggerFactory.getLogger(DeleteProductServlet.class);
    private final ProductService productService = new ProductService();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
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

        Long productId = Long.parseLong(idParam);
        productService.deleteProduct(productId);
        logger.info("Product {} deleted by admin: {}", productId, user.getEmail());
        response.sendRedirect(request.getContextPath() + "/home");
    }
}
