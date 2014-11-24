<%@ page import="java.sql.*,java.util.*,java.text.*,java.net.*,javax.servlet.*,javax.servlet.http.*"%>
<html>
<HEAD>


<TITLE>Update Photos</TITLE>
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
	} else {
	
		out.println("<CENTER><h1>Photosight</h1>");
		out.println("<h2>Edit Picture Info</h2>");
		out.println("Add information to the picture!<br></CENTER>");
		out.println("<form action='UpdatePicture' method='post'>");
		String userID = (String)session.getAttribute("userID");
		out.println(" <input type=hidden name=userID value="+userID+"> ");
		String picID = request.getParameter("picID");
		out.println(" <input type=hidden name=picID value="+picID+"> ");
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
		
		String infoQuery = "SELECT owner_name, subject, place, timing, description " +
							"FROM images WHERE photo_id=" + picID;
		Class drvClass2 = Class.forName(driverName);
		DriverManager.registerDriver((Driver) drvClass2.newInstance());
		Connection conn2 = DriverManager.getConnection(dbstring,username,password);
		Statement stmt2 = conn2.createStatement();
		ResultSet rset2 = stmt2.executeQuery(infoQuery);
		
        String owner_name, subject, place, timing, description, year, month, day;

	    if ( rset2.next() ) {
	    	owner_name = rset2.getString("owner_name");
	    	subject = rset2.getString("subject");
	        place = rset2.getString("place");
	        timing = rset2.getString("timing");
	        description = rset2.getString("description");
	        
	       	String delimiter = "-";
	        String[] temp;
	        temp = timing.split(delimiter);
	        year = temp[0];
	        month = temp[1];
	        day = temp[2];
	        
			out.println("<input type='hidden' name='picID' value = " + picID +">");
			out.println("Subject:<textarea name='subject'>"+subject.trim()+"</textarea><br>");
			out.println("Place:<textarea name='place'>"+place.trim()+"</textarea><br>");
			out.println("Description:<textarea name='description'>"+description.trim()+"</textarea><br>");
			out.println("Date:<br>");
			out.println("Year(YYYY format):<input type='text' name='year' value = " + year +"><br>");
			out.println("Month(MM format):<input type='text' name='month' value = " + month +"><br>");
			out.println("Day(DD format):<input type='text' name='day' value = " + day +"><br>");
			out.println("<input type='submit' name='update' value='Update'><br>");
			out.println("</form>");
	    }
		else {
			out.println("<html> Pictures are not avialable</html>");
		}
	}
%>
</body>
</html>
