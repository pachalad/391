<%@ page import="java.sql.*,java.util.*,java.text.*,java.net.*,javax.servlet.*,javax.servlet.http.*,java.util.*"%>
<html>
<head> DATA ANALYSIS EXTREME </head>
<hr>
<body>
<%
	String start=request.getParameter("startdate");
	String ends =request.getParameter("enddate");
	String timetype =request.getParameter("timetype");
	out.println(start);
	out.println(ends);
	out.println(timetype);
%>

</body>
</html>