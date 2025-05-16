package com.app.parking.model;

public class Car extends Vehicle {
    public Car(String licensePlate, String ownerId) {
        super(licensePlate, ownerId);
        this.type = "Car";
    }

    public Car(String vehicleId, String licensePlate, String ownerId) {
        super(vehicleId, licensePlate, ownerId);
        this.type = "Car";
    }
}