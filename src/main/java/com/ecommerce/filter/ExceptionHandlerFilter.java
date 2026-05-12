package com.ecommerce.filter;

import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;

@WebFilter("/*")
public class ExceptionHandlerFilter extends HttpFilter {

    private static final Logger logger = LoggerFactory.getLogger(ExceptionHandlerFilter.class);

    @Override
    protected void doFilter(HttpServletRequest request, HttpServletResponse response,
                            FilterChain chain) throws IOException, ServletException {
        try {
            chain.doFilter(request, response);
        } catch (Exception e) {
            logger.error("Unhandled exception on [{}]: {}", request.getRequestURI(), e.getMessage(), e);

            if (response.isCommitted()) return;

            String message = e.getMessage();
            if (e instanceof ServletException) {
                Throwable root = ((ServletException) e).getRootCause();
                if (root != null && root.getMessage() != null) {
                    message = root.getMessage();
                }
            }

            response.setStatus(500);
            request.setAttribute("errorCode", 500);
            request.setAttribute("errorMessage", message != null ? message : "An unexpected error occurred.");

            try {
                request.getRequestDispatcher("/views/error/error.jsp").forward(request, response);
            } catch (Exception fe) {
                logger.error("Failed to forward to error page: {}", fe.getMessage());
            }
        }
    }
}
