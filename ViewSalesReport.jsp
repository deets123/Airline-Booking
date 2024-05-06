<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html>
<html>
<head>
    <title>View Sales Report</title>
</head>
<body>
    <h1>Sales Report</h1>

    <% 
        HttpSession session1 = request.getSession();
        String userRole = (String) session.getAttribute("role");

        if (userRole == null || !userRole.equals("admin")) {
            // Redirect to login or show an error message
            response.sendRedirect("Login.jsp");
        } else {
            // Display the sales report form and results
    %>

    <form action="ViewSalesReport.jsp" method="post">
        <label for="reportType">Select Report Type:</label>
        <select name="reportType">
            <option value="monthly">Monthly Report</option>
            <option value="flight">By Flight Number</option>
            <option value="airline">By Airline</option>
            <option value="customer">By Customer</option>
        </select><br>
        
        <label for="criteria">Enter Criteria:</label>
        <input type="text" name="criteria" required><br>
        
        <input type="submit" value="Generate Report">
    </form>

    <%
        if (request.getMethod().equals("POST")) {
            String reportType = request.getParameter("reportType");
            String criteria = request.getParameter("criteria");

            Connection conn = null;
            PreparedStatement pstmt = null;
            ResultSet rs = null;

            try {
                Class.forName("com.mysql.jdbc.Driver");
                conn = DriverManager.getConnection("jdbc:mysql://localhost/cs336Project", "root", "Aditya123$");

                String sql = ""; // SQL query based on reportType and criteria

                if ("monthly".equals(reportType)) {
                    sql = "SELECT sum(TotalFare) as tot FROM Ticket WHERE MONTH(purchaseDate) = ?"; 
                    pstmt = conn.prepareStatement(sql);
                    pstmt.setString(1, criteria);
                }
                else if ("customer".equals(reportType)) {
                    String[] nameParts = criteria.split(" ");
                	sql = "SELECT SUM(TotalFare) as tot FROM Ticket WHERE customerID IN (SELECT customerID FROM Customer WHERE Fname = ? AND Lname = ?)";
                    pstmt = conn.prepareStatement(sql);
                    pstmt.setString(1, nameParts[0]);
                    pstmt.setString(2, nameParts[1]);
                }
                else if ("airline".equals(reportType)) {
                    sql = "SELECT SUM(Ticket.TotalFare) AS tot "
                            + "FROM Ticket "
                            + "JOIN AssociatedWith ON Ticket.tid = AssociatedWith.tid "
                            + "JOIN Flight ON AssociatedWith.Fid = Flight.Fid "
                            + "JOIN Aircraft ON Flight.acid = Aircraft.acid "
                            + "JOIN AirlineComp ON Aircraft.cid = AirlineComp.cid "
                            + "WHERE AirlineComp.cid = ?";
                    pstmt = conn.prepareStatement(sql);
                    pstmt.setString(1, criteria);
                }
                else if ("flight".equals(reportType)) { 
                	sql = "SELECT SUM(TotalFare) AS tot FROM Ticket JOIN AssociatedWith ON Ticket.tid = AssociatedWith.tid WHERE AssociatedWith.Fid = ?";
                    pstmt = conn.prepareStatement(sql);
                    pstmt.setString(1, criteria);
                }
                rs = pstmt.executeQuery();

                // Display the results in a table or a structured format
                %><table><tr><th>Column1</th></tr><%
                while (rs.next()) {
                    %><tr><td><%= rs.getString("tot") %></td></tr><%
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
