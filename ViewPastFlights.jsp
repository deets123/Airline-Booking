<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<!DOCTYPE html>
<html>
<head>
    <title>Past Flight Reservations</title>
</head>
<body>
    <h1>Past Flight Reservations</h1>
    <table border="1">
        <tr>
            <th>Reservation ID</th>
            <th>Customer Name</th>
            <th>Flight ID</th>
            <th>Departure Time</th>
            <th>Arrival Time</th>
            <th>Departure Airport</th>
            <th>Destination Airport</th>
            <th>Reservation Date</th>
            <th>Total Fare</th>
        </tr>
        <% 
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            Class.forName("com.mysql.jdbc.Driver");
            conn = DriverManager.getConnection("jdbc:mysql://localhost/cs336Project", "root", "Aditya123$");

            String sql = "SELECT Ticket.tid, Customer.Fname, Customer.Lname, Flight.Fid, Flight.d_time, Flight.a_time, Flight.dep_airport, Flight.dest_airport, Ticket.purchaseDate, Ticket.TotalFare FROM Ticket JOIN Customer ON Ticket.customerID = Customer.customerID JOIN AssociatedWith ON Ticket.tid = AssociatedWith.tid JOIN Flight ON AssociatedWith.Fid = Flight.Fid WHERE Flight.Days_of_operation < CURDATE()";
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();

            while (rs.next()) {
                out.println("<tr>");
                out.println("<td>" + rs.getInt("tid") + "</td>");
                out.println("<td>" + rs.getString("Fname") + " " + rs.getString("Lname") + "</td>");
                out.println("<td>" + rs.getInt("Fid") + "</td>");
                out.println("<td>" + rs.getTime("d_time") + "</td>");
                out.println("<td>" + rs.getTime("a_time") + "</td>");
                out.println("<td>" + rs.getString("dep_airport") + "</td>");
                out.println("<td>" + rs.getString("dest_airport") + "</td>");
                out.println("<td>" + rs.getDate("purchaseDate") + "</td>");
                out.println("<td>" + rs.getFloat("TotalFare") + "</td>");
                // Add more data fields as needed
                out.println("</tr>");
            }
        } catch (Exception e) {
            out.println("<p>Error: " + e.getMessage() + "</p>");
            e.printStackTrace(new PrintWriter(out));
        } finally {
            if (rs != null) try { rs.close(); } catch (Exception e) {}
            if (pstmt != null) try { pstmt.close(); } catch (Exception e) {}
            if (conn != null) try { conn.close(); } catch (Exception e) {}
        }
        %>
    </table>
</body>
</html>
