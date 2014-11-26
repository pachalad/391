
<html>
<head> DATA ANALYSIS EXTREME </head>
<%
	// Check to see if user is admin otherwise redirects to login.
	String userID=(String) session.getAttribute("userID");
	if (!userID.equals("admin")){
		response.sendRedirect("/Photosight/login.html");
	}
	%>
<hr>
<body>
Pick the two items you want to query!<br>
<!-- This grabs the admins choices for the data analysis. -->
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
	</select><br>
Username: <input type="text" name=user><br>
Subject: <input type="text" name=sub><br>
Time:<br>
From(Format YYYY-MM-DD):<input type="text" name=startdate><br>
To(Format YYYY-MM-DD):<input type="text" name=enddate><br>
Select timing type:<br>
<input type="radio" name="timetype" value="year">Year
<input type="radio" name="timetype" value="month">Month
<input type="radio" name="timetype" value="week">Week

<input type=submit name=submit value=Analyze!>
</form><br>


	

</body>
</html>



