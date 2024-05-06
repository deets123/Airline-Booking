<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html>
<html>
<head>
    <title>Manage Reservations</title>
    <script>
        function showForm(action) {
            document.getElementById('addForm').style.display = action === 'add' ? 'block' : 'none';
            document.getElementById('editForm').style.display = action === 'edit' ? 'block' : 'none';
        }
    </script>
</head>
<body>
    <h1>Manage Flight Reservations</h1>
    
    <form action="ManageReservations.jsp" method="post">
        <select name="action" onchange="showForm(this.value)">
            <option value="add">Add Reservation</option>
            <option value="edit">Edit Reservation</option>
        </select>
    </form>

    <!-- Add Reservation Form -->
<div id="addForm" style="display:none;">
    <h2>Add Reservation</h2>
    <form action="ManageReservations.jsp" method="post">
        <input type="hidden" name="action" value="add">
        Customer ID: <input type="number" name="customerId" required><br>
        Flight ID: <input type="number" name="flightId" required><br>
        Seat Number: <input type="text" name="seatNum" required><br>
        Class: <select name="class">
            <option value="Economy">Economy</option>
            <option value="Business">Business</option>
            <option value="First Class">First Class</option>
        </select><br>
        Total Fare: <input type="number" name="totalFare" step="0.01" required><br>
        Booking Fee: <input type="number" name="bookingFee" step="0.01" required><br>
        Change Fee: <input type="number" name="changeFee" step="0.01" required><br> 
        <input type="submit" value="Add Reservation">
    </form>
</div>

    <!-- Edit Reservation Form -->
    <div id="editForm" style="display:none;">
        <h2>Edit Reservation</h2>
        <form action="ManageReservations.jsp" method="post">
            <input type="hidden" name="action" value="edit">
            Reservation ID: <input type="number" name="reservationId" required><br>
        	Flight ID: <input type="number" name="flightId" required><br>
        	Seat Number: <input type="text" name="seatNum" required><br>
        	Class: <select name="class">
            	<option value="Economy">Economy</option>
            	<option value="Business">Business</option>
           	 	<option value="First Class">First Class</option>
        	</select><br>
        	Total Fare: <input type="number" name="totalFare" step="0.01" required><br>
        	Booking Fee: <input type="number" name="bookingFee" step="0.01" required><br> 
        	Change Fee: <input type="number" name="changeFee" step="0.01" required><br> 
        	<input type="submit" value="Update Reservation">
        </form>
    </div>

    <%
        String action = request.getParameter("action");
        if(action != null) {
            Connection conn = null;
            PreparedStatement pstmt = null;

            try {
                Class.forName("com.mysql.jdbc.Driver");
                conn = DriverManager.getConnection("jdbc:mysql://localhost/cs336Project", "root", "Aditya123$");

                if ("add".equals(action)) {
                    int customerId = Integer.parseInt(request.getParameter("customerId"));
                    int flightId = Integer.parseInt(request.getParameter("flightId"));
                    String seatNum = request.getParameter("seatNum");
                    String flightClass = request.getParameter("class");
                    float totalFare = Float.parseFloat(request.getParameter("totalFare"));
                    float bookingFee = Float.parseFloat(request.getParameter("bookingFee"));
                    float changeFee = Float.parseFloat(request.getParameter("changeFee"));

                    ResultSet rs = null;
                    try {
                        conn.setAutoCommit(false);

                        // Check if customer exists
                        String checkCustomerSql = "SELECT COUNT(*) FROM Customer WHERE customerID = ?";
                        pstmt = conn.prepareStatement(checkCustomerSql);
                        pstmt.setInt(1, customerId);
                        rs = pstmt.executeQuery();
                        if (rs.next() && rs.getInt(1) == 0) {
                            out.println("<p>Error: Customer with ID " + customerId + " does not exist.</p>");
                        } else {
                            // Insert a new ticket with the specified tid
                            ResultSet rs1 = null;
                            String insertTicketSql = "INSERT INTO Ticket (customerID, seatNum, TotalFare, bookingFee, purchaseDate, purchaseTime) VALUES (?, ?, ?, ?, NOW(), NOW())";
                            pstmt = conn.prepareStatement(insertTicketSql, Statement.RETURN_GENERATED_KEYS);
                            pstmt.setInt(1, customerId);
                            pstmt.setString(2, seatNum);
                            pstmt.setFloat(3, totalFare);
                            pstmt.setFloat(4, bookingFee);
                            pstmt.executeUpdate();
                            
                            ResultSet ticketRs = pstmt.getGeneratedKeys();
                            int newTicketId = 0;
                            if (ticketRs.next()) {
                                newTicketId = ticketRs.getInt(1);
                            }
                            
                            String ticketTypeSql = "INSERT INTO TicketType (tid, changeFee, class) VALUES (?, ?, ?)";
                            pstmt = conn.prepareStatement(ticketTypeSql);
                            pstmt.setInt(1, newTicketId);
                            pstmt.setFloat(2, changeFee);
                            pstmt.setString(3, flightClass);
                            pstmt.executeUpdate();
                            
                            // Associate ticket with a flight
                            String associateSql = "INSERT INTO AssociatedWith (Fid, tid) VALUES (?, ?)";
                            pstmt = conn.prepareStatement(associateSql);
                            pstmt.setInt(1, flightId);
                            pstmt.setInt(2, newTicketId);
                            pstmt.executeUpdate();
                            
                            String updateSeatsSql = "UPDATE Flight SET num_of_seat = num_of_seat - 1 WHERE Fid = ?";
                            pstmt = conn.prepareStatement(updateSeatsSql);
                            pstmt.setInt(1, flightId);
                            pstmt.executeUpdate();

                            // Commit transaction
                            conn.commit();
                        }
                    } catch (SQLException e) {
                        if (conn != null) {
                            try {
                                conn.rollback();
                            } catch (SQLException ex) {
                                out.println("<p>Error rolling back: " + ex.getMessage() + "</p>");
                            }
                        }
                        out.println("<p>Error: " + e.getMessage() + "</p>");
                    } finally {
                        if (rs != null) try { rs.close(); } catch (SQLException e) { }
                        if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { }
                        if (conn != null) try { conn.close(); } catch (SQLException e) { }
                        if (conn != null) try { conn.setAutoCommit(true); } catch (SQLException e) { }
                    }
                } else if ("edit".equals(action)) {
                    int tid = Integer.parseInt(request.getParameter("reservationId"));
                    String seatNum = request.getParameter("seatNum");
                    String flightClass = request.getParameter("class"); // This may not be used depending on your schema
                    float totalFare = Float.parseFloat(request.getParameter("totalFare")) + Float.parseFloat(request.getParameter("changeFee"));
                    float bookingFee = Float.parseFloat(request.getParameter("bookingFee"));

                    try {
                        conn.setAutoCommit(false);

                        // Update the ticket details
                        String updateTicketSql = "UPDATE Ticket SET seatNum = ?, TotalFare = ?, bookingFee = ? WHERE tid = ?";
                        pstmt = conn.prepareStatement(updateTicketSql);
                        pstmt.setString(1, seatNum);
                        pstmt.setFloat(2, totalFare);
                        pstmt.setFloat(3, bookingFee);
                        pstmt.setInt(4, tid);
                        pstmt.executeUpdate();
                        
                        int newFlightId = Integer.parseInt(request.getParameter("flightId"));


                     	// Check if the flight ID associated with the ticket has changed
                        String checkFlightSql = "SELECT Fid FROM AssociatedWith WHERE tid = ?";
                        pstmt = conn.prepareStatement(checkFlightSql);
                        pstmt.setInt(1, tid);
                        ResultSet rs = pstmt.executeQuery();
                        if (rs.next()) {
                            int currentFlightId = rs.getInt("Fid");
                            if (currentFlightId != newFlightId) {
                                // Update the AssociatedWith table
                                String updateAssociatedSql = "UPDATE AssociatedWith SET Fid = ? WHERE tid = ?";
                                pstmt = conn.prepareStatement(updateAssociatedSql);
                                pstmt.setInt(1, newFlightId);
                                pstmt.setInt(2, tid);
                                pstmt.executeUpdate();
                            }
                        }

                        conn.commit();
                    } catch (Exception e) {
                        if (conn != null) {
                            try {
                                conn.rollback();
                            } catch (SQLException ex) {
                                out.println("<p>Error rolling back: " + ex.getMessage() + "</p>");
                            }
                        }
                        out.println("<p>Error: " + e.getMessage() + "</p>");
                    } finally {
                        if (conn != null) try { conn.setAutoCommit(true); } catch (SQLException e) { }
                        if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { }
                        if (conn != null) try { conn.close(); } catch (SQLException e) { }
                    }
                }
            } catch (Exception e) {
                out.println("<p>Error: " + e.getMessage() + "</p>");
            } finally {
                try { if (pstmt != null) pstmt.close(); } catch (Exception e) {}
                try { if (conn != null) conn.close(); } catch (Exception e) {}
            }
        }
    %>
</body>
</html>
