<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ page import="java.sql.*" %>
<%@ page import="java.io.*" %>
    
<!DOCTYPE html>
<html>
<head><title>Edit Team</title>
<style>
  body { font-family: Arial; background: #f0f4f8; }
  table { background-color: #ECE5B6; width: 50%; }
  th, td { padding: 8px; }
  input[type=text], textarea { width: 100%; }
  .success { background:#d4edda; color:#155724; padding:10px; }
</style>
</head>
<body>
<h2>Edit Project</h2>

<%
String teamId = request.getParameter("teamId");
String action = request.getParameter("action");

Connection con = null;
try {
	Class.forName("com.mysql.cj.jdbc.Driver");
    con = DriverManager.getConnection(
        "jdbc:mysql://localhost:3306/project_registry?useSSL=false&serverTimezone=UTC", "root", "root");

    // Handle Update submit
    if ("update".equals(action)) {
        PreparedStatement ps = con.prepareStatement(
            "UPDATE teams SET team_name=?, project_title=?, description=?, members=? WHERE team_id=?");
        ps.setString(1, request.getParameter("teamName"));
        ps.setString(2, request.getParameter("projectTitle"));
        ps.setString(3, request.getParameter("description"));
        ps.setString(4, request.getParameter("members"));
        ps.setInt(5, Integer.parseInt(teamId));
        ps.executeUpdate();
        ps.close();
%>
        <div class="success">✅ Updated successfully! <a href="index.jsp">Back to Home</a></div>
<%
    } else {
        // Load existing data into form
        PreparedStatement ps = con.prepareStatement("SELECT * FROM teams WHERE team_id=?");
        ps.setInt(1, Integer.parseInt(teamId));
        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
%>
<FORM action="edit.jsp" method="post">
  <input type="hidden" name="teamId" value="<%= teamId %>">
  <input type="hidden" name="action" value="update">
  <TABLE border="1" width="50%">
    <TR><TH>Team Name:</TH>
        <TD><INPUT TYPE="text" NAME="teamName" value="<%= rs.getString("team_name") %>"></TD></TR>
    <TR><TH>Project Title:</TH>
        <TD><INPUT TYPE="text" NAME="projectTitle" value="<%= rs.getString("project_title") %>"></TD></TR>
    <TR><TH>Description:</TH>
        <TD><textarea NAME="description"><%= rs.getString("description") %></textarea></TD></TR>
    <TR><TH>Members:</TH>
        <TD><INPUT TYPE="text" NAME="members" value="<%= rs.getString("members") %>"></TD></TR>
    <TR><TH></TH><TD><INPUT TYPE="submit" VALUE="Update"></TD></TR>
  </TABLE>
</FORM>
<%
        }
        rs.close(); ps.close();
    }
    con.close();
} catch (Exception ex) {
    out.println("<p style='color:red'>Error: " + ex.getMessage() + "</p>");
}
%>
<br><a href="index.jsp">← Back</a>
</body>
</html>