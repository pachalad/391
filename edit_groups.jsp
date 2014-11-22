<HTML>
<HEAD>


<TITLE>Main</TITLE>
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
	
	
}





%>
</BODY>
</HTML>