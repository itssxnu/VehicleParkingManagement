package com.app.parking.util;

import com.app.parking.model.User;
import com.app.parking.model.Admin;
import java.util.*;
import java.io.*;

public class UserUtil {
    private static final String FILE_PATH = "data/parking/users.txt";

    public static void createUser(User user) throws IOException {
        BufferedWriter bw = new BufferedWriter(new FileWriter(FILE_PATH, true));
        bw.write(String.join(",", user.getUsername(), user.getPassword(), user.getFullName(),
                user.getContact(), user.getRole()));
        bw.newLine();
        bw.close();
    }

    public static User getUserByUsername(String username) throws IOException {
        BufferedReader br = new BufferedReader(new FileReader(FILE_PATH));
        String line;
        while ((line = br.readLine()) != null) {
            String[] parts = line.split(",");
            if (parts[0].equals(username)) {
                String role = parts[4];
                br.close();
                if (role.equals("admin")) {
                    return new Admin(parts[0], parts[1], parts[2], parts[3]);
                } else {
                    return new User(parts[0], parts[1], parts[2], parts[3], parts[4]);
                }
            }
        }
        br.close();
        return null;
    }

    // Update, delete, getAllUsersByRole, etc. can follow similar logic
}
