<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Login — ShopMVC</title>
  <style>
    *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
    body {
      font-family: 'Segoe UI', system-ui, -apple-system, sans-serif;
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      min-height: 100vh;
      display: flex;
      align-items: center;
      justify-content: center;
      padding: 20px;
    }
    .card {
      background: #fff;
      border-radius: 16px;
      box-shadow: 0 20px 60px rgba(0,0,0,0.2);
      width: 100%;
      max-width: 420px;
      padding: 48px 40px;
    }
    .brand { text-align: center; margin-bottom: 32px; }
    .brand h1 { font-size: 28px; color: #1a1a2e; font-weight: 700; }
    .brand p  { color: #6b7280; font-size: 14px; margin-top: 4px; }
    .form-group { margin-bottom: 18px; }
    label { display: block; font-size: 13px; font-weight: 600; color: #374151; margin-bottom: 6px; }
    input {
      width: 100%; padding: 12px 16px;
      border: 1.5px solid #e5e7eb; border-radius: 8px;
      font-size: 15px; color: #111827;
      transition: border-color .2s, box-shadow .2s;
      outline: none;
    }
    input:focus { border-color: #667eea; box-shadow: 0 0 0 3px rgba(102,126,234,.15); }
    .btn {
      width: 100%; padding: 13px;
      background: linear-gradient(135deg, #667eea, #764ba2);
      color: #fff; border: none; border-radius: 8px;
      font-size: 16px; font-weight: 600; cursor: pointer;
      transition: opacity .2s, transform .1s;
      margin-top: 8px;
    }
    .btn:hover { opacity: .92; }
    .btn:active { transform: scale(.98); }
    .alert {
      padding: 10px 14px; border-radius: 8px;
      font-size: 13px; margin-bottom: 16px;
    }
    .alert-error { background: #fef2f2; color: #b91c1c; border: 1px solid #fecaca; }
    .alert-success { background: #f0fdf4; color: #166534; border: 1px solid #bbf7d0; }
    .divider { text-align: center; color: #9ca3af; font-size: 13px; margin: 20px 0; }
    .link-row { text-align: center; font-size: 14px; color: #6b7280; }
    .link-row a { color: #667eea; font-weight: 600; text-decoration: none; }
    .link-row a:hover { text-decoration: underline; }
  </style>
</head>
<body>
<div class="card">
  <div class="brand">
    <h1>&#128722; ShopMVC</h1>
    <p>Sign in to your account</p>
  </div>

  <%
    List<String> errors = (List<String>) request.getAttribute("errors");
    String singleError  = (String) request.getAttribute("error");
    boolean deleted     = "true".equals(request.getParameter("deleted"));
    boolean registered  = "true".equals(request.getParameter("registered"));
  %>

  <% if (errors != null && !errors.isEmpty()) { %>
    <div class="alert alert-error">
      <% for (String e : errors) { %><div>&#9888; <%= e %></div><% } %>
    </div>
  <% } else if (singleError != null && !singleError.isEmpty()) { %>
    <div class="alert alert-error">&#9888; <%= singleError %></div>
  <% } %>

  <% if (deleted) { %>
    <div class="alert alert-success">&#10003; Your account has been deleted.</div>
  <% } else if (registered) { %>
    <div class="alert alert-success">&#10003; Account created! Please sign in.</div>
  <% } %>

  <form action="${pageContext.request.contextPath}/login" method="post" novalidate>
    <div class="form-group">
      <label for="email">Email Address</label>
      <input type="email" id="email" name="email" placeholder="you@example.com" required autocomplete="email">
    </div>
    <div class="form-group">
      <label for="password">Password</label>
      <input type="password" id="password" name="password" placeholder="••••••••" required autocomplete="current-password">
    </div>
    <button type="submit" class="btn">Sign In</button>
  </form>

  <div class="divider">— or —</div>
  <div class="link-row">
    Don't have an account? <a href="${pageContext.request.contextPath}/register">Create one</a>
  </div>
</div>
</body>
</html>
