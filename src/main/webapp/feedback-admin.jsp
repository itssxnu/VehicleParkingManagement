<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.app.parking.model.SupportTicket" %>
<%@ page import="com.app.parking.model.Feedback" %>
<%@ page import="java.util.List" %>
<%
    List<SupportTicket> unresolvedTickets = (List<SupportTicket>) request.getAttribute("unresolvedTickets");
    List<Feedback> allFeedback = (List<Feedback>) request.getAttribute("allFeedback");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Feedback Management</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-100">
<div class="max-w-7xl mx-auto px-4 py-8">
    <div class="bg-white rounded-lg shadow-md p-6 mb-8">
        <h2 class="text-2xl font-bold text-gray-800 mb-6">Feedback Management Dashboard</h2>

        <!-- Unresolved Support Tickets Section -->
        <div class="mb-10">
            <h3 class="text-xl font-semibold text-gray-700 mb-4">Unresolved Support Tickets</h3>
            <% if (unresolvedTickets.isEmpty()) { %>
            <p class="text-gray-500">No unresolved tickets.</p>
            <% } else { %>
            <div class="overflow-x-auto">
                <table class="min-w-full border border-gray-200">
                    <thead class="bg-gray-50">
                    <tr>
                        <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider border">Date</th>
                        <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider border">User ID</th>
                        <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider border">Subject</th>
                        <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider border">Actions</th>
                    </tr>
                    </thead>
                    <tbody class="bg-white divide-y divide-gray-200">
                    <% for (SupportTicket ticket : unresolvedTickets) { %>
                    <tr class="hover:bg-gray-50">
                        <td class="px-6 py-4 whitespace-nowrap border text-sm text-gray-900"><%= ticket.getSubmissionDate() %></td>
                        <td class="px-6 py-4 whitespace-nowrap border text-sm text-gray-900"><%= ticket.getUserId() %></td>
                        <td class="px-6 py-4 whitespace-nowrap border text-sm text-gray-900"><%= ticket.getSubject() %></td>
                        <td class="px-6 py-4 whitespace-nowrap border text-sm text-gray-900">
                            <a href="feedback?action=view-ticket&id=<%= ticket.getFeedbackId() %>"
                               class="inline-flex items-center px-3 py-1 border border-transparent text-xs font-medium rounded-md shadow-sm text-white bg-blue-600 hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500">
                                Respond
                            </a>
                        </td>
                    </tr>
                    <% } %>
                    </tbody>
                </table>
            </div>
            <% } %>
        </div>

        <!-- All Feedback Items Section -->
        <div>
            <h3 class="text-xl font-semibold text-gray-700 mb-4">All Feedback Items</h3>
            <% if (allFeedback.isEmpty()) { %>
            <p class="text-gray-500">No feedback items found.</p>
            <% } else { %>
            <div class="overflow-x-auto">
                <table class="min-w-full border border-gray-200">
                    <thead class="bg-gray-50">
                    <tr>
                        <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider border">Date</th>
                        <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider border">User ID</th>
                        <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider border">Type</th>
                        <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider border">Subject</th>
                        <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider border">Status</th>
                    </tr>
                    </thead>
                    <tbody class="bg-white divide-y divide-gray-200">
                    <% for (Feedback feedback : allFeedback) { %>
                    <tr class="hover:bg-gray-50">
                        <td class="px-6 py-4 whitespace-nowrap border text-sm text-gray-900"><%= feedback.getSubmissionDate() %></td>
                        <td class="px-6 py-4 whitespace-nowrap border text-sm text-gray-900"><%= feedback.getUserId() %></td>
                        <td class="px-6 py-4 whitespace-nowrap border text-sm <%= feedback instanceof SupportTicket ? "text-red-600 font-semibold" : "text-gray-900" %>">
                            <%= feedback instanceof SupportTicket ? "Ticket" : "Feedback" %>
                        </td>
                        <td class="px-6 py-4 whitespace-nowrap border text-sm text-gray-900"><%= feedback.getSubject() %></td>
                        <td class="px-6 py-4 whitespace-nowrap border text-sm <%= feedback.isResolved() ? "text-green-600" : "text-yellow-600" %>">
                            <%= feedback.isResolved() ? "Resolved" : "Pending" %>
                        </td>
                    </tr>
                    <% } %>
                    </tbody>
                </table>
            </div>
            <% } %>
        </div>
    </div>

    <!-- Back to Dashboard Button -->
    <div class="mt-4">
        <a href="admin-dashboard.jsp" class="inline-flex items-center px-4 py-2 border border-transparent text-sm font-medium rounded-md shadow-sm text-white bg-blue-600 hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500">
            Back to Dashboard
        </a>
    </div>
</div>
</body>
</html>