package com.ecommerce.listener;

import com.ecommerce.config.DatabaseConnection;
import com.ecommerce.config.RedisConfig;
import jakarta.servlet.ServletContext;
import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.sql.Connection;

@WebListener
public class AppContextListener implements ServletContextListener {

    private static final Logger logger = LoggerFactory.getLogger(AppContextListener.class);

    @Override
    public void contextInitialized(ServletContextEvent event) {
        ServletContext ctx = event.getServletContext();
        logger.info("============================================");
        logger.info("  ShopMVC Application Starting...");
        logger.info("============================================");

        verifyDatabaseConnection(ctx);
        verifyRedisConnection(ctx);

        logger.info("Application startup complete.");
        logger.info("============================================");
    }

    @Override
    public void contextDestroyed(ServletContextEvent event) {
        logger.info("Application shutting down — resources released.");
    }

    private void verifyDatabaseConnection(ServletContext ctx) {
        try (Connection conn = DatabaseConnection.getConnection()) {
            if (conn != null && !conn.isClosed()) {
                logger.info("[DB] MySQL connection OK — database: ecommerce_mvc");
                ctx.setAttribute("dbStatus", "OK");
            }
        } catch (Exception e) {
            logger.error("[DB] MySQL connection FAILED: {}", e.getMessage());
            logger.error("[DB] Ensure MySQL is running and schema.sql has been executed.");
            ctx.setAttribute("dbStatus", "FAILED");
        }
    }

    private void verifyRedisConnection(ServletContext ctx) {
        if (RedisConfig.isAvailable()) {
            logger.info("[CACHE] Redis connection OK — caching enabled");
            ctx.setAttribute("redisStatus", "OK");
        } else {
            logger.warn("[CACHE] Redis not available — application will run without cache (degraded performance)");
            ctx.setAttribute("redisStatus", "UNAVAILABLE");
        }
    }
}
