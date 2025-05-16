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

    List<ParkingSlot> occupiedSlots = (List<ParkingSlot>) request.getAttribute("occupiedSlots");
    List<Vehicle> vehicles = (List<Vehicle>) request.getAttribute("vehicles");
    String error = (String) request.getAttribute("error");
    String success = (String) request.getAttribute("success");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Occupied Parking Slots</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>

<body class="bg-gray-100">
<header class="bg-blue-600 text-white p-6">
    <div class="max-w-7xl mx-auto flex justify-between items-center">
        <h1 class="text-3xl font-semibold">Occupied Parking Slots</h1>
        <div class="flex space-x-4">
            <a href="parking-slots?action=operator-view" class="bg-gray-500 px-4 py-2 rounded-md hover:bg-gray-600">Back to Dashboard</a>
            <a href="login.jsp" class="bg-red-500 px-4 py-2 rounded-md hover:bg-red-600">Logout</a>
        </div>
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

    <div class="max-w-7xl mx-auto bg-white p-6 rounded-lg shadow-md">
        <div class="flex justify-between items-center mb-6">
            <h2 class="text-2xl font-semibold text-gray-800">Currently Occupied Slots: <%= occupiedSlots != null ? occupiedSlots.size() : 0 %></h2>
            <a href="parking-slots?action=operator-view" class="inline-flex items-center px-4 py-2 border border-transparent text-sm font-medium rounded-md shadow-sm text-white bg-blue-600 hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500">
                View All Slots
            </a>
        </div>

        <% if (occupiedSlots != null && !occupiedSlots.isEmpty()) { %>
        <div class="overflow-x-auto">
            <table class="min-w-full divide-y divide-gray-200">
                <thead class="bg-gray-50">
                <tr>
                    <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Slot Number</th>
                    <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Type</th>
                    <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Vehicle</th>
                    <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">License Plate</th>
                    <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Actions</th>
                </tr>
                </thead>
                <tbody class="bg-white divide-y divide-gray-200">
                <% for (ParkingSlot slot : occupiedSlots) { %>
                <tr class="bg-red-50">
                    <td class="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900"><%= slot.getSlotNumber() %></td>
                    <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500"><%= slot.getType() %></td>
                    <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                        <%= slot.getVehicleId() != null ? slot.getVehicleId() : "Unknown" %>
                    </td>
                    <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                        <%= getVehicleLicensePlate(vehicles, slot.getVehicleId()) %>
                    </td>
                    <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
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
            <h3 class="mt-2 text-lg font-medium text-gray-900">No occupied slots</h3>
            <p class="mt-1 text-sm text-gray-500">All parking slots are currently available.</p>
            <div class="mt-6">
                <a href="parking-slots?action=operator-view" class="inline-flex items-center px-4 py-2 border border-transparent text-sm font-medium rounded-md shadow-sm text-white bg-blue-600 hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500">
                    View All Slots
                </a>
            </div>
        </div>
        <% } %>
    </div>
</main>
</body>
</html>
<%!
    private String getVehicleLicensePlate(List<Vehicle> vehicles, String vehicleId) {
        if (vehicles == null || vehicleId == null) return "N/A";
        for (Vehicle vehicle : vehicles) {
            if (vehicle.getVehicleId().equals(vehicleId)) {
                return vehicle.getLicensePlate();
            }
        }
        return "N/A";
    }
%>