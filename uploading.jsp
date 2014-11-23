<%@ page import="java.sql.*,java.util.*,java.text.*,java.net.*,javax.servlet.*,javax.servlet.http.*"%>
<html>
<HEAD>


<TITLE>Upload Photos</TITLE>
</HEAD>
<body>

<% 
	Boolean print;
	if (session.getAttribute("userID") == null) {
	    // Session is not created.
		out.println("<CENTER>");    
	    out.println("<h1>Photosight</h1>");
		out.println("<FORM METHOD = link ACTION = login.html>");
		out.println("<INPUT TYPE= submit VALUE = Login>");
		out.println("</FORM>");
		out.println("</CENTER>");
	} else{

		//out.println("<b>Or upload a folder!</b><br>");
		//out.println("<hr>");
		out.println("<CENTER><h1>Photosight</h1>");
		out.println("<h2>Uploading pictures!</h2>");
		out.println("Add information to the picture! You need to click the bottom upload!<br></CENTER>");
		out.println("<form action='MUploadInfo' method='post'>");
		out.println("Number of photos:<input type='text' name='numofphotos'><br>");
		String userID = (String)session.getAttribute("userID");
		out.println("<input tupe = hidden name = userID value = '"+userID+"'");
		out.println(" <input type=hidden name=userID value="+userID+"> ");
		String username = "kboyle";
		String password = "kieran92";
		String dbstring = "jdbc:oracle:thin:@gwynne.cs.ualberta.ca:1521:CRS ";
		String driverName = "oracle.jdbc.driver.OracleDriver";
		String query = "select group_name from groups where user_name='"+userID+"' or group_id=1 or group_id=2";
		String group;
		Class drvClass1 = Class.forName(driverName);
		DriverManager.registerDriver((Driver) drvClass1.newInstance());
		Connection conn1 = DriverManager.getConnection(dbstring,username,password);
		Statement stmt1 = conn1.createStatement();
		ResultSet rset1 = stmt1.executeQuery(query);
		out.println("Permission:<select name='permission'>");
		while (rset1.next()) {
			group = rset1.getObject(1).toString();
			out.println("<option value="+'"'+group+'"'+'>'+group+"</option>");
			}
		stmt1.close();
		conn1.close();
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
		out.println("<form action='MUploadImage' method = 'post' enctype='multipart/form-data'>");
		out.println("Please select the path of the images!<br>");
		out.println("File Path:<input name='file-path' type='file' size='30' multiple='' ></input><br>");
		out.println("<input type='submit' name='submit' value='Upload'><br>");
		out.println("</form><br>");
	}
%>
</body>
</html>
