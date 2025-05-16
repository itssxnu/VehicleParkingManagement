<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.app.parking.model.User" %>
<%
  User user = (User) session.getAttribute("user");
  if (user == null || !"admin".equals(user.getRole())) {
    response.sendRedirect("login.jsp");
    return;
  }
%>
<html>
<head>
  <title>Admin Dashboard</title>
  <style>
    .dashboard-container {
      width: 80%;
      margin: 0 auto;
      padding: 20px;
      font-family: Arial, sans-serif;
    }
    .dashboard-header {
      background-color: #4CAF50;
      color: white;
      padding: 15px;
      text-align: center;
      margin-bottom: 20px;
    }
    .dashboard-menu {
      display: flex;
      flex-wrap: wrap;
      gap: 15px;
      margin-bottom: 20px;
    }
    .menu-button {
      background-color: #4CAF50;
      color: white;
      padding: 10px 15px;
      text-decoration: none;
      border-radius: 5px;
      transition: background-color 0.3s;
    }
    .menu-button:hover {
      background-color: #45a049;
    }
  </style>
</head>
<body>
<div class="dashboard-container">
  <div class="dashboard-header">
    <h2>Welcome, <%= user.getFullName() %> (Admin)</h2>
  </div>

  <div class="dashboard-menu">
    <a href="users" class="menu-button">Manage Users</a>
    <a href="vehicles" class="menu-button">Manage Vehicles</a>
    <a href="parking-slots" class="menu-button">Manage Parking Slots</a>
    <a href="transactions" class="menu-button">View Payment History</a>
    <a href="feedback?action=manage" class="menu-button">Manage Feedback</a>
    <a href="login.jsp" class="menu-button">Logout</a>
  </div>

  <!-- You can add dashboard content here -->
</div>
</body>
</html>