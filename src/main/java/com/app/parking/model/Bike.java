package com.app.parking.model;

public class Bike extends Vehicle{
    public Bike(String licensePlate, String ownerId) {
        super(licensePlate, ownerId);
        this.type = "Bike";
    }

    public Bike(String vehicleId, String licensePlate, String ownerId) {
        super(vehicleId, licensePlate, ownerId);
        this.type = "Bike";
    }
}
