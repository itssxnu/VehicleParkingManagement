<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.app.parking.model.ParkingSlot" %>
<%
    ParkingSlot parkingSlot = (ParkingSlot) request.getAttribute("parkingSlot");
    String error = (String) request.getAttribute("error");
%>
<html>
<head>
    <title><%= parkingSlot == null ? "Add" : "Edit" %> Parking Slot</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        .form-container { width: 300px; margin: 0 auto; }
        .form-group { margin-bottom: 15px; }
        label { display: block; margin-bottom: 5px; }
        input, select { width: 100%; padding: 8px; }
        .error { color: red; margin-bottom: 10px; }
        .btn {
            background-color: #4CAF50;
            color: white;
            padding: 10px 15px;
            border: none;
            cursor: pointer;
        }
        .btn:hover { background-color: #45a049; }
    </style>
</head>
<body>
<div class="form-container">
    <h2><%= parkingSlot == null ? "Add" : "Edit" %> Parking Slot</h2>

    <% if (error != null) { %>
    <div class="error"><%= error %></div>
    <% } %>

    <form action="parking-slots" method="post">
        <input type="hidden" name="action" value="<%= parkingSlot == null ? "create" : "update" %>">
        <% if (parkingSlot != null) { %>
        <input type="hidden" name="id" value="<%= parkingSlot.getSlotId() %>">
        <% } %>

        <div class="form-group">
            <label for="slotNumber">Slot Number:</label>
            <input type="text" id="slotNumber" name="slotNumber"
                   value="<%= parkingSlot != null ? parkingSlot.getSlotNumber() : "" %>" required>
        </div>

        <div class="form-group">
            <label for="type">Vehicle Type:</label>
            <select id="type" name="type">
                <option value="Car" <%= parkingSlot != null && "Car".equals(parkingSlot.getType()) ? "selected" : "" %>>Car</option>
                <option value="Bike" <%= parkingSlot != null && "Bike".equals(parkingSlot.getType()) ? "selected" : "" %>>Bike</option>
                <option value="Truck" <%= parkingSlot != null && "Truck".equals(parkingSlot.getType()) ? "selected" : "" %>>Truck</option>
            </select>
        </div>

        <div class="form-group">
            <input type="submit" class="btn" value="Save">
            <a href="parking-slots" style="margin-left: 10px;">Cancel</a>
        </div>
    </form>
</div>
</body>
</html>