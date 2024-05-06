<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html>
<html>
<head>
    <title>Flight Waiting List</title>
</head>
<body>
    <h1>Flight Waiting List</h1>
    <form action="WaitingList.jsp" method="get">
        Flight ID: <input type="number" name="flightId" required><br>
        <input type="submit" value="View Waiting List">
    </form>

    <% 
        String flightId = request.getParameter("flightId");
        if (flightId != null && !flightId.trim().isEmpty()) {
            Connection conn = null;
            PreparedStatement pstmt = null;
            ResultSet rs = null;
            try {
                Class.forName("com.mysql.jdbc.Driver");
                conn = DriverManager.getConnection("jdbc:mysql://localhost/cs336Project", "root", "Aditya123$");

                String sql = "SELECT Customer.customerID, Customer.Fname, Customer.Lname FROM FlightWaitingList INNER JOIN Customer ON FlightWaitingList.customerID = Customer.customerID WHERE FlightWaitingList.Fid = ?";
                pstmt = conn.prepareStatement(sql);
                pstmt.setInt(1, Integer.parseInt(flightId));
                rs = pstmt.executeQuery();

                %><table><tr><th>Customer ID</th><th>First Name</th><th>Last Name</th></tr><%
                while (rs.next()) {
                    %><tr><td><%= rs.getInt("customerID") %></td><td><%= rs.getString("Fname") %></td><td><%= rs.getString("Lname") %></td></tr><%
                }
                %></table><%
            } catch (Exception e) {
                out.println("<p>Error: " + e.getMessage() + "</p>");
            } finally {
                try { if (rs != null) rs.close(); } catch (Exception e) {}
                try { if (pstmt != null) pstmt.close(); } catch (Exception e) {}
                try { if (conn != null) conn.close(); } catch (Exception e) {}
            }
        }
    %>
</body>
</html>
