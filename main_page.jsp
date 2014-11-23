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
	/*
	out.println("<CENTER>");    
    out.println("<h1>Photosight</h1>");
	out.println("<FORM METHOD = link ACTION = login.html>");
	out.println("<INPUT TYPE= submit VALUE = Login>");
	out.println("</FORM>");
	out.println("</CENTER>");
	*/
	
	response.sendRedirect("/Photosight/login.html");
}
%>
	<H1><CENTER>Photosight</CENTER></H1>
	
	<% 
	out.println("<H3><CENTER>Hey "+userID+"!</CENTER></H3>");
<<<<<<< HEAD
	out.println("<H3><CENTER>What do You Want to Do?</CENTER></H3>");
	out.println("<CENTER>");
	out.println("<FORM METHOD = LINK ACTION = main_page.jsp>");
	out.println("<INPUT TYPE= submit VALUE= 'View Images'>");
	out.println("</FORM>");
	out.println("<FORM METHOD = 'LINK' ACTION = 'create_group.jsp'><INPUT TYPE='submit' VALUE='Create Group'></FORM>");
	out.println("<FORM METHOD = LINK ACTION = edit_groups.jsp>");
	out.println("<INPUT TYPE= submit VALUE= 'Edit Groups'>");
	out.println("</FORM>");
	out.println("<FORM METHOD = LINK ACTION = uploading.jsp>");
	out.println("<INPUT TYPE= submit VALUE='Upload Images'>");
	out.println("</FORM>");
	out.println("<FORM METHOD = LINK ACTION = main_page.jsp>");
	out.println("<INPUT TYPE= submit VALUE= Search>");
	out.println("</FORM>");
	out.println("<FORM METHOD = LINK ACTION = main_page.jsp >");
	out.println("<INPUT TYPE= submit VALUE= Logout>");
	out.println("</FORM>");
	out.println("<FORM METHOD = LINK ACTION = main_page.jsp>");
	out.println("</FORM>");
	out.println("</CENTER>");
=======
	%>
	<H3><CENTER>What do You Want to Do?</CENTER></H3>
	<CENTER>
	<FORM METHOD = LINK ACTION = main_page.jsp>
	<INPUT TYPE= submit VALUE= 'View Images'>
	</FORM>
	<FORM METHOD = 'LINK' ACTION = 'create_group.jsp'><INPUT TYPE='submit' VALUE='Create Group'></FORM>
	<FORM METHOD = LINK ACTION = main_page.jsp>
	<INPUT TYPE= submit VALUE= 'My Groups'>
	</FORM>
	<FORM METHOD = LINK ACTION = uploading.jsp>
	<INPUT TYPE= submit VALUE='Upload Images'>
	</FORM>
	<FORM METHOD = LINK ACTION = main_page.jsp>
	<INPUT TYPE= submit VALUE= Search>
	</FORM>
	<FORM METHOD = LINK ACTION = main_page.jsp >
	<INPUT TYPE= submit VALUE= Logout>
	</FORM>
	<FORM METHOD = LINK ACTION = main_page.jsp>
	</FORM>
	</CENTER>
>>>>>>> 768992f5650bc6ca4f22213b86d19c539c8cbde9
	
}





</BODY>
</HTML>