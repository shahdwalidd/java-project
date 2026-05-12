<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Add Product — ShopMVC</title>
  <style>
    *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
    body { font-family: 'Segoe UI', system-ui, sans-serif; background: #f8fafc; }
    .navbar {
      background: linear-gradient(135deg, #1a1a2e, #16213e);
      padding: 0 32px; height: 64px;
      display: flex; align-items: center; justify-content: space-between;
      box-shadow: 0 2px 12px rgba(0,0,0,.3);
    }
    .navbar-brand { color: #fff; font-size: 22px; font-weight: 700; text-decoration: none; }
    .navbar-brand span { color: #667eea; }
    .nav-link { color: #94a3b8; text-decoration: none; font-size: 14px; margin-left: 20px; }
    .nav-link:hover { color: #fff; }
    .container { max-width: 600px; margin: 40px auto; padding: 0 24px; }
    .back-link { display: inline-flex; align-items: center; gap: 6px; color: #667eea; text-decoration: none; font-size: 14px; font-weight: 500; margin-bottom: 24px; }
    .back-link:hover { text-decoration: underline; }
    .card { background: #fff; border-radius: 16px; box-shadow: 0 4px 20px rgba(0,0,0,.08); padding: 40px 36px; }
    .card-title { font-size: 24px; font-weight: 800; color: #1e293b; margin-bottom: 28px; }
    .form-group { margin-bottom: 20px; }
    label { display: block; font-size: 13px; font-weight: 600; color: #374151; margin-bottom: 6px; }
    input, textarea {
      width: 100%; padding: 12px 14px;
      border: 1.5px solid #e5e7eb; border-radius: 8px;
      font-size: 15px; font-family: inherit; color: #111827;
      transition: border-color .2s;
    }
    input:focus, textarea:focus { border-color: #667eea; outline: none; box-shadow: 0 0 0 3px rgba(102,126,234,.12); }
    textarea { min-height: 110px; resize: vertical; }
    .alert-error { background: #fef2f2; color: #b91c1c; border: 1px solid #fecaca; border-radius: 8px; padding: 10px 14px; font-size: 13px; margin-bottom: 16px; }
    .btn-submit {
      width: 100%; padding: 13px;
      background: linear-gradient(135deg, #667eea, #764ba2);
      color: #fff; border: none; border-radius: 8px;
      font-size: 16px; font-weight: 600; cursor: pointer;
      transition: opacity .2s;
    }
    .btn-submit:hover { opacity: .9; }
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
  <a class="back-link" href="${pageContext.request.contextPath}/home">&#8592; Back to Products</a>

  <div class="card">
    <div class="card-title">&#43; Add New Product</div>

    <% String error = (String) request.getAttribute("error"); %>
    <% if (error != null && !error.isEmpty()) { %>
      <div class="alert-error">&#9888; <%= error %></div>
    <% } %>

    <form action="${pageContext.request.contextPath}/add-product" method="post">
      <div class="form-group">
        <label for="name">Product Name *</label>
        <input type="text" id="name" name="name" placeholder="e.g. Wireless Headphones" required>
      </div>
      <div class="form-group">
        <label for="description">Description</label>
        <textarea id="description" name="description" placeholder="Describe the product..."></textarea>
      </div>
      <div class="form-group">
        <label for="price">Price (USD) *</label>
        <input type="number" id="price" name="price" step="0.01" min="0.01" placeholder="0.00" required>
      </div>
      <div class="form-group">
        <label for="imageUrl">Image URL</label>
        <input type="url" id="imageUrl" name="imageUrl" placeholder="https://example.com/image.jpg">
      </div>
      <button type="submit" class="btn-submit">Add Product</button>
    </form>
  </div>
</div>
</body>
</html>
