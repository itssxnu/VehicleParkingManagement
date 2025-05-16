<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Submit Feedback</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>

<body class="bg-gray-100 min-h-screen">
<div class="max-w-md mx-auto p-6">
    <div class="bg-white p-8 rounded-lg shadow-md">
        <div class="flex justify-between items-center mb-6">
            <h2 class="text-2xl font-semibold text-gray-800">Submit Feedback</h2>
            <a href="parking-slots?action=operator-view" class="text-sm text-blue-600 hover:text-blue-800">Back to Dashboard</a>
        </div>

        <% if (request.getAttribute("error") != null) { %>
        <div class="mb-4 p-3 bg-red-100 border-l-4 border-red-500 text-red-700">
            <p><%= request.getAttribute("error") %></p>
        </div>
        <% } %>

        <% if (request.getAttribute("success") != null) { %>
        <div class="mb-4 p-3 bg-green-100 border-l-4 border-green-500 text-green-700">
            <p><%= request.getAttribute("success") %></p>
        </div>
        <% } %>

        <form action="feedback" method="post">
            <input type="hidden" name="action" value="submit-feedback">

            <div class="mb-4">
                <label for="type" class="block text-sm font-medium text-gray-700 mb-1">Type</label>
                <select id="type" name="type" class="w-full p-2 border border-gray-300 rounded-md focus:ring-blue-500 focus:border-blue-500" required>
                    <option value="feedback">General Feedback</option>
                    <option value="ticket">Support Ticket</option>
                </select>
            </div>

            <div class="mb-4">
                <label for="subject" class="block text-sm font-medium text-gray-700 mb-1">Subject</label>
                <input type="text" id="subject" name="subject"
                       class="w-full p-2 border border-gray-300 rounded-md focus:ring-blue-500 focus:border-blue-500"
                       required>
            </div>

            <div class="mb-6">
                <label for="message" class="block text-sm font-medium text-gray-700 mb-1">Message</label>
                <textarea id="message" name="message" rows="4"
                          class="w-full p-2 border border-gray-300 rounded-md focus:ring-blue-500 focus:border-blue-500"
                          required></textarea>
            </div>

            <div class="flex items-center justify-between">
                <button type="submit"
                        class="px-4 py-2 bg-blue-600 text-white rounded-md hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-offset-2">
                    Submit
                </button>
                <a href="parking-slots?action=operator-view"
                   class="text-sm text-gray-600 hover:text-gray-800">
                    Cancel
                </a>
            </div>
        </form>
    </div>
</div>

<script>
    function toggleTicketFields() {
        const type = document.getElementById("type").value;
    }
</script>
</body>
</html>