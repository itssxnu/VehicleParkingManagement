package com.app.parking.controller;

import com.app.parking.dao.VehicleDAO;
import com.app.parking.model.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;

@WebServlet(name = "VehicleServlet", value = "/vehicles")
public class VehicleServlet extends HttpServlet {
    private VehicleDAO vehicleDAO;

    @Override
    public void init() {
        vehicleDAO = new VehicleDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        if (action == null) {
            action = "list";
        }

        switch (action) {
            case "new":
                showNewForm(request, response);
                break;
            case "edit":
                showEditForm(request, response);
                break;
            case "delete":
                deleteVehicle(request, response);
                break;
            default:
                listAllVehicles(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        if ("create".equals(action)) {
            createVehicle(request, response);
        } else if ("update".equals(action)) {
            updateVehicle(request, response);
        }
    }

    private void listAllVehicles(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("vehicles", vehicleDAO.getAllVehicles());
        request.getRequestDispatcher("vehicle-list.jsp").forward(request, response);
    }

    private void showNewForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("vehicle-form.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String id = request.getParameter("id");
        request.setAttribute("vehicle", vehicleDAO.getVehicleById(id));
        request.getRequestDispatcher("vehicle-form.jsp").forward(request, response);
    }

    private void createVehicle(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String licensePlate = request.getParameter("licensePlate");
        String ownerName = request.getParameter("ownerName");
        String type = request.getParameter("type");

        // Check if vehicle already exists
        boolean exists = vehicleDAO.getAllVehicles().stream()
                .anyMatch(v -> v.getLicensePlate().equalsIgnoreCase(licensePlate));

        if (exists) {
            request.setAttribute("error", "Vehicle with this license plate already exists");
            request.getRequestDispatcher("vehicle-form.jsp").forward(request, response);
            return;
        }

        Vehicle vehicle = switch (type) {
            case "Car" -> new Car(licensePlate, ownerName);
            case "Bike" -> new Bike(licensePlate, ownerName);
            case "Truck" -> new Truck(licensePlate, ownerName);
            default -> null;
        };

        if (vehicle != null && vehicleDAO.createVehicle(vehicle)) {
            response.sendRedirect("vehicles");
        } else {
            request.setAttribute("error", "Failed to create vehicle");
            request.getRequestDispatcher("vehicle-form.jsp").forward(request, response);
        }
    }

    private void updateVehicle(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String id = request.getParameter("id");
        String licensePlate = request.getParameter("licensePlate");
        String ownerName = request.getParameter("ownerName");

        Vehicle existingVehicle = vehicleDAO.getVehicleById(id);
        if (existingVehicle == null) {
            response.sendRedirect("vehicles");
            return;
        }

        // Check if new license plate is already taken by another vehicle
        boolean plateTaken = vehicleDAO.getAllVehicles().stream()
                .anyMatch(v -> !v.getVehicleId().equals(id) &&
                        v.getLicensePlate().equalsIgnoreCase(licensePlate));

        if (plateTaken) {
            request.setAttribute("error", "License plate already in use by another vehicle");
            request.setAttribute("vehicle", existingVehicle);
            request.getRequestDispatcher("vehicle-form.jsp").forward(request, response);
            return;
        }

        existingVehicle.setLicensePlate(licensePlate);
        existingVehicle.setOwnerName(ownerName);

        if (vehicleDAO.updateVehicle(existingVehicle)) {
            response.sendRedirect("vehicles");
        } else {
            request.setAttribute("error", "Failed to update vehicle");
            request.setAttribute("vehicle", existingVehicle);
            request.getRequestDispatcher("vehicle-form.jsp").forward(request, response);
        }
    }

    private void deleteVehicle(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String id = request.getParameter("id");
        vehicleDAO.deleteVehicle(id);
        response.sendRedirect("vehicles");
    }
}