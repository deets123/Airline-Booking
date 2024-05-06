<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html>
<html>
<head>
    <title>Customer Representative Dashboard</title>
</head>
<body>
    <h1>Welcome to the Customer Representative Dashboard</h1>
    
    <%
        String username = (String) session.getAttribute("user");

        // Check if the user is logged in and has the role of a customer representative
        String userRole = (String) session.getAttribute("role");
        if (username == null || userRole == null || !userRole.equals("customer_rep")) {
            response.sendRedirect("Login.jsp");
            return; // Stop further rendering of the page
        }
    %>
    
    <p>Hello, <%= username %> (Customer Representative)</p>
    
    <h2>Customer Representative Functions</h2>
    <ul>
        <li><a href="ManageReservations.jsp">Manage Reservations</a></li>
        <li><a href="AssistCustomers.jsp">Assist Customers</a></li>
        <li><a href="ManageFlights.jsp">Manage Flights</a></li>
        <li><a href="CustomerQueries.jsp">Customer Queries</a></li>
        <li><a href="WaitingList.jsp">Flight Waiting List</a>
        <li><a href="Logout.jsp">Logout</a></li>
    </ul>
    
</body>
</html>
