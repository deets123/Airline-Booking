<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html>
<html>
<head>
    <title>Search Flights</title>
    <script>
        function toggleReturnDate() {
            var tripType = document.querySelector('input[name="tripType"]:checked').value;
            document.getElementById('returnDate').style.display = (tripType === 'roundTrip') ? 'block' : 'none';
        }
    </script>
</head>
<body>
    <h1>Search for Flights</h1>
    <form action="SearchFlights.jsp" method="get">
        Departure Airport: <input type="text" name="departureAirport" required><br>
        Arrival Airport: <input type="text" name="arrivalAirport" required><br>
        Date: <input type="date" name="date" required><br>
        <input type="radio" name="tripType" value="oneWay" checked onclick="toggleReturnDate()"> One Way
        <input type="radio" name="tripType" value="roundTrip" onclick="toggleReturnDate()"> Round Trip<br>
        Return Date: <input type="date" name="returnDate" id="returnDate" style="display: none;"><br>
        Flexible Dates: <input type="checkbox" name="flexibleDates"><br>
        Sort by:<select name="sortBy">
 					<option value="price">Price</option>
    				<option value="takeOffTime">Take-off Time</option>
    				<option value="landingTime">Landing Time</option>
    				<option value="duration">Duration</option>
				</select><br>	
		Filter by Price: 
			<input type="number" name="minPrice" placeholder="Min"> to 
			<input type="number" name="maxPrice" placeholder="Max"><br>
        <input type="submit" value="Search">
    </form>
    <hr>

    <% 
    String departureAirport = request.getParameter("departureAirport");
    String arrivalAirport = request.getParameter("arrivalAirport");
    String date = request.getParameter("date");
    String returnDate = request.getParameter("returnDate");
    String tripType = request.getParameter("tripType");
    boolean isFlexible = request.getParameter("flexibleDates") != null;
    String sortBy = request.getParameter("sortBy");
    String minPrice = request.getParameter("minPrice");
    String maxPrice = request.getParameter("maxPrice");

    if (departureAirport != null && arrivalAirport != null && date != null) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            Class.forName("com.mysql.jdbc.Driver");
            conn = DriverManager.getConnection("jdbc:mysql://localhost/cs336Project", "root", "Aditya123$");

            String sql;
            if (isFlexible) {
                if ("oneWay".equals(tripType)) {
                    sql = "SELECT * FROM Flight WHERE dep_airport = ? AND dest_airport = ? AND DATE(Days_of_operation) BETWEEN DATE_SUB(?, INTERVAL 3 DAY) AND DATE_ADD(?, INTERVAL 3 DAY)";
                    
                    if (minPrice != null && !minPrice.isEmpty()) {
                        sql += " AND price >= " + minPrice;
                    }
                    if (maxPrice != null && !maxPrice.isEmpty()) {
                        sql += " AND price <= " + maxPrice;
                    }
                    
                    if (sortBy != null) {
                        sql += " ORDER BY ";
                        switch (sortBy) {
                            case "price":
                                sql += "price";
                                break;
                            case "takeOffTime":
                                sql += "d_time";
                                break;
                            case "landingTime":
                                sql += "a_time";
                                break;
                        }
                    }
                    
                    pstmt = conn.prepareStatement(sql);
                    pstmt.setString(1, departureAirport);
                    pstmt.setString(2, arrivalAirport);
                    pstmt.setDate(3, java.sql.Date.valueOf(date));
                    pstmt.setDate(4, java.sql.Date.valueOf(date));
                    rs = pstmt.executeQuery();
                    
                    
                    
                    while (rs.next()) {
                        // Display each flight
                        out.println("<p>Flight: " + rs.getString("Fid") + 
                                    ", Departure: " + rs.getString("d_time") +
                                    ", Arrival: " + rs.getString("a_time") +
                                    ", Price" + rs.getString("price"));
                    }
                } else if ("roundTrip".equals(tripType) && returnDate != null) {
                    // Query for the departure leg
    				String departureLegSql = "SELECT * FROM Flight WHERE dep_airport = ? AND dest_airport = ? AND DATE(Days_of_operation) BETWEEN DATE_SUB(?, INTERVAL 3 DAY) AND DATE_ADD(?, INTERVAL 3 DAY)";
                    
                    if (minPrice != null && !minPrice.isEmpty()) {
                    	departureLegSql += " AND price >= " + minPrice;
                    }
                    if (maxPrice != null && !maxPrice.isEmpty()) {
                    	departureLegSql += " AND price <= " + maxPrice;
                    }
                    
                    if (sortBy != null) {
                    	departureLegSql += " ORDER BY ";
                        switch (sortBy) {
                            case "price":
                            	departureLegSql += "price";
                                break;
                            case "takeOffTime":
                            	departureLegSql += "d_time";
                                break;
                            case "landingTime":
                            	departureLegSql += "a_time";
                                break;
                        }
                    }
                    
  				  	pstmt = conn.prepareStatement(departureLegSql);
    				pstmt.setString(1, departureAirport);
    				pstmt.setString(2, arrivalAirport);
    				pstmt.setDate(3, java.sql.Date.valueOf(date));
    				pstmt.setDate(4, java.sql.Date.valueOf(date));
    				ResultSet departureRs = pstmt.executeQuery();
    				
                    while (departureRs.next()) {
                        // Display each flight
                        out.println("<p>Flight: " + departureRs.getString("Fid") + 
                                    ", Departure: " + departureRs.getString("d_time") +
                                    ", Arrival: " + departureRs.getString("a_time") + 
                                    ", Price" + departureRs.getString("price"));
                    }

    				// Query for the return leg with flexible dates
    				String returnLegSql = "SELECT * FROM Flight WHERE dep_airport = ? AND dest_airport = ? AND DATE(Days_of_operation) BETWEEN DATE_SUB(?, INTERVAL 3 DAY) AND DATE_ADD(?, INTERVAL 3 DAY)";
    				
                    if (minPrice != null && !minPrice.isEmpty()) {
                    	returnLegSql += " AND price >= " + minPrice;
                    }
                    if (maxPrice != null && !maxPrice.isEmpty()) {
                    	returnLegSql += " AND price <= " + maxPrice;
                    }
                    
                    if (sortBy != null) {
                    	returnLegSql += " ORDER BY ";
                        switch (sortBy) {
                            case "price":
                            	returnLegSql += "price";
                                break;
                            case "takeOffTime":
                            	returnLegSql += "d_time";
                                break;
                            case "landingTime":
                            	returnLegSql += "a_time";
                                break;
                        }
                    }
    				
    				pstmt = conn.prepareStatement(returnLegSql);
    				pstmt.setString(1, arrivalAirport);
    				pstmt.setString(2, departureAirport);
    				pstmt.setDate(3, java.sql.Date.valueOf(returnDate));
    				pstmt.setDate(4, java.sql.Date.valueOf(returnDate));
    				ResultSet returnRs = pstmt.executeQuery();
    				
                    while (returnRs.next()) {
                        // Display each flight
                        out.println("<p>Flight: " + returnRs.getString("Fid") + 
                                    ", Departure: " + returnRs.getString("d_time") +
                                    ", Arrival: " + returnRs.getString("a_time") +
                                    ", Price: " + returnRs.getString("price"));
                    }
                }
            } else {
                // SQL query for specific date
				if ("oneWay".equals(tripType)) {
    				sql = "SELECT * FROM Flight WHERE dep_airport = ? AND dest_airport = ? AND DATE(Days_of_operation) = ?";
    				
                    if (minPrice != null && !minPrice.isEmpty()) {
                        sql += " AND price >= " + minPrice;
                    }
                    if (maxPrice != null && !maxPrice.isEmpty()) {
                        sql += " AND price <= " + maxPrice;
                    }
                    
                    if (sortBy != null) {
                        sql += " ORDER BY ";
                        switch (sortBy) {
                            case "price":
                                sql += "price";
                                break;
                            case "takeOffTime":
                                sql += "d_time";
                                break;
                            case "landingTime":
                                sql += "a_time";
                                break;
                        }
                    }
    				
    				pstmt = conn.prepareStatement(sql);
    				pstmt.setString(1, departureAirport);
    				pstmt.setString(2, arrivalAirport);
    				pstmt.setDate(3, java.sql.Date.valueOf(date));
    	            rs = pstmt.executeQuery();

                    while (rs.next()) {
                        // Display each flight
                        out.println("<p>Flight: " + rs.getString("Fid") + 
                                    ", Departure: " + rs.getString("d_time") +
                                    ", Arrival: " + rs.getString("a_time") +
                                    ", Price: " + rs.getString("price"));
                    }
				}
				else if ("roundTrip".equals(tripType) && returnDate != null) {
				    // Query for the departure leg
				    String departureLegSql = "SELECT * FROM Flight WHERE dep_airport = ? AND dest_airport = ? AND DATE(Days_of_operation) = ?";
				    		
                    if (minPrice != null && !minPrice.isEmpty()) {
                    	departureLegSql += " AND price >= " + minPrice;
                    }
                    if (maxPrice != null && !maxPrice.isEmpty()) {
                    	departureLegSql += " AND price <= " + maxPrice;
                    }
                    
                    if (sortBy != null) {
                    	departureLegSql += " ORDER BY ";
                        switch (sortBy) {
                            case "price":
                            	departureLegSql += "price";
                                break;
                            case "takeOffTime":
                            	departureLegSql += "d_time";
                                break;
                            case "landingTime":
                            	departureLegSql += "a_time";
                                break;
                        }
                    }		
				    
				    pstmt = conn.prepareStatement(departureLegSql);
				    pstmt.setString(1, departureAirport);
				    pstmt.setString(2, arrivalAirport);
				    pstmt.setDate(3, java.sql.Date.valueOf(date));
				    ResultSet departureRs = pstmt.executeQuery();
				    
                    while (departureRs.next()) {
                        // Display each flight
                        out.println("<p>Flight: " + departureRs.getString("Fid") + 
                                    ", Departure: " + departureRs.getString("d_time") +
                                    ", Arrival: " + departureRs.getString("a_time") +
                                    ", Price: " + departureRs.getString("price"));
                    }

				    // Query for the return leg
				    String returnLegSql = "SELECT * FROM Flight WHERE dep_airport = ? AND dest_airport = ? AND DATE(Days_of_operation) = ?";
				    		
                    if (minPrice != null && !minPrice.isEmpty()) {
                    	returnLegSql += " AND price >= " + minPrice;
                    }
                    if (maxPrice != null && !maxPrice.isEmpty()) {
                    	returnLegSql += " AND price <= " + maxPrice;
                    }
                    
                    if (sortBy != null) {
                    	returnLegSql += " ORDER BY ";
                        switch (sortBy) {
                            case "price":
                            	returnLegSql += "price";
                                break;
                            case "takeOffTime":
                            	returnLegSql += "d_time";
                                break;
                            case "landingTime":
                            	returnLegSql += "a_time";
                                break;
                        }
                    }		
				    		
				    pstmt = conn.prepareStatement(returnLegSql);
				    pstmt.setString(1, arrivalAirport);
				    pstmt.setString(2, departureAirport);
				    pstmt.setDate(3, java.sql.Date.valueOf(returnDate));
				    ResultSet returnRs = pstmt.executeQuery();
				    
                    while (returnRs.next()) {
                        // Display each flight
                        out.println("<p>Flight: " + returnRs.getString("Fid") + 
                                    ", Departure: " + returnRs.getString("d_time") +
                                    ", Arrival: " + returnRs.getString("a_time") +
                                    ", Price: " + returnRs.getString("price"));
                    }
				}
            }
        } catch (Exception e) {
            out.println("<p>Error: " + e.getMessage() + "</p>");
            e.printStackTrace(new java.io.PrintWriter(out));
        } finally {
            if (rs != null) try { rs.close(); } catch (Exception e) {}
            if (pstmt != null) try { pstmt.close(); } catch (Exception e) {}
            if (conn != null) try { conn.close(); } catch (Exception e) {}
        }
    }
    %>
</body>
</html>
