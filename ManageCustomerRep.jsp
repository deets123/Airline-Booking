<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html>
<html>
<head>
    <title>Manage Customer Representatives</title>
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
    <h1>Manage Customer Representatives</h1>
    
    <form action="">
        <label for="actionSelect">Choose an Action:</label>
        <select name="action" id="actionSelect" onchange="showForm(this.value)">
            <option value="view">View Representatives</option>
            <option value="add">Add Representative</option>
            <option value="edit">Edit Representative</option>
            <option value="delete">Delete Representative</option>
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
                    String addSql = "INSERT INTO CustomerRepresentative (fname, lname) VALUES (?, ?)";
                    pstmt = conn.prepareStatement(addSql);
                    pstmt.setString(1, fname);
                    pstmt.setString(2, lname);
                    pstmt.executeUpdate();
                } else if ("edit".equals(action)) {
                    int repId = Integer.parseInt(request.getParameter("repId")); // Assuming repId is your primary key
                    String fname = request.getParameter("fname");
                    String lname = request.getParameter("lname");
                    String editSql = "UPDATE CustomerRepresentative SET fname = ?, lname = ? WHERE repId = ?";
                    pstmt = conn.prepareStatement(editSql);
                    pstmt.setString(1, fname);
                    pstmt.setString(2, lname);
                    pstmt.setInt(3, repId);
                    pstmt.executeUpdate();
                }
                else if ("delete".equals(action)) {
                    int repId = Integer.parseInt(request.getParameter("repId"));
                    String deleteSql = "DELETE FROM CustomerRepresentative WHERE repId = ?";
                    pstmt = conn.prepareStatement(deleteSql);
                    pstmt.setInt(1, repId);
                    pstmt.executeUpdate();
                }

                String viewSql = "SELECT * FROM CustomerRepresentative";
                pstmt = conn.prepareStatement(viewSql);
                rs = pstmt.executeQuery();
    %>

    <!-- View Representatives Form -->
    <div id="viewForm" style="display:none;">
        <h2>View Representatives</h2>
        <table>
            <tr>
                <th>Representative ID</th>
                <th>First Name</th>
                <th>Last Name</th>
            </tr>
            <% while (rs != null && rs.next()) { %>
                <tr>
                    <td><%= rs.getInt("repId") %></td>
                    <td><%= rs.getString("fname") %></td>
                    <td><%= rs.getString("lname") %></td>
                </tr>
            <% } %>
        </table>
    </div>

    <!-- Add Representative Form -->
    <div id="addForm" style="display:none;">
        <form action="ManageCustomerRep.jsp" method="post">
            <input type="hidden" name="action" value="add">
            <h2>Add Representative</h2>
            First Name: <input type="text" name="fname" required><br>
            Last Name: <input type="text" name="lname" required><br>
            <input type="submit" value="Add Representative">
        </form>
    </div>

    <!-- Edit Representative Form -->
    <div id="editForm" style="display:none;">
        <form action="ManageCustomerRep.jsp" method="post">
            <input type="hidden" name="action" value="edit">
            <h2>Edit Representative</h2>
            Representative ID: <input type="number" name="repId" required><br>
            First Name: <input type="text" name="fname" required><br>
            Last Name: <input type="text" name="lname" required><br>
            <input type="submit" value="Update Representative">
        </form>
    </div>

    <!-- Delete Representative Form -->
    <div id="deleteForm" style="display:none;">
        <form action="ManageCustomerRep.jsp" method="post">
            <input type="hidden" name="action" value="delete">
            <h2>Delete Representative</h2>
            Representative ID: <input type="number" name="repId" required><br>
            <input type="submit" value="Delete Representative">
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
