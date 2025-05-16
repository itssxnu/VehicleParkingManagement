package com.app.parking.dao;

import com.app.parking.model.ParkingSlot;
import java.io.*;
import java.nio.file.*;
import java.util.*;
import java.util.stream.Collectors;

public class ParkingSlotDAO {
    private static final String FILE_PATH = "src/main/resources/data/parking_slots.txt";

    static {
        try {
            Files.createDirectories(Paths.get("src/main/resources/data"));
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    // Create a new parking slot
    public boolean createParkingSlot(ParkingSlot slot) {
        try (BufferedWriter writer = new BufferedWriter(new FileWriter(FILE_PATH, true))) {
            writer.write(slot.toString());
            writer.newLine();
            return true;
        } catch (IOException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Get all parking slots
    public List<ParkingSlot> getAllParkingSlots() {
        List<ParkingSlot> slots = new ArrayList<>();
        try (BufferedReader reader = new BufferedReader(new FileReader(FILE_PATH))) {
            String line;
            while ((line = reader.readLine()) != null) {
                ParkingSlot slot = ParkingSlot.fromString(line);
                if (slot != null) {
                    slots.add(slot);
                }
            }
        } catch (IOException e) {
            // File may not exist yet
        }
        return slots;
    }

    // Get parking slot by ID
    public ParkingSlot getParkingSlotById(String id) {
        return getAllParkingSlots().stream()
                .filter(s -> s.getSlotId().equals(id))
                .findFirst()
                .orElse(null);
    }

    // Get available parking slots
    public List<ParkingSlot> getAvailableParkingSlots() {
        return getAllParkingSlots().stream()
                .filter(s -> !s.isOccupied())
                .collect(Collectors.toList());
    }

    // Get available parking slots by type
    public List<ParkingSlot> getAvailableParkingSlotsByType(String type) {
        return getAllParkingSlots().stream()
                .filter(s -> !s.isOccupied() && s.getType().equals(type))
                .collect(Collectors.toList());
    }

    // Sort parking slots by availability using Quick Sort
    public List<ParkingSlot> getParkingSlotsSortedByAvailability() {
        List<ParkingSlot> slots = getAllParkingSlots();
        quickSort(slots, 0, slots.size() - 1);
        return slots;
    }

    private void quickSort(List<ParkingSlot> slots, int low, int high) {
        if (low < high) {
            int pi = partition(slots, low, high);
            quickSort(slots, low, pi - 1);
            quickSort(slots, pi + 1, high);
        }
    }

    private int partition(List<ParkingSlot> slots, int low, int high) {
        // Pivot is availability (false comes before true)
        boolean pivot = slots.get(high).isOccupied();
        int i = low - 1;

        for (int j = low; j < high; j++) {
            if (!slots.get(j).isOccupied() ||
                    (slots.get(j).isOccupied() == pivot &&
                            slots.get(j).getSlotNumber().compareTo(slots.get(high).getSlotNumber()) < 0)) {
                i++;
                Collections.swap(slots, i, j);
            }
        }
        Collections.swap(slots, i + 1, high);
        return i + 1;
    }

    // Assign vehicle to slot
    public boolean assignVehicleToSlot(String slotId, String vehicleId) {
        ParkingSlot slot = getParkingSlotById(slotId);
        if (slot == null || slot.isOccupied()) return false;

        slot.setOccupied(true);
        slot.setVehicleId(vehicleId);
        return updateParkingSlot(slot);
    }

    // Release vehicle from slot
    public boolean releaseSlot(String slotId) {
        ParkingSlot slot = getParkingSlotById(slotId);
        if (slot == null || !slot.isOccupied()) return false;

        slot.setOccupied(false);
        slot.setVehicleId(null);
        return updateParkingSlot(slot);
    }

    // Update parking slot
    public boolean updateParkingSlot(ParkingSlot updatedSlot) {
        List<ParkingSlot> slots = getAllParkingSlots();
        boolean found = false;

        for (int i = 0; i < slots.size(); i++) {
            if (slots.get(i).getSlotId().equals(updatedSlot.getSlotId())) {
                slots.set(i, updatedSlot);
                found = true;
                break;
            }
        }

        if (found) {
            return saveAllParkingSlots(slots);
        }
        return false;
    }

    // Delete parking slot
    public boolean deleteParkingSlot(String id) {
        List<ParkingSlot> slots = getAllParkingSlots();
        boolean removed = slots.removeIf(s -> s.getSlotId().equals(id));

        if (removed) {
            return saveAllParkingSlots(slots);
        }
        return false;
    }

    private boolean saveAllParkingSlots(List<ParkingSlot> slots) {
        try (BufferedWriter writer = new BufferedWriter(new FileWriter(FILE_PATH))) {
            for (ParkingSlot s : slots) {
                writer.write(s.toString());
                writer.newLine();
            }
            return true;
        } catch (IOException e) {
            e.printStackTrace();
            return false;
        }
    }
}