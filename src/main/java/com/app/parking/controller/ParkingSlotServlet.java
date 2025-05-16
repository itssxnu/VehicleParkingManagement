package com.app.parking.controller;

import com.app.parking.dao.ParkingSlotDAO;
import com.app.parking.dao.ParkingTransactionDAO;
import com.app.parking.dao.VehicleDAO;
import com.app.parking.model.ParkingSlot;
import com.app.parking.model.ParkingTransaction;
import com.app.parking.model.User;
import com.app.parking.model.Vehicle;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;
import java.time.LocalDateTime;
import java.util.List;
import java.util.stream.Collectors;

@WebServlet(name = "ParkingSlotServlet", value = "/parking-slots")
public class ParkingSlotServlet extends HttpServlet {
    private ParkingSlotDAO parkingSlotDAO;
    private VehicleDAO vehicleDAO;
    private ParkingTransactionDAO transactionDAO;

    @Override
    public void init() {
        parkingSlotDAO = new ParkingSlotDAO();
        vehicleDAO = new VehicleDAO();
        transactionDAO = new ParkingTransactionDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        String action = request.getParameter("action");

        if (action == null) {
            action = "list";
        }

        switch (action) {
            case "new":
                if (!isAdmin(user)) {
                    sendForbidden(response);
                    return;
                }
                showNewForm(request, response);
                break;
            case "edit":
                if (!isAdmin(user)) {
                    sendForbidden(response);
                    return;
                }
                showEditForm(request, response);
                break;
            case "delete":
                if (!isAdmin(user)) {
                    sendForbidden(response);
                    return;
                }
                deleteParkingSlot(request, response);
                break;
            case "assign":
                showAssignForm(request, response);
                break;
            case "release":
                releaseParkingSlot(request, response);
                break;
            case "available":
                listAvailableParkingSlots(request, response);
                break;
            case "sorted":
                listSortedParkingSlots(request, response);
                break;
            case "operator-view":
                showOperatorDashboard(request, response);
                break;
            case "sorted-view":
                showSortedParkingSlots(request, response);
                break;
            case "occupied-view":
                showOccupiedSlots(request, response);
                break;
            default:
                if (isAdmin(user)) {
                    listAllParkingSlots(request, response);
                } else {
                    showOperatorDashboard(request, response);
                }
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        String action = request.getParameter("action");

        if ("create".equals(action) || "update".equals(action) || "delete".equals(action)) {
            if (!isAdmin(user)) {
                sendForbidden(response);
                return;
            }
        }

        switch (action) {
            case "create":
                createParkingSlot(request, response);
                break;
            case "update":
                updateParkingSlot(request, response);
                break;
            case "delete":
                deleteParkingSlot(request, response);
                break;
            case "assign-vehicle":
                assignVehicleToSlot(request, response);
                break;
            case "release":
                releaseParkingSlot(request, response);
                break;
            default:
                response.sendRedirect("parking-slots");
        }
    }

    private boolean isAdmin(User user) {
        return user != null && "admin".equals(user.getRole());
    }

    private void sendForbidden(HttpServletResponse response) throws IOException {
        response.sendError(HttpServletResponse.SC_FORBIDDEN, "Admin access required");
    }

    private void listAllParkingSlots(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("parkingSlots", parkingSlotDAO.getAllParkingSlots());
        request.getRequestDispatcher("parking-slot-list.jsp").forward(request, response);
    }

    private void listAvailableParkingSlots(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("parkingSlots", parkingSlotDAO.getAvailableParkingSlots());
        request.setAttribute("availableView", true);
        request.getRequestDispatcher("parking-slot-list.jsp").forward(request, response);
    }

    private void listSortedParkingSlots(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("parkingSlots", parkingSlotDAO.getParkingSlotsSortedByAvailability());
        request.setAttribute("sortedView", true);
        request.getRequestDispatcher("parking-slot-list.jsp").forward(request, response);
    }

    private void showNewForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("parking-slot-form.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String id = request.getParameter("id");
        request.setAttribute("parkingSlot", parkingSlotDAO.getParkingSlotById(id));
        request.getRequestDispatcher("parking-slot-form.jsp").forward(request, response);
    }

    private void showAssignForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String id = request.getParameter("id");
        request.setAttribute("parkingSlot", parkingSlotDAO.getParkingSlotById(id));
        request.setAttribute("vehicles", vehicleDAO.getAllVehicles());
        request.getRequestDispatcher("assign-vehicle-form.jsp").forward(request, response);
    }

    private void createParkingSlot(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String slotNumber = request.getParameter("slotNumber");
        String type = request.getParameter("type");

        if (parkingSlotDAO.getAllParkingSlots().stream()
                .anyMatch(s -> s.getSlotNumber().equalsIgnoreCase(slotNumber))) {
            request.setAttribute("error", "Parking slot with this number already exists");
            request.getRequestDispatcher("parking-slot-form.jsp").forward(request, response);
            return;
        }

        ParkingSlot slot = new ParkingSlot(slotNumber, type);
        if (parkingSlotDAO.createParkingSlot(slot)) {
            response.sendRedirect("parking-slots");
        } else {
            request.setAttribute("error", "Failed to create parking slot");
            request.getRequestDispatcher("parking-slot-form.jsp").forward(request, response);
        }
    }

    private void updateParkingSlot(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String id = request.getParameter("id");
        ParkingSlot existingSlot = parkingSlotDAO.getParkingSlotById(id);

        if (existingSlot == null) {
            response.sendRedirect("parking-slots");
            return;
        }

        String slotNumber = request.getParameter("slotNumber");
        String type = request.getParameter("type");

        if (parkingSlotDAO.getAllParkingSlots().stream()
                .anyMatch(s -> !s.getSlotId().equals(id) &&
                        s.getSlotNumber().equalsIgnoreCase(slotNumber))) {
            request.setAttribute("error", "Slot number already in use");
            request.setAttribute("parkingSlot", existingSlot);
            request.getRequestDispatcher("parking-slot-form.jsp").forward(request, response);
            return;
        }

        existingSlot.setSlotNumber(slotNumber);
        existingSlot.setType(type);

        if (parkingSlotDAO.updateParkingSlot(existingSlot)) {
            response.sendRedirect("parking-slots");
        } else {
            request.setAttribute("error", "Failed to update parking slot");
            request.setAttribute("parkingSlot", existingSlot);
            request.getRequestDispatcher("parking-slot-form.jsp").forward(request, response);
        }
    }

    private void assignVehicleToSlot(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String slotId = request.getParameter("slotId");
        String vehicleId = request.getParameter("vehicleId");

        if (parkingSlotDAO.assignVehicleToSlot(slotId, vehicleId)) {
            createCheckinTransaction(vehicleId, slotId);
            response.sendRedirect("parking-slots?action=operator-view&success=Vehicle+assigned");
        } else {
            request.setAttribute("error", "Failed to assign vehicle");
            showOperatorDashboard(request, response);
        }
    }

    private void createCheckinTransaction(String vehicleId, String slotId) {
        ParkingTransaction transaction = new ParkingTransaction(vehicleId, slotId);
        transactionDAO.createTransaction(transaction);
    }

    private void releaseParkingSlot(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String id = request.getParameter("id");
        ParkingSlot slot = parkingSlotDAO.getParkingSlotById(id);

        if (slot != null && slot.isOccupied()) {
            vehicleDAO.deleteVehicle(slot.getVehicleId());
            parkingSlotDAO.releaseSlot(id);
            updateTransactionForRelease(id);
            response.sendRedirect("parking-slots?action=operator-view&success=Vehicle+released");
        } else {
            response.sendRedirect("parking-slots?action=operator-view&error=Release+failed");
        }
    }

    private void updateTransactionForRelease(String slotId) {
        transactionDAO.getActiveTransactions().stream()
                .filter(t -> t.getSlotId().equals(slotId))
                .findFirst()
                .ifPresent(transaction -> {
                    transaction.setExitTime(LocalDateTime.now());
                    transactionDAO.updateTransaction(transaction);
                });
    }

    private void deleteParkingSlot(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String id = request.getParameter("id");
        parkingSlotDAO.deleteParkingSlot(id);
        response.sendRedirect("parking-slots");
    }

    private void showOperatorDashboard(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("parkingSlots", parkingSlotDAO.getParkingSlotsSortedByAvailability());
        request.setAttribute("vehicles", vehicleDAO.getAllVehicles());
        passMessages(request);
        request.getRequestDispatcher("user-dashboard.jsp").forward(request, response);
    }

    private void showSortedParkingSlots(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("parkingSlots", parkingSlotDAO.getParkingSlotsSortedByAvailability());
        request.setAttribute("vehicles", vehicleDAO.getAllVehicles());
        request.setAttribute("sortedView", true);
        passMessages(request);
        request.getRequestDispatcher("user-dashboard.jsp").forward(request, response);
    }

    private void passMessages(HttpServletRequest request) {
        String success = request.getParameter("success");
        String error = request.getParameter("error");
        if (success != null) request.setAttribute("success", success);
        if (error != null) request.setAttribute("error", error);
    }

    private void showOccupiedSlots(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<ParkingSlot> allSlots = parkingSlotDAO.getAllParkingSlots();
        List<ParkingSlot> occupiedSlots = allSlots.stream()
                .filter(ParkingSlot::isOccupied)
                .collect(Collectors.toList());

        request.setAttribute("occupiedSlots", occupiedSlots);
        request.setAttribute("vehicles", vehicleDAO.getAllVehicles());
        request.getRequestDispatcher("occupied-slots.jsp").forward(request, response);
    }
}