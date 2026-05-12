<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.ecommerce.model.Review" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Edit Review — ShopMVC</title>
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
    .container { max-width: 580px; margin: 40px auto; padding: 0 24px; }
    .back-link { display: inline-flex; align-items: center; gap: 6px; color: #667eea; text-decoration: none; font-size: 14px; font-weight: 500; margin-bottom: 24px; }
    .back-link:hover { text-decoration: underline; }
    .card { background: #fff; border-radius: 16px; box-shadow: 0 4px 20px rgba(0,0,0,.08); padding: 40px 36px; }
    .card-title { font-size: 24px; font-weight: 800; color: #1e293b; margin-bottom: 28px; }
    .form-group { margin-bottom: 20px; }
    label { display: block; font-size: 13px; font-weight: 600; color: #374151; margin-bottom: 6px; }
    select, textarea {
      width: 100%; padding: 12px 14px;
      border: 1.5px solid #e5e7eb; border-radius: 8px;
      font-size: 15px; font-family: inherit; color: #111827;
      transition: border-color .2s;
    }
    select:focus, textarea:focus { border-color: #667eea; outline: none; }
    textarea { min-height: 110px; resize: vertical; }
    .btn-submit {
      width: 100%; padding: 13px;
      background: linear-gradient(135deg, #3b82f6, #1d4ed8);
      color: #fff; border: none; border-radius: 8px;
      font-size: 16px; font-weight: 600; cursor: pointer;
      transition: opacity .2s;
    }
    .btn-submit:hover { opacity: .9; }
  </style>
</head>
<body>
<%
  Review review    = (Review) request.getAttribute("review");
  String productId = (String) request.getAttribute("productId");
%>

<nav class="navbar">
  <a class="navbar-brand" href="${pageContext.request.contextPath}/home">&#128722; Shop<span>MVC</span></a>
  <div>
    <a class="nav-link" href="${pageContext.request.contextPath}/home">Home</a>
    <a class="nav-link" href="${pageContext.request.contextPath}/logout">Sign out</a>
  </div>
</nav>

<div class="container">
  <a class="back-link" href="${pageContext.request.contextPath}/product?id=<%= productId %>">&#8592; Back to Product</a>

  <div class="card">
    <div class="card-title">&#9998; Edit Your Review</div>

    <form action="${pageContext.request.contextPath}/update-review" method="post">
      <input type="hidden" name="reviewId"  value="<%= review.getId() %>">
      <input type="hidden" name="productId" value="<%= productId %>">

      <div class="form-group">
        <label for="rating">Rating</label>
        <select name="rating" id="rating" required>
          <option value="5" <%= review.getRating() == 5 ? "selected" : "" %>>&#9733;&#9733;&#9733;&#9733;&#9733; — Excellent</option>
          <option value="4" <%= review.getRating() == 4 ? "selected" : "" %>>&#9733;&#9733;&#9733;&#9733;&#9734; — Good</option>
          <option value="3" <%= review.getRating() == 3 ? "selected" : "" %>>&#9733;&#9733;&#9733;&#9734;&#9734; — Average</option>
          <option value="2" <%= review.getRating() == 2 ? "selected" : "" %>>&#9733;&#9733;&#9734;&#9734;&#9734; — Poor</option>
          <option value="1" <%= review.getRating() == 1 ? "selected" : "" %>>&#9733;&#9734;&#9734;&#9734;&#9734; — Terrible</option>
        </select>
      </div>

      <div class="form-group">
        <label for="comment">Your Review</label>
        <textarea name="comment" id="comment"><%= review.getComment() != null ? review.getComment() : "" %></textarea>
      </div>

      <button type="submit" class="btn-submit">Update Review</button>
    </form>
  </div>
</div>
</body>
</html>
