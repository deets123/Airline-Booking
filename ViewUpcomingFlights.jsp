 <%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<!DOCTYPE html>
<html>
<head>
    <title>Upcoming Flights</title>
</head>
<body>
    <h1>Upcoming Flights</h1>
    <table border="1">
        <tr>
            <th>Flight ID</th>
            <th>Departure Time</th>
            <th>Arrival Time</th>
            <th>Departure Airport</th>
            <th>Destination Airport</th>
            <th>Days of Operation</th>
            <th>Price</th>
        </tr>
        <% 
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            Class.forName("com.mysql.jdbc.Driver");
            conn = DriverManager.getConnection("jdbc:mysql://localhost/cs336Project", "root", "Aditya123$");

            String sql = "SELECT * FROM Flight WHERE Days_of_operation >= CURDATE()";
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();

            while (rs.next()) {
                out.println("<tr>");
                out.println("<td>" + rs.getInt("Fid") + "</td>");
                out.println("<td>" + rs.getTime("d_time") + "</td>");
                out.println("<td>" + rs.getTime("a_time") + "</td>");
                out.println("<td>" + rs.getString("dep_airport") + "</td>");
                out.println("<td>" + rs.getString("dest_airport") + "</td>");
                out.println("<td>" + rs.getString("Days_of_operation") + "</td>");
                out.println("<td>" + rs.getFloat("price") + "</td>");
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
 