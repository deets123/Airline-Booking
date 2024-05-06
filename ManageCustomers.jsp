<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html>
<html>
<head>
    <title>Manage Customers</title>
    <script>
        function showForm(action) {
            document.getElementById('addForm').style.display = action === 'add' ? 'block' : 'none';
            document.getElementById('editForm').style.display = action === 'edit' ? 'block' : 'none';
            document.getElementById('deleteForm').style.display = action === 'delete' ? 'block' : 'none';
            document.getElementById('viewForm').style.display = action === 'view' ? 'block' : 'none';
        }
    </script>
</head>
<body>
    <h1>Manage Customers</h1>
    
    <form action="">
        <label for="actionSelect">Choose an Action:</label>
        <select name="action" id="actionSelect" onchange="showForm(this.value)">
            <option value="view">View Customers</option>
            <option value="add">Add Customer</option>
            <option value="edit">Edit Customer</option>
            <option value="delete">Delete Customer</option>
        </select>
    </form>
    
    <% 
        String userRole = (String) session.getAttribute("role");

        if (userRole == null || !userRole.equals("admin")) {
            response.sendRedirect("Login.jsp");
        } else {
            Connection conn = null;
            PreparedStatement pstmt = null;
            ResultSet rs = null;

            try {
                Class.forName("com.mysql.jdbc.Driver");
                conn = DriverManager.getConnection("jdbc:mysql://localhost/cs336Project", "root", "Aditya123$");

                String action = request.getParameter("action");

                if ("add".equals(action)) {
                    String fname = request.getParameter("fname");
                    String lname = request.getParameter("lname");
                    String addSql = "INSERT INTO Customer (Fname, Lname) VALUES (?, ?)";
                    pstmt = conn.prepareStatement(addSql);
                    pstmt.setString(1, fname);
                    pstmt.setString(2, lname);
                    pstmt.executeUpdate();
                } else if ("edit".equals(action)) {
                    int customerId = Integer.parseInt(request.getParameter("customerId"));
                    String fname = request.getParameter("fname");
                    String lname = request.getParameter("lname");
                    String editSql = "UPDATE Customer SET Fname = ?, Lname = ? WHERE customerID = ?";
                    pstmt = conn.prepareStatement(editSql);
                    pstmt.setString(1, fname);
                    pstmt.setString(2, lname);
                    pstmt.setInt(3, customerId);
                    pstmt.executeUpdate();
                }
             	else if ("delete".equals(action)) {
                	int customerId = Integer.parseInt(request.getParameter("customerId"));
                	String deleteSql = "DELETE FROM Customer WHERE customerID = ?";
                	pstmt = conn.prepareStatement(deleteSql);
                	pstmt.setInt(1, customerId);
                	pstmt.executeUpdate();
            	}

                String viewSql = "SELECT * FROM Customer";
                pstmt = conn.prepareStatement(viewSql);
                rs = pstmt.executeQuery();
    %>

    <!-- View Customers Form -->
    <div id="viewForm" style="display:none;">
        <h2>View Customers</h2>
        <table>
            <tr>
                <th>Customer ID</th>
                <th>First Name</th>
                <th>Last Name</th>
            </tr>
            <% while (rs != null && rs.next()) { %>
                <tr>
                    <td><%= rs.getInt("customerID") %></td>
                    <td><%= rs.getString("Fname") %></td>
                    <td><%= rs.getString("Lname") %></td>
                </tr>
            <% } %>
        </table>
    </div>

    <!-- Add Customer Form -->
    <div id="addForm" style="display:none;">
        <form action="ManageCustomers.jsp" method="post">
            <input type="hidden" name="action" value="add">
            <h2>Add Customer</h2>
            First Name: <input type="text" name="fname" required><br>
            Last Name: <input type="text" name="lname" required><br>
            <input type="submit" value="Add Customer">
        </form>
    </div>

    <!-- Edit Customer Form -->
    <div id="editForm" style="display:none;">
        <form action="ManageCustomers.jsp" method="post">
            <input type="hidden" name="action" value="edit">
            <h2>Edit Customer</h2>
            Customer ID: <input type="number" name="customerId" required><br>
            First Name: <input type="text" name="fname" required><br>
            Last Name: <input type="text" name="lname" required><br>
            <input type="submit" value="Update Customer">
        </form>
    </div>
    <div id="deleteForm" style="display:none;">
        <form action="ManageCustomers.jsp" method="post">
            <input type="hidden" name="action" value="delete">
            <h2>Delete Customer</h2>
            Customer ID: <input type="number" name="customerId" required><br>
            <input type="submit" value="Delete Customer">
        </form>
    </div>
    

    <% 
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
