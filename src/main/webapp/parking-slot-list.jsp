<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.app.parking.model.ParkingSlot" %>
<%@ page import="java.util.List" %>
<%
  List<ParkingSlot> parkingSlots = (List<ParkingSlot>) request.getAttribute("parkingSlots");
  boolean availableView = request.getAttribute("availableView") != null;
  boolean sortedView = request.getAttribute("sortedView") != null;
%>
<html>
<head>
  <title>Parking Slot Management</title>
  <style>
    body { font-family: Arial, sans-serif; margin: 20px; }
    .header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; }
    .btn {
      background-color: #4CAF50;
      color: white;
      padding: 10px 15px;
      text-decoration: none;
      border-radius: 5px;
    }
    .btn:hover { background-color: #45a049; }
    table { width: 100%; border-collapse: collapse; margin-top: 20px; }
    th, td { border: 1px solid #ddd; padding: 8px; text-align: left; }
    th { background-color: #f2f2f2; }
    .occupied { background-color: #ffdddd; }
    .available { background-color: #ddffdd; }
    .view-options { margin-bottom: 15px; }
  </style>
</head>
<body>
<div class="header">
  <h1>Parking Slot Management</h1>
  <a href="parking-slots?action=new" class="btn">Add New Slot</a>
</div>

<div class="view-options">
  <a href="parking-slots" class="btn <%= !availableView && !sortedView ? "active" : "" %>">All Slots</a>
  <a href="parking-slots?action=available" class="btn <%= availableView ? "active" : "" %>">Available Slots</a>
  <a href="parking-slots?action=sorted" class="btn <%= sortedView ? "active" : "" %>">Sort by Availability</a>
  <a href="admin-dashboard.jsp" class="btn"> Back to Dashboard </a>
</div>

<table>
  <tr>
    <th>Slot ID</th>
    <th>Slot Number</th>
    <th>Type</th>
    <th>Status</th>
    <th>Vehicle ID</th>
    <th>Actions</th>
  </tr>
  <% for (ParkingSlot slot : parkingSlots) { %>
  <tr class="<%= slot.isOccupied() ? "occupied" : "available" %>">
    <td><%= slot.getSlotId() %></td>
    <td><%= slot.getSlotNumber() %></td>
    <td><%= slot.getType() %></td>
    <td><%= slot.isOccupied() ? "Occupied" : "Available" %></td>
    <td><%= slot.getVehicleId() != null ? slot.getVehicleId() : "N/A" %></td>
    <td>
      <% if (!slot.isOccupied()) { %>
      <a href="parking-slots?action=assign&id=<%= slot.getSlotId() %>">Assign Vehicle</a>
      <% } else { %>
      <a href="parking-slots?action=release&id=<%= slot.getSlotId() %>">Release</a>
      <% } %>
      | <a href="parking-slots?action=edit&id=<%= slot.getSlotId() %>">Edit</a>
      | <a href="parking-slots?action=delete&id=<%= slot.getSlotId() %>"
           onclick="return confirm('Are you sure you want to delete this parking slot?')">Delete</a>
    </td>
  </tr>
  <% } %>
</table>
</body>
</html>