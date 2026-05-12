package com.ecommerce.filter;

import com.ecommerce.config.RedisConfig;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import redis.clients.jedis.Jedis;

import java.io.IOException;

@WebFilter("/*")
public class RateLimitFilter extends HttpFilter {

    private static final Logger logger          = LoggerFactory.getLogger(RateLimitFilter.class);
    private static final int    MAX_REQUESTS    = 60;
    private static final int    WINDOW_SECONDS  = 60;

    @Override
    protected void doFilter(HttpServletRequest request, HttpServletResponse response,
                            FilterChain chain) throws IOException, ServletException {

        String uri = request.getRequestURI();
        if (uri.contains("/static/") || uri.endsWith(".css") || uri.endsWith(".js") || uri.endsWith(".ico")) {
            chain.doFilter(request, response);
            return;
        }

        if (!RedisConfig.isAvailable()) {
            chain.doFilter(request, response);
            return;
        }

        String clientIp = resolveClientIp(request);
        String key      = "rate:" + clientIp;

        try (Jedis jedis = RedisConfig.getResource()) {
            long count = jedis.incr(key);
            if (count == 1) {
                jedis.expire(key, WINDOW_SECONDS);
            }
            long ttl = jedis.ttl(key);

            response.setHeader("X-RateLimit-Limit",     String.valueOf(MAX_REQUESTS));
            response.setHeader("X-RateLimit-Remaining", String.valueOf(Math.max(0, MAX_REQUESTS - count)));
            response.setHeader("X-RateLimit-Reset",     String.valueOf(System.currentTimeMillis() / 1000 + ttl));

            if (count > MAX_REQUESTS) {
                logger.warn("Rate limit exceeded for IP: {}", clientIp);
                response.setStatus(429);
                response.setHeader("Retry-After", String.valueOf(ttl));
                response.setContentType("text/html;charset=UTF-8");
                response.getWriter().write(
                    "<html><body><h2>429 - Too Many Requests</h2><p>Please slow down and try again shortly.</p></body></html>"
                );
                return;
            }
        } catch (Exception e) {
            logger.error("Rate limit check error: {}", e.getMessage());
        }

        chain.doFilter(request, response);
    }

    private String resolveClientIp(HttpServletRequest request) {
        String ip = request.getHeader("X-Forwarded-For");
        if (ip == null || ip.isEmpty()) {
            return request.getRemoteAddr();
        }
        return ip.split(",")[0].trim();
    }
}
