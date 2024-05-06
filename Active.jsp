<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html>
<html>
<head>
    <title>Most Active Flight</title>
</head>
<body>
    <h1>Most Active Flight</h1>

    <% 
        HttpSession session1 = request.getSession();
        String username = (String) session.getAttribute("user");

        if (username == null || !session.getAttribute("role").equals("admin")) {
            // Redirect to login or show an error message
            response.sendRedirect("login.jsp");
        } else {
            Connection conn = null;
            PreparedStatement pstmt = null;
            ResultSet rs = null;

            try {
                Class.forName("com.mysql.jdbc.Driver");
                conn = DriverManager.getConnection("jdbc:mysql://localhost/cs336Project", "root", "Aditya123$");

                String sql = "SELECT Fid, COUNT(tid) AS TicketCount " +
                             "FROM AssociatedWith " +
                             "GROUP BY Fid " +
                             "HAVING COUNT(tid) = (SELECT MAX(TicketCount) FROM (SELECT Fid, COUNT(tid) AS TicketCount FROM AssociatedWith GROUP BY Fid) AS SubQuery)";

                pstmt = conn.prepareStatement(sql);
                rs = pstmt.executeQuery();

                if (rs.next()) {
                    int flightId = rs.getInt("Fid");
                    int ticketCount = rs.getInt("TicketCount");

                    %><p>Most Active Flight: Flight ID <%= flightId %> - Tickets Sold: <%= ticketCount %></p><%
                } else {
                    %><p>No data found for the most active flight.</p><%
                }

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
