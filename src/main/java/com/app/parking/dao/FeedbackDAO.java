package com.app.parking.dao;

import com.app.parking.model.Feedback;
import com.app.parking.model.SupportTicket;
import java.io.*;
import java.nio.file.*;
import java.time.LocalDateTime;
import java.util.*;
import java.util.stream.Collectors;

public class FeedbackDAO {
    private static final String FILE_PATH = "src/main/resources/data/feedback.txt";

    static {
        try {
            Files.createDirectories(Paths.get("src/main/resources/data"));
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    // Create new feedback or ticket
    public boolean createFeedback(Feedback feedback) {
        try (BufferedWriter writer = new BufferedWriter(new FileWriter(FILE_PATH, true))) {
            writer.write(feedback.toString());
            writer.newLine();
            return true;
        } catch (IOException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Get all feedback items
    public List<Feedback> getAllFeedback() {
        List<Feedback> feedbackList = new ArrayList<>();
        try (BufferedReader reader = new BufferedReader(new FileReader(FILE_PATH))) {
            String line;
            while ((line = reader.readLine()) != null) {
                Feedback feedback = parseFeedbackLine(line);
                if (feedback != null) {
                    feedbackList.add(feedback);
                }
            }
        } catch (IOException e) {
            e.printStackTrace();
            // File may not exist yet
        }
        return feedbackList;
    }

    // Get feedback by ID
    public Feedback getFeedbackById(String id) {
        return getAllFeedback().stream()
                .filter(f -> f.getFeedbackId().equals(id))
                .findFirst()
                .orElse(null);
    }

    // Get feedback by user
    public List<Feedback> getFeedbackByUser(String userId) {
        return getAllFeedback().stream()
                .filter(f -> f.getUserId().equals(userId))
                .collect(Collectors.toList());
    }

    // Get unresolved tickets
    public List<SupportTicket> getUnresolvedTickets() {
        return getAllFeedback().stream()
                .filter(f -> f instanceof SupportTicket && !f.isResolved())
                .map(f -> (SupportTicket) f)
                .collect(Collectors.toList());
    }

    // Update feedback (primarily for admin responses)
    public boolean updateFeedback(Feedback updatedFeedback) {
        List<Feedback> feedbackList = getAllFeedback();
        boolean found = false;

        for (int i = 0; i < feedbackList.size(); i++) {
            if (feedbackList.get(i).getFeedbackId().equals(updatedFeedback.getFeedbackId())) {
                feedbackList.set(i, updatedFeedback);
                found = true;
                break;
            }
        }

        if (found) {
            return saveAllFeedback(feedbackList);
        }
        return false;
    }

    private Feedback parseFeedbackLine(String line) {
        String[] parts = line.split("\\|");
        if (parts.length == 6) { // Regular feedback
            return Feedback.fromString(line);
        } else if (parts.length == 8) { // Support ticket
            return SupportTicket.fromString(line);
        }
        return null;
    }

    private boolean saveAllFeedback(List<Feedback> feedbackList) {
        try (BufferedWriter writer = new BufferedWriter(new FileWriter(FILE_PATH))) {
            for (Feedback f : feedbackList) {
                writer.write(f.toString());
                writer.newLine();
            }
            return true;
        } catch (IOException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean deleteFeedback(String feedbackId) {
        List<Feedback> feedbackList = getAllFeedback();
        boolean removed = feedbackList.removeIf(f -> f.getFeedbackId().equals(feedbackId));

        if (removed) {
            return saveAllFeedback(feedbackList);
        }
        return false;
    }
}