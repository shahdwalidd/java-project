CREATE DATABASE IF NOT EXISTS `ecommerce_mvc`
  DEFAULT CHARACTER SET utf8mb4
  DEFAULT COLLATE utf8mb4_unicode_ci;

USE `ecommerce_mvc`;

CREATE TABLE IF NOT EXISTS `users` (
    `id`         BIGINT       AUTO_INCREMENT PRIMARY KEY,
    `username`   VARCHAR(50)  NOT NULL UNIQUE,
    `email`      VARCHAR(100) NOT NULL UNIQUE,
    `password`   VARCHAR(255) NOT NULL,
    `role`       VARCHAR(20)  NOT NULL DEFAULT 'USER',
    `created_at` TIMESTAMP    DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS `products` (
    `id`          BIGINT         AUTO_INCREMENT PRIMARY KEY,
    `name`        VARCHAR(100)   NOT NULL,
    `description` TEXT,
    `price`       DECIMAL(10, 2) NOT NULL,
    `image_url`   VARCHAR(500),
    `created_at`  TIMESTAMP      DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS `reviews` (
    `id`         BIGINT    AUTO_INCREMENT PRIMARY KEY,
    `user_id`    BIGINT    NOT NULL,
    `product_id` BIGINT    NOT NULL,
    `rating`     INT       NOT NULL CHECK (`rating` BETWEEN 1 AND 5),
    `comment`    TEXT,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (`user_id`)    REFERENCES `users`(`id`)    ON DELETE CASCADE,
    FOREIGN KEY (`product_id`) REFERENCES `products`(`id`) ON DELETE CASCADE
);

INSERT INTO `users` (`username`, `email`, `password`, `role`)
VALUES (
    'admin',
    'admin@shopmvc.com',
    '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZd1q3O4a2',
    'ADMIN'
) ON DUPLICATE KEY UPDATE `role` = 'ADMIN';
