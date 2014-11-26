<%@ page import="java.sql.*,java.util.*,java.text.*,java.net.*,javax.servlet.*,javax.servlet.http.*"%>
<html>
<HEAD>


<TITLE>Upload Photos</TITLE>
</HEAD>
<body>

<% 
	Boolean print;
	// If no session ID, print a page that lets the user return
	// to the homepage.
	if (session.getAttribute("userID") == null) {
	    // Session is not created.
		out.println("<CENTER>");    
	    out.println("<h1>Photosight</h1>");
		out.println("<FORM METHOD = link ACTION = login.html>");
		out.println("<INPUT TYPE= submit VALUE = Login>");
		out.println("</FORM>");
		out.println("</CENTER>");
		// If a session exists, print the uploading webpage.
	} else{
		out.println("<CENTER><h1>Photosight</h1>");
		out.println("<h2>Uploading pictures!</h2>");
		out.println("Add information to the picture! You need to click the bottom upload!<br></CENTER>");
		out.println("<form action='MUploadInfo' method='post'>");
		// User needs to put in number of photos they plan to upload otherwise this wont work.
		out.println("Number of photos:<input type='text' name='numofphotos'><br>");
		String userID = (String)session.getAttribute("userID");
		out.println(" <input type=hidden name=userID value="+userID+"> ");
		// Database stuff.
		String username = "kboyle";
		String password = "kieran92";
		String dbstring = "jdbc:oracle:thin:@gwynne.cs.ualberta.ca:1521:CRS ";
		String driverName = "oracle.jdbc.driver.OracleDriver";
		// This query grabs all the groups the user can post pictures to.
		String query = "select group_name from groups where user_name='"+userID+"' or group_id=1 or group_id=2";
		String group;
		// Register and query Database.
		Class drvClass1 = Class.forName(driverName);
		DriverManager.registerDriver((Driver) drvClass1.newInstance());
		Connection conn1 = DriverManager.getConnection(dbstring,username,password);
		Statement stmt1 = conn1.createStatement();
		ResultSet rset1 = stmt1.executeQuery(query);
		// Create a dropdown where the user can choose the group.
		out.println("Permission:<select name='permission'>");
		while (rset1.next()) {
			group = rset1.getObject(1).toString();
			// Defaults choice to private.
			if (group.equals("private")){
				out.println("<option selected=selected value="+'"'+group+'"'+'>'+group+"</option>");
			}else{out.println("<option value="+'"'+group+'"'+'>'+group+"</option>");}
			}
		stmt1.close();
		conn1.close();
		// Grabs the rest of the user info for the pics.
		out.println("</select><br>");
		out.println("Subject:<input type='text' name='subject'><br>");
		out.println("Place:<input type='text' name='place'><br>");
		out.println("Description:<textarea name='description'></textarea><br>");
		out.println("Date:<br>");
		out.println("Year(YYYY format):<input type='text' name='year'><br>");
		out.println("Month(MM format):<input type='text' name='month'><br>");
		out.println("Day(DD format):<input type='text' name='day'><br>");
		out.println("<input type='submit' name='submit' value='Upload'><br>");
		out.println("</form>");

		// In this part the user adds uploads pictures.
		out.println("<form action='MUploadImage' method = 'post' enctype='multipart/form-data'>");
		out.println("Please select the path of the images!<br>");
		out.println("File Path:<input name='file-path' type='file' size='30' multiple='' ></input><br>");
		out.println("<input type='submit' name='submit' value='Upload'><br>");
		out.println("</form><br>");
	}
%>
</body>
</html>
