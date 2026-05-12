<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"><title>404 — Not Found</title>
  <style>
    body { font-family: 'Segoe UI', sans-serif; background: #f8fafc; display: flex; align-items: center; justify-content: center; min-height: 100vh; margin: 0; }
    .box { text-align: center; background: #fff; padding: 60px 48px; border-radius: 16px; box-shadow: 0 8px 32px rgba(0,0,0,.1); max-width: 460px; }
    .code { font-size: 80px; font-weight: 900; color: #f59e0b; line-height: 1; }
    h2 { font-size: 22px; color: #1e293b; margin: 12px 0 8px; }
    p  { color: #64748b; font-size: 15px; line-height: 1.6; }
    a  { display: inline-block; margin-top: 28px; padding: 12px 28px; background: linear-gradient(135deg, #667eea, #764ba2); color: #fff; border-radius: 8px; text-decoration: none; font-weight: 600; }
  </style>
</head>
<body>
  <div class="box">
    <div class="code">404</div>
    <h2>Page Not Found</h2>
    <p>The page you are looking for doesn't exist or has been moved.</p>
    <a href="${pageContext.request.contextPath}/home">&#8592; Go Home</a>
  </div>
</body>
</html>
