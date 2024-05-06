<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html>
<html>
<head>
<title>Manage Flights</title>
<script>
	function showForm(formId) {
		document.getElementById('addFlightForm').style.display = formId === 'addFlight' ? 'block'
				: 'none';
		document.getElementById('editFlightForm').style.display = formId === 'editFlight' ? 'block'
				: 'none';
		document.getElementById('deleteFlightForm').style.display = formId === 'deleteFlight' ? 'block'
				: 'none';
		document.getElementById('addAircraftForm').style.display = formId === 'addAircraft' ? 'block'
				: 'none';
		document.getElementById('editAircraftForm').style.display = formId === 'editAircraft' ? 'block'
				: 'none';
		document.getElementById('deleteAircraftForm').style.display = formId === 'deleteAircraft' ? 'block'
				: 'none';
		document.getElementById('addAirportForm').style.display = formId === 'addAirport' ? 'block'
				: 'none';
		document.getElementById('editAirportForm').style.display = formId === 'editAirport' ? 'block'
				: 'none';
		document.getElementById('deleteAirportForm').style.display = formId === 'deleteAirport' ? 'block'
				: 'none';

	}
</script>
</head>
<body>
	<h1>Manage Flights</h1>

	<form>
		<select onchange="showForm(this.value)">
			<option value="addFlight">Add Flight</option>
			<option value="editFlight">Edit Flight</option>
			<option value="deleteFlight">Delete Flight</option>
			<option value="addAircraft">Add Aircraft</option>
			<option value="editAircraft">Edit Aircraft</option>
			<option value="deleteAircraft">Delete Aircraft</option>
			<option value="addAirport">Add Airport</option>
			<option value="editAirport">Edit Airport</option>
			<option value="deleteAirport">Delete Airport</option>

		</select>
	</form>

	<!-- Add Flight Form -->
	<div id="addFlightForm" style="display: none;">
		<h2>Add Flight</h2>
		<form method="POST" action="">
			Flight Number: <input type="text" name="flightNumber" required><br>
			Departure Time: <input type="time" name="departureTime" required><br>
			Arrival Time: <input type="time" name="arrivalTime" required><br>
			Departure Airport: <input type="text" name="departureAirport"
				required><br> Arrival Airport: <input type="text"
				name="arrivalAirport" required><br> Number of Seats: <input
				type="text" name="numOfSeats" required><br> Aircraft
			ID: <input type="text" name="acid" required><br> Date: <input
				type="date" name="date" required><br> Price: <input
				type="text" name="price" required><br> <input
				type="hidden" name="action" value="addFlight"> <input
				type="submit" value="Add Flight">
		</form>
	</div>

	<!-- Edit Flight Form -->
	<div id="editFlightForm" style="display: none;">
		<h2>Edit Flight</h2>
		<form method="POST" action="">
			Flight ID: <input type="number" name="flightId" required><br>
			New Flight Number: <input type="text" name="newFlightNumber"><br>
			New Departure Time: <input type="time" name="newDepartureTime"><br>
			New Arrival Time: <input type="time" name="newArrivalTime"><br>
			New Departure Airport: <input type="text" name="newDepartureAirport"><br>
			New Arrival Airport: <input type="text" name="newArrivalAirport"><br>
			New Number of Seats: <input type="number" name="newNumOfSeats"><br>
			New Aircraft ID: <input type="text" name="newAcid"><br>
			New Date: <input type="date" name="newDate" required><br>
			New Price: <input type="text" name="newprice" required><br>
			<input type="hidden" name="action" value="editFlight"> <input
				type="submit" value="Update Flight">
		</form>
	</div>

	<!-- Delete Flight Form -->
	<div id="deleteFlightForm" style="display: none;">
		<h2>Delete Flight</h2>
		<form method="POST" action="">
			Flight ID: <input type="number" name="flightId" required><br>
			<input type="hidden" name="action" value="deleteFlight"> <input
				type="submit" value="Delete Flight">
		</form>
	</div>

	<!-- Add Aircraft Form -->
	<div id="addAircraftForm" style="display: none;">
		<h2>Add Aircraft</h2>
		<form method="POST" action="ManageFlights.jsp">
			Aircraft ID: <input type="text" name="acid" required><br>
			Number of Seats: <input type="number" name="numOfSeats" required><br>
			<input type="hidden" name="action" value="addAircraft"> <input
				type="submit" value="Add Aircraft">
		</form>
	</div>

	<!-- Edit Aircraft Form -->
	<div id="editAircraftForm" style="display: none;">
		<h2>Edit Aircraft</h2>
		<form method="POST" action="ManageFlights.jsp">
			Aircraft ID: <input type="text" name="acid" required><br>
			New Number of Seats: <input type="number" name="newNumOfSeats"><br>
			<input type="hidden" name="action" value="editAircraft"> <input
				type="submit" value="Update Aircraft">
		</form>
	</div>

	<!-- Delete Aircraft Form -->
	<div id="deleteAircraftForm" style="display: none;">
		<h2>Delete Aircraft</h2>
		<form method="POST" action="">
			Aircraft ID: <input type="number" name="acid" required><br>
			<input type="hidden" name="action" value="deleteAircraft"> <input
				type="submit" value="Delete Aircraft">
		</form>
	</div>

	<!-- Add Airport Form -->
	<div id="addAirportForm" style="display: none;">
		<h2>Add Airport</h2>
		<form method="POST" action="ManageFlights.jsp">
			Airport ID: <input type="text" name="aid" required><br>
			<input type="hidden" name="action" value="addAirport"> <input
				type="submit" value="Add Airport">
		</form>
	</div>

	<!-- Edit Airport Form -->
	<div id="editAirportForm" style="display: none;">
		<h2>Edit Airport</h2>
		<form method="POST" action="ManageFlights.jsp">
			Old Airport ID: <input type="text" name="aid" required><br>
			New Airport ID: <input type="text" name="newaid" required><br>
			<input type="hidden" name="action" value="editAirport"> <input
				type="submit" value="Update Airport">
		</form>
	</div>

	<!-- Delete Airport Form -->
	<div id="deleteAirportForm" style="display: none;">
		<h2>Delete Airport</h2>
		<form method="POST" action="ManageFlights.jsp">
			Airport ID: <input type="text" name="aid" required><br>
			<input type="hidden" name="action" value="deleteAirport"> <input
				type="submit" value="Delete Airport">
		</form>
	</div>
	<%
	// Database connection setup
	String action = request.getParameter("action");
	if (action != null) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			// Database connection
			conn = DriverManager.getConnection("jdbc:mysql://localhost/cs336Project", "root", "Aditya123$");

			if ("addFlight".equals(action)) {
		int flightNumber = Integer.parseInt(request.getParameter("flightNumber"));
		String departureTimeStr = request.getParameter("departureTime");
		String arrivalTimeStr = request.getParameter("arrivalTime");
		String departureAirport = request.getParameter("departureAirport");
		String arrivalAirport = request.getParameter("arrivalAirport");
		int numOfSeats = Integer.parseInt(request.getParameter("numOfSeats"));
		int acid = Integer.parseInt(request.getParameter("acid"));
		float price = Float.parseFloat(request.getParameter("price"));
		String date = request.getParameter("date");

		Time departureTime = null;
		Time arrivalTime = null;

		// Validate and format time strings
		if (departureTimeStr != null && !departureTimeStr.isEmpty()) {
			departureTime = Time.valueOf(departureTimeStr + (departureTimeStr.length() == 5 ? ":00" : ""));
		}
		if (arrivalTimeStr != null && !arrivalTimeStr.isEmpty()) {
			arrivalTime = Time.valueOf(arrivalTimeStr + (arrivalTimeStr.length() == 5 ? ":00" : ""));
		}

		String checkAircraftSql = "SELECT COUNT(*) FROM Aircraft WHERE acid = ?";
		pstmt = conn.prepareStatement(checkAircraftSql);
		pstmt.setInt(1, acid);
		rs = pstmt.executeQuery();

		try {
			Class.forName("com.mysql.jdbc.Driver");
			conn = DriverManager.getConnection("jdbc:mysql://localhost/cs336Project", "root", "Aditya123$");

			if (rs.next() && rs.getInt(1) > 0) {
				// Aircraft exists, proceed to add flight
				String addFlightSql = "INSERT INTO Flight (Fid, d_time, num_of_seat, type, dep_airport, dest_airport, a_time, Days_of_operation, acid, price) VALUES (?, ?, ?, NULL, ?, ?, ?, ?, ?, ?)";
				pstmt = conn.prepareStatement(addFlightSql);
				pstmt.setInt(1, flightNumber);
				pstmt.setTime(2, (departureTime));
				pstmt.setInt(3, numOfSeats);
				pstmt.setString(4, departureAirport);
				pstmt.setString(5, arrivalAirport);
				pstmt.setTime(6, (arrivalTime));
				pstmt.setDate(7, java.sql.Date.valueOf(date));
				pstmt.setInt(8, acid);
				pstmt.setFloat(9, price);
				pstmt.executeUpdate();

				out.println("<p>Flight added successfully!</p>");
			} else {
				// Aircraft does not exist
				out.println("<p>Error: Aircraft with ID " + acid + " does not exist.</p>");
			}
		} catch (Exception e) {
			out.println("<p>Error: " + e.getMessage() + "</p>");
			e.printStackTrace(new PrintWriter(out));
		} finally {
			if (pstmt != null)
				try {
					pstmt.close();
				} catch (Exception e) {
				}
			if (conn != null)
				try {
					conn.close();
				} catch (Exception e) {
				}
		}
			} else if ("editFlight".equals(action)) {
		int flightId = Integer.parseInt(request.getParameter("flightId"));
		int newFlightNumber = Integer.parseInt(request.getParameter("newFlightNumber"));
		String departureTimeStr = request.getParameter("newDepartureTime");
		String arrivalTimeStr = request.getParameter("newArrivalTime");
		String newDepartureAirport = request.getParameter("newDepartureAirport");
		String newArrivalAirport = request.getParameter("newArrivalAirport");
		String newDate = request.getParameter("newDate");
		int newNumOfSeats = Integer.parseInt(request.getParameter("newNumOfSeats"));
		int newAcid = Integer.parseInt(request.getParameter("newAcid"));
		float newPrice = Float.parseFloat(request.getParameter("newprice"));

		Time newDepartureTime = null;
		Time newArrivalTime = null;

		// Validate and format time strings
		if (departureTimeStr != null && !departureTimeStr.isEmpty()) {
			newDepartureTime = Time.valueOf(departureTimeStr + (departureTimeStr.length() == 5 ? ":00" : ""));
		}
		if (arrivalTimeStr != null && !arrivalTimeStr.isEmpty()) {
			newArrivalTime = Time.valueOf(arrivalTimeStr + (arrivalTimeStr.length() == 5 ? ":00" : ""));
		}

		try {
			Class.forName("com.mysql.jdbc.Driver");
			conn = DriverManager.getConnection("jdbc:mysql://localhost/cs336Project", "root", "Aditya123$");

			// Check if the new aircraft ID exists (if changed)
			String checkAircraftSql = "SELECT COUNT(*) FROM Aircraft WHERE acid = ?";
			pstmt = conn.prepareStatement(checkAircraftSql);
			pstmt.setInt(1, newAcid);
			rs = pstmt.executeQuery();

			if (rs.next() && rs.getInt(1) > 0) {
				// Aircraft exists, proceed to update flight
				String updateFlightSql = "UPDATE Flight SET Fid = ?, d_time = ?, a_time = ?, dep_airport = ?, dest_airport = ?, num_of_seat = ?, acid = ?, Days_of_operation = ?, price = ? WHERE Fid = ?";
				pstmt = conn.prepareStatement(updateFlightSql);
				pstmt.setInt(1, newFlightNumber);
				pstmt.setTime(2, (newDepartureTime));
				pstmt.setTime(3, (newArrivalTime));
				pstmt.setString(4, newDepartureAirport);
				pstmt.setString(5, newArrivalAirport);
				pstmt.setInt(6, newNumOfSeats);
				pstmt.setInt(7, newAcid);
				pstmt.setDate(8, java.sql.Date.valueOf(newDate));
				pstmt.setFloat(9, newPrice);
				pstmt.setInt(10, flightId);
				pstmt.executeUpdate();

				out.println("<p>Flight updated successfully!</p>");
			} else {
				// Aircraft does not exist
				out.println("<p>Error: New Aircraft with ID " + newAcid + " does not exist.</p>");
			}
		} catch (Exception e) {
			out.println("<p>Error: " + e.getMessage() + "</p>");
			e.printStackTrace(new PrintWriter(out));
		} finally {
			if (rs != null)
				try {
					rs.close();
				} catch (Exception e) {
				}
			if (pstmt != null)
				try {
					pstmt.close();
				} catch (Exception e) {
				}
			if (conn != null)
				try {
					conn.close();
				} catch (Exception e) {
				}
		}
			} else if ("deleteFlight".equals(action)) {
		int flightId = Integer.parseInt(request.getParameter("flightId"));
		try {
			Class.forName("com.mysql.jdbc.Driver");
			conn = DriverManager.getConnection("jdbc:mysql://localhost/cs336Project", "root", "Aditya123$");
			conn.setAutoCommit(false);

			// Check for associated records
			String checkAssociatedSql = "SELECT COUNT(*) FROM AssociatedWith WHERE Fid = ?";
			pstmt = conn.prepareStatement(checkAssociatedSql);
			pstmt.setInt(1, flightId);
			ResultSet checkRs = pstmt.executeQuery();
			if (checkRs.next() && checkRs.getInt(1) > 0) {
				out.println("<p>Error: Cannot delete flight. There are associated reservations.</p>");
			} else {
				// Delete the flight
				String deleteFlightSql = "DELETE FROM Flight WHERE Fid = ?";
				pstmt = conn.prepareStatement(deleteFlightSql);
				pstmt.setInt(1, flightId);
				int rowsAffected = pstmt.executeUpdate();

				if (rowsAffected > 0) {
					out.println("<p>Flight deleted successfully!</p>");
				} else {
					out.println("<p>Error: No flight found with ID " + flightId + ".</p>");
				}
			}
			conn.commit();
		} catch (Exception e) {
			out.println("<p>Error: " + e.getMessage() + "</p>");
			if (conn != null) {
				try {
					conn.rollback();
				} catch (SQLException ex) {
					out.println("<p>Error rolling back: " + ex.getMessage() + "</p>");
				}
			}
			e.printStackTrace(new PrintWriter(out));
		} finally {
			if (pstmt != null)
				try {
					pstmt.close();
				} catch (Exception e) {
				}
			if (conn != null)
				try {
					conn.close();
				} catch (Exception e) {
				}
			if (conn != null)
				try {
					conn.setAutoCommit(true);
				} catch (SQLException e) {
				}
		}
			}
			
			else if ("addAircraft".equals(action)) {
		int acid = Integer.parseInt(request.getParameter("acid"));
		int numOfSeats = Integer.parseInt(request.getParameter("numOfSeats"));

		try {
			Class.forName("com.mysql.jdbc.Driver");
			conn = DriverManager.getConnection("jdbc:mysql://localhost/cs336Project", "root", "Aditya123$");

			String addAircraftSql = "INSERT INTO Aircraft (acid, noOfSeats) VALUES (?, ?)";
			pstmt = conn.prepareStatement(addAircraftSql);
			pstmt.setInt(1, acid);
			pstmt.setInt(2, numOfSeats);
			// Set other fields as necessary
			pstmt.executeUpdate();

			out.println("<p>Aircraft added successfully!</p>");
		} catch (Exception e) {
			out.println("<p>Error: " + e.getMessage() + "</p>");
			e.printStackTrace(new PrintWriter(out));
		} finally {
			if (pstmt != null)
				try {
					pstmt.close();
				} catch (Exception e) {
				}
			if (conn != null)
				try {
					conn.close();
				} catch (Exception e) {
				}
		}
			} else if ("editAircraft".equals(action)) {
		String acid = request.getParameter("acid");
		int newNumOfSeats = Integer.parseInt(request.getParameter("newNumOfSeats"));

		try {
			Class.forName("com.mysql.jdbc.Driver");
			conn = DriverManager.getConnection("jdbc:mysql://localhost/cs336Project", "root", "Aditya123$");

			String updateAircraftSql = "UPDATE Aircraft SET noOfSeats = ? WHERE acid = ?";
			pstmt = conn.prepareStatement(updateAircraftSql);
			pstmt.setInt(1, newNumOfSeats);
			pstmt.setString(2, acid);
			pstmt.executeUpdate();

			out.println("<p>Aircraft updated successfully!</p>");
		} catch (Exception e) {
			out.println("<p>Error: " + e.getMessage() + "</p>");
			e.printStackTrace(new PrintWriter(out));
		} finally {
			if (rs != null)
				try {
					rs.close();
				} catch (Exception e) {
				}
			if (pstmt != null)
				try {
					pstmt.close();
				} catch (Exception e) {
				}
			if (conn != null)
				try {
					conn.close();
				} catch (Exception e) {
				}
		}
			} else if ("deleteAircraft".equals(action)) {
		String acid = request.getParameter("acid");

		try {
			Class.forName("com.mysql.jdbc.Driver");
			conn = DriverManager.getConnection("jdbc:mysql://localhost/cs336Project", "root", "Aditya123$");

			String deleteAircraftSql = "DELETE FROM Aircraft WHERE acid = ?";
			pstmt = conn.prepareStatement(deleteAircraftSql);
			pstmt.setString(1, acid);
			int rowsAffected = pstmt.executeUpdate();

			if (rowsAffected > 0) {
				out.println("<p>Aircraft deleted successfully!</p>");
			} else {
				out.println("<p>Error: No aircraft found with ID " + acid + ".</p>");
			}
		} catch (Exception e) {
			out.println("<p>Error: " + e.getMessage() + "</p>");
			e.printStackTrace(new PrintWriter(out));
		} finally {
			if (pstmt != null)
				try {
					pstmt.close();
				} catch (Exception e) {
				}
			if (conn != null)
				try {
					conn.close();
				} catch (Exception e) {
				}
		}
			} else if ("addAirport".equals(action)) {
		String aid = request.getParameter("aid");

		try {
			String addAirportSql = "INSERT INTO Airport (aid) VALUES (?)";
			pstmt = conn.prepareStatement(addAirportSql);
			pstmt.setString(1, aid);
			// Set other fields as necessary
			pstmt.executeUpdate();

			out.println("<p>Airport added successfully!</p>");
		} catch (Exception e) {
			out.println("<p>Error: " + e.getMessage() + "</p>");
		}
			} else if ("editAirport".equals(action)) {
		String aid = request.getParameter("aid");
		String newAid = request.getParameter("newaid");
		// Assume you have new fields to update

		try {
			String updateAirportSql = "UPDATE Airport SET aid = ? WHERE aid = ?";
			pstmt = conn.prepareStatement(updateAirportSql);
			// Set new values
			pstmt.setString(1, newAid);
			pstmt.setString(2, aid);
			pstmt.executeUpdate();

			out.println("<p>Airport updated successfully!</p>");
		} catch (Exception e) {
			out.println("<p>Error: " + e.getMessage() + "</p>");
		}
			} else if ("deleteAirport".equals(action)) {
		String aid = request.getParameter("aid");

		try {
			String deleteAirportSql = "DELETE FROM Airport WHERE aid = ?";
			pstmt = conn.prepareStatement(deleteAirportSql);
			pstmt.setString(1, aid);
			int rowsAffected = pstmt.executeUpdate();

			if (rowsAffected > 0) {
				out.println("<p>Airport deleted successfully!</p>");
			} else {
				out.println("<p>Error: No airport found with ID " + aid + ".</p>");
			}
		} catch (Exception e) {
			out.println("<p>Error: " + e.getMessage() + "</p>");
		}
			}
			// Similarly, handle airport actions
		} catch (Exception e) {
			out.println("<p>Error: " + e.getMessage() + "</p>");
		} finally {

		}
	}
	%>
</body>
</html>
