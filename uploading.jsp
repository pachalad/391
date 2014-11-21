<%@ page import="java.sql.*,java.util.*,java.text.*,java.net.*,javax.servlet.*,javax.servlet.http.*"%>
<html>
<head> Uploading pictures!</head>
<hr>
<body>

Add information to the picture! You need to click the bottom upload!<br>
<form action="UploadInfo" method="post">
Permission:<select name="permission">
	  <% 	String username = "pachala";
		String password = "Cheapradio1";
		String dbstring = "jdbc:oracle:thin:@gwynne.cs.ualberta.ca:1521:CRS ";
		String driverName = "oracle.jdbc.driver.OracleDriver";
		String query = "select group_name from groups"; //where user_name='"+userID+"' or group_id=1 or group_id=2";
		String group;
		Class drvClass = Class.forName(driverName);
	    DriverManager.registerDriver((Driver) drvClass.newInstance());
		Connection conn = DriverManager.getConnection(dbstring,username,password);
		Statement stmt = conn.createStatement();
		ResultSet rset = stmt.executeQuery(query);
		while (rset.next()) {
			group = rset.getObject(1).toString();
		     	out.println("<option value="+'"'+group+'"'+'>'+group+"</option>");
			 }
		stmt.close();
		conn.close();
	%>
	    </select><br>
Subject:<input type="text" name="subject"><br>
Place:<input type="text" name="place"><br>
Description:<textarea name="description"></textarea><br>
Date:<br>
Year(YYYY format):<input type="text" name="year"><br>
Month(MM format):<input type="text" name="month"><br>
Day(DD format):<input type="text" name="day"><br>
<input type="submit" name="submit" value="Upload">
</form><br>

<form action="UploadImage" method="post" enctype="multipart/form-data" >
Please input or select the path of the image!<br>
File path:<input name="file-path" type="file" size="30" ></input><br>
<input type="submit" name="submit" value="Upload"><br>
</form><br>

<b>Or upload a folder!</b><br>
<hr>
Add information to the picture! You need to click the bottom upload!<br>
<form action="MUploadInfo" method="post">
Number of photos:<input type="text" name="numofphotos"><br>
Permission:<select name="permission">
	  <% 
		Class drvClass1 = Class.forName(driverName);
	    DriverManager.registerDriver((Driver) drvClass1.newInstance());
		Connection conn1 = DriverManager.getConnection(dbstring,username,password);
		Statement stmt1 = conn1.createStatement();
		ResultSet rset1 = stmt1.executeQuery(query);
		while (rset1.next()) {
			group = rset1.getObject(1).toString();
		     	out.println("<option value="+'"'+group+'"'+'>'+group+"</option>");
			 }
		stmt.close();
		conn.close();
	%>
	    </select><br>
Subject:<input type="text" name="subject"><br>
Place:<input type="text" name="place"><br>
Description:<textarea name="description"></textarea><br>
Date:<br>
Year(YYYY format):<input type="text" name="year"><br>
Month(MM format):<input type="text" name="month"><br>
Day(DD format):<input type="text" name="day"><br>
<input type="submit" name="submit" value="Upload"><br>
</form>

<form action="MUploadImage" method = "post" enctype="multipart/form-data">
Please select the path of the images!<br>
File Path:<input name="file-path" type="file" size="30" multiple="" ></input><br>
<input type="submit" name="submit" value="Upload"><br>
</form><br>


<form action=/proj1/home.html>
    	<input type="submit" value="Back to home">
</form>
</body>
</html>
