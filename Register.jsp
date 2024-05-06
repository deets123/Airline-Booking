<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="javax.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <title>Registration</title>
</head>
<body>
    <h2>User Registration</h2>
    <form method="POST" action="Register.jsp">
        Username: <input type="text" name="username"><br>
        Password: <input type="password" name="password"><br>
        First Name: <input type="text" name="fname" required><br>
    	Last Name: <input type="text" name="lname" required><br>
        User Type: 
        <select name="userType">
            <option value="customer">Customer</option>
            <option value="admin">Admin</option>
            <option value="customer_rep">Customer Representative</option>
        </select><br>
        <input type="submit" value="Register">
    </form>

    <%
        if (request.getMethod().equals("POST")) {
            String username = request.getParameter("username");
            String password = request.getParameter("password");
            String userType = request.getParameter("userType");
            String fname = request.getParameter("fname");
            String lname = request.getParameter("lname");

            // JDBC connection
            Connection conn = null;
            PreparedStatement pstmt = null;
            try {
                // Load the JDBC driver
                Class.forName("com.mysql.jdbc.Driver");

                // Establish a connection
                conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/cs336Project", "root", "Aditya123$");

                // Create SQL query
                String sql = "INSERT INTO User (username, password, userType) VALUES (?, ?, ?)";
                pstmt = conn.prepareStatement(sql);
                pstmt.setString(1, username);
                pstmt.setString(2, password);
                pstmt.setString(3, userType);
                
                if ("customer".equals(userType)) {
                    String sqlCustomer = "INSERT INTO Customer (Fname, Lname) VALUES (?, ?)";
                    pstmt = conn.prepareStatement(sqlCustomer);
                    pstmt.setString(1, fname);
                    pstmt.setString(2, lname);
                    pstmt.executeUpdate();
                }
                else if ("customer_rep".equals(userType)) {
                    String sqlCustomer = "INSERT INTO CustomerRepresentative (Fname, Lname) VALUES (?, ?)";
                    pstmt = conn.prepareStatement(sqlCustomer);
                    pstmt.setString(1, fname);
                    pstmt.setString(2, lname);
                    pstmt.executeUpdate();
                }

                // Execute update
                pstmt.executeUpdate();
                out.println("<p>Registration successful!</p>");
            } catch (Exception e) {
                out.println("<p>Error: " + e.getMessage() + "</p>");
            } finally {
                // Clean-up environment
                if (pstmt != null) try { pstmt.close(); } catch (SQLException se2) { }
                if (conn != null) try { conn.close(); } catch (SQLException se) { }
            }
        }
    %>
</body>
</html>