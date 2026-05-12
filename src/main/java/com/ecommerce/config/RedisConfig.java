package com.ecommerce.config;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import redis.clients.jedis.Jedis;
import redis.clients.jedis.JedisPool;
import redis.clients.jedis.JedisPoolConfig;

public class RedisConfig {

    private static final Logger logger = LoggerFactory.getLogger(RedisConfig.class);

    private static final String REDIS_HOST = "localhost";
    private static final int    REDIS_PORT = 6379;

    private static JedisPool jedisPool;
    private static boolean   available = false;

    static {
        try {
            JedisPoolConfig poolConfig = new JedisPoolConfig();
            poolConfig.setMaxTotal(10);
            poolConfig.setMaxIdle(5);
            poolConfig.setMinIdle(1);
            poolConfig.setTestOnBorrow(true);

            jedisPool = new JedisPool(poolConfig, REDIS_HOST, REDIS_PORT, 2000);

            try (Jedis jedis = jedisPool.getResource()) {
                available = "PONG".equals(jedis.ping());
            }

            if (available) {
                logger.info("Redis connection pool initialized on {}:{}", REDIS_HOST, REDIS_PORT);
            } else {
                logger.warn("Redis did not respond to PING — cache will be disabled");
            }
        } catch (Exception e) {
            logger.warn("Redis unavailable — application will run without cache: {}", e.getMessage());
            available = false;
        }
    }

    private RedisConfig() {
    }

    public static boolean isAvailable() {
        return available && jedisPool != null && !jedisPool.isClosed();
    }

    public static Jedis getResource() {
        if (!isAvailable()) {
            throw new IllegalStateException("Redis is not available");
        }
        return jedisPool.getResource();
    }
}
