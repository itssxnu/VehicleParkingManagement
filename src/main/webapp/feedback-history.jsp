<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.app.parking.model.Feedback" %>
<%@ page import="com.app.parking.model.SupportTicket" %>
<%@ page import="java.util.List" %>
<%
    List<Feedback> feedbackHistory = (List<Feedback>) request.getAttribute("feedbackHistory");
    String success = request.getParameter("success");
    String error = request.getParameter("error");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Feedback History</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>

<body class="bg-gray-100">
<header class="bg-blue-600 text-white p-6">
    <div class="max-w-7xl mx-auto flex justify-between items-center">
        <h1 class="text-3xl font-semibold">My Feedback History</h1>
        <a href="parking-slots?action=operator-view" class="bg-gray-500 px-4 py-2 rounded-md hover:bg-gray-600">Back to Dashboard</a>
    </div>
</header>

<main class="p-6">
    <div class="max-w-7xl mx-auto">
        <div class="flex justify-between items-center mb-6">
            <h2 class="text-xl font-semibold text-gray-800">All Submitted Feedback</h2>
            <a href="feedback" class="bg-blue-500 text-white px-4 py-2 rounded-md hover:bg-blue-600">Submit New Feedback</a>
        </div>

        <% if (success != null) { %>
        <div class="mb-4 p-3 bg-green-100 border-l-4 border-green-500 text-green-700">
            <p><%= success %></p>
        </div>
        <% } %>

        <% if (error != null) { %>
        <div class="mb-4 p-3 bg-red-100 border-l-4 border-red-500 text-red-700">
            <p><%= error %></p>
        </div>
        <% } %>

        <% if (feedbackHistory.isEmpty()) { %>
        <div class="bg-white p-8 rounded-lg shadow-md text-center">
            <svg class="mx-auto h-12 w-12 text-gray-400" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9.172 16.172a4 4 0 015.656 0M9 10h.01M15 10h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
            </svg>
            <h3 class="mt-2 text-lg font-medium text-gray-900">No feedback submitted yet</h3>
            <p class="mt-1 text-sm text-gray-500">Get started by submitting your first feedback or support ticket.</p>
            <div class="mt-6">
                <a href="feedback" class="inline-flex items-center px-4 py-2 border border-transparent text-sm font-medium rounded-md shadow-sm text-white bg-blue-600 hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500">
                    Submit Feedback
                </a>
            </div>
        </div>
        <% } else { %>
        <div class="bg-white rounded-lg shadow-md overflow-hidden">
            <table class="min-w-full divide-y divide-gray-200">
                <thead class="bg-gray-50">
                <tr>
                    <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Date</th>
                    <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Type</th>
                    <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Subject</th>
                    <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Status</th>
                    <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Actions</th>
                </tr>
                </thead>
                <tbody class="bg-white divide-y divide-gray-200">
                <% for (Feedback feedback : feedbackHistory) { %>
                <tr class="<%= feedback instanceof SupportTicket ? "bg-red-50 hover:bg-red-100" : "hover:bg-gray-50" %>">
                    <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                        <%= feedback.getSubmissionDate() %>
                    </td>
                    <td class="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900">
                        <%= feedback instanceof SupportTicket ? "Support Ticket" : "Feedback" %>
                    </td>
                    <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                        <%= feedback.getSubject() %>
                    </td>
                    <td class="px-6 py-4 whitespace-nowrap text-sm">
                        <% if (feedback.isResolved()) { %>
                        <span class="px-2 inline-flex text-xs leading-5 font-semibold rounded-full bg-green-100 text-green-800">
                                        Resolved
                                    </span>
                        <% } else { %>
                        <span class="px-2 inline-flex text-xs leading-5 font-semibold rounded-full bg-yellow-100 text-yellow-800">
                                        Pending
                                    </span>
                        <% } %>
                    </td>
                    <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                        <div class="flex space-x-2">
                            <a href="feedback?action=view&id=<%= feedback.getFeedbackId() %>"
                               class="text-blue-600 hover:text-blue-900">View</a>
                            <a href="#" onclick="confirmDelete('<%= feedback.getFeedbackId() %>')"
                               class="text-red-600 hover:text-red-900">Delete</a>
                        </div>
                    </td>
                </tr>
                <% } %>
                </tbody>
            </table>
        </div>
        <% } %>
    </div>
</main>

<script>
    function confirmDelete(feedbackId) {
        if (confirm('Are you sure you want to delete this item?')) {
            const form = document.createElement('form');
            form.method = 'POST';
            form.action = 'feedback';

            const actionInput = document.createElement('input');
            actionInput.type = 'hidden';
            actionInput.name = 'action';
            actionInput.value = 'delete-feedback';
            form.appendChild(actionInput);

            const idInput = document.createElement('input');
            idInput.type = 'hidden';
            idInput.name = 'id';
            idInput.value = feedbackId;
            form.appendChild(idInput);

            document.body.appendChild(form);
            form.submit();
        }
    }
</script>
</body>
</html>