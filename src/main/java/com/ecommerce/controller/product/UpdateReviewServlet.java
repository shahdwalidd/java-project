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

@WebServlet("/update-review")
public class UpdateReviewServlet extends HttpServlet {

    private static final Logger logger        = LoggerFactory.getLogger(UpdateReviewServlet.class);
    private final ReviewService reviewService = new ReviewService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("loggedInUser");

        String reviewIdParam = request.getParameter("id");
        if (!ValidationUtil.isValidLong(reviewIdParam)) {
            response.sendError(400, "Invalid review ID");
            return;
        }

        Review review = reviewService.getReviewById(Long.parseLong(reviewIdParam));
        if (review == null) {
            response.sendError(404, "Review not found");
            return;
        }

        if (!review.getUserId().equals(user.getId())) {
            response.sendError(403, "You can only edit your own reviews");
            return;
        }

        request.setAttribute("review", review);
        request.setAttribute("productId", String.valueOf(review.getProductId()));
        request.getRequestDispatcher("/views/product/update-review.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("loggedInUser");

        String reviewIdParam  = request.getParameter("reviewId");
        String productIdParam = request.getParameter("productId");
        String ratingParam    = request.getParameter("rating");
        String comment        = request.getParameter("comment");

        List<String> errors = ValidationUtil.validateReview(ratingParam, productIdParam);
        if (!ValidationUtil.isValidLong(reviewIdParam)) {
            errors.add("Invalid review ID");
        }

        if (!errors.isEmpty()) {
            if (ValidationUtil.isValidLong(productIdParam)) {
                response.sendRedirect(request.getContextPath() + "/product?id=" + productIdParam);
            } else {
                response.sendRedirect(request.getContextPath() + "/home");
            }
            return;
        }

        Long   reviewId  = Long.parseLong(reviewIdParam);
        Long   productId = Long.parseLong(productIdParam);

        Review existing = reviewService.getReviewById(reviewId);
        if (existing == null) {
            response.sendError(404, "Review not found");
            return;
        }

        if (!existing.getUserId().equals(user.getId())) {
            logger.warn("User {} attempted to update review {} owned by user {}",
                        user.getId(), reviewId, existing.getUserId());
            response.sendError(403, "You can only edit your own reviews");
            return;
        }

        Review review = new Review();
        review.setId(reviewId);
        review.setUserId(user.getId());
        review.setProductId(productId);
        review.setRating(Integer.parseInt(ratingParam));
        review.setComment(comment != null ? comment.trim() : "");

        reviewService.updateReview(review);
        logger.info("Review {} updated by user {}", reviewId, user.getEmail());
        response.sendRedirect(request.getContextPath() + "/product?id=" + productId);
    }
}
