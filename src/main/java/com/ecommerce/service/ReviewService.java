package com.ecommerce.service;

import com.ecommerce.dao.ReviewDAO;
import com.ecommerce.model.Review;
import com.ecommerce.util.CacheConstants;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.List;

public class ReviewService {

    private static final Logger logger       = LoggerFactory.getLogger(ReviewService.class);
    private final ReviewDAO     reviewDAO    = new ReviewDAO();
    private final CacheService  cacheService = new CacheService();

    public List<Review> getReviewsByProduct(Long productId) {
        String cacheKey = CacheConstants.REVIEWS_KEY_PREFIX + productId;
        List<Review> cached = cacheService.getList(cacheKey, Review.class);
        if (cached != null) return cached;

        List<Review> reviews = reviewDAO.findByProductId(productId);
        cacheService.set(cacheKey, reviews);
        return reviews;
    }

    public Review getReviewById(Long id) {
        String cacheKey = CacheConstants.REVIEW_KEY_PREFIX + id;
        Review cached = cacheService.get(cacheKey, Review.class);
        if (cached != null) return cached;

        Review review = reviewDAO.findById(id);
        if (review != null) {
            cacheService.set(cacheKey, review);
        }
        return review;
    }

    public boolean addReview(Review review) {
        if (review.getRating() < 1 || review.getRating() > 5) {
            logger.warn("Invalid rating {} rejected", review.getRating());
            return false;
        }
        reviewDAO.save(review);
        cacheService.delete(CacheConstants.REVIEWS_KEY_PREFIX + review.getProductId());
        logger.info("Review added for product {} by user {}", review.getProductId(), review.getUserId());
        return true;
    }

    public boolean updateReview(Review review) {
        if (review.getRating() < 1 || review.getRating() > 5) {
            logger.warn("Invalid rating {} rejected", review.getRating());
            return false;
        }
        boolean updated = reviewDAO.update(review);
        if (updated) {
            cacheService.delete(CacheConstants.REVIEW_KEY_PREFIX + review.getId());
            cacheService.delete(CacheConstants.REVIEWS_KEY_PREFIX + review.getProductId());
        }
        return updated;
    }

    public boolean deleteReview(Long id) {
        Review review = reviewDAO.findById(id);
        boolean deleted = reviewDAO.deleteById(id);
        if (deleted && review != null) {
            cacheService.delete(CacheConstants.REVIEW_KEY_PREFIX + id);
            cacheService.delete(CacheConstants.REVIEWS_KEY_PREFIX + review.getProductId());
        }
        return deleted;
    }
}
