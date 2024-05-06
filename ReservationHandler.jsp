<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html>
<html>
<head>
    <title>Manage Reservations</title>
</head>
<body>
    <h1>Book Flights</h1>
    <form action="ReservationHandler.jsp" method="get">
        Departure Airport: <input type="text" name="departureAirport" required><br>
        Arrival Airport: <input type="text" name="arrivalAirport" required><br>
        Date: <input type="date" name="date" required><br>
        Customer First Name: <input type="text" name="firstName" required><br>
		Customer Last Name: <input type="text" name="lastName" required><br>
        <input type="submit" value="Search">
    </form>
    <hr>

    <!-- Flight Search Results -->
    <% 
    String departureAirport = request.getParameter("departureAirport");
    String arrivalAirport = request.getParameter("arrivalAirport");
    String date = request.getParameter("date");
    String firstName = request.getParameter("firstName");
    String lastName = request.getParameter("lastName");

    if (departureAirport != null && arrivalAirport != null && date != null) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            Class.forName("com.mysql.jdbc.Driver");
            conn = DriverManager.getConnection("jdbc:mysql://localhost/cs336Project", "root", "Aditya123$");

            String sql = "SELECT Fid, d_time, a_time, num_of_seat, price FROM Flight WHERE dep_airport = ? AND dest_airport = ? AND Days_of_operation = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, departureAirport);
            pstmt.setString(2, arrivalAirport);
            pstmt.setDate(3, java.sql.Date.valueOf(date));
            rs = pstmt.executeQuery();

            while (rs.next()) {
                int flightId = rs.getInt("Fid");
                Time departureTime = rs.getTime("d_time");
                Time arrivalTime = rs.getTime("a_time");
                int numSeats = rs.getInt("num_of_seat");
                float price = rs.getFloat("price");

                out.println("<p>Flight ID: " + flightId + ", Departure: " + departureTime + ", Arrival: " + arrivalTime + ", Price: $" + price + "</p>");
                out.println("<form action='Reserve.jsp' method='post'>");
                out.println("<input type='hidden' name='flightId' value='" + flightId + "'>");
                out.println("<input type='hidden' name='price' value='" + price + "'>");
                out.println("<input type='hidden' name='firstName' value='" + firstName + "'>");
                out.println("<input type='hidden' name='lastName' value='" + lastName + "'>");
                out.println("<input type='submit' value='Reserve'>");
                out.println("</form>");
            }
        } catch (Exception e) {
            out.println("<p>Error: " + e.getMessage() + "</p>");
            e.printStackTrace(new PrintWriter(out));
        } finally {
            if (rs != null) try { rs.close(); } catch (Exception e) {}
            if (pstmt != null) try { pstmt.close(); } catch (Exception e) {}
            if (conn != null) try { conn.close(); } catch (Exception e) {}
        }
    }
    %>
</body>
</html>
