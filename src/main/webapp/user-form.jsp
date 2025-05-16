<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.app.parking.model.User" %>
<%
  User user = (User) request.getAttribute("user");
  String action = user == null ? "Add" : "Edit";
  String formAction = user == null ? "register" : "update";
  String error = (String) request.getAttribute("error");
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title><%= action %> User - Parking System</title>
  <script src="https://cdn.tailwindcss.com"></script>
  <style>
    body {
      background-image: url('background.jpeg');
      background-size: cover;
      background-position: center;
      background-attachment: fixed;
      background-repeat: no-repeat;
    }
    .bg-overlay {
      background-color: rgba(255, 255, 255, 0.85);
    }
  </style>
</head>
<body class="min-h-screen flex items-center justify-center">
<div class="w-full max-w-md p-8 space-y-6 bg-white rounded-lg shadow-md bg-overlay">
  <div class="text-center">
    <h2 class="text-2xl font-bold text-gray-900"><%= action %> User</h2>
    <% if (user == null) { %>
    <p class="mt-2 text-sm text-gray-600">Create your account to access the parking system</p>
    <% } %>
  </div>

  <%-- Error Message --%>
  <% if (error != null) { %>
  <div class="bg-red-50 border-l-4 border-red-500 p-4">
    <div class="flex">
      <div class="flex-shrink-0">
        <svg class="h-5 w-5 text-red-500" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor">
          <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zM8.707 7.293a1 1 0 00-1.414 1.414L8.586 10l-1.293 1.293a1 1 0 101.414 1.414L10 11.414l1.293 1.293a1 1 0 001.414-1.414L11.414 10l1.293-1.293a1 1 0 00-1.414-1.414L10 8.586 8.707 7.293z" clip-rule="evenodd" />
        </svg>
      </div>
      <div class="ml-3">
        <p class="text-sm text-red-700"><%= error %></p>
      </div>
    </div>
  </div>
  <% } %>

  <

  <form class="mt-6 space-y-4" action="users" method="post">
    <input type="hidden" name="action" value="<%= formAction %>">
    <% if (user != null) { %>
    <input type="hidden" name="id" value="<%= user.getId() %>">
    <% } %>

    <div>
      <label for="username" class="block text-sm font-medium text-gray-700">Username</label>
      <input id="username" name="username" type="text" required
             value="<%= user != null ? user.getUsername() : "" %>"
             class="mt-1 block w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-blue-500 focus:border-blue-500 sm:text-sm">
    </div>

    <div>
      <label for="password" class="block text-sm font-medium text-gray-700">Password</label>
      <input id="password" name="password" type="password" required
             value="<%= user != null ? user.getPassword() : "" %>"
             class="mt-1 block w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-blue-500 focus:border-blue-500 sm:text-sm">
    </div>

    <div>
      <label for="fullName" class="block text-sm font-medium text-gray-700">Full Name</label>
      <input id="fullName" name="fullName" type="text" required
             value="<%= user != null ? user.getFullName() : "" %>"
             class="mt-1 block w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-blue-500 focus:border-blue-500 sm:text-sm">
    </div>

    <div>
      <label for="contact" class="block text-sm font-medium text-gray-700">Contact</label>
      <input id="contact" name="contact" type="text" required
             value="<%= user != null ? user.getContact() : "" %>"
             class="mt-1 block w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-blue-500 focus:border-blue-500 sm:text-sm">
    </div>

    <div>
      <label for="role" class="block text-sm font-medium text-gray-700">Role</label>
      <select id="role" name="role"
              <%= user != null && "admin".equals(user.getRole()) ? "disabled" : "" %>
              class="mt-1 block w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-blue-500 focus:border-blue-500 sm:text-sm">
        <option value="user" <%= user != null && "user".equals(user.getRole()) ? "selected" : "" %>>User</option>
        <option value="admin" <%= user != null && "admin".equals(user.getRole()) ? "selected" : "" %>>Admin</option>
      </select>
    </div>

    <div class="pt-4">
      <button type="submit"
              class="w-full flex justify-center py-2 px-4 border border-transparent rounded-md shadow-sm text-sm font-medium text-white bg-blue-600 hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500">
        <%= action %> User
      </button>
    </div>
  </form>

  <div class="text-center pt-4 border-t border-gray-200">
    <% if (user == null) { %>
    <p class="text-sm text-gray-600">
      Already have an account?
      <a href="login.jsp" class="font-medium text-blue-600 hover:text-blue-500">
        Login here
      </a>
    </p>
    <% } else { %>
    <p class="text-sm text-gray-600">
      <a href="admin-dashboard.jsp" class="font-medium text-blue-600 hover:text-blue-500">
        Back to Dashboard
      </a>
    </p>
    <% } %>
  </div>
</div>
</body>
</html>