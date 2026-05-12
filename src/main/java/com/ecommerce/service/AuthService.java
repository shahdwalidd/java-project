package com.ecommerce.service;

import com.ecommerce.dao.UserDAO;
import com.ecommerce.model.User;
import org.mindrot.jbcrypt.BCrypt;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class AuthService {

    private static final Logger logger  = LoggerFactory.getLogger(AuthService.class);
    private final UserDAO       userDAO = new UserDAO();

    public boolean register(User user) {
        if (userDAO.existsByEmailOrUsername(user.getEmail(), user.getUsername())) {
            logger.warn("Registration failed — email or username already exists: {}", user.getEmail());
            return false;
        }
        user.setPassword(BCrypt.hashpw(user.getPassword(), BCrypt.gensalt()));
        user.setRole("USER");
        userDAO.save(user);
        logger.info("New user registered: {}", user.getEmail());
        return true;
    }

    public User login(String email, String password) {
        User user = userDAO.findByEmail(email);
        if (user == null) {
            return null;
        }
        if (BCrypt.checkpw(password, user.getPassword())) {
            logger.info("Login successful for: {}", email);
            return user;
        }
        logger.warn("Login failed — wrong password for: {}", email);
        return null;
    }
}
