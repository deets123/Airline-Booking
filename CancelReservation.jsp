<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html>
<html>
<head>
    <title>Cancel Reservation</title>
</head>
<body>
    <h1>Cancel Flight Reservation</h1>
    <form action="CancelReservation.jsp" method="post">
        Reservation ID: <input type="number" name="reservationId" required><br>
        <input type="submit" value="Cancel Reservation">
    </form>

    <%
        String reservationIdStr = request.getParameter("reservationId");
        if (reservationIdStr != null) {
            int reservationId = Integer.parseInt(reservationIdStr);
            Connection conn = null;
            PreparedStatement pstmt = null;
            ResultSet rs = null;

            try {
                Class.forName("com.mysql.jdbc.Driver");
                conn = DriverManager.getConnection("jdbc:mysql://localhost/cs336Project", "root", "Aditya123$");

                // Start transaction
                conn.setAutoCommit(false);

                // Get Flight ID and Ticket Class from reservation
				String getReservationSql = "SELECT AssociatedWith.Fid, TicketType.class FROM Ticket INNER JOIN TicketType ON Ticket.tid = TicketType.tid INNER JOIN AssociatedWith ON Ticket.tid = AssociatedWith.tid WHERE Ticket.tid = ?";
                pstmt = conn.prepareStatement(getReservationSql);
                pstmt.setInt(1, reservationId);
                rs = pstmt.executeQuery();
                int flightId = 0;
                String ticketClass = "";
                if (rs.next()) {
                    flightId = rs.getInt("Fid");
                    ticketClass = rs.getString("class");
                }

                if ("Business".equals(ticketClass) || "First Class".equals(ticketClass)) {
                	// Delete associated rows from 'TicketType' table
                	String deleteTypeSql = "DELETE FROM TicketType WHERE tid = ?";
                	pstmt = conn.prepareStatement(deleteTypeSql);
                	pstmt.setInt(1, reservationId);
                	pstmt.executeUpdate();
                	
                	// Delete associated rows from 'associatedwith' table
                	String deleteAssociatedSql = "DELETE FROM AssociatedWith WHERE tid = ?";
                	pstmt = conn.prepareStatement(deleteAssociatedSql);
                	pstmt.setInt(1, reservationId);
                	pstmt.executeUpdate();
                	
                	// Cancel the reservation
                    String deleteReservationSql = "DELETE FROM Ticket WHERE tid = ?";
                    pstmt = conn.prepareStatement(deleteReservationSql);
                    pstmt.setInt(1, reservationId);
                    pstmt.executeUpdate();

                    // Increment number of seats in the flight
                    String updateSeatsSql = "UPDATE Flight SET num_of_seat = num_of_seat + 1 WHERE Fid = ?";
                    pstmt = conn.prepareStatement(updateSeatsSql);
                    pstmt.setInt(1, flightId);
                    pstmt.executeUpdate();

                    // Check if there is anyone in the waiting list
                    String waitingListSql = "SELECT customerID FROM FlightWaitingList WHERE Fid = ? LIMIT 1";
                    pstmt = conn.prepareStatement(waitingListSql);
                    pstmt.setInt(1, flightId);
                    ResultSet waitingListRs = pstmt.executeQuery();
                    if (waitingListRs.next()) {
                        int waitingCustomerId = waitingListRs.getInt("customerID");
                        // Notify the customer in the waiting list (for demo purposes, just display a message)
                        out.println("<p>Alert: Customer with ID " + waitingCustomerId + " notified about the available seat.</p>");

                        // Remove the notified customer from the waiting list
                        String removeFromWaitingListSql = "DELETE FROM FlightWaitingList WHERE customerID = ? AND Fid = ?";
                        pstmt = conn.prepareStatement(removeFromWaitingListSql);
                        pstmt.setInt(1, waitingCustomerId);
                        pstmt.setInt(2, flightId);
                        pstmt.executeUpdate();
                    }

                    // Commit transaction
                    conn.commit();
                    out.println("<p>Reservation cancelled successfully.</p>");
                } else {
                    out.println("<p>Only Business or First Class reservations can be cancelled through this page.</p>");
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
        }
    %>
</body>
</html>
