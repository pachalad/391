<HTML>
<HEAD>


<TITLE>Main</TITLE>
</HEAD>

<BODY>
<%@ page import="java.sql.*" %>

<%
	session.invalidate();
	response.sendRedirect("/Photosight/login.html");
	
	

%>

</BODY>
</HTML>