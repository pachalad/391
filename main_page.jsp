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
	response.sendRedirect("/Photosight/login.html");
	
}else{
%>
	<H1><CENTER>Photosight</CENTER></H1>
	<% 
	out.println("<H3><CENTER>Hey "+userID+"!</CENTER></H3>");
	%>
	<H3><CENTER>What do You Want to Do?</CENTER></H3>
	<CENTER>

	<a href="/Photosight/PictureBrowse?top" style="text-decoration: none">
   	<input type="submit" value="View Top Images" />
	</a>
	<br>
	<br>

	<FORM METHOD = LINK ACTION = 'PictureBrowse'>
	<INPUT TYPE= submit VALUE= 'View All Images'>
	</FORM>

	<FORM METHOD = LINK ACTION = 'searchModule.jsp'>
	<INPUT TYPE= submit VALUE= 'Search For Images'>
	</FORM>

	<FORM METHOD = LINK ACTION = uploading.jsp>
	<INPUT TYPE= submit VALUE='Upload Images'>
	</FORM>
	
	<FORM METHOD = 'LINK' ACTION = 'create_group.jsp'>
	<INPUT TYPE='submit' VALUE='Create Group'>
	</FORM>

	<FORM METHOD = 'LINK' ACTION = 'create_group.jsp'>
	<INPUT TYPE='submit' VALUE='Create Group'></FORM>

	<FORM METHOD = LINK ACTION = edit_groups.jsp>
	<INPUT TYPE= submit VALUE= 'Add Group Members'>
	</FORM>
	<FORM METHOD = LINK ACTION = removeGroupMembers.jsp>
	<INPUT TYPE= submit VALUE= 'Remove Group Members'>
	</FORM>
<%
userID = (String) session.getAttribute("userID");
if (userID.equals("admin")){
	out.println("<FORM METHOD = LINK ACTION = dataanalysis.jsp>");
	out.println("<INPUT TYPE= submit VALUE= 'Admin Data Analysis'>");
	out.println("</FORM>");
	
}
	
%>

	<FORM METHOD = LINK ACTION = logoutPage.jsp >
	<INPUT TYPE= submit VALUE= Logout>
	</FORM>
	<FORM METHOD = LINK ACTION = main_page.jsp>
	</FORM>
	</CENTER>

<% 	
}
%> 




</BODY>
</HTML>