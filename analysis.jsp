<%@ page import="java.sql.*,java.util.*,java.text.*,java.net.*,javax.servlet.*,javax.servlet.http.*,java.util.*"%>
<html>
<body>

<%
	String x=request.getParameter("x");
	String y=request.getParameter("y");
	ArrayList<String> xarray=new ArrayList<String>();
	ArrayList<String> yarray=new ArrayList<String>();
	ArrayList<String> results=new ArrayList<String>();
	ArrayList<String> xclean = new ArrayList<String>();
	ArrayList<String> yclean = new ArrayList<String>();
	xclean.add("Picture count!");

	String timetype=request.getParameter("timetype");
	String time=request.getParameter("time");
	String username = "pachala";
	String password = "Cheapradio1";
	String dbstring = "jdbc:oracle:thin:@gwynne.cs.ualberta.ca:1521:CRS ";
	String driverName = "oracle.jdbc.driver.OracleDriver";
	String query = "select owner_name,subject,count(*) from images group by subject,owner_name";
	Class drvClass = Class.forName(driverName);
	DriverManager.registerDriver((Driver) drvClass.newInstance());
	Connection conn = DriverManager.getConnection(dbstring,username,password);
	Statement stmt = conn.createStatement();
	ResultSet rset = stmt.executeQuery(query);
	while (rset.next()){
		xarray.add(rset.getObject(1).toString());
		yarray.add(rset.getObject(2).toString());
		results.add(rset.getObject(3).toString());
	}
	out.println("<table border=2>");
	for (int i = 0; i<xarray.size(); i++){
		if (!xclean.contains(xarray.get(i))){
			xclean.add(xarray.get(i));
		}
		if (!yclean.contains(yarray.get(i))){
			yclean.add(yarray.get(i));
		}
	}
	out.println("<tr>");
	for (int i = 0; i<xclean.size(); i++){
		out.println("<td>"+xclean.get(i)+"</td>");
	}


	for (int j = 0; j<yclean.size(); j++){
		String row = yclean.get(j);
		out.println("<tr>");
		out.println("<td>"+row+"</td>");
			for (int i = 1;i<xclean.size();i++){
				String column=xclean.get(i);
				int index = xarray.indexOf(column);
				if (index!=-1){
				if (yarray.get(index).equals(row)){
					out.println("<td>"+results.get(index)+"</td>");
					xarray.remove(index);
					yarray.remove(index);
					results.remove(index);
				}else{out.println("<td> 0 </td>");}
				}else{out.println("<td> 0 </td>");}
			}
		out.println("</tr>");
	}


	out.println("</tr>");
	out.println("</table>");
	stmt.close();
	conn.close();
	%>

	

</body>
</html>


