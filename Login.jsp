<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%><!DOCTYPE html>
<html>
<head>
    <title>Login</title>
</head>
<body>
    <h2>Login</h2>
    <form action="Login.jsp" method="post">
        Username: <input type="text" name="username" required><br>
        Password: <input type="password" name="password" required><br>
        <input type="submit" value="Login">
    </form>

    <% 
    String username = request.getParameter("username");
    String password = request.getParameter("password");

    if (username != null && password != null) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String userRole = null;

        try {
            Class.forName("com.mysql.jdbc.Driver"); // Use com.mysql.cj.jdbc.Driver for newer MySQL versions
            conn = DriverManager.getConnection("jdbc:mysql://localhost/cs336Project", "root", "Aditya123$");

            String sql = "SELECT userType FROM User WHERE username=? AND password=?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, username);
            pstmt.setString(2, password);

            rs = pstmt.executeQuery();

            if (rs.next()) {
                userRole = rs.getString("userType");
            }

            if (userRole != null) {
                HttpSession session1 = request.getSession();
                session.setAttribute("user", username);
                session.setAttribute("role", userRole);

                if ("admin".equals(userRole)) {
                    response.sendRedirect("AdminDashboard.jsp");
                } else if ("customer_rep".equals(userRole)) {
                    response.sendRedirect("CustomerRepDashboard.jsp");
                } else {
                    response.sendRedirect("CustomerDashboard.jsp");
                }
            } else {
                out.println("<p>Invalid username or password.</p>");
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
