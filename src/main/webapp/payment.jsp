<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.app.parking.model.ParkingSlot" %>
<%@ page import="com.app.parking.model.Vehicle" %>
<%
    Double fee = (Double) request.getAttribute("fee");
    Vehicle vehicle = (Vehicle) request.getAttribute("vehicle");
    ParkingSlot slot = (ParkingSlot) request.getAttribute("slot");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Payment Processing</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-100 min-h-screen flex items-center justify-center p-4">
<div class="w-full max-w-md bg-white rounded-xl shadow-md overflow-hidden">
    <!-- Header -->
    <div class="bg-blue-600 py-4 px-6">
        <h2 class="text-xl font-semibold text-white">Parking Payment</h2>
    </div>

    <!-- Payment Details -->
    <div class="p-6">
        <div class="space-y-4 mb-6">
            <div class="flex justify-between">
                <span class="text-gray-600 font-medium">Vehicle:</span>
                <span class="text-gray-800"><%= vehicle.getLicensePlate() %> (<%= vehicle.getType() %>)</span>
            </div>
            <div class="flex justify-between">
                <span class="text-gray-600 font-medium">Slot Number:</span>
                <span class="text-gray-800"><%= slot.getSlotNumber() %></span>
            </div>
            <div class="flex justify-between">
                <span class="text-gray-600 font-medium">Duration:</span>
                <span class="text-gray-800"><%= request.getAttribute("duration") %> hours</span>
            </div>
        </div>

        <!-- Total Amount -->
        <div class="bg-blue-50 rounded-lg p-4 mb-6 text-center">
            <p class="text-sm text-gray-600">Total Amount</p>
            <p class="text-3xl font-bold text-blue-600"><%= String.format("%.2f", fee) %> LKR</p>
        </div>

        <!-- Payment Form -->
        <form action="transactions" method="post">
            <input type="hidden" name="action" value="complete-payment">

            <div class="mb-4">
                <label class="block text-gray-700 text-sm font-medium mb-2" for="paymentMethod">
                    Payment Method
                </label>
                <select id="paymentMethod" name="paymentMethod" required
                        class="w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-blue-500 focus:border-blue-500">
                    <option value="">Select Payment Method</option>
                    <option value="Cash">Cash</option>
                    <option value="Credit Card">Credit Card</option>
                    <option value="Debit Card">Debit Card</option>
                    <option value="Mobile Payment">Mobile Payment</option>
                </select>
            </div>

            <button type="submit"
                    class="w-full bg-green-600 hover:bg-green-700 text-white font-medium py-2 px-4 rounded-md transition duration-150 ease-in-out">
                Complete Payment
            </button>
        </form>
    </div>
</div>
</body>
</html>