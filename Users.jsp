<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html>
<html>
<head>
    <title>User Dashboard</title>
</head>
<body>
    <h1>Welcome to the User Dashboard</h1>
    
    <%
        String username = (String) session.getAttribute("username"); // Make sure the session attribute matches your implementation
    %>
    
    <p>Hello, <%= username %> (User)</p>
    
    <h2>User Functions</h2>
    <ul>
        <li><a href="SearchFlights.jsp">Search Flights</a></li>
        <li><a href="ReservationHandler.jsp">Reservations</a></li>
        <li><a href="ViewPastFlights.jsp">View Past Flight Reservations</a></li>
        <li><a href="ViewUpcomingFlights.jsp">View Upcoming Flights</a></li>
        <li><a href="CancelReservation.jsp">Cancel Reservation</a></li>
        <li><a href="AskQuestions.jsp">Ask Questions</a></li>
        <li><a href="ViewQuestions.jsp">View Questions and Answers</a></li>
        <li><a href="Logout.jsp">Logout</a></li>
    </ul>
    
</body>
</html>
