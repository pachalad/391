<HTML>
<HEAD>


<TITLE>Edit Account</TITLE>
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
	String sql = "select p.first_name ,   from persons p, users u  where user_name = '"+userID+"'";

	try{
    	stmt = conn.createStatement();
        rset = stmt.executeQuery(sql);
	}

    catch(Exception ex){
        out.println("<hr>" + ex.getMessage() + "<hr>");
	}
	
	String existingUser = null;
	String existingUser = null;
	String existingUser = null;
	String existingUser = null;
	while(rset!= null && rset.next()){
		existingUser = (rset.getString(1)).trim();
	}
	
	out.println("<CENTER><h1>Photosight</h1></CENTER>");
	out.println("<CENTER>Edit Information!");
	out.println("<FORM action = create_account.jsp method = post>");
	out.println("<Table>");
	out.println("<TR VALIGN=TOP ALIGN=LEFT>");
	out.println("<TD><B><I> a Userid:</I></B></TD>");
	out.println("<TD><INPUT TYPE= text NAME= newUSERID ><BR></TD></TR>");
	out.println("<TR VALIGN=TOP ALIGN=LEFT><TD><B><I>a Password:</I></B></TD>");
	out.println("<TD><INPUT TYPE= password create_accountNAME=newPASSWD><BR></TD></TR>");
	out.println("<TR VALIGN=TOP ALIGN=LEFT><TD><B><I>Your First Name:</I></B></TD>");
	out.println("<TD><INPUT TYPE=text NAME=newFIRSTNAME><BR></TD></TR>");
	out.println("<TR VALIGN=TOP ALIGN=LEFT><TD><B><I>Your Last Name:</I></B></TD>");
	out.println("<TD><INPUT TYPE= text NAME= newLASTNAME><BR></TD></TR>");
	out.println("<TR VALIGN=TOP ALIGN=LEFT><TD><B><I>Your Address:</CENTER></I></B></TD>");
	out.println("<TD><INPUT TYPE=text NAME=newADDRESS><BR></TD></TR>"); 
	out.println("<TR VALIGN=TOP ALIGN=LEFT><TD><B><I>Your Email:</I></B></TD>");
	out.println("<TD><INPUT TYPE=text NAME=newEMAIL><BR></TD></TR>");
	out.println("<TR VALIGN=TOP ALIGN=LEFT><TD><B><I>Your Telephone Number:</CENTER></I></B></TD>");
	out.println("<TD><INPUT TYPE=text NAME=newPHONE><BR></TD></TR></TABLE>");
	out.println("<INPUT TYPE=submit NAME=bRegister VALUE=Submit></FORM>");
	out.println("</FORM></CENTER>");

}


%>
</BODY>
</HTML>


 select password, first_name, last_name, address, email, phone
  2  from users INNER JOIN persons ON users.user_name = persons.user_name
  3  WHERE persons.user_name = 'dp'
  4  ;
