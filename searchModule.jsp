<%@ page import="java.sql.*, java.util.*" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
  <meta http-equiv="content-type" content="text/html; charset=windows-1250">
  <title>Search Images</title>
  </head>
  <body>
    
    <%
      String m_url = "jdbc:oracle:thin:@gwynne.cs.ualberta.ca:1521:CRS";
      String m_driverName = "oracle.jdbc.driver.OracleDriver";
      
      String m_userName = "kboyle"; //supply username
      String m_password = "kieran92"; //supply password
      
      String addItemError = "";
      
      Connection m_con;
      Statement stmt;
      
      try {
      
        Class drvClass = Class.forName(m_driverName);
        DriverManager.registerDriver((Driver)
        drvClass.newInstance());
        m_con = DriverManager.getConnection(m_url, m_userName, m_password);
        
      } catch(Exception e) {      
        out.print("Error displaying data: ");
        out.println(e.getMessage());
        return;
      }

      //try {
%>
	      Query the database to see relevant items
	      <br>
	      <br>
	      Enter the keywords you would like to search for, seperated by commas.
	      <br>
	      e.g.: parrot, cannonball, pirate ship
	      <br>

	      <form action="Search" method="post" >
	      <table>
	      	<tr>
	      		<td>
	            	<input type=text name=searchTerm>
	          	</td>
	        </tr>
	      	<tr>
				<td>
	      			Display results from after (must enter all or none):
	      		</td>
	      	</tr>
	      	<tr>
	      		<td>
					Year:  <input type='text' name='fromYear'>
					Month: <input type='text' name='fromMonth'>
					Day:   <input type='text' name='fromDay'>
					(Leave blank to search from the beginning of time)
				</td>
			</tr>
			<tr>
				<td>
	      			Display results from before (must enter all or none):
	      		</td>
	      	</tr>
	      	<tr>
	      		<td>
					Year (YYYY):  <input type='text' name='toYear'>
					Month (MM): <input type='text' name='toMonth'>
					Day (DD):   <input type='text' name='toDay'>
					(Leave blank to search to the end of the universe)
				</td>
			</tr>
			<tr>
	      		<td>
		      		Rank by: <select name='rank_by'>
		      		<option value='frequency'>Term Frequency</option>
		      		<option value='recent_first'>Most Recent First</option>
		      		<option value='recent_last'>Most Recent Last</option>
	      		</td>
	      	</tr>

	      </table>
      <tr>
	  	<td>
	    	<input type=submit value="Search" name="search">
	    </td>
	  </tr>
    </form>
  </body>
</html>
