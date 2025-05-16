<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.app.parking.model.ParkingTransaction" %>
<%@ page import="java.util.List" %>
<%
    List<ParkingTransaction> transactions = (List<ParkingTransaction>) request.getAttribute("transactions");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Transaction History</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-100">
<div class="max-w-7xl mx-auto px-4 py-8">
    <div class="bg-white rounded-lg shadow-md p-6">
        <h2 class="text-2xl font-bold text-gray-800 mb-6">Parking Transaction History</h2>

        <div class="overflow-x-auto">
            <table class="min-w-full border border-gray-200">
                <thead class="bg-gray-50">
                <tr>
                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider border">Transaction ID</th>
                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider border">Vehicle ID</th>
                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider border">Slot ID</th>
                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider border">Entry Time</th>
                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider border">Exit Time</th>
                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider border">Duration (hours)</th>
                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider border">Fee</th>
                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider border">Status</th>
                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider border">Payment Method</th>
                </tr>
                </thead>
                <tbody class="bg-white divide-y divide-gray-200">
                <% for (ParkingTransaction t : transactions) { %>
                <tr class="hover:bg-gray-50">
                    <td class="px-6 py-4 whitespace-nowrap border text-sm text-gray-900"><%= t.getTransactionId() %></td>
                    <td class="px-6 py-4 whitespace-nowrap border text-sm text-gray-900"><%= t.getVehicleId() %></td>
                    <td class="px-6 py-4 whitespace-nowrap border text-sm text-gray-900"><%= t.getSlotId() %></td>
                    <td class="px-6 py-4 whitespace-nowrap border text-sm text-gray-900"><%= t.getEntryTime() %></td>
                    <td class="px-6 py-4 whitespace-nowrap border text-sm text-gray-900"><%= t.getExitTime() != null ? t.getExitTime() : "N/A" %></td>
                    <td class="px-6 py-4 whitespace-nowrap border text-sm text-gray-900"><%= t.getExitTime() != null ? t.getDurationHours() : "N/A" %></td>
                    <td class="px-6 py-4 whitespace-nowrap border text-sm text-gray-900"><%= String.format("%.2f", t.getFee()) %> LKR</td>
                    <td class="px-6 py-4 whitespace-nowrap border text-sm <%= t.isPaid() ? "text-green-600" : "text-red-600" %>">
                        <%= t.isPaid() ? "Paid" : "Unpaid" %>
                    </td>
                    <td class="px-6 py-4 whitespace-nowrap border text-sm text-gray-900"><%= t.getPaymentMethod() != null ? t.getPaymentMethod() : "N/A" %></td>
                </tr>
                <% } %>
                </tbody>
            </table>
        </div>

        <div class="mt-6">
            <a href="admin-dashboard.jsp" class="inline-flex items-center px-4 py-2 border border-transparent text-sm font-medium rounded-md shadow-sm text-white bg-blue-600 hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500">
                Back to Dashboard
            </a>
        </div>
    </div>
</div>
</body>
</html>