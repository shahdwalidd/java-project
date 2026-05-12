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
  <title>Home — ShopMVC</title>
  <style>
    *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
    body { font-family: 'Segoe UI', system-ui, sans-serif; background: #f8fafc; color: #1e293b; }

    /* ── Navbar ── */
    .navbar {
      background: linear-gradient(135deg, #1a1a2e, #16213e);
      padding: 0 32px; height: 64px;
      display: flex; align-items: center; justify-content: space-between;
      box-shadow: 0 2px 12px rgba(0,0,0,0.3);
      position: sticky; top: 0; z-index: 100;
    }
    .navbar-brand { color: #fff; font-size: 22px; font-weight: 700; text-decoration: none; }
    .navbar-brand span { color: #667eea; }
    .navbar-right { display: flex; align-items: center; gap: 16px; }
    .user-badge {
      background: rgba(255,255,255,.1); border-radius: 20px;
      padding: 6px 14px; color: #e2e8f0; font-size: 14px;
    }
    .badge-admin {
      background: linear-gradient(135deg, #f59e0b, #d97706);
      color: #fff; font-size: 11px; font-weight: 700;
      padding: 2px 8px; border-radius: 10px; margin-left: 6px;
      text-transform: uppercase; letter-spacing: .5px;
    }
    .nav-link {
      color: #94a3b8; text-decoration: none; font-size: 14px; font-weight: 500;
      transition: color .2s;
    }
    .nav-link:hover { color: #fff; }

    /* ── Hero ── */
    .hero {
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      padding: 48px 32px 56px;
      text-align: center; color: #fff;
    }
    .hero h1 { font-size: 38px; font-weight: 800; margin-bottom: 8px; }
    .hero p  { font-size: 17px; opacity: .85; }

    .container { max-width: 1200px; margin: 0 auto; padding: 0 24px; }

    /* ── Section header ── */
    .section-header {
      display: flex; align-items: center; justify-content: space-between;
      margin: 36px 0 20px;
    }
    .section-title { font-size: 22px; font-weight: 700; color: #1e293b; }
    .count-badge {
      background: #e0e7ff; color: #4338ca;
      font-size: 12px; font-weight: 700;
      padding: 2px 10px; border-radius: 20px; margin-left: 8px;
    }
    .btn-add {
      background: linear-gradient(135deg, #667eea, #764ba2);
      color: #fff; padding: 10px 22px; border-radius: 8px;
      text-decoration: none; font-size: 14px; font-weight: 600;
      transition: opacity .2s, transform .1s;
      display: inline-flex; align-items: center; gap: 6px;
    }
    .btn-add:hover { opacity: .9; transform: translateY(-1px); }

    /* ── Products grid ── */
    .grid {
      display: grid;
      grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
      gap: 24px;
      margin-bottom: 48px;
    }
    .card {
      background: #fff; border-radius: 14px;
      box-shadow: 0 2px 12px rgba(0,0,0,.07);
      overflow: hidden;
      transition: transform .2s, box-shadow .2s;
    }
    .card:hover { transform: translateY(-4px); box-shadow: 0 12px 32px rgba(0,0,0,.12); }
    .card-img {
      width: 100%; height: 210px; object-fit: cover;
      background: #f1f5f9;
    }
    .card-img-placeholder {
      width: 100%; height: 210px;
      background: linear-gradient(135deg, #e0e7ff, #f0fdf4);
      display: flex; align-items: center; justify-content: center;
      font-size: 48px;
    }
    .card-body { padding: 18px 20px 20px; }
    .card-title { font-size: 17px; font-weight: 700; color: #1e293b; margin-bottom: 6px;
      white-space: nowrap; overflow: hidden; text-overflow: ellipsis;
    }
    .card-desc {
      font-size: 13px; color: #64748b; line-height: 1.5;
      display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical;
      overflow: hidden; margin-bottom: 12px;
    }
    .card-price { font-size: 22px; font-weight: 800; color: #059669; margin-bottom: 14px; }
    .card-actions { display: flex; gap: 8px; flex-wrap: wrap; }
    .btn-view {
      flex: 1; padding: 9px 12px;
      background: #f1f5f9; color: #475569;
      border-radius: 7px; text-decoration: none;
      font-size: 13px; font-weight: 600;
      text-align: center; transition: background .2s;
    }
    .btn-view:hover { background: #e2e8f0; }
    .btn-edit {
      padding: 9px 14px;
      background: #dbeafe; color: #1d4ed8;
      border-radius: 7px; text-decoration: none;
      font-size: 13px; font-weight: 600;
      transition: background .2s;
    }
    .btn-edit:hover { background: #bfdbfe; }
    .btn-delete {
      padding: 9px 14px;
      background: #fee2e2; color: #b91c1c;
      border: none; border-radius: 7px;
      font-size: 13px; font-weight: 600;
      cursor: pointer; transition: background .2s;
    }
    .btn-delete:hover { background: #fecaca; }

    .empty-state {
      text-align: center; padding: 80px 20px;
      grid-column: 1 / -1;
    }
    .empty-state .icon { font-size: 64px; margin-bottom: 16px; }
    .empty-state h3 { font-size: 20px; color: #64748b; }

    /* ── Reviews / Feedback section ── */
    .reviews-section {
      background: #fff;
      border-radius: 16px;
      box-shadow: 0 2px 12px rgba(0,0,0,.06);
      padding: 32px;
      margin-bottom: 48px;
    }
    .reviews-section-title {
      font-size: 20px; font-weight: 700; color: #1e293b;
      margin-bottom: 24px;
      display: flex; align-items: center; gap: 10px;
    }
    .reviews-grid {
      display: grid;
      grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
      gap: 16px;
    }
    .review-card {
      background: #f8fafc;
      border: 1px solid #e2e8f0;
      border-radius: 12px;
      padding: 18px 20px;
      transition: box-shadow .2s;
    }
    .review-card:hover { box-shadow: 0 4px 16px rgba(0,0,0,.08); }
    .review-header {
      display: flex; align-items: center; justify-content: space-between;
      margin-bottom: 10px;
    }
    .review-author {
      font-size: 14px; font-weight: 600; color: #1e293b;
      display: flex; align-items: center; gap: 6px;
    }
    .review-stars { color: #f59e0b; font-size: 14px; letter-spacing: 1px; }
    .review-product-link {
      font-size: 11px; color: #667eea; text-decoration: none; font-weight: 600;
      margin-bottom: 8px; display: block;
    }
    .review-product-link:hover { text-decoration: underline; }
    .review-comment {
      font-size: 13px; color: #475569; line-height: 1.6;
      display: -webkit-box; -webkit-line-clamp: 3; -webkit-box-orient: vertical;
      overflow: hidden;
    }
    .reviews-empty {
      text-align: center; padding: 40px;
      color: #94a3b8; font-size: 15px;
    }

    /* ── Danger zone ── */
    .danger-zone {
      background: #fff; border: 1.5px solid #fecaca; border-radius: 12px;
      padding: 24px 28px; margin-bottom: 48px;
      display: flex; align-items: center; justify-content: space-between;
    }
    .danger-zone-text h3 { font-size: 16px; color: #b91c1c; font-weight: 700; }
    .danger-zone-text p  { font-size: 13px; color: #9ca3af; margin-top: 4px; }
    .btn-danger {
      background: #b91c1c; color: #fff;
      border: none; padding: 10px 22px; border-radius: 8px;
      font-size: 14px; font-weight: 600; cursor: pointer;
      transition: background .2s;
    }
    .btn-danger:hover { background: #991b1b; }

    .alert-error {
      background: #fef2f2; color: #b91c1c;
      border: 1px solid #fecaca; border-radius: 8px;
      padding: 10px 16px; margin-top: 20px; margin-bottom: 4px; font-size: 14px;
    }

    footer {
      text-align: center; padding: 24px;
      color: #94a3b8; font-size: 13px;
      border-top: 1px solid #e2e8f0;
    }
  </style>
</head>
<body>
<%
  User          loggedInUser  = (User)    session.getAttribute("loggedInUser");
  List<Product> products      = (List<Product>) request.getAttribute("products");
  List<Review>  latestReviews = (List<Review>)  request.getAttribute("latestReviews");
  String        error         = (String)  request.getAttribute("error");
%>

<!-- ══ Navbar ══ -->
<nav class="navbar">
  <a class="navbar-brand" href="${pageContext.request.contextPath}/home">&#128722; Shop<span>MVC</span></a>
  <div class="navbar-right">
    <span class="user-badge">
      &#128100; <%= loggedInUser.getUsername() %>
      <% if (loggedInUser.isAdmin()) { %><span class="badge-admin">Admin</span><% } %>
    </span>
    <a class="nav-link" href="${pageContext.request.contextPath}/logout">Sign out</a>
  </div>
</nav>

<!-- ══ Hero ══ -->
<div class="hero">
  <h1>Welcome, <%= loggedInUser.getUsername() %>!</h1>
  <p>Discover our curated collection of products</p>
</div>

<div class="container">

  <% if (error != null && !error.isEmpty()) { %>
    <div class="alert-error">&#9888; <%= error %></div>
  <% } %>

  <!-- ══ Products ══ -->
  <div class="section-header">
    <h2 class="section-title">
      All Products
      <% if (products != null) { %><span class="count-badge"><%= products.size() %></span><% } %>
    </h2>
    <% if (loggedInUser.isAdmin()) { %>
      <a class="btn-add" href="${pageContext.request.contextPath}/add-product">&#43; Add Product</a>
    <% } %>
  </div>

  <div class="grid">
    <% if (products == null || products.isEmpty()) { %>
      <div class="empty-state">
        <div class="icon">&#128230;</div>
        <h3>No products yet. Check back soon!</h3>
      </div>
    <% } else { %>
      <% for (Product p : products) { %>
        <div class="card">
          <% if (p.getImageUrl() != null && !p.getImageUrl().isEmpty()) { %>
            <img class="card-img" src="<%= p.getImageUrl() %>" alt="<%= p.getName() %>"
                 onerror="this.style.display='none';this.nextElementSibling.style.display='flex'">
            <div class="card-img-placeholder" style="display:none;">&#128230;</div>
          <% } else { %>
            <div class="card-img-placeholder">&#128230;</div>
          <% } %>
          <div class="card-body">
            <div class="card-title"><%= p.getName() %></div>
            <div class="card-desc"><%= p.getDescription() != null && !p.getDescription().isEmpty() ? p.getDescription() : "No description provided." %></div>
            <div class="card-price">$<%= p.getPrice() %></div>
            <div class="card-actions">
              <a class="btn-view" href="${pageContext.request.contextPath}/product?id=<%= p.getId() %>">&#128065; View Details</a>
              <% if (loggedInUser.isAdmin()) { %>
                <a class="btn-edit" href="${pageContext.request.contextPath}/update-product?id=<%= p.getId() %>">&#9998; Edit</a>
                <form action="${pageContext.request.contextPath}/delete-product" method="post"
                      onsubmit="return confirm('Delete \'<%= p.getName() %>\'?')" style="margin:0">
                  <input type="hidden" name="id" value="<%= p.getId() %>">
                  <button type="submit" class="btn-delete">&#128465;</button>
                </form>
              <% } %>
            </div>
          </div>
        </div>
      <% } %>
    <% } %>
  </div>

  <!-- ══ Customer Reviews / Feedback Section ══ -->
  <div class="reviews-section">
    <div class="reviews-section-title">
      &#11088; Customer Reviews &amp; Feedback
    </div>

    <% if (latestReviews == null || latestReviews.isEmpty()) { %>
      <div class="reviews-empty">
        &#128172; No reviews yet — be the first to leave feedback on a product!
      </div>
    <% } else { %>
      <div class="reviews-grid">
        <% for (Review r : latestReviews) { %>
          <div class="review-card">
            <div class="review-header">
              <span class="review-author">&#128100; <%= r.getUsername() != null ? r.getUsername() : "User" %></span>
              <span class="review-stars">
                <%
                  int rating = r.getRating();
                  for (int s = 1; s <= 5; s++) {
                    if (s <= rating) out.print("&#9733;");
                    else             out.print("&#9734;");
                  }
                %>
              </span>
            </div>
            <a class="review-product-link"
               href="${pageContext.request.contextPath}/product?id=<%= r.getProductId() %>">
              &#128279; View Product
            </a>
            <div class="review-comment">
              <%= r.getComment() != null && !r.getComment().isEmpty() ? r.getComment() : "<em>No comment provided.</em>" %>
            </div>
          </div>
        <% } %>
      </div>
    <% } %>
  </div>

  <!-- ══ Danger Zone ══ -->
  <div class="danger-zone">
    <div class="danger-zone-text">
      <h3>&#9888; Danger Zone</h3>
      <p>Permanently delete your account and all associated data. This action cannot be undone.</p>
    </div>
    <form action="${pageContext.request.contextPath}/delete-account" method="post"
          onsubmit="return confirm('Delete your account permanently? This cannot be undone.')">
      <button type="submit" class="btn-danger">Delete My Account</button>
    </form>
  </div>

</div>

<footer>ShopMVC &copy; 2025 — Built with Java Servlets &amp; MySQL</footer>
</body>
</html>
