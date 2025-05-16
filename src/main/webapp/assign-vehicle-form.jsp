<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.app.parking.model.ParkingSlot" %>
<%
    ParkingSlot parkingSlot = (ParkingSlot) request.getAttribute("parkingSlot");
    String error = (String) request.getAttribute("error");
%>
<html>
<head>
    <title>Assign Vehicle to Parking Slot</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        .form-container { width: 300px; margin: 0 auto; }
        .form-group { margin-bottom: 15px; }
        label { display: block; margin-bottom: 5px; }
        input { width: 100%; padding: 8px; }
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
    <h2>Assign Vehicle to Parking Slot</h2>
    <p>Slot: <%= parkingSlot.getSlotNumber() %> (<%= parkingSlot.getType() %>)</p>

    <% if (error != null) { %>
    <div class="error"><%= error %></div>
    <% } %>

    <form action="parking-slots" method="post">
        <input type="hidden" name="action" value="assign-vehicle">
        <input type="hidden" name="slotId" value="<%= parkingSlot.getSlotId() %>">

        <div class="form-group">
            <label for="vehicleId">Vehicle ID:</label>
            <input type="text" id="vehicleId" name="vehicleId" required>
        </div>

        <div class="form-group">
            <input type="submit" class="btn" value="Assign">
            <a href="parking-slots" style="margin-left: 10px;">Cancel</a>
        </div>
    </form>
</div>
</body>
</html>