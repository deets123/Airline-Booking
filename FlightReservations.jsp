<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html>
<html>
<head>
    <title>Flight Reservations</title>
</head>
<body>
    <h1>Flight Reservations</h1>

    <% 
        HttpSession session1 = request.getSession();
        String username = (String) session.getAttribute("user");

        if (username == null || !session.getAttribute("role").equals("admin")) {
            // Redirect to login or show an error message
            response.sendRedirect("login.jsp");
        } else {
    %>

    <form action="FlightReservations.jsp" method="post">
        <label for="searchType">Search by:</label>
        <select name="searchType">
            <option value="flightNumber">Flight Number</option>
            <option value="customerName">Customer Name</option>
        </select><br>
        
        <label for="searchValue">Enter Value:</label>
        <input type="text" name="searchValue" required><br>
        
        <input type="submit" value="Search Reservations">
    </form>

    <%
        if (request.getMethod().equals("POST")) {
            String searchType = request.getParameter("searchType");
            String searchValue = request.getParameter("searchValue");

            Connection conn = null;
            PreparedStatement pstmt = null;
            ResultSet rs = null;

            try {
                Class.forName("com.mysql.jdbc.Driver");
                conn = DriverManager.getConnection("jdbc:mysql://localhost/cs336Project", "root", "Aditya123$");

                String sql = "";

                if ("flightNumber".equals(searchType)) {
                    sql = "SELECT * FROM Ticket JOIN AssociatedWith ON Ticket.tid = AssociatedWith.tid WHERE AssociatedWith.Fid = ?";
                } else if ("customerName".equals(searchType)) {
                    sql = "SELECT * FROM Ticket WHERE customerID IN (SELECT customerID FROM Customer WHERE Fname = ? OR Lname = ?)";
                }

                pstmt = conn.prepareStatement(sql);
                pstmt.setString(1, searchValue);
                if ("customerName".equals(searchType)) {
                    pstmt.setString(2, searchValue);
                }

                rs = pstmt.executeQuery();

                %><table><tr><th>Ticket ID</th><th>Flight ID</th><th>Customer ID</th><th>Total Fare</th></tr><%
                while (rs.next()) {
                    %><tr><td><%= rs.getString("tid") %></td><td><%= rs.getString("Fid") %></td><td><%= rs.getString("customerID") %></td><td><%= rs.getDouble("TotalFare") %></td></tr><%
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
    <% } %>
</body>
</html>
