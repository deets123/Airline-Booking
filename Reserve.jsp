<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html>
<html>
<head>
    <title>Reserve Flight</title>
</head>
<body>
    <% 
    int flightId = Integer.parseInt(request.getParameter("flightId"));
    float price = Float.parseFloat(request.getParameter("price"));
    String firstName = request.getParameter("firstName");
    String lastName = request.getParameter("lastName");

    //Integer customerId = (Integer) session.getAttribute("customerID");
    int customerId = 3;
    float bookingFee = 10.0f; // Fixed booking fee
    float totalFare = price + bookingFee; // Total fare including booking fee

    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    try {
        Class.forName("com.mysql.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost/cs336Project", "root", "Aditya123$");

        // Start transaction
        conn.setAutoCommit(false);
        
        String checkCustomerSql = "SELECT COUNT(*) FROM Customer WHERE customerID = ?";
        pstmt = conn.prepareStatement(checkCustomerSql);
        pstmt.setInt(1, customerId);
        rs = pstmt.executeQuery();
        if (rs.next() && rs.getInt(1) > 0) {
            // Customer exists, update the name
            String updateCustomerSql = "UPDATE Customer SET Fname = ?, Lname = ? WHERE customerID = ?";
            pstmt = conn.prepareStatement(updateCustomerSql);
            pstmt.setString(1, firstName);
            pstmt.setString(2, lastName);
            pstmt.setInt(3, customerId);
            pstmt.executeUpdate();
        } else {
            // Customer does not exist, insert new customer
            String insertCustomerSql = "INSERT INTO Customer (customerID, Fname, Lname) VALUES (?, ?, ?)";
            pstmt = conn.prepareStatement(insertCustomerSql);
            pstmt.setInt(1, customerId);
            pstmt.setString(2, firstName);
            pstmt.setString(3, lastName);
            pstmt.executeUpdate();
        }

        // Check seat availability
        String checkSeatsSql = "SELECT num_of_seat FROM Flight WHERE Fid = ?";
        pstmt = conn.prepareStatement(checkSeatsSql);
        pstmt.setInt(1, flightId);
        rs = pstmt.executeQuery();
        int availableSeats = 0;
        if (rs.next()) {
            availableSeats = rs.getInt("num_of_seat");
        }

        if (availableSeats > 0) {
            // Create a ticket
            String createTicketSql = "INSERT INTO Ticket (customerID, purchaseDate, purchaseTime, bookingFee, TotalFare) VALUES (?, NOW(), NOW(), ?, ?)";
            pstmt = conn.prepareStatement(createTicketSql, Statement.RETURN_GENERATED_KEYS);
            pstmt.setInt(1, customerId);
            pstmt.setFloat(2, bookingFee);
            pstmt.setFloat(3, totalFare);
            int affectedRows = pstmt.executeUpdate();

            long ticketId = -1;
            if (affectedRows > 0 && (rs = pstmt.getGeneratedKeys()).next()) {
                ticketId = rs.getLong(1);

                // Update AssociatedWith table
                String associateTicketSql = "INSERT INTO AssociatedWith (Fid, tid) VALUES (?, ?)";
                pstmt = conn.prepareStatement(associateTicketSql);
                pstmt.setInt(1, flightId);
                pstmt.setLong(2, ticketId);
                pstmt.executeUpdate();

                // Decrement the number of seats
                String updateSeatsSql = "UPDATE Flight SET num_of_seat = num_of_seat - 1 WHERE Fid = ?";
                pstmt = conn.prepareStatement(updateSeatsSql);
                pstmt.setInt(1, flightId);
                pstmt.executeUpdate();

                // Commit transaction
                conn.commit();

                out.println("<p>Reservation successful! Ticket ID: " + ticketId + "</p>");
            } else {
                throw new SQLException("Creating ticket failed, no rows affected.");
            }
        } else {
            out.println("<p>Flight is full. No seats available.</p>");
        }
    } catch (Exception e) {
        out.println("<p>Error: " + e.getMessage() + "</p>");
        if (conn != null) {
            try {
                conn.rollback();
            } catch (SQLException ex) {
                out.println("<p>Error on rollback: " + ex.getMessage() + "</p>");
            }
        }
        e.printStackTrace(new PrintWriter(out));
    } finally {
        if (rs != null) try { rs.close(); } catch (Exception e) {}
        if (pstmt != null) try { pstmt.close(); } catch (Exception e) {}
        try { 
            if (conn != null) {
                conn.setAutoCommit(true);
                conn.close();
            } 
        } catch (Exception e) {}
    }
    %>
</body>
</html>
