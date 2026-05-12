<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.ecommerce.model.Product" %>
<%@ page import="com.ecommerce.model.Review" %>
<%@ page import="com.ecommerce.model.User" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <%
    Product product       = (Product) request.getAttribute("product");
    List<Review> reviews  = (List<Review>) request.getAttribute("reviews");
    User loggedInUser     = (User) session.getAttribute("loggedInUser");
  %>
  <title><%= product.getName() %> — ShopMVC</title>
  <style>
    *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
    body { font-family: 'Segoe UI', system-ui, sans-serif; background: #f8fafc; color: #1e293b; }

    .navbar {
      background: linear-gradient(135deg, #1a1a2e, #16213e);
      padding: 0 32px; height: 64px;
      display: flex; align-items: center; justify-content: space-between;
      box-shadow: 0 2px 12px rgba(0,0,0,.3);
      position: sticky; top: 0; z-index: 100;
    }
    .navbar-brand { color: #fff; font-size: 22px; font-weight: 700; text-decoration: none; }
    .navbar-brand span { color: #667eea; }
    .nav-link { color: #94a3b8; text-decoration: none; font-size: 14px; margin-left: 20px; }
    .nav-link:hover { color: #fff; }

    .container { max-width: 960px; margin: 0 auto; padding: 32px 24px; }

    .breadcrumb { font-size: 13px; color: #94a3b8; margin-bottom: 24px; }
    .breadcrumb a { color: #667eea; text-decoration: none; }
    .breadcrumb a:hover { text-decoration: underline; }

    .product-card {
      background: #fff; border-radius: 16px;
      box-shadow: 0 4px 20px rgba(0,0,0,.08);
      overflow: hidden; display: flex;
      gap: 0; margin-bottom: 40px;
    }
    .product-img {
      width: 420px; min-height: 320px; flex-shrink: 0;
      object-fit: cover;
    }
    .product-img-placeholder {
      width: 420px; min-height: 320px; flex-shrink: 0;
      background: linear-gradient(135deg, #e0e7ff, #f0fdf4);
      display: flex; align-items: center; justify-content: center;
      font-size: 72px;
    }
    .product-info { padding: 36px 36px; flex: 1; }
    .product-name { font-size: 28px; font-weight: 800; color: #1e293b; margin-bottom: 12px; }
    .product-price { font-size: 36px; font-weight: 800; color: #059669; margin-bottom: 20px; }
    .product-desc { font-size: 15px; color: #64748b; line-height: 1.7; margin-bottom: 28px; }
    .product-meta { font-size: 12px; color: #94a3b8; }
    .admin-actions { display: flex; gap: 10px; margin-top: 24px; }
    .btn {
      padding: 10px 22px; border-radius: 8px;
      font-size: 14px; font-weight: 600; cursor: pointer;
      border: none; text-decoration: none; display: inline-block;
      transition: opacity .2s;
    }
    .btn:hover { opacity: .85; }
    .btn-edit  { background: #dbeafe; color: #1d4ed8; }
    .btn-delete-admin { background: #fee2e2; color: #b91c1c; }

    .section-title {
      font-size: 20px; font-weight: 700; color: #1e293b;
      margin-bottom: 20px; display: flex; align-items: center; gap: 10px;
    }
    .count-badge {
      background: #e0e7ff; color: #4338ca;
      font-size: 12px; font-weight: 700;
      padding: 2px 10px; border-radius: 20px;
    }

    .review-card {
      background: #fff; border-radius: 12px;
      box-shadow: 0 2px 8px rgba(0,0,0,.06);
      padding: 20px 22px; margin-bottom: 16px;
    }
    .review-header { display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 8px; }
    .reviewer-name { font-weight: 700; color: #1e293b; font-size: 15px; }
    .review-date   { font-size: 12px; color: #94a3b8; }
    .stars         { color: #f59e0b; font-size: 17px; margin-bottom: 8px; letter-spacing: 2px; }
    .review-comment { font-size: 14px; color: #475569; line-height: 1.6; }
    .review-actions { margin-top: 12px; display: flex; gap: 8px; }
    .btn-sm { padding: 6px 14px; font-size: 12px; font-weight: 600; border-radius: 6px; }
    .btn-sm-edit   { background: #dbeafe; color: #1d4ed8; text-decoration: none; }
    .btn-sm-delete { background: #fee2e2; color: #b91c1c; border: none; cursor: pointer; }

    .no-reviews { text-align: center; padding: 40px; color: #94a3b8; font-size: 15px; }

    .write-review {
      background: #fff; border-radius: 14px;
      box-shadow: 0 2px 12px rgba(0,0,0,.07);
      padding: 28px 32px; margin-top: 28px;
    }
    .write-review h3 { font-size: 18px; font-weight: 700; margin-bottom: 20px; }
    .form-group { margin-bottom: 18px; }
    label { display: block; font-size: 13px; font-weight: 600; color: #374151; margin-bottom: 6px; }
    select, textarea {
      width: 100%; padding: 11px 14px;
      border: 1.5px solid #e5e7eb; border-radius: 8px;
      font-size: 14px; font-family: inherit; color: #111827;
      transition: border-color .2s;
    }
    select:focus, textarea:focus { border-color: #667eea; outline: none; }
    textarea { min-height: 100px; resize: vertical; }
    .btn-submit {
      background: linear-gradient(135deg, #667eea, #764ba2);
      color: #fff; padding: 11px 28px;
      border: none; border-radius: 8px; font-size: 15px;
      font-weight: 600; cursor: pointer; transition: opacity .2s;
    }
    .btn-submit:hover { opacity: .9; }

    @media (max-width: 700px) {
      .product-card { flex-direction: column; }
      .product-img, .product-img-placeholder { width: 100%; min-height: 220px; }
    }
  </style>
</head>
<body>

<nav class="navbar">
  <a class="navbar-brand" href="${pageContext.request.contextPath}/home">&#128722; Shop<span>MVC</span></a>
  <div>
    <a class="nav-link" href="${pageContext.request.contextPath}/home">Home</a>
    <a class="nav-link" href="${pageContext.request.contextPath}/logout">Sign out</a>
  </div>
</nav>

<div class="container">
  <div class="breadcrumb">
    <a href="${pageContext.request.contextPath}/home">Home</a> &rsaquo; <%= product.getName() %>
  </div>

  <div class="product-card">
    <% if (product.getImageUrl() != null && !product.getImageUrl().isEmpty()) { %>
      <img class="product-img" src="<%= product.getImageUrl() %>" alt="<%= product.getName() %>"
           onerror="this.style.display='none';this.nextElementSibling.style.display='flex'">
      <div class="product-img-placeholder" style="display:none;">&#128230;</div>
    <% } else { %>
      <div class="product-img-placeholder">&#128230;</div>
    <% } %>

    <div class="product-info">
      <h1 class="product-name"><%= product.getName() %></h1>
      <div class="product-price">$<%= product.getPrice() %></div>
      <p class="product-desc"><%= product.getDescription() != null && !product.getDescription().isEmpty() ? product.getDescription() : "No description provided." %></p>
      <div class="product-meta">Added: <%= product.getCreatedAt() != null ? product.getCreatedAt().toString().substring(0,10) : "N/A" %></div>

      <% if (loggedInUser.isAdmin()) { %>
        <div class="admin-actions">
          <a class="btn btn-edit" href="${pageContext.request.contextPath}/update-product?id=<%= product.getId() %>">&#9998; Edit Product</a>
          <form action="${pageContext.request.contextPath}/delete-product" method="post" style="display:inline"
                onsubmit="return confirm('Delete this product?')">
            <input type="hidden" name="id" value="<%= product.getId() %>">
            <button type="submit" class="btn btn-delete-admin">&#128465; Delete</button>
          </form>
        </div>
      <% } %>
    </div>
  </div>

  <div class="section-title">
    Reviews
    <span class="count-badge"><%= reviews != null ? reviews.size() : 0 %></span>
  </div>

  <% if (reviews == null || reviews.isEmpty()) { %>
    <div class="no-reviews">&#128172; No reviews yet. Be the first to share your thoughts!</div>
  <% } else { %>
    <% for (Review r : reviews) { %>
      <div class="review-card">
        <div class="review-header">
          <span class="reviewer-name">&#128100; <%= r.getUsername() %></span>
          <span class="review-date"><%= r.getCreatedAt() != null ? r.getCreatedAt().toString().substring(0,10) : "" %></span>
        </div>
        <div class="stars">
          <% for (int i = 1; i <= 5; i++) { %>
            <%= i <= r.getRating() ? "&#9733;" : "&#9734;" %>
          <% } %>
        </div>
        <div class="review-comment"><%= r.getComment() != null ? r.getComment() : "" %></div>

        <% if (loggedInUser != null && (r.getUserId().equals(loggedInUser.getId()) || loggedInUser.isAdmin())) { %>
          <div class="review-actions">
            <% if (r.getUserId().equals(loggedInUser.getId())) { %>
              <a class="btn-sm btn-sm-edit"
                 href="${pageContext.request.contextPath}/update-review?id=<%= r.getId() %>">&#9998; Edit</a>
            <% } %>
            <form action="${pageContext.request.contextPath}/delete-review" method="post" style="display:inline"
                  onsubmit="return confirm('Delete this review?')">
              <input type="hidden" name="id" value="<%= r.getId() %>">
              <button type="submit" class="btn-sm btn-sm-delete">&#128465; Delete</button>
            </form>
          </div>
        <% } %>
      </div>
    <% } %>
  <% } %>

  <div class="write-review">
    <h3>&#9998; Write a Review</h3>
    <form action="${pageContext.request.contextPath}/add-review" method="post">
      <input type="hidden" name="productId" value="<%= product.getId() %>">

      <div class="form-group">
        <label for="rating">Your Rating</label>
        <select name="rating" id="rating" required>
          <option value="5">&#9733;&#9733;&#9733;&#9733;&#9733; — Excellent</option>
          <option value="4">&#9733;&#9733;&#9733;&#9733;&#9734; — Good</option>
          <option value="3">&#9733;&#9733;&#9733;&#9734;&#9734; — Average</option>
          <option value="2">&#9733;&#9733;&#9734;&#9734;&#9734; — Poor</option>
          <option value="1">&#9733;&#9734;&#9734;&#9734;&#9734; — Terrible</option>
        </select>
      </div>

      <div class="form-group">
        <label for="comment">Your Review</label>
        <textarea name="comment" id="comment" placeholder="Share your experience with this product..."></textarea>
      </div>

      <button type="submit" class="btn-submit">Submit Review &#8594;</button>
    </form>
  </div>
</div>
</body>
</html>
