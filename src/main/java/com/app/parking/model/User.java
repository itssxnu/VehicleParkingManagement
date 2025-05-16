package com.app.parking.model;

import java.util.UUID;

public class User {
    protected String id;
    protected String username;
    protected String password;
    protected String fullName;
    protected String contact;
    protected String role; // "user" or "admin"

    public User(String username, String password, String fullName, String contact, String role) {
        this.id = UUID.randomUUID().toString();
        this.username = username;
        this.password = password;
        this.fullName = fullName;
        this.contact = contact;
        this.role = role;
    }

    public User(String id, String username, String password, String fullName, String contact, String role) {
        this.id = id;
        this.username = username;
        this.password = password;
        this.fullName = fullName;
        this.contact = contact;
        this.role = role;
    }

    public String getId() {
        return id;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getContact() {
        return contact;
    }

    public void setContact(String contact) {
        this.contact = contact;
    }

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }

    @Override
    public String toString() {
        return String.join(",",
                this.id,
                this.username,
                this.password,
                this.fullName,
                this.contact,
                this.role
        );
    }

    public static User fromString(String str) {
        String[] parts = str.split(",");
        if (parts.length != 6) return null;

        return new User(
                parts[0], // id
                parts[1], // username
                parts[2], // password
                parts[3], // fullName
                parts[4], // contact
                parts[5]  // role
        );
    }
}
