<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - Parking System</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <style>
        body {
            background-image: url('background.jpeg');
            background-size: cover;
            background-position: center;
            background-attachment: fixed;
            background-repeat: no-repeat;
        }
        .bg-overlay {
            background-color: rgba(255, 255, 255, 0.85);
        }
    </style>
</head>
<body class="min-h-screen flex items-center justify-center">
<div class="w-full max-w-md p-8 space-y-8 bg-white rounded-lg shadow-md bg-overlay">
    <div class="text-center">
        <h2 class="text-3xl font-extrabold text-gray-900">Parking System</h2>
        <p class="mt-2 text-sm text-gray-600">Sign in to your account</p>
    </div>

    <%-- Error Message --%>
    <% String error = (String) request.getAttribute("error"); %>
    <% if (error != null) { %>
    <div class="bg-red-50 border-l-4 border-red-500 p-4">
        <div class="flex">
            <div class="flex-shrink-0">
                <svg class="h-5 w-5 text-red-500" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor">
                    <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zM8.707 7.293a1 1 0 00-1.414 1.414L8.586 10l-1.293 1.293a1 1 0 101.414 1.414L10 11.414l1.293 1.293a1 1 0 001.414-1.414L11.414 10l1.293-1.293a1 1 0 00-1.414-1.414L10 8.586 8.707 7.293z" clip-rule="evenodd" />
                </svg>
            </div>
            <div class="ml-3">
                <p class="text-sm text-red-700"><%= error %></p>
            </div>
        </div>
    </div>
    <% } %>

    <%-- Success Message --%>
    <% String registered = request.getParameter("registered"); %>
    <% if ("true".equals(registered)) { %>
    <div class="bg-green-50 border-l-4 border-green-500 p-4">
        <div class="flex">
            <div class="flex-shrink-0">
                <svg class="h-5 w-5 text-green-500" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor">
                    <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clip-rule="evenodd" />
                </svg>
            </div>
            <div class="ml-3">
                <p class="text-sm text-green-700">Registration successful! Please login.</p>
            </div>
        </div>
    </div>
    <% } %>

    <form class="mt-8 space-y-6" action="users" method="post">
        <input type="hidden" name="action" value="login">
        <div class="rounded-md shadow-sm space-y-4">
            <div>
                <label for="username" class="sr-only">Username</label>
                <input id="username" name="username" type="text" required
                       class="appearance-none relative block w-full px-3 py-2 border border-gray-300 placeholder-gray-500 text-gray-900 rounded-md focus:outline-none focus:ring-blue-500 focus:border-blue-500 focus:z-10 sm:text-sm"
                       placeholder="Username">
            </div>
            <div>
                <label for="password" class="sr-only">Password</label>
                <input id="password" name="password" type="password" required
                       class="appearance-none relative block w-full px-3 py-2 border border-gray-300 placeholder-gray-500 text-gray-900 rounded-md focus:outline-none focus:ring-blue-500 focus:border-blue-500 focus:z-10 sm:text-sm"
                       placeholder="Password">
            </div>
        </div>

        <div>
            <button type="submit"
                    class="group relative w-full flex justify-center py-2 px-4 border border-transparent text-sm font-medium rounded-md text-white bg-blue-600 hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500">
                Sign in
            </button>
        </div>
    </form>

    <div class="text-center">
        <p class="text-sm text-gray-600">
            Don't have an account?
            <a href="users?action=new" class="font-medium text-blue-600 hover:text-blue-500">
                Register here
            </a>
        </p>
    </div>
</div>
</body>
</html>