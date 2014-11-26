<HTML>
<HEAD>


<TITLE>Create Account Result</TITLE>
</HEAD>

<BODY>
<!--This is where we create an account/ test if the ccount can
    be created.
    @author  Kieran Boyle, University of Alberta
 -->

<%@ page import="java.sql.*" %>


<% 
	//http://www.tutorialspoint.com/jdbc/jdbc-batch-processing.htm November 2014
	// && request.getParameter("newUSERID") != null 
	//&& request.getParameter("newPASWD") != null && request.getParameter("newFIRSTNAME") != null 
	//&& request.getParameter("newLASTNAME") != null && request.getParameter("newADDRESS") != null 
	//&& request.getParameter("newEMAIL") != null && request.getParameter("newPHONE") != null)
	if(request.getParameter("bRegister") != null && request.getParameter("newUSERID") != null && request.getParameter("newPASSWD") != null 
		&& request.getParameter("newFIRSTNAME") != null && request.getParameter("newLASTNAME") != null 
		&& request.getParameter("newADDRESS") != null && request.getParameter("newEMAIL") != null 
		&& request.getParameter("newPHONE") != null){
		
		String newUsername = (request.getParameter("newUSERID")).trim();
		String newPassword = (request.getParameter("newPASSWD")).trim();
		String newFirstName = (request.getParameter("newFIRSTNAME")).trim();	
		String newLastName = (request.getParameter("newLASTNAME")).trim();
		String newAddress = (request.getParameter("newADDRESS")).trim();
		String newEmail = (request.getParameter("newEMAIL")).trim();
		String newPhone = (request.getParameter("newPHONE")).trim();
		
		if (!(newUsername.isEmpty() && newPassword.isEmpty() && newFirstName.isEmpty() && newLastName.isEmpty() && newAddress.isEmpty() && newEmail.isEmpty() && newPhone.isEmpty())){

			
			//newUsername = null;
			//Oracle connection stuff
			
			Connection conn = null;
			String driverName = "oracle.jdbc.driver.OracleDriver";
	        String dbstring = "jdbc:oracle:thin:@gwynne.cs.ualberta.ca:1521:CRS";
		
		        try{
			        //load and register the driver
	        		Class drvClass = Class.forName(driverName); 
		        	DriverManager.registerDriver((Driver) drvClass.newInstance());
	        	}
		        catch(Exception ex){
			        out.println("<hr>" + ex.getMessage() + "<hr>");
		
		        }
				
	        	try{
		        	//establish the connection 
			        conn = DriverManager.getConnection(dbstring,"kboyle","kieran92");
	        		conn.setAutoCommit(false);
		        }
	        	catch(Exception ex){
		        
			        out.println("<hr>" + ex.getMessage() + "<hr>");
	        	}
	
	        	//Testing to see if the username that the person is trying to enter is unique
			    Statement stmt = null;
		        ResultSet rset = null;
	        	String sql = "select user_name from users where user_name = '"+newUsername+"'";
			
	        	try{
		        	stmt = conn.createStatement();
			        rset = stmt.executeQuery(sql);
	        	}
		
		        catch(Exception ex){
			        out.println("<hr>" + ex.getMessage() + "<hr>");
	        	}
			
			String existingUser = null;
			
			
			
			while(rset!= null && rset.next()){
				existingUser = (rset.getString(1)).trim();
			}
			//out.println("eror with the condition the username is set to...."+existingUser);
			if(existingUser == null){
	        	stmt = null;
		        //http://www.mkyong.com/jdbc/how-to-insert-date-value-in-preparedstatement/ nov 15 2014
				String personsInsert = "INSERT INTO persons VALUES('"+newUsername+"','"+newFirstName+"','"+newLastName+"','"+newAddress+"','"+newEmail+"','"+newPhone+"')";
				String usersInsert = "INSERT INTO users VALUES('"+newUsername+"','"+newPassword+"',sysdate)";
	        	//out.println("<h1>"+personsInsert+"</h1>");
	        	
	        	try{
		        	stmt = conn.createStatement();
		        	stmt.executeUpdate(usersInsert);
		        	conn.commit();
	        	}
		
		        catch(Exception ex){
		        	out.println("<b>there is a problem with the users update</b>");
			        out.println("<hr>" + ex.getMessage() + "<hr>");
	        	}
				
				try {
		        	stmt = conn.createStatement();
			        stmt.executeUpdate(personsInsert);
			        conn.commit();
	        	}
		
		        catch(Exception ex){
		        	out.println("<b>there is a problem with the persons update</b>");
			        out.println("<hr>" + ex.getMessage() + "<hr>");
	        	}
				out.println("<CENTER><h1>Welcome to Photosight "+newFirstName+"</h1></CENTER>");
				out.println("<Center> <FORM METHOD = LINK ACTION = login.html>");
				out.println("<INPUT TYPE= submit VALUE=login >");
				out.println("</FORM></CENTER>");
			}else{
				out.println("<CENTER><h1>Photosight</h1></CENTER>");
				out.println("<CENTER>Sorry that username has been taken, please enter a new one!");
				out.println("<FORM action = create_account.jsp method = post>");
				out.println("<Table>");
				out.println("<TR VALIGN=TOP ALIGN=LEFT>");
				out.println("<TD><B><I> a Userid:</I></B></TD>");
				out.println("<TD><INPUT TYPE= text NAME= newUSERID ><BR></TD></TR>");
				out.println("<TR VALIGN=TOP ALIGN=LEFT><TD><B><I>a Password:</I></B></TD>");
				out.println("<TD><INPUT TYPE= password create_accountNAME=newPASSWD><BR></TD></TR>");
				out.println("<TR VALIGN=TOP ALIGN=LEFT><TD><B><I>Your First Name:</I></B></TD>");
				out.println("<TD><INPUT TYPE=text NAME=newFIRSTNAME><BR></TD></TR>");
				out.println("<TR VALIGN=TOP ALIGN=LEFT><TD><B><I>Your Last Name:</I></B></TD>");
				out.println("<TD><INPUT TYPE= text NAME= newLASTNAME><BR></TD></TR>");
				out.println("<TR VALIGN=TOP ALIGN=LEFT><TD><B><I>Your Address:</CENTER></I></B></TD>");
				out.println("<TD><INPUT TYPE=text NAME=newADDRESS><BR></TD></TR>"); 
				out.println("<TR VALIGN=TOP ALIGN=LEFT><TD><B><I>Your Email:</I></B></TD>");
				out.println("<TD><INPUT TYPE=text NAME=newEMAIL><BR></TD></TR>");
				out.println("<TR VALIGN=TOP ALIGN=LEFT><TD><B><I>Your Telephone Number:</CENTER></I></B></TD>");
				out.println("<TD><INPUT TYPE=text NAME=newPHONE><BR></TD></TR></TABLE>");
				out.println("<INPUT TYPE=submit NAME=bRegister VALUE=Submit></FORM>");
				out.println("</FORM></CENTER>");
				
				}
			
	        try{
	            conn.close();
	        }
	        catch(Exception ex){
	        	out.println("<hr>" + ex.getMessage() + "<hr>");
	        }
		}else{
			out.println("<CENTER><h1>Photosight</h1>");
			out.println("Please fill out the requested fields");
			out.println("<FORM action = create_account.jsp method = post>");
			out.println("<Table>");
			out.println("<TR VALIGN=TOP ALIGN=LEFT>");
			out.println("<TD><B><I> a Userid:</I></B></TD>");
			out.println("<TD><INPUT TYPE= text NAME= newUSERID ><BR></TD></TR>");
			out.println("<TR VALIGN=TOP ALIGN=LEFT><TD><B><I>a Password:</I></B></TD>");
			out.println("<TD><INPUT TYPE= password NAME=newPASSWD><BR></TD></TR>");
			out.println("<TR VALIGN=TOP ALIGN=LEFT><TD><B><I>Your First Name:</I></B></TD>");
			out.println("<TD><INPUT TYPE=text NAME=newFIRSTNAME><BR></TD></TR>");
			out.println("<TR VALIGN=TOP ALIGN=LEFT><TD><B><I>Your Last Name:</I></B></TD>");
			out.println("<TD><INPUT TYPE= text NAME= newLASTNAME><BR></TD></TR>");
			out.println("<TR VALIGN=TOP ALIGN=LEFT><TD><B><I>Your Address:</CENTER></I></B></TD>");
			out.println("<TD><INPUT TYPE=text NAME=newADDRESS><BR></TD></TR>"); 
			out.println("<TR VALIGN=TOP ALIGN=LEFT><TD><B><I>Your Email:</I></B></TD>");
			out.println("<TD><INPUT TYPE=text NAME=newEMAIL><BR></TD></TR>");
			out.println("<TR VALIGN=TOP ALIGN=LEFT><TD><B><I>Your Telephone Number:</CENTER></I></B></TD>");
			out.println("<TD><INPUT TYPE=text NAME=newPHONE><BR></TD></TR></TABLE>");
			out.println("<INPUT TYPE=submit NAME=bRegister VALUE=Submit></FORM>");
			out.println("</FORM></CENTER>");
			
			
			
		}
 
	}else{
			out.println("<CENTER><h1>Photosight</h1>");
			out.println("Please fill out the requested fields");
			out.println("<FORM action = create_account.jsp method = post>");
			out.println("<Table>");
			out.println("<TR VALIGN=TOP ALIGN=LEFT>");
			out.println("<TD><B><I> a Userid:</I></B></TD>");
			out.println("<TD><INPUT TYPE= text NAME= newUSERID ><BR></TD></TR>");
			out.println("<TR VALIGN=TOP ALIGN=LEFT><TD><B><I>a Password:</I></B></TD>");
			out.println("<TD><INPUT TYPE= password NAME=newPASSWD><BR></TD></TR>");
			out.println("<TR VALIGN=TOP ALIGN=LEFT><TD><B><I>Your First Name:</I></B></TD>");
			out.println("<TD><INPUT TYPE=text NAME=newFIRSTNAME><BR></TD></TR>");
			out.println("<TR VALIGN=TOP ALIGN=LEFT><TD><B><I>Your Last Name:</I></B></TD>");
			out.println("<TD><INPUT TYPE= text NAME= newLASTNAME><BR></TD></TR>");
			out.println("<TR VALIGN=TOP ALIGN=LEFT><TD><B><I>Your Address:</CENTER></I></B></TD>");
			out.println("<TD><INPUT TYPE=text NAME=newADDRESS><BR></TD></TR>"); 
			out.println("<TR VALIGN=TOP ALIGN=LEFT><TD><B><I>Your Email:</I></B></TD>");
			out.println("<TD><INPUT TYPE=text NAME=newEMAIL><BR></TD></TR>");
			out.println("<TR VALIGN=TOP ALIGN=LEFT><TD><B><I>Your Telephone Number:</CENTER></I></B></TD>");
			out.println("<TD><INPUT TYPE=text NAME=newPHONE><BR></TD></TR></TABLE>");
			out.println("<INPUT TYPE=submit NAME=bRegister VALUE=Submit></FORM>");
			out.println("</FORM></CENTER>");
		
	}
		


%>

</BODY>
</HTML>
