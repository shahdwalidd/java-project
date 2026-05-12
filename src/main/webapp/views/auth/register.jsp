<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Register — ShopMVC</title>
  <style>
    *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
    body {
      font-family: 'Segoe UI', system-ui, -apple-system, sans-serif;
      background: linear-gradient(135deg, #11998e 0%, #38ef7d 100%);
      min-height: 100vh;
      display: flex;
      align-items: center;
      justify-content: center;
      padding: 20px;
    }
    .card {
      background: #fff; border-radius: 16px;
      box-shadow: 0 20px 60px rgba(0,0,0,0.2);
      width: 100%; max-width: 420px;
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
    input:focus { border-color: #11998e; box-shadow: 0 0 0 3px rgba(17,153,142,.15); }
    .btn {
      width: 100%; padding: 13px;
      background: linear-gradient(135deg, #11998e, #38ef7d);
      color: #fff; border: none; border-radius: 8px;
      font-size: 16px; font-weight: 600; cursor: pointer;
      transition: opacity .2s, transform .1s; margin-top: 8px;
    }
    .btn:hover { opacity: .9; }
    .btn:active { transform: scale(.98); }
    .alert { padding: 10px 14px; border-radius: 8px; font-size: 13px; margin-bottom: 16px; }
    .alert-error { background: #fef2f2; color: #b91c1c; border: 1px solid #fecaca; }
    .hint { font-size: 11px; color: #9ca3af; margin-top: 3px; }
    .link-row { text-align: center; font-size: 14px; color: #6b7280; margin-top: 20px; }
    .link-row a { color: #11998e; font-weight: 600; text-decoration: none; }
    .link-row a:hover { text-decoration: underline; }
  </style>
</head>
<body>
<div class="card">
  <div class="brand">
    <h1>&#128722; ShopMVC</h1>
    <p>Create your free account</p>
  </div>

  <%
    List<String> errors = (List<String>) request.getAttribute("errors");
    String singleError  = (String) request.getAttribute("error");
  %>
  <% if (errors != null && !errors.isEmpty()) { %>
    <div class="alert alert-error">
      <% for (String e : errors) { %><div>&#9888; <%= e %></div><% } %>
    </div>
  <% } else if (singleError != null && !singleError.isEmpty()) { %>
    <div class="alert alert-error">&#9888; <%= singleError %></div>
  <% } %>

  <form action="${pageContext.request.contextPath}/register" method="post" novalidate>
    <div class="form-group">
      <label for="username">Username</label>
      <input type="text" id="username" name="username" placeholder="johndoe" required minlength="3">
      <div class="hint">Minimum 3 characters</div>
    </div>
    <div class="form-group">
      <label for="email">Email Address</label>
      <input type="email" id="email" name="email" placeholder="you@example.com" required>
    </div>
    <div class="form-group">
      <label for="password">Password</label>
      <input type="password" id="password" name="password" placeholder="••••••••" required minlength="6">
      <div class="hint">Minimum 6 characters</div>
    </div>
    <button type="submit" class="btn">Create Account</button>
  </form>

  <div class="link-row">
    Already have an account? <a href="${pageContext.request.contextPath}/login">Sign in</a>
  </div>
</div>
</body>
</html>
