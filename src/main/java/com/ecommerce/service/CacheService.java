package com.ecommerce.service;

import com.ecommerce.config.RedisConfig;
import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import redis.clients.jedis.Jedis;

import java.lang.reflect.Type;
import java.util.List;

public class CacheService {

    private static final Logger logger = LoggerFactory.getLogger(CacheService.class);
    private static final Gson   gson   = new Gson();
    private static final int    TTL    = 300;

    public void set(String key, Object value) {
        if (!RedisConfig.isAvailable()) return;
        try (Jedis jedis = RedisConfig.getResource()) {
            jedis.setex(key, TTL, gson.toJson(value));
        } catch (Exception e) {
            logger.error("Cache set failed for key {}: {}", key, e.getMessage());
        }
    }

    public <T> T get(String key, Class<T> type) {
        if (!RedisConfig.isAvailable()) return null;
        try (Jedis jedis = RedisConfig.getResource()) {
            String json = jedis.get(key);
            return json != null ? gson.fromJson(json, type) : null;
        } catch (Exception e) {
            logger.error("Cache get failed for key {}: {}", key, e.getMessage());
            return null;
        }
    }

    public <T> List<T> getList(String key, Class<T> type) {
        if (!RedisConfig.isAvailable()) return null;
        try (Jedis jedis = RedisConfig.getResource()) {
            String json = jedis.get(key);
            if (json == null) return null;
            Type listType = TypeToken.getParameterized(List.class, type).getType();
            return gson.fromJson(json, listType);
        } catch (Exception e) {
            logger.error("Cache getList failed for key {}: {}", key, e.getMessage());
            return null;
        }
    }

    public void delete(String key) {
        if (!RedisConfig.isAvailable()) return;
        try (Jedis jedis = RedisConfig.getResource()) {
            jedis.del(key);
        } catch (Exception e) {
            logger.error("Cache delete failed for key {}: {}", key, e.getMessage());
        }
    }

    public void deleteByPattern(String pattern) {
        if (!RedisConfig.isAvailable()) return;
        try (Jedis jedis = RedisConfig.getResource()) {
            java.util.Set<String> keys = jedis.keys(pattern);
            if (keys != null && !keys.isEmpty()) {
                jedis.del(keys.toArray(new String[0]));
            }
        } catch (Exception e) {
            logger.error("Cache deleteByPattern failed for {}: {}", pattern, e.getMessage());
        }
    }
}
