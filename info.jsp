<html>
<head></head>
<body>
<br>
<%
  String permission = request.getParameter("permission");
  String subject = request.getParameter("subject");
  String place = request.getParameter("place");
  String desc = request.getParameter("description");
  out.print(permission);
  out.print(subject);
  out.print(place);
  out.print(desc);
%>
</body>
</html>
