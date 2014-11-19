<HTML>
<HEAD>


<TITLE>Main</TITLE>
</HEAD>

<BODY>
<%@ page import="java.sql.*" %>
<% 
//HttpSession session = request.getSession(true);
//session = request.getSession(false);
//session.getId();
//String sessId = (String)session.getId();
//out.println("is this a problem "+sessId);
String userID = (String) session.getAttribute("userID");
String userKeyID = (String) session.getAttribute("userIDKey");
//out.println("this the user id"+userID);
//out.println("this is the user key"+userKeyID );
if (session.getAttribute("userID") == null) {
    // Session is not created.
	out.println("<CENTER>");    
    out.println("<h1>Photosight</h1>");
	out.println("<FORM METHOD = link ACTION = login.html>");
	out.println("<INPUT TYPE= submit VALUE = Login>");
	out.println("</FORM>");
	out.println("</CENTER>");


} else {
	out.println("<H1><CENTER>Photosight</CENTER></H1>");
	out.println("<H3><CENTER>Hey "+userID+"!</CENTER></H3>");
	out.println("<H3><CENTER>What do You Want to Do?</CENTER></H3>");
	out.println("<CENTER>");
	out.println("<FORM METHOD = LINK ACTION = main_page.html>");
	out.println("<INPUT TYPE= submit VALUE= 'View Images'>");
	out.println("</FORM>");
	out.println("<FORM METHOD = 'LINK' ACTION = 'main_page.html'><INPUT TYPE='submit' VALUE='Create Group'></FORM>");
	out.println("<FORM METHOD = LINK ACTION = main_page.html>");
	out.println("<INPUT TYPE= submit VALUE= 'My Groups'>");
	out.println("</FORM>");
	out.println("<FORM METHOD = LINK ACTION = main_page.html>");
	out.println("<INPUT TYPE= submit VALUE='Upload Images'>");
	out.println("</FORM>");
	out.println("<FORM METHOD = LINK ACTION = main_page.html>");
	out.println("<INPUT TYPE= submit VALUE= Search>");
	out.println("</FORM>");
	out.println("<FORM METHOD = LINK ACTION = main_page.html >");
	out.println("<INPUT TYPE= submit VALUE= Logout>");
	out.println("</FORM>");
	out.println("<FORM METHOD = LINK ACTION = main_page.html >");
	out.println("</FORM>");
	out.println("</CENTER>");
	
	out.println();
//	out.println();
//	out.println();	
//	out.println();
//	out.println();
//	out.println();
//	out.println();


    // Session is already created.
}



//E696B98B86C51816953CE8AD841766E5



%>
</BODY>
</HTML>