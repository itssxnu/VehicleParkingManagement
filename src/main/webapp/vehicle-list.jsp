<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.app.parking.model.Vehicle" %>
<%@ page import="java.util.List" %>
<%@ page import="com.app.parking.model.User" %>
<%
  List<Vehicle> vehicles = (List<Vehicle>) request.getAttribute("vehicles");
  User user = (User) session.getAttribute("user");
  boolean isAdmin = user != null && "admin".equals(user.getRole());
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Vehicle Management</title>
  <script src="https://cdn.tailwindcss.com"></script>
</head>

<body class="bg-gray-100">
<header class="bg-blue-600 text-white p-6">
  <div class="max-w-7xl mx-auto flex justify-between items-center">
    <h1 class="text-3xl font-semibold">Vehicle Management</h1>
    <div class="flex space-x-4">
      <a href="<%= isAdmin ? "admin-dashboard.jsp" : "parking-slots?action=operator-view" %>"
         class="bg-gray-500 px-4 py-2 rounded-md hover:bg-gray-600">
        Back to Dashboard
      </a>
      <a href="vehicles?action=new" class="bg-blue-500 px-4 py-2 rounded-md hover:bg-blue-600">Add New Vehicle</a>
    </div>
  </div>
</header>

<main class="p-6">
  <div class="max-w-7xl mx-auto bg-white p-6 rounded-lg shadow-md">
    <h2 class="text-2xl font-semibold text-gray-800 mb-4">Parking Lot Vehicles</h2>

    <% if (vehicles != null && !vehicles.isEmpty()) { %>
    <div class="overflow-x-auto">
      <table class="min-w-full divide-y divide-gray-200">
        <thead class="bg-gray-50">
        <tr>
          <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">License Plate</th>
          <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Type</th>
          <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Owner Name</th>
          <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Status</th>
          <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Actions</th>
        </tr>
        </thead>
        <tbody class="bg-white divide-y divide-gray-200">
        <% for (Vehicle vehicle : vehicles) { %>
        <tr class="hover:bg-gray-50">
          <td class="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900">
            <%= vehicle.getLicensePlate() %>
          </td>
          <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
            <%= vehicle.getType() %>
          </td>
          <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
            <%= vehicle.getOwnerName() %>
          </td>
          <td class="px-6 py-4 whitespace-nowrap text-sm">
            <span class="px-2 inline-flex text-xs leading-5 font-semibold rounded-full bg-green-100 text-green-800">
              Active
            </span>
          </td>
          <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
            <div class="flex space-x-2">
              <a href="vehicles?action=edit&id=<%= vehicle.getVehicleId() %>"
                 class="inline-flex items-center px-3 py-1 border border-transparent text-xs font-medium rounded-md shadow-sm text-white bg-yellow-500 hover:bg-yellow-600 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-yellow-500">
                Edit
              </a>
              <a href="vehicles?action=delete&id=<%= vehicle.getVehicleId() %>"
                 onclick="return confirm('Are you sure you want to delete this vehicle?')"
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
    <% } else { %>
    <div class="text-center py-12">
      <svg class="mx-auto h-12 w-12 text-gray-400" fill="none" viewBox="0 0 24 24" stroke="currentColor">
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9.172 16.172a4 4 0 015.656 0M9 10h.01M15 10h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
      </svg>
      <h3 class="mt-2 text-lg font-medium text-gray-900">No vehicles found</h3>
      <p class="mt-1 text-sm text-gray-500">Get started by adding a new vehicle.</p>
      <div class="mt-6">
        <a href="vehicles?action=new" class="inline-flex items-center px-4 py-2 border border-transparent text-sm font-medium rounded-md shadow-sm text-white bg-blue-600 hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500">
          Add New Vehicle
        </a>
      </div>
    </div>
    <% } %>
  </div>
</main>
</body>
</html>