<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.app.parking.model.SupportTicket" %>
<%
    SupportTicket ticket = (SupportTicket) request.getAttribute("ticket");
%>
<html>
<head>
    <title>Ticket Details</title>
    <style>
        .ticket-container {
            width: 70%;
            margin: 20px auto;
            border: 1px solid #ddd;
            padding: 20px;
            border-radius: 5px;
        }
        .ticket-header {
            border-bottom: 1px solid #ddd;
            padding-bottom: 10px;
            margin-bottom: 15px;
        }
        .ticket-meta {
            color: #666;
            font-size: 14px;
            margin-bottom: 10px;
        }
        .ticket-message, .ticket-response {
            background-color: #f9f9f9;
            padding: 15px;
            border-radius: 5px;
            margin-bottom: 20px;
        }
        .ticket-response {
            background-color: #e6f7e6;
        }
        .response-form textarea {
            width: 100%;
            height: 100px;
            padding: 8px;
            border: 1px solid #ddd;
            border-radius: 4px;
            margin-bottom: 10px;
        }
        .btn {
            padding: 8px 15px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
        }
        .btn-submit {
            background-color: #4CAF50;
            color: white;
        }
        .btn-back {
            background-color: #f2f2f2;
        }
    </style>
</head>
<body>
<div class="ticket-container">
    <div class="ticket-header">
        <h2><%= ticket.getSubject() %></h2>
        <div class="ticket-meta">
            Submitted by: <%= ticket.getUserId() %> on <%= ticket.getSubmissionDate() %>
        </div>
    </div>

    <div class="ticket-message">
        <h4>Original Message:</h4>
        <p><%= ticket.getMessage() %></p>
    </div>

    <% if (ticket.isResolved()) { %>
    <div class="ticket-response">
        <h4>Admin Response:</h4>
        <p><%= ticket.getResponse() %></p>
        <div class="ticket-meta">
            Responded on <%= ticket.getResponseDate() %>
        </div>
    </div>
    <% } else { %>
    <form class="response-form" action="feedback" method="post">
        <input type="hidden" name="action" value="respond-ticket">
        <input type="hidden" name="ticketId" value="<%= ticket.getFeedbackId() %>">

        <h4>Respond to Ticket:</h4>
        <textarea name="response" required></textarea>

        <button type="submit" class="btn btn-submit">Submit Response</button>
        <a href="feedback?action=manage" class="btn btn-back">Back to Tickets</a>
    </form>
    <% } %>
</div>
</body>
</html>