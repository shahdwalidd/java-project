package com.ecommerce.controller.auth;

import com.ecommerce.dao.UserDAO;
import com.ecommerce.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;

@WebServlet("/delete-account")
public class DeleteAccountServlet extends HttpServlet {

    private static final Logger logger  = LoggerFactory.getLogger(DeleteAccountServlet.class);
    private final UserDAO       userDAO = new UserDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User user = (User) session.getAttribute("loggedInUser");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        boolean deleted = userDAO.deleteById(user.getId());

        if (deleted) {
            logger.info("Account deleted for user: {}", user.getEmail());
            session.invalidate();
            Cookie jwtCookie = new Cookie("jwt_token", "");
            jwtCookie.setHttpOnly(true);
            jwtCookie.setMaxAge(0);
            jwtCookie.setPath("/");
            response.addCookie(jwtCookie);
            response.sendRedirect(request.getContextPath() + "/login?deleted=true");
        } else {
            logger.warn("Failed to delete account for: {}", user.getEmail());
            request.setAttribute("error", "Failed to delete account. Please try again.");
            request.getRequestDispatcher("/views/home.jsp").forward(request, response);
        }
    }
}
