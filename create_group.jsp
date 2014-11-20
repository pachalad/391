<HTML>
<HEAD>


<TITLE>Create Group</TITLE>
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
}else{
	
	out.println("the session user is: "+userID);
	out.println("<form method=post action=create_group.jsp><CENTER>");
	out.println("<h1>Photosight</h1>");
	out.println("<h2>Let's Make a Group</h2>");
	out.println("Enter a Group Name: <input type=text name = GROUPNAME maxlength=20><br>");
	out.println("<input type=submit name=bCreate value=Create!><br>");
	out.println("</CENTER></form>");
	
	if(request.getParameter("bSubmit") != null)
     {
		String groupName = (request.getParameter("GROUPNAME")).trim();
		//establish the connection to the underlying database
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
    	String sql = "select group_name from groups where group_name = '"+groupName+"' AND user_name = '"+userID+"'";
    	try{
        	stmt = conn.createStatement();
	        rset = stmt.executeQuery(sql);
    	}

        catch(Exception ex){
	        out.println("<hr>" + ex.getMessage() + "<hr>");
    	}
		String existingGroup = null;
		
		while(rset!= null && rset.next()){
			existingGroup = (rset.getString(1)).trim();
		}
		
		if(existingGroup == null){
			
		}
        
		
     }
	
	
}


%>
</BODY>
</HTML>