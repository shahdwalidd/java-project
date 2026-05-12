package com.ecommerce.controller;

import com.ecommerce.model.Product;
import com.ecommerce.model.Review;
import com.ecommerce.service.ProductService;
import com.ecommerce.service.ReviewService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

/**
 * HomeServlet — loads all products and the latest reviews for the home page.
 */
@WebServlet("/home")
public class HomeServlet extends HttpServlet {

    private final ProductService productService = new ProductService();
    private final ReviewService  reviewService  = new ReviewService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Load all products (served from Redis cache when available)
        List<Product> products = productService.getAllProducts();
        request.setAttribute("products", products);

        // Load latest reviews across all products for the home-page feedback section
        List<Review> latestReviews = new ArrayList<>();
        if (products != null) {
            for (Product p : products) {
                List<Review> productReviews = reviewService.getReviewsByProduct(p.getId());
                if (productReviews != null) {
                    latestReviews.addAll(productReviews);
                }
                if (latestReviews.size() >= 6) break; // show up to 6 recent reviews
            }
        }
        request.setAttribute("latestReviews", latestReviews);

        request.getRequestDispatcher("/views/home.jsp").forward(request, response);
    }
}
