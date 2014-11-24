<%@ page import="java.sql.*,java.util.*,java.text.*,java.net.*,javax.servlet.*,javax.servlet.http.*,java.util.*"%>
<html>
<body>

<%
	String userID=(String) session.getAttribute("userID");
	if (!userID.equals("admin")){
		response.sendRedirect("/Photosight/login.html");
	}
	String x=request.getParameter("x");
	String y=request.getParameter("y");
	String year=request.getParameter("year");
	String month= request.getParameter("month");                                      
	ArrayList<String> xarray=new ArrayList<String>();
	ArrayList<String> yarray=new ArrayList<String>();
	ArrayList<String> results=new ArrayList<String>();
	ArrayList<String> xclean = new ArrayList<String>();
	ArrayList<String> yclean = new ArrayList<String>();
	xclean.add("Picture count!");
	String timetype=request.getParameter("timetype");
	if (x.equals("timing")||y.equals("timing")){
		out.println(timetype.toUpperCase()+"!");
	}
	String username = "kboyle";
	String password = "kieran92";
	String dbstring = "jdbc:oracle:thin:@gwynne.cs.ualberta.ca:1521:CRS ";
	String driverName = "oracle.jdbc.driver.OracleDriver";
	String query;
	query = "select "+x+","+y+",count(*) from images group by "+x+","+y;
	if (x.equals("timing")||y.equals("timing")) {
		if (timetype.equals("year")){
			if (x.equals("timing")){
				query = "select extract("+timetype+" from "+x+"),"+y+",count(*) from images group by "+x+","+y;
			} else{
				query = "select "+x+" ,extract("+timetype+" from "+y+"),count(*) from images group by "+y+","+x;}
		}else if (timetype.equals("month")){
			if (x.equals("timing")){
				query = "select extract("+timetype+" from "+x+"),"+y+",count(*) from images where timing>= DATE '"+year+"-01-01' and timing<= DATE '"+year+"-12-31' group by "+x+","+y;
			} else{
				query = "select "+x+" ,extract("+timetype+" from "+y+"),count(*) from images where timing>= DATE '"+year+"-01-01' and timing<= DATE '"+year+"-12-31' group by "+y+","+x;}
		}else if (timetype.equals("week")){
			if (x.equals("timing")){
				query = "select to_char(timing,'WW'),"+y+",count(*) from images where timing>= DATE '"+year+"-"+month+"-01' and timing<= DATE '"+year+"-"+month+"-31' group by "+x+","+y;
			} else{
				query = "select "+x+" ,to_char(timing,'WW'),count(*) from images where timing>= DATE '"+year+"-"+month+"-01' and timing<= DATE '"+year+"-"+month+"-31' group by "+y+","+x;}
		}
	}

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

	if("year".equals(timetype) && (x.equals("timing")||y.equals("timing"))) {
		out.println("<form action=analysis.jsp method=post>");
		out.println("<input type=hidden name=month value="+month+">");
		out.println("<input type=hidden name=x value="+x+">");
		out.println("<input type=hidden name=y value="+y+">");
		out.println("DrillDown into Year!");
		out.println("<select name=year>");
		if(x.equals("timing")){
			for (int i = 1;i<xclean.size();i++){
				out.println("<option value="+xclean.get(i)+" >"+xclean.get(i)+" </option>");
			}
		}
		if(y.equals("timing")){
			for (int i = 0;i<yclean.size();i++){
				out.println("<option value="+yclean.get(i)+" >"+yclean.get(i)+" </option>");
			}
		}
		out.println("</select>");
		out.println("<input type=hidden name=timetype value=month>");
		out.println("<input type=submit name=submit value= Drilldown>");
		out.println("</form");
	}

	if("month".equals(timetype) && (x.equals("timing")||y.equals("timing"))) {
		out.println("<form action=analysis.jsp method=post>");
		out.println("<input type=hidden name=x value="+x+">");
		out.println("<input type=hidden name=y value="+y+">");
		out.println("DrillDown into week or roll up!<br>");
		out.println("<input type=hidden name=year value="+year+">");
		out.println("<input type=hidden name=timetype value=year>");
		out.println("<input type=submit name=submit value=RollUp!><br>");
		out.println("</form>");

		out.println("<form action=analysis.jsp method=post>");
		out.println("<input type=hidden name=x value="+x+">");
		out.println("<input type=hidden name=y value="+y+">");

		out.println("DrillDown into Month!");
		out.println("<select name=month>");
		if(x.equals("timing")){
			for (int i = 1;i<xclean.size();i++){
				out.println("<option value="+xclean.get(i)+" >"+xclean.get(i)+" </option>");
			}
		}
		if(y.equals("timing")){
			for (int i = 0;i<yclean.size();i++){
				out.println("<option value="+yclean.get(i)+" >"+yclean.get(i)+" </option>");
			}
		}
		out.println("</select>");
		out.println("<input type=hidden name=year value="+year+">");
		out.println("<input type=hidden name=timetype value=week>");
		out.println("<input type=submit name=drill value= Drill down>");
		out.println("</form>");


	}

	if("week".equals(timetype) && (x.equals("timing")||y.equals("timing"))) {
		out.println("<form action=analysis.jsp method=post>");
		out.println("<input type=hidden name=x value="+x+">");
		out.println("<input type=hidden name=y value="+y+">");
		out.println("Roll up!<br>");
		out.println("<input type=hidden name=year value="+year+">");
		out.println("<input type=hidden name=year value="+month+">");
		out.println("<input type=hidden name=timetype value=month>");
		out.println("<input type=submit name=submit value=RollUp!><br>");
		out.println("</form>");
	}




	stmt.close();
	conn.close();
	%>

	

</body>
</html>


