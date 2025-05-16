package com.app.parking.model;

public class Truck extends Vehicle{
    public Truck(String licensePlate, String ownerId) {
        super(licensePlate, ownerId);
        this.type = "Truck";
    }

    public Truck(String vehicleId, String licensePlate, String ownerId) {
        super(vehicleId, licensePlate, ownerId);
        this.type = "Truck";
    }
}
