<%@ page language="java" contentType="text/html; charset=UTF-8" 
pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.io.*" %>

<!DOCTYPE html>
<html>
<head>
<title>Project Registry</title>
<style>
  body  { font-family: Arial; background-color: #f0f4f8; }
  h2    { color: #2c3e50; }
  table { border-collapse: collapse; width: 90%; background-color: #ffffcc; }
  th, td { border: 1px solid #aaa; padding: 10px; text-align: left; }
  th    { background-color: #2c3e50; color: white; }
  tr:nth-child(even) { background-color: #f2f2f2; }
  .btn-delete { background: #e74c3c; color: white; border: none; padding: 5px 10px; cursor: pointer; }
  .btn-edit   { background: #3498db; color: white; border: none; padding: 5px 10px; cursor: pointer; }
</style>
</head>
<body>

<h2>📋 Registered Projects</h2>
<a href="register.jsp"><button>+ Register New Project</button></a>
<br><br>

<%
try {
	Class.forName("com.mysql.cj.jdbc.Driver");
    Connection con = DriverManager.getConnection(
        "jdbc:mysql://localhost:3306/project_registry?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC", "root", "root");
    Statement st = con.createStatement();
    ResultSet rs = st.executeQuery("SELECT * FROM teams");
%>

<TABLE cellpadding="10" border="1">
  <tr>
    <th>#</th>
    <th>Team Name</th>
    <th>Project Title</th>
    <th>Description</th>
    <th>Members</th>
    <th>Actions</th>
  </tr>

<%
    int count = 0;
    while (rs.next()) {
        count++;
%>
  <TR>
    <TD><%= rs.getInt("team_id") %></TD>
    <TD><%= rs.getString("team_name") %></TD>
    <TD><b><%= rs.getString("project_title") %></b></TD>
    <TD><%= rs.getString("description") %></TD>
    <TD><%= rs.getString("members") %></TD>
    <TD>
      <FORM action="delete.jsp" method="post" style="display:inline">
        <input type="hidden" name="teamId" value="<%= rs.getInt("team_id") %>">
        <button class="btn-delete" type="submit">Delete</button>
      </FORM>
      &nbsp;
      <FORM action="edit.jsp" method="get" style="display:inline">
        <input type="hidden" name="teamId" value="<%= rs.getInt("team_id") %>">
        <button class="btn-edit" type="submit">Edit</button>
      </FORM>
    </TD>
  </TR>
<%
    }
    if (count == 0) {
        out.println("<TR><TD colspan='6' align='center'>No projects registered yet.</TD></TR>");
    }
    rs.close(); st.close(); con.close();
} catch (Exception ex) {
    out.println("<p style='color:red'>DB Error: " + ex.getMessage() + "</p>");
}
%>
</TABLE>
</body>
</html>