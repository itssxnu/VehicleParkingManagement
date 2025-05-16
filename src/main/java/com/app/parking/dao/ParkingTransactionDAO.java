package com.app.parking.dao;

import com.app.parking.model.ParkingTransaction;
import java.io.*;
import java.nio.file.*;
import java.time.LocalDateTime;
import java.util.*;
import java.util.stream.Collectors;

public class ParkingTransactionDAO {
    private static final String FILE_PATH = "src/main/resources/data/transactions.txt";

    static {
        try {
            Files.createDirectories(Paths.get("src/main/resources/data"));
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    // Create a new transaction
    public boolean createTransaction(ParkingTransaction transaction) {
        try (BufferedWriter writer = new BufferedWriter(new FileWriter(FILE_PATH, true))) {
            writer.write(transaction.toString());
            writer.newLine();
            return true;
        } catch (IOException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Get all transactions
    public List<ParkingTransaction> getAllTransactions() {
        List<ParkingTransaction> transactions = new ArrayList<>();
        try (BufferedReader reader = new BufferedReader(new FileReader(FILE_PATH))) {
            String line;
            while ((line = reader.readLine()) != null) {
                ParkingTransaction transaction = ParkingTransaction.fromString(line);
                if (transaction != null) {
                    transactions.add(transaction);
                }
            }
        } catch (IOException e) {
            // File may not exist yet
        }
        return transactions;
    }

    // Get transaction by ID
    public ParkingTransaction getTransactionById(String id) {
        return getAllTransactions().stream()
                .filter(t -> t.getTransactionId().equals(id))
                .findFirst()
                .orElse(null);
    }

    // Get active transactions (no exit time)
    public List<ParkingTransaction> getActiveTransactions() {
        return getAllTransactions().stream()
                .filter(t -> t.getExitTime() == null)
                .collect(Collectors.toList());
    }

    // Get transactions by vehicle
    public List<ParkingTransaction> getTransactionsByVehicle(String vehicleId) {
        return getAllTransactions().stream()
                .filter(t -> t.getVehicleId().equals(vehicleId))
                .collect(Collectors.toList());
    }

    // Update transaction
    public boolean updateTransaction(ParkingTransaction updatedTransaction) {
        List<ParkingTransaction> transactions = getAllTransactions();
        boolean found = false;

        for (int i = 0; i < transactions.size(); i++) {
            if (transactions.get(i).getTransactionId().equals(updatedTransaction.getTransactionId())) {
                transactions.set(i, updatedTransaction);
                found = true;
                break;
            }
        }

        if (found) {
            return saveAllTransactions(transactions);
        }
        return false;
    }

    private boolean saveAllTransactions(List<ParkingTransaction> transactions) {
        try (BufferedWriter writer = new BufferedWriter(new FileWriter(FILE_PATH))) {
            for (ParkingTransaction t : transactions) {
                writer.write(t.toString());
                writer.newLine();
            }
            return true;
        } catch (IOException e) {
            e.printStackTrace();
            return false;
        }
    }


}