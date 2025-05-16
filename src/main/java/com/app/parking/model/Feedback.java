package com.app.parking.model;

import java.time.LocalDateTime;
import java.util.UUID;

public class Feedback {
    private String feedbackId;
    private String userId;
    private String subject;
    private String message;
    private LocalDateTime submissionDate;
    private boolean isResolved;

    public Feedback(String userId, String subject, String message) {
        this.feedbackId = UUID.randomUUID().toString();
        this.userId = userId;
        this.subject = subject;
        this.message = message;
        this.submissionDate = LocalDateTime.now();
        this.isResolved = false;
    }

    // For loading existing feedback
    public Feedback(String feedbackId, String userId, String subject,
                    String message, LocalDateTime submissionDate, boolean isResolved) {
        this.feedbackId = feedbackId;
        this.userId = userId;
        this.subject = subject;
        this.message = message;
        this.submissionDate = submissionDate;
        this.isResolved = isResolved;
    }

    // Getters and Setters
    public String getFeedbackId() { return feedbackId; }
    public String getUserId() { return userId; }
    public String getSubject() { return subject; }
    public String getMessage() { return message; }
    public LocalDateTime getSubmissionDate() { return submissionDate; }
    public boolean isResolved() { return isResolved; }

    public void setResolved(boolean resolved) { isResolved = resolved; }

    @Override
    public String toString() {
        return String.join("|",
                this.feedbackId,
                this.userId,
                this.subject,
                this.message,
                this.submissionDate.toString(),
                String.valueOf(this.isResolved)
        );
    }

    public static Feedback fromString(String str) {
        String[] parts = str.split("\\|");
        if (parts.length != 6) return null;

        return new Feedback(
                parts[0], // feedbackId
                parts[1], // userId
                parts[2], // subject
                parts[3], // message
                LocalDateTime.parse(parts[4]), // submissionDate
                Boolean.parseBoolean(parts[5]) // isResolved
        );
    }
}