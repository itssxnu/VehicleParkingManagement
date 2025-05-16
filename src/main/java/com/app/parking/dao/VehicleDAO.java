package com.app.parking.dao;

import com.app.parking.model.Vehicle;
import java.io.*;
import java.nio.file.*;
import java.util.*;

public class VehicleDAO {
    private static final String FILE_PATH = "src/main/resources/data/vehicles.txt";

    static {
        try {
            Files.createDirectories(Paths.get("src/main/resources/data"));
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    // Create a new vehicle
    public boolean createVehicle(Vehicle vehicle) {
        try (BufferedWriter writer = new BufferedWriter(new FileWriter(FILE_PATH, true))) {
            writer.write(vehicle.toString());
            writer.newLine();
            return true;
        } catch (IOException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Get all vehicles
    public List<Vehicle> getAllVehicles() {
        List<Vehicle> vehicles = new ArrayList<>();
        try (BufferedReader reader = new BufferedReader(new FileReader(FILE_PATH))) {
            String line;
            while ((line = reader.readLine()) != null) {
                Vehicle vehicle = Vehicle.fromString(line);
                if (vehicle != null) {
                    vehicles.add(vehicle);
                }
            }
        } catch (IOException e) {
            // File may not exist yet
        }
        return vehicles;
    }

    // Get vehicle by ID
    public Vehicle getVehicleById(String id) {
        return getAllVehicles().stream()
                .filter(v -> v.getVehicleId().equals(id))
                .findFirst()
                .orElse(null);
    }

    // Update vehicle
    public boolean updateVehicle(Vehicle updatedVehicle) {
        List<Vehicle> vehicles = getAllVehicles();
        boolean found = false;

        for (int i = 0; i < vehicles.size(); i++) {
            if (vehicles.get(i).getVehicleId().equals(updatedVehicle.getVehicleId())) {
                vehicles.set(i, updatedVehicle);
                found = true;
                break;
            }
        }

        if (found) {
            return saveAllVehicles(vehicles);
        }
        return false;
    }

    // Delete vehicle
    public boolean deleteVehicle(String id) {
        List<Vehicle> vehicles = getAllVehicles();
        boolean removed = vehicles.removeIf(v -> v.getVehicleId().equals(id));

        if (removed) {
            return saveAllVehicles(vehicles);
        }
        return false;
    }

    private boolean saveAllVehicles(List<Vehicle> vehicles) {
        try (BufferedWriter writer = new BufferedWriter(new FileWriter(FILE_PATH))) {
            for (Vehicle v : vehicles) {
                writer.write(v.toString());
                writer.newLine();
            }
            return true;
        } catch (IOException e) {
            e.printStackTrace();
            return false;
        }
    }
}