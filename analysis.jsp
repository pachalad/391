<%@ page import="java.sql.*,java.util.*,java.text.*,java.net.*,javax.servlet.*,javax.servlet.http.*,java.util.*"%>
<html>
<body>

<%
	// This checks to see if the user is admin.
	String userID=(String) session.getAttribute("userID");
	if (!userID.equals("admin")){
		response.sendRedirect("/Photosight/login.html");
	}
	// Grab all the requested parameters.
	String x=request.getParameter("x");
	String y=request.getParameter("y");
	String startdate=request.getParameter("startdate");
	String enddate= request.getParameter("enddate");
	String user=request.getParameter("user");
	String sub= request.getParameter("sub");
	// These arrrays are used to clean and format the query results.                                   
	ArrayList<String> xarray=new ArrayList<String>();
	ArrayList<String> yarray=new ArrayList<String>();
	ArrayList<String> results=new ArrayList<String>();
	ArrayList<String> xclean = new ArrayList<String>();
	ArrayList<String> yclean = new ArrayList<String>();
	xclean.add("Picture count!");

	// If time is queried, this will print in which mode the user is in
	// ie. Year,Month,Week
	String timetype=request.getParameter("timetype");
	if (x.equals("timing")||y.equals("timing")){
		out.println(timetype.toUpperCase()+"!");
	}
	// Database stuff
	String username = "kboyle";
	String password = "kieran92";
	String dbstring = "jdbc:oracle:thin:@gwynne.cs.ualberta.ca:1521:CRS ";
	String driverName = "oracle.jdbc.driver.OracleDriver";

	String query= null;
	// These conditionals run if the user didnt choose timing. Based
	// on the parameters it selects different queries.
	if (!x.equals("timing") && !y.equals("timing")){
		if (user.isEmpty() && sub.isEmpty()){
			query = "select "+x+","+y+", count(*) from images group by "+x+","+y;
		}else if(!user.isEmpty() && !sub.isEmpty()){
			query = "select "+x+","+y+",count(*) from images where subject like '%"+sub+"%' and owner_name='"+user+"' group by "+x+","+y;
		}else if(!user.isEmpty() && sub.isEmpty()){
			query = "select "+x+","+y+",count(*) from images where owner_name='"+user+"' group by "+x+","+y;
		}else if(user.isEmpty() && !sub.isEmpty()){
			query = "select "+x+","+y+",count(*) from images where subject like '%"+sub+"%' group by "+x+","+y;
		}
	}
	// These conditionals run if the user did choose timing. Based
	// on the parameters and times it selects different queries.
	if (x.equals("timing")) {
		if (timetype.equals("year")){
			if (!user.isEmpty()){
				query = "select extract("+timetype+" from "+x+"),"+y+",count(*) from images where timing>=DATE '"+startdate+"' and timing<=DATE '"+enddate+"' and owner_name='"+user+"' group by "+x+","+y;
			}else if(!sub.isEmpty()){
				query = "select extract("+timetype+" from "+x+"), "+y+",count(*) from images where timing>=DATE '"+startdate+"' and timing<=DATE '"+enddate+"' and subject like '%"+sub+"%' group by "+x+","+y;
			}else{
				query = "select extract("+timetype+" from "+x+"), "+y+",count(*) from images where timing>=DATE '"+startdate+"' and timing<=DATE '"+enddate+"' group by "+x+","+y;
			}
		}else if (timetype.equals("month")){
			if (!user.isEmpty()){
				query = "select to_char(timing,'YYYY-MM'), "+y+",count(*) from images where timing>= DATE '"+startdate+"' and timing<= DATE '"+enddate+"' and owner_name='"+user+"' group by "+x+","+y;
			}else if (!sub.isEmpty()){
				query = "select to_char(timing,'YYYY-MM'), "+y+" ,count(*) from images where timing>= DATE '"+startdate+"' and timing<= DATE '"+enddate+"' and subject like '%"+sub+"%' group by "+x+","+y;
			}else{
				query = "select to_char(timing,'YYYY-MM'), "+y+",count(*) from images where timing>= DATE '"+startdate+"' and timing<= DATE '"+enddate+"' group by "+x+","+y;
			}
		}else if (timetype.equals("week")){
			if (!user.isEmpty()){
				query = "select to_char(timing,'YYYY-MM-WW'),"+y+",count(*) from images where timing>= DATE '"+startdate+"' and timing<= DATE '"+enddate+"' and owner_name='"+user+"' group by "+x+","+y;
			}else if(!sub.isEmpty()){
				query = "select to_char(timing,'YYYY-MM-WW'),"+y+",count(*) from images where timing>= DATE '"+startdate+"' and timing<= DATE '"+enddate+"' and subject like '%"+sub+"%' group by "+x+","+y;
			}else{
				query = "select to_char(timing,'YYYY-MM-WW'),"+y+",count(*) from images where timing>= DATE '"+startdate+"' and timing<= DATE '"+enddate+"' group by "+x+","+y;
			}
		}
	}
	// Register database and open connection.
	Class drvClass = Class.forName(driverName);
	DriverManager.registerDriver((Driver) drvClass.newInstance());
	Connection conn = DriverManager.getConnection(dbstring,username,password);
	Statement stmt = conn.createStatement();
	ResultSet rset = stmt.executeQuery(query);
	// Iterate over results and add them to the correct array.
	while (rset.next()){
		xarray.add(rset.getObject(1).toString());
		yarray.add(rset.getObject(2).toString());
		results.add(rset.getObject(3).toString());
	}

	out.println("<table border=2>");
	// This filters the answers and cleans any duplicates,
	// These are user to create the axis.
	for (int i = 0; i<xarray.size(); i++){
		if (!xclean.contains(xarray.get(i))){
			xclean.add(xarray.get(i));
		}
		if (!yclean.contains(yarray.get(i))){
			yclean.add(yarray.get(i));
		}
	}
	out.println("<tr>");
	// Creates X axis and columns.
	for (int i = 0; i<xclean.size(); i++){
		out.println("<td>"+xclean.get(i)+"</td>");
	}

	// Adds rows!
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

	//This prints if Timing and Year is selected. Allows the user to drill down.
	if("year".equals(timetype) && (x.equals("timing")||y.equals("timing"))) {
		out.println("<form action=analysis.jsp method=post>");
		out.println("<input type=hidden name=startdate value="+startdate+">");
		out.println("<input type=hidden name=enddate value="+enddate+">");
		out.println("<input type=hidden name=sub value="+sub+">");
		out.println("<input type=hidden name=user value="+user+">");
		out.println("<input type=hidden name=x value="+x+">");
		out.println("<input type=hidden name=y value="+y+">");
		out.println("DrillDown into Year!");
		out.println("<input type=hidden name=timetype value=month>");
		out.println("<input type=submit name=submit value= Drilldown>");
		out.println("</form");
	}

	// This prints if Timing and Month is selected. Allows user to rollback
	// and drill down into weeks.
	if("month".equals(timetype) && (x.equals("timing")||y.equals("timing"))) {
		out.println("<form action=analysis.jsp method=post>");
		out.println("DrillDown into week or roll up!<br>");
		out.println("<input type=hidden name=startdate value="+startdate+">");
		out.println("<input type=hidden name=enddate value="+enddate+">");
		out.println("<input type=hidden name=sub value="+sub+">");
		out.println("<input type=hidden name=user value="+user+">");
		out.println("<input type=hidden name=x value="+x+">");
		out.println("<input type=hidden name=y value="+y+">");
		out.println("<input type=hidden name=timetype value=year>");
		out.println("<input type=submit name=submit value=RollUp!><br>");
		out.println("</form>");

		out.println("<form action=analysis.jsp method=post>");
		out.println("<input type=hidden name=startdate value="+startdate+">");
		out.println("<input type=hidden name=enddate value="+enddate+">");
		out.println("<input type=hidden name=sub value="+sub+">");
		out.println("<input type=hidden name=user value="+user+">");
		out.println("<input type=hidden name=x value="+x+">");
		out.println("<input type=hidden name=y value="+y+">");
		out.println("DrillDown!");
		out.println("<input type=hidden name=timetype value=week>");
		out.println("<input type=submit name=drill value= Drilldown>");
		out.println("</form>");
	}

	// This prints if Timing and Week is selected. Allows user to rollback.
	if("week".equals(timetype) && (x.equals("timing")||y.equals("timing"))) {
		out.println("<form action=analysis.jsp method=post>");
		out.println("<input type=hidden name=startdate value="+startdate+">");
		out.println("<input type=hidden name=enddate value="+enddate+">");
		out.println("<input type=hidden name=sub value="+sub+">");
		out.println("<input type=hidden name=user value="+user+">");
		out.println("<input type=hidden name=x value="+x+">");
		out.println("<input type=hidden name=y value="+y+">");
		out.println("Roll up!<br>");
		out.println("<input type=hidden name=timetype value=month>");
		out.println("<input type=submit name=submit value=RollUp!><br>");
		out.println("</form>");
	}




	stmt.close();
	conn.close();
	%>

	

</body>
</html>


