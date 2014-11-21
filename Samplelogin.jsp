<HTML>
<HEAD>


<TITLE>Login</TITLE>
</HEAD>

<BODY>
<!--A simple example to demonstrate how to use JSP to 
    connect and query a database. 
    @author  Hong-Yu Zhang, University of Alberta
 -->
<%@ page import="java.sql.*" %>

<% 
	/**
	This file checks to see if the username and password typed in are 
	valid in our database.  If not it reprompts the user showing a message
	that either the typed in password or username are invalid.
	If the user doesn't have an account, the user can click Register
	and they will be redirected to Register.jsp where they can create an 
	account.

	*/

        if(request.getParameter("bSubmit") != null)
        {

	        //get the user input from the login page
        	String userName = (request.getParameter("USERID")).trim();
	        String passwd = (request.getParameter("PASSWD")).trim();


	        //establish the connection to the underlying database
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
	

	        //select the user table from the underlying db and validate the user name and password
        	Statement stmt = null;
	        ResultSet rset = null;
        	String sql = "select pwd from login where id = '"+userName+"'";
		
        	try{
	        	stmt = conn.createStatement();
		        rset = stmt.executeQuery(sql);
        	}
	
	        catch(Exception ex){
		        out.println("<hr>" + ex.getMessage() + "<hr>");
        	}

	        
		String truepwd = null;
        	while(rset != null && rset.next())
	        	truepwd = (rset.getString(1)).trim();
	
        	//checks username agains what the db returns as the correct one
		// if it is valid it redirects to usermain.jsp which is the
		// users home page.
	        if(passwd.equals(truepwd)){
	        	// Creates a session on valid login
   			String userIDKey = new String("userID");
			String userID = userName;
			session.setAttribute(userIDKey, userID);
			out.println("it worked");
		        //response.sendRedirect("usermain.jsp?user="+userName);

        	}else{
                	out.println("<form method=post action=login.jsp><CENTER>");
			out.println("<p><b>you entered"+passwd+"</b></p>");
			out.println("<p><b>actual password is "+truepwd+"</b></p>");
	        	out.println("<p><b>Either your userName or your password is inValid!</b></p>");
                	out.println("UserName: <input type=text name=USERID maxlength=20><br>");
               		out.println("Password: <input type=password name=PASSWD maxlength=20><br>");
                	out.println("<input type=submit name=bSubmit value=Submit><br>");
                	out.println("<input type=submit name=bRegister value=Register>");
                	out.println("</CENTER></form>");
		}

                try{
                        conn.close();
                }
                catch(Exception ex){
                        out.println("<hr>" + ex.getMessage() + "<hr>");
                }
        }else
	/**
	Called if the user clicks Register Button. Sends the user to the registration page.	
	*/
	if (request.getParameter("bRegister") != null){
	        //get the user input from the login page
        	response.sendRedirect("Register.jsp?a=0");

		}
       		else
        	{
	
                out.println("<form method=post action=login.jsp><CENTER>");
                out.println("UserName: <input type=text name=USERID maxlength=20><br>");
                out.println("Password: <input type=password name=PASSWD maxlength=20><br>");
                out.println("<input type=submit name=bSubmit value=Submit><br>");
                out.println("<input type=submit name=bRegister value=Register>");
                out.println("</CENTER></form>");
        }      
%>



</BODY>
</HTML>
