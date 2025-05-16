package com.app.parking.model;

import java.util.UUID;

public abstract class Vehicle {
    protected String vehicleId;
    protected String licensePlate;
    protected String ownerName; // Changed from ownerId to ownerName
    protected String type; // "Car", "Bike", "Truck"

    public Vehicle(String licensePlate, String ownerName) {
        this.vehicleId = UUID.randomUUID().toString();
        this.licensePlate = licensePlate;
        this.ownerName = ownerName;
    }

    // For loading existing vehicles
    public Vehicle(String vehicleId, String licensePlate, String ownerName) {
        this.vehicleId = vehicleId;
        this.licensePlate = licensePlate;
        this.ownerName = ownerName;
    }

    // Getters and Setters
    public String getVehicleId() { return vehicleId; }
    public String getLicensePlate() { return licensePlate; }
    public String getOwnerName() { return ownerName; }
    public String getType() { return type; }

    public void setLicensePlate(String licensePlate) { this.licensePlate = licensePlate; }
    public void setOwnerName(String ownerName) { this.ownerName = ownerName; }

    @Override
    public String toString() {
        return String.join(",",
                this.vehicleId,
                this.licensePlate,
                this.ownerName,
                this.type
        );
    }

    public static Vehicle fromString(String str) {
        String[] parts = str.split(",");
        if (parts.length != 4) return null;

        return switch (parts[3]) {
            case "Car" -> new Car(parts[0], parts[1], parts[2]);
            case "Bike" -> new Bike(parts[0], parts[1], parts[2]);
            case "Truck" -> new Truck(parts[0], parts[1], parts[2]);
            default -> null;
        };
    }
}