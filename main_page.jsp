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
if (session.isNew()) {
    // Session is not created.
	out.println("<CENTER>");    
    out.println("<h1>Photosight</h1>");
	out.println("<FORM METHOD = link ACTION = login.html>");
	out.println("<INPUT TYPE= submit VALUE = Login>");
	out.println("</FORM>");
	out.println("</CENTER>");


} else {
	out.println("<h1>Photosight</h1>");
	out.println("wait what");
    // Session is already created.
}



//E696B98B86C51816953CE8AD841766E5



%>
</BODY>
</HTML>