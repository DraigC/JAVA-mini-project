<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
     <%@ page import="java.sql.*" %>
<%@ page import="java.io.*" %>
<%
String teamId = request.getParameter("teamId");
try {
	Class.forName("com.mysql.cj.jdbc.Driver");
	Connection con = DriverManager.getConnection(
        "jdbc:mysql://localhost:3306/project_registry?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC", "root", "root");
    PreparedStatement ps = con.prepareStatement("DELETE FROM teams WHERE team_id = ?");
    ps.setInt(1, Integer.parseInt(teamId));
    ps.executeUpdate();
    ps.close(); con.close();
} catch (Exception ex) {
    out.println("Error: " + ex.getMessage());
}
response.sendRedirect("index.jsp");
%>