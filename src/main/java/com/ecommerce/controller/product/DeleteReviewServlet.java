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

@WebServlet("/delete-review")
public class DeleteReviewServlet extends HttpServlet {

    private static final Logger logger        = LoggerFactory.getLogger(DeleteReviewServlet.class);
    private final ReviewService reviewService = new ReviewService();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("loggedInUser");

        String reviewIdParam = request.getParameter("id");
        if (!ValidationUtil.isValidLong(reviewIdParam)) {
            response.sendError(400, "Invalid review ID");
            return;
        }

        Long   reviewId = Long.parseLong(reviewIdParam);
        Review review   = reviewService.getReviewById(reviewId);

        if (review == null) {
            response.sendError(404, "Review not found");
            return;
        }

        if (!review.getUserId().equals(user.getId()) && !user.isAdmin()) {
            logger.warn("User {} attempted to delete review {} owned by user {}",
                        user.getId(), reviewId, review.getUserId());
            response.sendError(403, "You can only delete your own reviews");
            return;
        }

        Long productId = review.getProductId();
        reviewService.deleteReview(reviewId);
        logger.info("Review {} deleted by user {}", reviewId, user.getEmail());
        response.sendRedirect(request.getContextPath() + "/product?id=" + productId);
    }
}
