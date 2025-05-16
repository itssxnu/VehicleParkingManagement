<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.app.parking.model.User" %>
<%@ page import="java.util.List" %>
<%
  List<User> users = (List<User>) request.getAttribute("users");
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>User Management</title>
  <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-100 min-h-screen">
<div class="max-w-7xl mx-auto p-6">
  <div class="flex justify-between items-center mb-6">
    <h1 class="text-2xl font-bold text-gray-800">User Management</h1>
    <div class="flex space-x-4">
      <a href="admin-dashboard.jsp" class="bg-gray-500 hover:bg-gray-600 text-white px-4 py-2 rounded-md">Back to Dashboard</a>
      <a href="users?action=new" class="bg-blue-500 hover:bg-blue-600 text-white px-4 py-2 rounded-md">Add New User</a>
    </div>
  </div>

  <div class="bg-white rounded-lg shadow-md overflow-hidden">
    <% if (users.isEmpty()) { %>
    <div class="text-center p-8">
      <svg class="mx-auto h-12 w-12 text-gray-400" fill="none" viewBox="0 0 24 24" stroke="currentColor">
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4.354a4 4 0 110 5.292M15 21H3v-1a6 6 0 0112 0v1zm0 0h6v-1a6 6 0 00-9-5.197M13 7a4 4 0 11-8 0 4 4 0 018 0z" />
      </svg>
      <h3 class="mt-2 text-lg font-medium text-gray-900">No users found</h3>
      <p class="mt-1 text-sm text-gray-500">Get started by creating a new user.</p>
      <div class="mt-6">
        <a href="users?action=new" class="inline-flex items-center px-4 py-2 border border-transparent text-sm font-medium rounded-md shadow-sm text-white bg-blue-600 hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500">
          Add New User
        </a>
      </div>
    </div>
    <% } else { %>
    <div class="overflow-x-auto">
      <table class="min-w-full divide-y divide-gray-200">
        <thead class="bg-gray-50">
        <tr>
          <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">ID</th>
          <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Username</th>
          <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Full Name</th>
          <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Contact</th>
          <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Role</th>
          <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Actions</th>
        </tr>
        </thead>
        <tbody class="bg-white divide-y divide-gray-200">
        <% for (User user : users) { %>
        <tr class="hover:bg-gray-50">
          <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500"><%= user.getId() %></td>
          <td class="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900"><%= user.getUsername() %></td>
          <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500"><%= user.getFullName() %></td>
          <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500"><%= user.getContact() %></td>
          <td class="px-6 py-4 whitespace-nowrap text-sm">
            <% if ("admin".equals(user.getRole())) { %>
            <span class="px-2 inline-flex text-xs leading-5 font-semibold rounded-full bg-purple-100 text-purple-800">Admin</span>
            <% } else { %>
            <span class="px-2 inline-flex text-xs leading-5 font-semibold rounded-full bg-blue-100 text-blue-800">User</span>
            <% } %>
          </td>
          <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
            <div class="flex space-x-2">
              <a href="users?action=edit&id=<%= user.getId() %>"
                 class="inline-flex items-center px-3 py-1 border border-transparent text-xs font-medium rounded-md shadow-sm text-white bg-yellow-500 hover:bg-yellow-600 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-yellow-500">
                Edit
              </a>
              <a href="users?action=delete&id=<%= user.getId() %>"
                 onclick="return confirm('Are you sure you want to delete this user?')"
                 class="inline-flex items-center px-3 py-1 border border-transparent text-xs font-medium rounded-md shadow-sm text-white bg-red-500 hover:bg-red-600 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-red-500">
                Delete
              </a>
            </div>
          </td>
        </tr>
        <% } %>
        </tbody>
      </table>
    </div>
    <% } %>
  </div>
</div>
</body>
</html>