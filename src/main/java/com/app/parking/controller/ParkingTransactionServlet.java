package com.app.parking.controller;

import com.app.parking.dao.*;
import com.app.parking.model.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;
import java.time.LocalDateTime;

@WebServlet(name = "ParkingTransactionServlet", value = "/transactions")
public class ParkingTransactionServlet extends HttpServlet {
    private ParkingTransactionDAO transactionDAO;
    private ParkingSlotDAO slotDAO;
    private VehicleDAO vehicleDAO;

    @Override
    public void init() {
        transactionDAO = new ParkingTransactionDAO();
        slotDAO = new ParkingSlotDAO();
        vehicleDAO = new VehicleDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (action == null) {
            action = "list";
        }

        // Only admin can view transaction history
        if (!"admin".equals(user.getRole())){
            response.sendRedirect("parking-slots?action=operator-view");
            return;
        }

        switch (action) {
            case "history":
                showTransactionHistory(request, response);
                break;
            default:
                showTransactionHistory(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        if ("checkout".equals(action)) {
            processCheckout(request, response);
        } else if ("complete-payment".equals(action)) {
            completePayment(request, response);
        } else {
            response.sendRedirect("parking-slots?action=operator-view");
        }
    }

    private void showTransactionHistory(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("transactions", transactionDAO.getAllTransactions());
        request.getRequestDispatcher("transaction-history.jsp").forward(request, response);
    }

    // Called when vehicle is assigned to slot
    public void createCheckinTransaction(String vehicleId, String slotId) {
        ParkingTransaction transaction = new ParkingTransaction(vehicleId, slotId);
        transactionDAO.createTransaction(transaction);
    }

    private void processCheckout(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String slotId = request.getParameter("slotId");

        // Find active transaction for this slot
        ParkingTransaction transaction = transactionDAO.getActiveTransactions().stream()
                .filter(t -> t.getSlotId().equals(slotId))
                .findFirst()
                .orElse(null);

        if (transaction == null) {
            response.sendRedirect("parking-slots?action=operator-view&error=No+active+transaction+found");
            return;
        }

        // Get vehicle for fee calculation
        Vehicle vehicle = vehicleDAO.getVehicleById(transaction.getVehicleId());
        if (vehicle == null) {
            response.sendRedirect("parking-slots?action=operator-view&error=Vehicle+not+found");
            return;
        }

        // Set exit time and calculate fee
        transaction.setExitTime(LocalDateTime.now());
        double fee = transaction.calculateFee(vehicle.getType());

        // Store in session for payment processing
        request.getSession().setAttribute("currentTransaction", transaction);

        // Forward to payment page
        request.setAttribute("fee", fee);
        request.setAttribute("vehicle", vehicle);
        request.setAttribute("slot", slotDAO.getParkingSlotById(slotId));
        request.getRequestDispatcher("payment.jsp").forward(request, response);
    }

    private void completePayment(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        ParkingTransaction transaction = (ParkingTransaction) session.getAttribute("currentTransaction");
        String paymentMethod = request.getParameter("paymentMethod");

        if (transaction == null) {
            response.sendRedirect("parking-slots?action=operator-view&error=Transaction+not+found");
            return;
        }

        // Update transaction
        transaction.setPaid(true);
        transaction.setPaymentMethod(paymentMethod);
        transactionDAO.updateTransaction(transaction);

        // Release slot and remove vehicle
        slotDAO.releaseSlot(transaction.getSlotId());
        vehicleDAO.deleteVehicle(transaction.getVehicleId());

        session.removeAttribute("currentTransaction");
        response.sendRedirect("parking-slots?action=operator-view&success=Payment+completed+and+vehicle+removed");
    }
}