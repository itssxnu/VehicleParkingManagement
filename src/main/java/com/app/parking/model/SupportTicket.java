package com.app.parking.model;

import java.time.LocalDateTime;

public class SupportTicket extends Feedback {
    private String response;
    private LocalDateTime responseDate;

    public SupportTicket(String userId, String subject, String message) {
        super(userId, subject, message);
    }

    // For loading existing tickets
    public SupportTicket(String feedbackId, String userId, String subject,
                         String message, LocalDateTime submissionDate,
                         boolean isResolved, String response, LocalDateTime responseDate) {
        super(feedbackId, userId, subject, message, submissionDate, isResolved);
        this.response = response;
        this.responseDate = responseDate;
    }

    // Getters and Setters
    public String getResponse() { return response; }
    public LocalDateTime getResponseDate() { return responseDate; }

    public void setResponse(String response) {
        this.response = response;
        this.responseDate = LocalDateTime.now();
        setResolved(true);
    }

    @Override
    public String toString() {
        return super.toString() + "|" +
                (response != null ? response : "null") + "|" +
                (responseDate != null ? responseDate.toString() : "null");
    }

    public static SupportTicket fromString(String str) {
        String[] parts = str.split("\\|");
        if (parts.length != 8) return null;

        return new SupportTicket(
                parts[0], // feedbackId
                parts[1], // userId
                parts[2], // subject
                parts[3], // message
                LocalDateTime.parse(parts[4]), // submissionDate
                Boolean.parseBoolean(parts[5]), // isResolved
                "null".equals(parts[6]) ? null : parts[6], // response
                "null".equals(parts[7]) ? null : LocalDateTime.parse(parts[7]) // responseDate
        );
    }
}