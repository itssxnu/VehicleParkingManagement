package com.app.parking.dao;

import com.app.parking.model.User;
import com.app.parking.model.Admin;
import java.io.*;
import java.nio.file.*;
import java.util.*;
import java.util.stream.Collectors;

public class UserDAO {
    private static final String FILE_PATH = "src/main/resources/data/users.txt";
    private static final String DELIMITER = ",";

    static {
        try {
            Files.createDirectories(Paths.get("src/main/resources/data"));
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    // Create a new user
    public boolean createUser(User user) {
        try (BufferedWriter writer = new BufferedWriter(new FileWriter(FILE_PATH, true))) {
            writer.write(user.toString());
            writer.newLine();
            return true;
        } catch (IOException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Get all users
    public List<User> getAllUsers() {
        List<User> users = new ArrayList<>();
        try (BufferedReader reader = new BufferedReader(new FileReader(FILE_PATH))) {
            String line;
            while ((line = reader.readLine()) != null) {
                User user = User.fromString(line);
                if (user != null) {
                    users.add(user);
                }
            }
        } catch (IOException e) {
            // File may not exist yet
        }
        return users;
    }

    // Get user by ID
    public User getUserById(String id) {
        return getAllUsers().stream()
                .filter(user -> user.getId().equals(id))
                .findFirst()
                .orElse(null);
    }

    // Get user by username
    public User getUserByUsername(String username) {
        return getAllUsers().stream()
                .filter(user -> user.getUsername().equals(username))
                .findFirst()
                .orElse(null);
    }

    // Update user
    public boolean updateUser(User updatedUser) {
        List<User> users = getAllUsers();
        boolean found = false;

        for (int i = 0; i < users.size(); i++) {
            if (users.get(i).getId().equals(updatedUser.getId())) {
                users.set(i, updatedUser);
                found = true;
                break;
            }
        }

        if (found) {
            return saveAllUsers(users);
        }
        return false;
    }

    // Delete user
    public boolean deleteUser(String id) {
        List<User> users = getAllUsers();
        boolean removed = users.removeIf(user -> user.getId().equals(id));

        if (removed) {
            return saveAllUsers(users);
        }
        return false;
    }

    // Save all users to file (used for update and delete)
    private boolean saveAllUsers(List<User> users) {
        try (BufferedWriter writer = new BufferedWriter(new FileWriter(FILE_PATH))) {
            for (User user : users) {
                writer.write(user.toString());
                writer.newLine();
            }
            return true;
        } catch (IOException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Authenticate user
    public User authenticate(String username, String password) {
        return getAllUsers().stream()
                .filter(user -> user.getUsername().equals(username) && user.getPassword().equals(password))
                .findFirst()
                .orElse(null);
    }
}