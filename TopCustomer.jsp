<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html>
<html>
<head>
    <title>Top Revenue Generating Customer</title>
</head>
<body>
    <h1>Top Revenue Generating Customer</h1>

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

                String sql = "SELECT Customer.customerID, Customer.Fname, Customer.Lname, SUM(Ticket.TotalFare) AS TotalRevenue FROM Ticket JOIN Customer ON Ticket.customerID = Customer.customerID GROUP BY Ticket.customerID HAVING SUM(Ticket.TotalFare) = (SELECT MAX(TotalRevenue) FROM (SELECT SUM(TotalFare) AS TotalRevenue FROM Ticket GROUP BY customerID)AS SubQuery)";

                pstmt = conn.prepareStatement(sql);
                rs = pstmt.executeQuery();

                if (rs.next()) {
                    String customerId = rs.getString("customerID");
                    String firstName = rs.getString("Fname");
                    String lastName = rs.getString("Lname");
                    double totalRevenue = rs.getDouble("TotalRevenue");

                    %><p>Top Revenue Customer: <%= firstName %> <%= lastName %> (ID: <%= customerId %>) - Total Revenue: $<%= totalRevenue %></p><%
                } else {
                    %><p>No revenue data available.</p><%
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
