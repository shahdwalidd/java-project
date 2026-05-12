package com.ecommerce.service;

import com.ecommerce.dao.ProductDAO;
import com.ecommerce.model.Product;
import com.ecommerce.util.CacheConstants;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.List;

public class ProductService {

    private static final Logger logger       = LoggerFactory.getLogger(ProductService.class);
    private final ProductDAO    productDAO   = new ProductDAO();
    private final CacheService  cacheService = new CacheService();

    public List<Product> getAllProducts() {
        List<Product> cached = cacheService.getList(CacheConstants.ALL_PRODUCTS_KEY, Product.class);
        if (cached != null) return cached;

        List<Product> products = productDAO.findAll();
        cacheService.set(CacheConstants.ALL_PRODUCTS_KEY, products);
        return products;
    }

    public Product getProductById(Long id) {
        Product cached = cacheService.get(CacheConstants.PRODUCT_KEY_PREFIX + id, Product.class);
        if (cached != null) return cached;

        Product product = productDAO.findById(id);
        if (product != null) {
            cacheService.set(CacheConstants.PRODUCT_KEY_PREFIX + id, product);
        }
        return product;
    }

    public void addProduct(Product product) {
        productDAO.save(product);
        cacheService.delete(CacheConstants.ALL_PRODUCTS_KEY);
        logger.info("Product added: {}", product.getName());
    }

    public boolean updateProduct(Product product) {
        boolean updated = productDAO.update(product);
        if (updated) {
            cacheService.delete(CacheConstants.PRODUCT_KEY_PREFIX + product.getId());
            cacheService.delete(CacheConstants.ALL_PRODUCTS_KEY);
            logger.info("Product updated: {}", product.getId());
        }
        return updated;
    }

    public boolean deleteProduct(Long id) {
        boolean deleted = productDAO.deleteById(id);
        if (deleted) {
            cacheService.delete(CacheConstants.PRODUCT_KEY_PREFIX + id);
            cacheService.delete(CacheConstants.ALL_PRODUCTS_KEY);
            logger.info("Product deleted: {}", id);
        }
        return deleted;
    }
}
