package com.ecommerce.model;

import java.sql.Timestamp;

public class Review {

    private Long      id;
    private Long      userId;
    private Long      productId;
    private int       rating;
    private String    comment;
    private Timestamp createdAt;
    private String    username;

    public Review() {
    }

    public Review(Long id, Long userId, Long productId,
                  int rating, String comment, Timestamp createdAt) {
        this.id        = id;
        this.userId    = userId;
        this.productId = productId;
        this.rating    = rating;
        this.comment   = comment;
        this.createdAt = createdAt;
    }

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public Long getUserId() { return userId; }
    public void setUserId(Long userId) { this.userId = userId; }

    public Long getProductId() { return productId; }
    public void setProductId(Long productId) { this.productId = productId; }

    public int getRating() { return rating; }
    public void setRating(int rating) { this.rating = rating; }

    public String getComment() { return comment; }
    public void setComment(String comment) { this.comment = comment; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }
}
