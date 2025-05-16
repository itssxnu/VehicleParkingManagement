package com.app.parking.model;

import java.util.UUID;

public class ParkingSlot {
    private String slotId;
    private String slotNumber;
    private String type; // "Car", "Bike", "Truck"
    private boolean isOccupied;
    private String vehicleId; // null if available

    public ParkingSlot(String slotNumber, String type) {
        this.slotId = UUID.randomUUID().toString();
        this.slotNumber = slotNumber;
        this.type = type;
        this.isOccupied = false;
        this.vehicleId = null;
    }

    // For loading existing slots
    public ParkingSlot(String slotId, String slotNumber, String type, boolean isOccupied, String vehicleId) {
        this.slotId = slotId;
        this.slotNumber = slotNumber;
        this.type = type;
        this.isOccupied = isOccupied;
        this.vehicleId = vehicleId;
    }

    // Getters and Setters
    public String getSlotId() { return slotId; }
    public String getSlotNumber() { return slotNumber; }
    public String getType() { return type; }
    public boolean isOccupied() { return isOccupied; }
    public String getVehicleId() { return vehicleId; }

    public void setSlotNumber(String slotNumber) { this.slotNumber = slotNumber; }
    public void setType(String type) { this.type = type; }
    public void setOccupied(boolean occupied) { isOccupied = occupied; }
    public void setVehicleId(String vehicleId) { this.vehicleId = vehicleId; }

    @Override
    public String toString() {
        return String.join(",",
                this.slotId,
                this.slotNumber,
                this.type,
                String.valueOf(this.isOccupied),
                this.vehicleId != null ? this.vehicleId : "null"
        );
    }

    public static ParkingSlot fromString(String str) {
        String[] parts = str.split(",");
        if (parts.length != 5) return null;

        return new ParkingSlot(
                parts[0], // slotId
                parts[1], // slotNumber
                parts[2], // type
                Boolean.parseBoolean(parts[3]), // isOccupied
                "null".equals(parts[4]) ? null : parts[4] // vehicleId
        );
    }
}