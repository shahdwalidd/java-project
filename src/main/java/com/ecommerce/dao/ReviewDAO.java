package com.ecommerce.dao;

import com.ecommerce.config.DatabaseConnection;
import com.ecommerce.model.Review;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class ReviewDAO {

    private static final Logger logger = LoggerFactory.getLogger(ReviewDAO.class);

    public List<Review> findByProductId(Long productId) {
        String sql = "SELECT r.*, u.username FROM reviews r " +
                     "JOIN users u ON r.user_id = u.id " +
                     "WHERE r.product_id = ? ORDER BY r.created_at DESC";
        List<Review> reviews = new ArrayList<>();

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setLong(1, productId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    reviews.add(mapRow(rs));
                }
            }

        } catch (SQLException e) {
            logger.error("Failed to fetch reviews for product {}: {}", productId, e.getMessage());
            throw new RuntimeException("Failed to fetch reviews", e);
        }
        return reviews;
    }

    public Review findById(Long id) {
        String sql = "SELECT r.*, u.username FROM reviews r " +
                     "JOIN users u ON r.user_id = u.id " +
                     "WHERE r.id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setLong(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapRow(rs);
                }
            }

        } catch (SQLException e) {
            logger.error("Failed to fetch review {}: {}", id, e.getMessage());
            throw new RuntimeException("Failed to fetch review", e);
        }
        return null;
    }

    public void save(Review review) {
        String sql = "INSERT INTO reviews (user_id, product_id, rating, comment) VALUES (?, ?, ?, ?)";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setLong(1, review.getUserId());
            stmt.setLong(2, review.getProductId());
            stmt.setInt(3, review.getRating());
            stmt.setString(4, review.getComment());
            stmt.executeUpdate();

        } catch (SQLException e) {
            logger.error("Failed to save review: {}", e.getMessage());
            throw new RuntimeException("Failed to save review", e);
        }
    }

    public boolean update(Review review) {
        String sql = "UPDATE reviews SET rating = ?, comment = ? WHERE id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, review.getRating());
            stmt.setString(2, review.getComment());
            stmt.setLong(3, review.getId());
            return stmt.executeUpdate() > 0;

        } catch (SQLException e) {
            logger.error("Failed to update review {}: {}", review.getId(), e.getMessage());
            throw new RuntimeException("Failed to update review", e);
        }
    }

    public boolean deleteById(Long id) {
        String sql = "DELETE FROM reviews WHERE id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setLong(1, id);
            return stmt.executeUpdate() > 0;

        } catch (SQLException e) {
            logger.error("Failed to delete review {}: {}", id, e.getMessage());
            throw new RuntimeException("Failed to delete review", e);
        }
    }

    private Review mapRow(ResultSet rs) throws SQLException {
        Review review = new Review();
        review.setId(rs.getLong("id"));
        review.setUserId(rs.getLong("user_id"));
        review.setProductId(rs.getLong("product_id"));
        review.setRating(rs.getInt("rating"));
        review.setComment(rs.getString("comment"));
        review.setCreatedAt(rs.getTimestamp("created_at"));
        review.setUsername(rs.getString("username"));
        return review;
    }
}
