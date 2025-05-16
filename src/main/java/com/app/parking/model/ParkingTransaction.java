package com.app.parking.model;

import java.time.LocalDateTime;
import java.time.Duration;
import java.util.UUID;

public class ParkingTransaction {
    private String transactionId;
    private String vehicleId;
    private String slotId;
    private LocalDateTime entryTime;
    private LocalDateTime exitTime;
    private double fee;
    private boolean isPaid;
    private String paymentMethod;

    public ParkingTransaction(String vehicleId, String slotId) {
        this.transactionId = UUID.randomUUID().toString();
        this.vehicleId = vehicleId;
        this.slotId = slotId;
        this.entryTime = LocalDateTime.now();
        this.isPaid = false;
    }

    // For loading existing transactions
    public ParkingTransaction(String transactionId, String vehicleId, String slotId,
                              LocalDateTime entryTime, LocalDateTime exitTime,
                              double fee, boolean isPaid, String paymentMethod) {
        this.transactionId = transactionId;
        this.vehicleId = vehicleId;
        this.slotId = slotId;
        this.entryTime = entryTime;
        this.exitTime = exitTime;
        this.fee = fee;
        this.isPaid = isPaid;
        this.paymentMethod = paymentMethod;
    }

    // Getters and Setters
    public String getTransactionId() { return transactionId; }
    public String getVehicleId() { return vehicleId; }
    public String getSlotId() { return slotId; }
    public LocalDateTime getEntryTime() { return entryTime; }
    public LocalDateTime getExitTime() { return exitTime; }
    public double getFee() { return fee; }
    public boolean isPaid() { return isPaid; }
    public String getPaymentMethod() { return paymentMethod; }

    public void setExitTime(LocalDateTime exitTime) { this.exitTime = exitTime; }
    public void setFee(double fee) { this.fee = fee; }
    public void setPaid(boolean paid) { isPaid = paid; }
    public void setPaymentMethod(String paymentMethod) { this.paymentMethod = paymentMethod; }

    // Calculate duration in hours
    public long getDurationHours() {
        if (exitTime == null) return 0;
        return Duration.between(entryTime, exitTime).toHours();
    }

    // Calculate fee based on duration and vehicle type
    public double calculateFee(String vehicleType) {
        if (exitTime == null) return 0;

        long hours = getDurationHours();
        double rate = switch (vehicleType) {
            case "Car" -> 5.0; // $5 per hour for cars
            case "Truck" -> 7.5; // $7.5 per hour for trucks
            case "Bike" -> 3.0; // $3 per hour for bikes
            default -> 5.0;
        };

        // Minimum charge for first hour
        if (hours < 1) hours = 1;

        this.fee = hours * rate;
        return this.fee;
    }

    @Override
    public String toString() {
        return String.join(",",
                this.transactionId,
                this.vehicleId,
                this.slotId,
                this.entryTime.toString(),
                this.exitTime != null ? this.exitTime.toString() : "null",
                String.valueOf(this.fee),
                String.valueOf(this.isPaid),
                this.paymentMethod != null ? this.paymentMethod : "null"
        );
    }

    public static ParkingTransaction fromString(String str) {
        String[] parts = str.split(",");
        if (parts.length != 8) return null;

        return new ParkingTransaction(
                parts[0], // transactionId
                parts[1], // vehicleId
                parts[2], // slotId
                LocalDateTime.parse(parts[3]), // entryTime
                "null".equals(parts[4]) ? null : LocalDateTime.parse(parts[4]), // exitTime
                Double.parseDouble(parts[5]), // fee
                Boolean.parseBoolean(parts[6]), // isPaid
                "null".equals(parts[7]) ? null : parts[7] // paymentMethod
        );
    }
}