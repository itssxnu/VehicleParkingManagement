package com.app.parking.controller;

import com.app.parking.dao.FeedbackDAO;
import com.app.parking.model.Feedback;
import com.app.parking.model.SupportTicket;
import com.app.parking.model.User;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;
import java.time.LocalDateTime;
import java.util.List;
import java.util.stream.Collectors;

@WebServlet(name = "FeedbackServlet", value = "/feedback")
public class FeedbackServlet extends HttpServlet {
    private FeedbackDAO feedbackDAO;

    @Override
    public void init() {
        feedbackDAO = new FeedbackDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        String action = request.getParameter("action");

        if (action == null) {
            action = "view";
        }

        if ("admin".equals(user.getRole())) {
            switch (action) {
                case "manage":
                    showAdminDashboard(request, response);
                    break;
                case "view-ticket":
                    showTicketDetails(request, response);
                    break;
                default:
                    showAdminDashboard(request, response);
            }
        } else {
            switch (action) {
                case "history":
                    showUserFeedbackHistory(request, response, user.getId());
                    break;
                default:
                    showFeedbackForm(request, response);
            }
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        String action = request.getParameter("action");

        if ("submit-feedback".equals(action)) {
            submitFeedback(request, response, user.getId());
        } else if ("submit-ticket".equals(action)) {
            submitSupportTicket(request, response, user.getId());
        } else if ("respond-ticket".equals(action)) {
            respondToTicket(request, response);
        } else if ("delete-feedback".equals(action)) {
            deleteFeedback(request, response, user.getId());
        }
    }

    private void showFeedbackForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("feedback-form.jsp").forward(request, response);
    }

    private void showUserFeedbackHistory(HttpServletRequest request, HttpServletResponse response, String userId)
            throws ServletException, IOException {
        request.setAttribute("feedbackHistory", feedbackDAO.getFeedbackByUser(userId));
        request.getRequestDispatcher("feedback-history.jsp").forward(request, response);
    }

    private void showAdminDashboard(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Feedback> allFeedback = feedbackDAO.getAllFeedback();
        List<SupportTicket> unresolvedTickets = allFeedback.stream()
                .filter(f -> f instanceof SupportTicket && !f.isResolved())
                .map(f -> (SupportTicket) f)
                .collect(Collectors.toList());

        request.setAttribute("unresolvedTickets", unresolvedTickets);
        request.setAttribute("allFeedback", allFeedback);
        request.getRequestDispatcher("feedback-admin.jsp").forward(request, response);
    }

    private void showTicketDetails(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String ticketId = request.getParameter("id");
        Feedback feedback = feedbackDAO.getFeedbackById(ticketId);

        if (feedback instanceof SupportTicket) {
            request.setAttribute("ticket", (SupportTicket) feedback);
            request.getRequestDispatcher("ticket-details.jsp").forward(request, response);
        } else {
            response.sendRedirect("feedback?action=manage");
        }
    }

    private void submitFeedback(HttpServletRequest request, HttpServletResponse response, String userId)
            throws ServletException, IOException {
        String type = request.getParameter("type"); // Get the type from form
        String subject = request.getParameter("subject");
        String message = request.getParameter("message");

        Feedback feedback;
        if ("ticket".equals(type)) {
            feedback = new SupportTicket(userId, subject, message);
        } else {
            feedback = new Feedback(userId, subject, message);
        }

        if (feedbackDAO.createFeedback(feedback)) {
            response.sendRedirect("feedback?action=history&success=Submission+successful");
        } else {
            request.setAttribute("error", "Failed to submit");
            request.getRequestDispatcher("feedback-form.jsp").forward(request, response);
        }
    }

    private void submitSupportTicket(HttpServletRequest request, HttpServletResponse response, String userId)
            throws ServletException, IOException {
        String subject = request.getParameter("subject");
        String message = request.getParameter("message");

        SupportTicket ticket = new SupportTicket(userId, subject, message);
        if (feedbackDAO.createFeedback(ticket)) {
            response.sendRedirect("feedback?action=history&success=Ticket+submitted+successfully");
        } else {
            request.setAttribute("error", "Failed to submit support ticket");
            request.getRequestDispatcher("feedback-form.jsp").forward(request, response);
        }
    }

    private void respondToTicket(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String ticketId = request.getParameter("ticketId");
        String responseText = request.getParameter("response");

        Feedback feedback = feedbackDAO.getFeedbackById(ticketId);
        if (feedback instanceof SupportTicket) {
            SupportTicket ticket = (SupportTicket) feedback;
            ticket.setResponse(responseText);

            if (feedbackDAO.updateFeedback(ticket)) {
                response.sendRedirect("feedback?action=view-ticket&id=" + ticketId + "&success=Response+submitted");
            } else {
                response.sendRedirect("feedback?action=view-ticket&id=" + ticketId + "&error=Failed+to+submit+response");
            }
        } else {
            response.sendRedirect("feedback?action=manage&error=Invalid+ticket");
        }
    }

    private void deleteFeedback(HttpServletRequest request, HttpServletResponse response, String userId)
            throws ServletException, IOException {
        String feedbackId = request.getParameter("id");
        Feedback feedback = feedbackDAO.getFeedbackById(feedbackId);

        if (feedback != null && feedback.getUserId().equals(userId)) {
            if (feedbackDAO.deleteFeedback(feedbackId)) {
                response.sendRedirect("feedback?action=history&success=Feedback+deleted+successfully");
            } else {
                response.sendRedirect("feedback?action=history&error=Failed+to+delete+feedback");
            }
        } else {
            response.sendRedirect("feedback?action=history&error=Unauthorized+access");
        }
    }
}