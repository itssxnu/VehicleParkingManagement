package com.app.parking.controller;

import com.app.parking.dao.UserDAO;
import com.app.parking.model.User;
import com.app.parking.model.Admin;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;

@WebServlet(name = "UserServlet", value = "/users")
public class UserServlet extends HttpServlet {
    private UserDAO userDAO;

    @Override
    public void init() {
        userDAO = new UserDAO();
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
                deleteUser(request, response);
                break;
            default:
                listUsers(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        if ("login".equals(action)) {
            loginUser(request, response);
        } else if ("register".equals(action)) {
            registerUser(request, response);
        } else if ("update".equals(action)) {
            updateUser(request, response);
        }
    }

    private void listUsers(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("users", userDAO.getAllUsers());
        request.getRequestDispatcher("user-list.jsp").forward(request, response);
    }

    private void showNewForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("user-form.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String id = request.getParameter("id");
        request.setAttribute("user", userDAO.getUserById(id));
        request.getRequestDispatcher("user-form.jsp").forward(request, response);
    }

    private void registerUser(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String fullName = request.getParameter("fullName");
        String contact = request.getParameter("contact");
        String role = request.getParameter("role");

        if (userDAO.getUserByUsername(username) != null) {
            request.setAttribute("error", "Username already exists");
            request.getRequestDispatcher("user-form.jsp").forward(request, response);
            return;
        }

        User user;
        if ("admin".equals(role)) {
            user = new Admin(username, password, fullName, contact);
        } else {
            user = new User(username, password, fullName, contact, "user");
        }

        if (userDAO.createUser(user)) {
            response.sendRedirect("login.jsp?registered=true");
        } else {
            request.setAttribute("error", "Failed to create user");
            request.getRequestDispatcher("user-form.jsp").forward(request, response);
        }
    }

    private void updateUser(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String id = request.getParameter("id");
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String fullName = request.getParameter("fullName");
        String contact = request.getParameter("contact");
        String role = request.getParameter("role");

        User existingUser = userDAO.getUserById(id);
        if (existingUser == null) {
            response.sendRedirect("users?action=list");
            return;
        }

        User userWithSameUsername = userDAO.getUserByUsername(username);
        if (userWithSameUsername != null && !userWithSameUsername.getId().equals(id)) {
            request.setAttribute("error", "Username already exists");
            request.setAttribute("user", existingUser);
            request.getRequestDispatcher("user-form.jsp").forward(request, response);
            return;
        }

        existingUser.setUsername(username);
        existingUser.setPassword(password);
        existingUser.setFullName(fullName);
        existingUser.setContact(contact);

        // Only update role if not admin (admins can't change their role)
        if (!"admin".equals(existingUser.getRole())) {
            existingUser.setRole(role);
        }

        if (userDAO.updateUser(existingUser)) {
            response.sendRedirect("users?action=list");
        } else {
            request.setAttribute("error", "Failed to update user");
            request.setAttribute("user", existingUser);
            request.getRequestDispatcher("user-form.jsp").forward(request, response);
        }
    }

    private void deleteUser(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String id = request.getParameter("id");
        userDAO.deleteUser(id);
        response.sendRedirect("users?action=list");
    }

    private void loginUser(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        User user = userDAO.authenticate(username, password);
        if (user != null) {
            HttpSession session = request.getSession();
            session.setAttribute("user", user);

            if ("admin".equals(user.getRole())) {
                response.sendRedirect("admin-dashboard.jsp");
            } else {
                response.sendRedirect("parking-slots?action=operator-view");
            }
        } else {
            request.setAttribute("error", "Invalid username or password");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }
}