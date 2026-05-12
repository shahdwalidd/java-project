package com.ecommerce.controller.product;

import com.ecommerce.model.Review;
import com.ecommerce.model.User;
import com.ecommerce.service.ReviewService;
import com.ecommerce.util.ValidationUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;
import java.util.List;

@WebServlet("/add-review")
public class AddReviewServlet extends HttpServlet {

    private static final Logger  logger        = LoggerFactory.getLogger(AddReviewServlet.class);
    private final ReviewService  reviewService = new ReviewService();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User   user           = (User) request.getSession().getAttribute("loggedInUser");
        String productIdParam = request.getParameter("productId");
        String ratingParam    = request.getParameter("rating");
        String comment        = request.getParameter("comment");

        List<String> errors = ValidationUtil.validateReview(ratingParam, productIdParam);
        if (!errors.isEmpty()) {
            if (ValidationUtil.isValidLong(productIdParam)) {
                response.sendRedirect(request.getContextPath() + "/product?id=" + productIdParam);
            } else {
                response.sendError(400, errors.get(0));
            }
            return;
        }

        Review review = new Review();
        review.setUserId(user.getId());
        review.setProductId(Long.parseLong(productIdParam));
        review.setRating(Integer.parseInt(ratingParam));
        review.setComment(comment != null ? comment.trim() : "");

        reviewService.addReview(review);
        logger.info("Review added for product {} by user {}", productIdParam, user.getEmail());
        response.sendRedirect(request.getContextPath() + "/product?id=" + productIdParam);
    }
}
