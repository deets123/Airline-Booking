<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html>
<html>
<head>
    <title>Admin Dashboard</title>
</head>
<body>
    <h1>Welcome to the Admin Dashboard</h1>
    
    <%
        HttpSession session1 = request.getSession();
        String username = (String) session.getAttribute("user");
    %>
    
    <p>Hello, <%= username %> (Admin)</p>
    
    <h2>Admin Functions</h2>
    <ul>
        <li><a href="ViewSalesReport.jsp">View Sales Report</a></li>
        <li><a href="ManageCustomers.jsp">Manage Customers</a></li>
        <li><a href="ManageCustomerRep.jsp">Manage Customer Representative</a></li>
        <li><a href="FlightReservations.jsp">List Flight Reservations</a></li>
        <li><a href="Active.jsp">Most Active Flights</a>
        <li><a href="TopCustomer.jsp">Top Customer</a>
        <li><a href="Logout.jsp">Logout</a></li>
        
    </ul>
    
</body>
</html>