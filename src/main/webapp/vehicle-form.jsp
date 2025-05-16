<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.app.parking.model.Vehicle" %>
<%
  Vehicle vehicle = (Vehicle) request.getAttribute("vehicle");
  String error = (String) request.getAttribute("error");
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title><%= vehicle == null ? "Add" : "Edit" %> Vehicle</title>
  <script src="https://cdn.tailwindcss.com"></script>
</head>

<body class="bg-gray-100 min-h-screen">
<div class="max-w-md mx-auto p-6">
  <div class="bg-white p-8 rounded-lg shadow-md">
    <div class="flex justify-between items-center mb-6">
      <h2 class="text-2xl font-semibold text-gray-800"><%= vehicle == null ? "Add New" : "Edit" %> Vehicle</h2>
      <a href="vehicles" class="text-sm text-blue-600 hover:text-blue-800">Back to List</a>
    </div>

    <% if (error != null) { %>
    <div class="mb-4 p-3 bg-red-100 border-l-4 border-red-500 text-red-700">
      <p><%= error %></p>
    </div>
    <% } %>

    <form action="vehicles" method="post">
      <input type="hidden" name="action" value="<%= vehicle == null ? "create" : "update" %>">
      <% if (vehicle != null) { %>
      <input type="hidden" name="id" value="<%= vehicle.getVehicleId() %>">
      <% } %>

      <div class="mb-4">
        <label for="licensePlate" class="block text-sm font-medium text-gray-700 mb-1">License Plate</label>
        <input type="text" id="licensePlate" name="licensePlate"
               value="<%= vehicle != null ? vehicle.getLicensePlate() : "" %>"
               class="w-full p-2 border border-gray-300 rounded-md focus:ring-blue-500 focus:border-blue-500"
               required>
      </div>

      <div class="mb-4">
        <label for="ownerName" class="block text-sm font-medium text-gray-700 mb-1">Owner Name</label>
        <input type="text" id="ownerName" name="ownerName"
               value="<%= vehicle != null ? vehicle.getOwnerName() : "" %>"
               class="w-full p-2 border border-gray-300 rounded-md focus:ring-blue-500 focus:border-blue-500"
               required>
      </div>

      <div class="mb-6">
        <label for="type" class="block text-sm font-medium text-gray-700 mb-1">Vehicle Type</label>
        <select id="type" name="type"
                class="w-full p-2 border border-gray-300 rounded-md focus:ring-blue-500 focus:border-blue-500"
                <%= vehicle != null ? "disabled" : "" %>>
          <option value="Car" <%= vehicle != null && "Car".equals(vehicle.getType()) ? "selected" : "" %>>Car</option>
          <option value="Bike" <%= vehicle != null && "Bike".equals(vehicle.getType()) ? "selected" : "" %>>Bike</option>
          <option value="Truck" <%= vehicle != null && "Truck".equals(vehicle.getType()) ? "selected" : "" %>>Truck</option>
        </select>
      </div>

      <div class="flex items-center justify-between">
        <button type="submit"
                class="px-4 py-2 bg-blue-600 text-white rounded-md hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-offset-2">
          <%= vehicle == null ? "Register" : "Update" %> Vehicle
        </button>
        <a href="vehicles"
           class="text-sm text-gray-600 hover:text-gray-800">
          Cancel
        </a>
      </div>
    </form>
  </div>
</div>
</body>
</html>