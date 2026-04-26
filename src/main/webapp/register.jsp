<%@ page language="java" contentType="text/html; charset=UTF-8" 
pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.io.*" %>

<!DOCTYPE html>
<html>
<head>
<title>Register Project</title>
<style>
  body { font-family: Arial, sans-serif; background-color: #f0f4f8; }
  h2 { color: #2c3e50; }
  table { background-color: #ECE5B6; width: 50%; }
  th { text-align: left; padding: 8px; }
  td { padding: 8px; }
  input[type=text], textarea { width: 100%; padding: 5px; }
  .success { background-color: #d4edda; color: #155724; padding: 10px; margin-top: 10px; }
  .error   { background-color: #f8d7da; color: #721c24; padding: 10px; margin-top: 10px; }
</style>
</head>
<body bgcolor="#ffffcc">

<h2>Register Your Project</h2>

<FORM action="register.jsp" method="post">
<TABLE border="1" width="50%">
  <TR>
    <TH width="40%">Team Name:</TH>
    <TD><INPUT TYPE="text" NAME="teamName" required></TD>
  </TR>
  <TR>
    <TH>Project Title:</TH>
    <TD><INPUT TYPE="text" NAME="projectTitle" required></TD>
  </TR>
  <TR>
    <TH>Description:</TH>
    <TD><textarea NAME="description" rows="3"></textarea></TD>
  </TR>
  <TR>
    <TH>Members (Name-RollNo, comma separated):</TH>
    <TD><INPUT TYPE="text" NAME="members" placeholder="Ravi-22CS01, Priya-22CS02"></TD>
  </TR>
  <TR>
    <TH></TH>
    <TD><INPUT TYPE="submit" VALUE="Submit Project"></TD>
  </TR>
</TABLE>
</FORM>

<%
// Only run when form is submitted
String teamName     = request.getParameter("teamName");
String projectTitle = request.getParameter("projectTitle");
String description  = request.getParameter("description");
String members      = request.getParameter("members");

if (teamName != null && projectTitle != null) {
    try {
    	Class.forName("com.mysql.cj.jdbc.Driver");
        Connection con = DriverManager.getConnection(
            "jdbc:mysql://localhost:3306/project_registry?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC", "root", "root");

        // ── Duplicate Check ──────────────────────────────────────────
        // Levenshtein Distance method (pure Java, no library needed)
        Statement st = con.createStatement();
        ResultSet rs = st.executeQuery("SELECT team_name, project_title FROM teams");

        String duplicateTeam = null;
        String duplicateTitle = null;

        while (rs.next()) {
            String existingTitle = rs.getString("project_title").toLowerCase().trim();
            String newTitle      = projectTitle.toLowerCase().trim();

            // Method 1: Levenshtein Distance
            int distance = levenshtein(newTitle, existingTitle);
            int maxLen   = Math.max(newTitle.length(), existingTitle.length());
            double levScore = (maxLen == 0) ? 1.0 : 1.0 - ((double) distance / maxLen);

            // Method 2: Jaccard Similarity on words
            String[] newWords      = newTitle.split("\\s+");
            String[] existingWords = existingTitle.split("\\s+");

            java.util.Set<String> setA = new java.util.HashSet<>();
            java.util.Set<String> setB = new java.util.HashSet<>();
            for (String w : newWords)      setA.add(w);
            for (String w : existingWords) setB.add(w);

            java.util.Set<String> intersection = new java.util.HashSet<>(setA);
            intersection.retainAll(setB);

            java.util.Set<String> union = new java.util.HashSet<>(setA);
            union.addAll(setB);

            double jaccardScore = (union.size() == 0) ? 0 : (double) intersection.size() / union.size();

            // Combined score
            double finalScore = (levScore * 0.8) + (jaccardScore * 0.2);

            if (finalScore >= 0.51) {
                duplicateTeam  = rs.getString("team_name");
                duplicateTitle = rs.getString("project_title");
                break;
            }
        }
        rs.close();
        st.close();
        // ── End Duplicate Check ──────────────────────────────────────

        if (duplicateTeam != null) {
%>
            <div class="error">
                ❌ <b>Submission Rejected!</b> Your project title "<%= projectTitle %>" 
                is too similar to <b><%= duplicateTeam %></b>'s project "<b><%= duplicateTitle %></b>".
                <br>Please choose a different and more unique topic.
            </div>
<%
        } else {
            // No duplicate — insert into DB
            PreparedStatement ps = con.prepareStatement(
                "INSERT INTO teams (team_name, project_title, description, members) VALUES (?,?,?,?)");
            ps.setString(1, teamName);
            ps.setString(2, projectTitle);
            ps.setString(3, description);
            ps.setString(4, members);
            int rows = ps.executeUpdate();
            ps.close();

            if (rows > 0) {
%>
                <div class="success">
                    ✅ <b>Project Registered Successfully!</b> 
                    <a href="index.jsp">View all teams →</a>
                </div>
<%
            }
        }
        con.close();
    } catch (Exception ex) {
        out.println("<div class='error'>Database error: " + ex.getMessage() + "</div>");
    }
}
%>

<%!
// Levenshtein Distance — pure Java, no external library needed
int levenshtein(String a, String b) {
    int[][] dp = new int[a.length() + 1][b.length() + 1];
    for (int i = 0; i <= a.length(); i++) dp[i][0] = i;
    for (int j = 0; j <= b.length(); j++) dp[0][j] = j;
    for (int i = 1; i <= a.length(); i++) {
        for (int j = 1; j <= b.length(); j++) {
            if (a.charAt(i-1) == b.charAt(j-1))
                dp[i][j] = dp[i-1][j-1];
            else
                dp[i][j] = 1 + Math.min(dp[i-1][j-1], Math.min(dp[i-1][j], dp[i][j-1]));
        }
    }
    return dp[a.length()][b.length()];
}
%>

<br><a href="index.jsp">← Back to Home</a>
</body>
</html>