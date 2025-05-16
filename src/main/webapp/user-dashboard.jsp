<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.app.parking.model.User" %>
<%@ page import="com.app.parking.model.Vehicle" %>
<%@ page import="com.app.parking.model.ParkingSlot" %>
<%@ page import="java.util.List" %>
<%
  User user = (User) session.getAttribute("user");
  if (user == null) {
    response.sendRedirect("login.jsp");
    return;
  }

  List<Vehicle> vehicles = (List<Vehicle>) request.getAttribute("vehicles");
  List<ParkingSlot> parkingSlots = (List<ParkingSlot>) request.getAttribute("parkingSlots");
  String error = (String) request.getAttribute("error");
  String success = (String) request.getAttribute("success");

  // Calculate dashboard metrics
  long availableSlots = parkingSlots != null ? parkingSlots.stream().filter(s -> !s.isOccupied()).count() : 0;
  long totalVehicles = vehicles != null ? vehicles.size() : 0;
  long occupiedSlots = parkingSlots != null ? parkingSlots.stream().filter(ParkingSlot::isOccupied).count() : 0;
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Vehicle Parking System Dashboard</title>
  <script src="https://cdn.tailwindcss.com"></script>
</head>

<body class="bg-gray-100">
<header class="bg-blue-600 text-white p-6">
  <div class="max-w-7xl mx-auto flex justify-between items-center">
    <h1 class="text-3xl font-semibold">Welcome, <%= user.getFullName() %></h1>
    <a href="login.jsp" class="bg-red-500 px-4 py-2 rounded-md hover:bg-red-600">Logout</a>
  </div>
</header>

<main class="p-6">
  <% if (error != null) { %>
  <div class="max-w-7xl mx-auto mb-6 p-4 bg-red-100 border-l-4 border-red-500 text-red-700">
    <p><%= error %></p>
  </div>
  <% } %>

  <% if (success != null) { %>
  <div class="max-w-7xl mx-auto mb-6 p-4 bg-green-100 border-l-4 border-green-500 text-green-700">
    <p><%= success %></p>
  </div>
  <% } %>

  <div class="max-w-7xl mx-auto grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
    <div class="bg-white p-6 rounded-lg shadow-md">
      <h2 class="text-2xl font-semibold text-gray-800">Available Slots</h2>
      <p class="text-4xl font-bold text-blue-600"><%= availableSlots %></p>
      <p class="text-sm text-gray-500">Slots available for new vehicles.</p>
      <a href="parking-slots?action=operator-view" class="mt-4 inline-block w-full py-2 bg-green-500 text-white text-center rounded-md hover:bg-green-600">Manage Slots</a>
    </div>

    <div class="bg-white p-6 rounded-lg shadow-md">
      <h2 class="text-2xl font-semibold text-gray-800">Total Vehicles</h2>
      <p class="text-4xl font-bold text-blue-600"><%= totalVehicles %></p>
      <p class="text-sm text-gray-500">Total number of vehicles in the system.</p>
      <a href="vehicles" class="mt-4 inline-block w-full py-2 bg-yellow-500 text-white text-center rounded-md hover:bg-yellow-600">View Vehicles</a>
    </div>

    <div class="bg-white p-6 rounded-lg shadow-md">
      <h2 class="text-2xl font-semibold text-gray-800">Occupied Slots</h2>
      <p class="text-4xl font-bold text-blue-600"><%= occupiedSlots %></p>
      <p class="text-sm text-gray-500">Vehicles currently parked in the system.</p>
      <a href="parking-slots?action=occupied-view" class="mt-4 inline-block w-full py-2 bg-indigo-500 text-white text-center rounded-md hover:bg-indigo-600">View Occupied Slots</a>
    </div>
  </div>

  <div class="max-w-7xl mx-auto mt-6 grid grid-cols-1 md:grid-cols-2 lg:grid-cols-2 gap-6">
    <div class="bg-white p-6 rounded-lg shadow-md text-center">
      <h3 class="text-xl font-semibold text-gray-800">Submit Feedback</h3>
      <p class="text-sm text-gray-500 mb-4">Share your experience or report issues.</p>
      <a href="feedback" class="inline-block py-2 px-4 bg-blue-500 text-white rounded-md hover:bg-blue-600">Submit Feedback</a>
    </div>

    <div class="bg-white p-6 rounded-lg shadow-md text-center">
      <h3 class="text-xl font-semibold text-gray-800">My Feedback History</h3>
      <p class="text-sm text-gray-500 mb-4">View your previous feedback and tickets.</p>
      <a href="feedback?action=history" class="inline-block py-2 px-4 bg-blue-500 text-white rounded-md hover:bg-blue-600">View History</a>
    </div>
  </div>

  <!-- Parking Slots Table -->
  <div class="max-w-7xl mx-auto mt-8 bg-white p-6 rounded-lg shadow-md">
    <h2 class="text-2xl font-semibold text-gray-800 mb-4">Parking Slot Management</h2>

    <% if (parkingSlots != null && !parkingSlots.isEmpty()) { %>
    <div class="overflow-x-auto">
      <table class="min-w-full divide-y divide-gray-200">
        <thead class="bg-gray-50">
        <tr>
          <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Slot Number</th>
          <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Type</th>
          <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Status</th>
          <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Assigned Vehicle</th>
          <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Actions</th>
        </tr>
        </thead>
        <tbody class="bg-white divide-y divide-gray-200">
        <% for (ParkingSlot slot : parkingSlots) { %>
        <tr class="<%= slot.isOccupied() ? "bg-red-50" : "bg-green-50" %>">
          <td class="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900"><%= slot.getSlotNumber() %></td>
          <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500"><%= slot.getType() %></td>
          <td class="px-6 py-4 whitespace-nowrap text-sm">
            <%= slot.isOccupied() ?
                    "<span class='px-2 inline-flex text-xs leading-5 font-semibold rounded-full bg-red-100 text-red-800'>Occupied</span>" :
                    "<span class='px-2 inline-flex text-xs leading-5 font-semibold rounded-full bg-green-100 text-green-800'>Available</span>" %>
          </td>
          <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
            <%= slot.getVehicleId() != null ?
                    slot.getVehicleId() + " (" + getVehicleLicensePlate(vehicles, slot.getVehicleId()) + ")" :
                    "None" %>
          </td>
          <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
            <% if (!slot.isOccupied()) { %>
            <form class="flex items-center space-x-2" action="parking-slots" method="post">
              <input type="hidden" name="action" value="assign-vehicle">
              <input type="hidden" name="slotId" value="<%= slot.getSlotId() %>">
              <select name="vehicleId" required class="mt-1 block w-full pl-3 pr-10 py-2 text-base border-gray-300 focus:outline-none focus:ring-blue-500 focus:border-blue-500 sm:text-sm rounded-md">
                <option value="">Select Vehicle</option>
                <% for (Vehicle vehicle : vehicles) { %>
                <option value="<%= vehicle.getVehicleId() %>">
                  <%= vehicle.getLicensePlate() %> (<%= vehicle.getType() %>)
                </option>
                <% } %>
              </select>
              <button type="submit" class="inline-flex items-center px-3 py-2 border border-transparent text-sm leading-4 font-medium rounded-md shadow-sm text-white bg-green-600 hover:bg-green-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-green-500">
                Assign
              </button>
            </form>
            <% } else { %>
            <div class="flex space-x-2">
              <form action="transactions" method="post">
                <input type="hidden" name="action" value="checkout">
                <input type="hidden" name="slotId" value="<%= slot.getSlotId() %>">
                <button type="submit" class="inline-flex items-center px-3 py-2 border border-transparent text-sm leading-4 font-medium rounded-md shadow-sm text-white bg-yellow-600 hover:bg-yellow-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-yellow-500">
                  Checkout
                </button>
              </form>
              <form action="parking-slots" method="post"
                    onsubmit="return confirm('Are you sure you want to release this vehicle and remove it from the system?');">
                <input type="hidden" name="action" value="release">
                <input type="hidden" name="id" value="<%= slot.getSlotId() %>">
                <button type="submit" class="inline-flex items-center px-3 py-2 border border-transparent text-sm leading-4 font-medium rounded-md shadow-sm text-white bg-red-600 hover:bg-red-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-red-500">
                  Release
                </button>
              </form>
            </div>
            <% } %>
          </td>
        </tr>
        <% } %>
        </tbody>
      </table>
    </div>
    <% } else { %>
    <p class="text-gray-500">No parking slots available.</p>
    <% } %>
  </div>
</main>
</body>
</html>
<%!
  private String getVehicleLicensePlate(List<Vehicle> vehicles, String vehicleId) {
    if (vehicles == null) return "";
    for (Vehicle vehicle : vehicles) {
      if (vehicle.getVehicleId().equals(vehicleId)) {
        return vehicle.getLicensePlate();
      }
    }
    return "";
  }
%>