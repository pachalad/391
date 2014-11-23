<HTML>
<HEAD>


<TITLE>Remove Group Members</TITLE>
</HEAD>

<BODY>
<%@ page import="java.sql.*" %>
<% 
String userID = (String) session.getAttribute("userID");
String userKeyID = (String) session.getAttribute("userIDKey");
if (session.getAttribute("userID") == null) {
    // Session is not created.
	out.println("<CENTER>");    
    out.println("<h1>Photosight</h1>");
	out.println("<FORM METHOD = link ACTION = login.html>");
	out.println("<INPUT TYPE= submit VALUE = Login>");
	out.println("</FORM>");
	out.println("</CENTER>");


} else {
	out.println("<form method=post action= removeGroupMembers.jsp>");
	out.println("<H1><CENTER>Photosight</CENTER></H1>");
	out.println("<H2><CENTER>Remove Group Members</CENTER></H2>");
	//out.println("Hey "+userID+"!");
	//out.println("Let's edit some groups");
	out.println("Enter the group name of which you need to remove someone from: <input type=text name = GROUPNAME maxlength=20><br>");
	out.println("Enter the Person who you wish to remove: <input type=text name = PERSON maxlength=20><br>");
	out.println("<input type=submit name=bRemovePerson value=Remove!><br>");
	out.println("</form>");
	if(request.getParameter("bRemovePerson") != null)
    {
		String groupName = (request.getParameter("GROUPNAME")).trim();
		String groupUserID = (request.getParameter("PERSON")).trim();
		Connection conn = null;
		String driverName = "oracle.jdbc.driver.OracleDriver";
        String dbstring = "jdbc:oracle:thin:@gwynne.cs.ualberta.ca:1521:CRS";
        try{
	        //load and register the driver
    		Class drvClass = Class.forName(driverName); 
        	DriverManager.registerDriver((Driver) drvClass.newInstance());
    	}
        catch(Exception ex){
	        out.println("<hr>" + ex.getMessage() + "<hr>");

        }
    	try{
        	//establish the connection 
	        conn = DriverManager.getConnection(dbstring,"kboyle","kieran92");
    		conn.setAutoCommit(false);
        }
    	catch(Exception ex){
        
	        out.println("<hr>" + ex.getMessage() + "<hr>");
    	}
    	Statement stmt = null;
        ResultSet rset = null;
        String sql = "select group_id from groups where group_name = '"+groupName+"' AND user_name = '"+userID+"'";
    	try{
        	stmt = conn.createStatement();
	        rset = stmt.executeQuery(sql);
    	}

        catch(Exception ex){
        	out.println("here is the problem when looking for groups");
	        out.println("<hr>" + ex.getMessage() + "<hr>");
    	}
    	String existingGroup = null;
		while(rset!= null && rset.next()){
			existingGroup = (rset.getString(1)).trim();
		}
		
		Statement stmtPerson = null;
        ResultSet rsetPerson = null;
        sql = "select user_name from users where user_name = '"+groupUserID+"'";
    	try{
        	stmtPerson = conn.createStatement();
	        rsetPerson = stmt.executeQuery(sql);
    	}

        catch(Exception ex){
	        out.println("<hr>" + ex.getMessage() + "<hr>");
    	}
    	
    	String existingPerson = null;
		
    	
    	while(rsetPerson!= null && rsetPerson.next()){
			existingPerson = (rsetPerson.getString(1)).trim();
		}
		if(existingGroup != null && existingPerson != null){
			stmt = null;
			sql = "DELETE FROM group_lists WHERE group_id = "+existingGroup+" AND friend_id ='"+existingPerson+"' ";
	    	try{
	        	stmt = conn.createStatement();
		        stmt.executeUpdate(sql);
		        conn.commit();
	    	}

	        catch(Exception ex){
	        	out.println("<b>there is a problem with adding a person into a group</b>");
		        out.println("<hr>" + ex.getMessage() + "<hr>");
	    	}
	    	out.println("<CENTER><h2>"+existingPerson+" has been removed from "+groupName+"</h2>");
	    	out.println("<FORM METHOD = link ACTION = edit_groups.jsp>");
	    	out.println("</FORM>");
	    	out.println("</CENTER>");

		}else{
			out.println("<CENTER><h1>person or group does not exist</h1></CENTER>");
			
		}
    }
}


%>
</BODY>
</HTML>
