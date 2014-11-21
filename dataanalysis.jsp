<%@ page import="java.sql.*,java.util.*,java.text.*,java.net.*,javax.servlet.*,javax.servlet.http.*,java.lang.String"%>
<html>
<head> DATA ANALYSIS EXTREME </head>
<hr>
<body>
Pick the two items you want to query!<br>


<%
	out.println("<form action=dataanalysis.jsp method=post>");
	out.println("X variable:");
	out.println("<select name=x>");
	out.println("<option value=subject> subject </option>");
	out.println("<option value=user> user </option>");
	out.println("<option value =time> time </time>");
	out.println("</select><br>");
	out.println("Y variable:");
	out.println("<select name=y>");
	out.println("<option value=subject> subject </option>");
	out.println("<option value=user> user </option>");
	out.println("<option value =time> time </time>");
	out.println("</select><br>");

	String x = request.getParameter("x");
	String y =request.getParameter("y");

	if ("time".equals(x) || "time".equals(y)){
		out.println("<select name=specs>");
		out.println("<option value=year> year </option>");
		out.println("<option value=month> month </option>");
		out.println("<option value=day> day </option>");
		out.println("</select><br>");
	}
	out.println("<input type=submit name=submit value=Analyze!>");
	out.println("</form><br>");
%>

	

</body>
</html>



