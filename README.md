# ShopMVC

A backend-focused e-commerce web application built with Java Servlets following the MVC architectural pattern. The project covers authentication, Redis caching, rate limiting, and structured data management across clearly separated layers.



ShopMVC is a Java EE backend project that demonstrates practical understanding of servlet-based web development. It supports two authentication strategies — session-based and JWT-based — alongside Redis for both caching and rate limiting, and MySQL as the relational database.

---


## Features

**Authentication**

- Registration and login with BCrypt password hashing
- Session-based authentication (stateful)
- JWT-based authentication (stateless) stored in an HttpOnly cookie
- Token expiration set to 24 hours, validated on every protected request
- On session loss, AuthFilter restores the session from a valid JWT automatically
- Logout clears both the session and the JWT cookie

**Authorization**

- AuthFilter intercepts all protected endpoints before the request reaches any servlet
- Admin-only routes: add, edit, and delete products
- Regular users can add, edit, and delete their own reviews only

**Product Management**

- Admins can add, update, and delete products
- All users can browse products on the home page and view product detail pages
- Product list is cached in Redis and invalidated on any write operation

**Reviews**

- Authenticated users can submit a review with a rating (1 to 5) and a comment
- Reviews are displayed on both the product detail page and the home page feedback section
- Review data is cached per product in Redis

**Caching**

- Redis caches the full product list under the key `products:all`
- Individual product reviews are cached under `reviews:product:{id}`
- Cache is invalidated automatically when data changes

**Rate Limiting**

- Applied to all non-static requests via RateLimitFilter
- Limit: 60 requests per minute per IP address
- Uses Redis INCR with EXPIRE for tracking
- Returns HTTP 429 with Retry-After, X-RateLimit-Limit, X-RateLimit-Remaining, and X-RateLimit-Reset headers when the limit is exceeded

**Error Handling**

- ExceptionHandlerFilter wraps the entire filter chain and catches any unhandled exception
- Custom error pages for 403, 404, and 500
- Internal error details are never exposed to the client

**Input Validation**

- Server-side validation on all form submissions via ValidationUtil
- Covers email format, password length, product name, price range, and review rating

---



## Setup and Run

### 1. Database

Open MySQL Workbench or any MySQL client and run:


This creates the `ecommerce_mvc` database with the three tables and inserts a default admin account.

Default admin credentials:

```
Email:    admin@shopmvc.com
Password: admin123
```

Update the database password in `DatabaseConnection.java` to match your local MySQL setup:

```java
private static final String PASSWORD = "your_password_here";
```

### 2. Redis

Start a Redis container using Docker:

```bash
docker run -d --name redis-shopmvc -p 6379:6379 redis:7-alpine
```

Verify it is running:

```bash
docker exec -it redis-shopmvc redis-cli ping
```

Expected output: `PONG`

To stop and start Redis later:

```bash
docker stop redis-shopmvc
docker start redis-shopmvc
```

### 3. JWT Secret (optional)

By default the application uses a hardcoded fallback secret key. For any non-local environment set this environment variable before starting Tomcat:

```
JWT_SECRET=your-secret-key-minimum-32-characters
```

### 4. IntelliJ and Tomcat

1. Open the project as a Maven project in IntelliJ
2. Go to Run > Edit Configurations > + > Tomcat Server > Local
3. Under the Deployment tab click + > Artifact > select `ecommerce-mvc:war exploded`
4. Click Run

The application will be available at:

```
http://localhost:8080/ecommerce_mvc_war_exploded/home
```

---

## Endpoints

| Method   | Endpoint             | Access        | Description         |
|----------|----------------------|---------------|---------------------|
| GET      | /home                | Authenticated | Home page           |
| GET/POST | /login               | Public        | Sign in             |
| GET/POST | /register            | Public        | Sign up             |
| GET      | /logout              | Authenticated | Sign out            |
| POST     | /delete-account      | Authenticated | Delete own account  |
| GET      | /product?id=X        | Authenticated | Product detail page |
| GET/POST | /add-product         | Admin only    | Add a product       |
| GET/POST | /update-product?id=X | Admin only    | Edit a product      |
| POST     | /delete-product      | Admin only    | Delete a product    |
| POST     | /add-review          | Authenticated | Submit a review     |
| GET/POST | /update-review?id=X  | Authenticated | Edit own review     |
| POST     | /delete-review       | Authenticated | Delete own review   |

---

## Testing

### AuthFilter — protected routes

Open these URLs without being logged in:

```
http://localhost:8080/ecommerce_mvc_war_exploded/home
http://localhost:8080/ecommerce_mvc_war_exploded/add-product
```

Expected: redirect to `/login` in both cases.

### Registration and Login

Go to `/register`, create a new account, and verify the redirect to `/login`.
Log in and check the browser under DevTools > Application > Cookies. You should see a `jwt_token` cookie marked as HttpOnly.

### Admin-only access

Log in as a regular user and navigate to:

```
http://localhost:8080/ecommerce_mvc_war_exploded/add-product
```

Expected: 403 Forbidden page.

### Redis cache

Before opening the home page, check Redis keys:

```bash
docker exec -it redis-shopmvc redis-cli keys "*"
```

Expected: `(empty array)`

Open the home page in the browser, then check again:

```bash
docker exec -it redis-shopmvc redis-cli keys "*"
```

Expected output:

```
1) "products:all"
2) "reviews:product:1"
```

### Rate limiting

Run the following in PowerShell:

```powershell
$url = "http://localhost:8080/ecommerce_mvc_war_exploded/login"
1..65 | ForEach-Object {
    try {
        $r = Invoke-WebRequest -Uri $url -Method GET -UseBasicParsing -MaximumRedirection 0 -ErrorAction SilentlyContinue
        Write-Host "$_ : $($r.StatusCode)"
    } catch {
        $code = $_.Exception.Response.StatusCode.value__
        Write-Host "$_ : $code"
    }
}
```

Expected output:

```
1 : 200
2 : 200
...
60 : 200
61 : 429
62 : 429
...
65 : 429
```

To confirm the rate limit key exists in Redis after running the test:

```bash
docker exec -it redis-shopmvc redis-cli keys "*"
```

Expected: a key starting with `rate:` followed by your IP address, for example `rate:0:0:0:0:0:0:0:1`.

### JWT expiration

To verify that an expired token is handled correctly, temporarily change the expiration in `JwtUtil.java`:

```java
private static final long EXPIRATION_MS = 1000L * 10; // 10 seconds
```

Log in, wait 15 seconds, then navigate to `/home`.

Expected: the `jwt_token` cookie is cleared automatically and you are redirected to `/login`.

Revert the value after testing:

```java
private static final long EXPIRATION_MS = 1000L * 60 * 60 * 24; // 24 hours
```


If Redis is not running the application still starts and functions normally without caching.
