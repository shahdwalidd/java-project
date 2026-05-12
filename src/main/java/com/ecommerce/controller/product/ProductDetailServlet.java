package com.ecommerce.controller.product;

import com.ecommerce.model.Product;
import com.ecommerce.model.Review;
import com.ecommerce.service.ProductService;
import com.ecommerce.service.ReviewService;
import com.ecommerce.util.ValidationUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet("/product")
public class ProductDetailServlet extends HttpServlet {

    private final ProductService productService = new ProductService();
    private final ReviewService  reviewService  = new ReviewService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idParam = request.getParameter("id");
        if (!ValidationUtil.isValidLong(idParam)) {
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }

        Long productId = Long.parseLong(idParam);
        Product product = productService.getProductById(productId);
        if (product == null) {
            response.sendError(404, "Product not found");
            return;
        }

        List<Review> reviews = reviewService.getReviewsByProduct(productId);
        request.setAttribute("product", product);
        request.setAttribute("reviews", reviews);
        request.getRequestDispatcher("/views/product/product-detail.jsp").forward(request, response);
    }
}
