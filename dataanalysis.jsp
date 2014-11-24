
<html>
<head> DATA ANALYSIS EXTREME </head>
<%
	String userID=(String) session.getAttribute("userID");
	if (!userID.equals("admin")){
		response.sendRedirect("/Photosight/login.html");
	}
	%>
<hr>
<body>
Pick the two items you want to query!<br>
<form action=analysis.jsp method=post>
	X variable:
	<select name=x>
		<option value = subject> subject </option>
		<option value = owner_name> user </option>
		<option value = timing> time </time>
	</select><br>
	Y variable:
	<select name=y>
		<option value = subject> subject </option>
		<option value = owner_name> user </option> 
		<option value = timing> time </time>
	</select><br>
<input type=hidden name=timetype value=year>
<input type=submit name=submit value=Analyze!>
</form><br>


	

</body>
</html>



