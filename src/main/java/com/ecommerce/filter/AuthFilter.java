package com.ecommerce.filter;

import com.ecommerce.dao.UserDAO;
import com.ecommerce.model.User;
import com.ecommerce.util.JwtUtil;
import io.jsonwebtoken.Claims;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;

@WebFilter({"/home", "/product", "/add-product", "/update-product",
            "/delete-product", "/add-review", "/update-review",
            "/delete-review", "/delete-account"})
public class AuthFilter extends HttpFilter {

    private static final Logger  logger  = LoggerFactory.getLogger(AuthFilter.class);
    private final        UserDAO userDAO = new UserDAO();

    @Override
    protected void doFilter(HttpServletRequest request, HttpServletResponse response,
                            FilterChain chain) throws IOException, ServletException {

        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        response.setHeader("Pragma", "no-cache");
        response.setDateHeader("Expires", 0);

        User user = resolveUserFromSession(request);

        if (user == null) {
            user = resolveUserFromJwt(request);
            if (user != null) {
                HttpSession session = request.getSession(true);
                session.setAttribute("loggedInUser", user);
            }
        }

        if (user == null) {
            logger.warn("Unauthenticated access attempt to: {}", request.getRequestURI());
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        chain.doFilter(request, response);
    }

    private User resolveUserFromSession(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) return null;
        return (User) session.getAttribute("loggedInUser");
    }

    private User resolveUserFromJwt(HttpServletRequest request) {
        String token = extractJwtFromCookies(request);
        if (token == null) return null;

        Claims claims = JwtUtil.validateToken(token);
        if (claims == null) return null;

        try {
            Long userId = Long.parseLong(claims.getSubject());
            User user = userDAO.findById(userId);
            if (user != null) {
                logger.info("JWT auth successful for user id: {}", userId);
            }
            return user;
        } catch (Exception e) {
            logger.warn("Failed to resolve user from JWT: {}", e.getMessage());
            return null;
        }
    }

    private String extractJwtFromCookies(HttpServletRequest request) {
        Cookie[] cookies = request.getCookies();
        if (cookies == null) return null;
        for (Cookie cookie : cookies) {
            if ("jwt_token".equals(cookie.getName())) {
                return cookie.getValue();
            }
        }
        return null;
    }
}
