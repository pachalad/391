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
	<%
		/*
	      if (request.getParameter("search") != null) {
	    	  	out.println("<br>");
	        	out.println("Search term(s): " + request.getParameter("searchTerm"));
	          	out.println("<br>");
	          	
	        	String query = "SELECT photo_id, subject, place, description, ";
	          	
	            if(!(request.getParameter("searchTerm").equals(""))) {
	            	
	            	String searchString = request.getParameter("searchTerm");
	            	
					List<String> searchTerms = Arrays.asList(searchString.split(","));
	            	
	            	out.println(searchTerms);
	            	
	            	String term;
	            	
	            	int count = searchTerms.size();
	            	
	            	//adapted from http://sqlmag.com/t-sql/counting-instances-word-record accessed Nov 20th, 2014
	            	
	            	query += "( ";
	            	for (int i = 0; i < count - 1; i++) {
	            		term = searchTerms.get(i).trim();
		            	query += "( (6 * (LENGTH(subject) - LENGTH(REPLACE(subject, '" + term + "', '')))/LENGTH('"+term+"') ) ) + ";
	            	}
	            	term = searchTerms.get(count - 1).trim();
	            	query += "( (6 * (LENGTH(subject) - LENGTH(REPLACE(subject, '" + term + "', '')))/LENGTH('"+term+"') ) )" +
	       				 	  ") AS subjectFreq, ";
	            			  
	            	query += "( ";
	            	for (int i = 0; i < count - 1; i++) {
	            		term = searchTerms.get(i).trim();
		            	query += "( (3 * (LENGTH(place) - LENGTH(REPLACE(place, '" + term + "', '')))/LENGTH('"+term+"') ) ) + ";
	            	}
	            	term = searchTerms.get(count - 1).trim();
	            	query += "( (3 * (LENGTH(place) - LENGTH(REPLACE(place, '" + term + "', '')))/LENGTH('"+term+"') ) )" +
	       				 	  ") AS placeFreq, ";
	       				 	  
		           	query += "( ";
		           	for (int i = 0; i < count - 1; i++) {
		           		term = searchTerms.get(i).trim();
		            	query += "( ((LENGTH(description) - LENGTH(REPLACE(description, '" + term + "', '')))/LENGTH('"+term+"') ) ) + ";
		           	}
		           	term = searchTerms.get(count - 1).trim();
		           	query += "( ((LENGTH(description) - LENGTH(REPLACE(description, '" + term + "', '')))/LENGTH('"+term+"') ) )" +
		      				 ") AS descriptionFreq ";
					
		      		query += "FROM images " +
		      				 "WHERE (";
		           	
		      		for (int i = 0; i < count - 1; i++) {
		           		term = searchTerms.get(i).trim();
		            	query += "(contains(subject, '" + term + "') > 0) OR " +
		            			 "(contains(place, '" + term + "') > 0) OR " +
		            			 "(contains(description, '" + term + "') > 0) OR ";
		           	}
					term = searchTerms.get(count - 1).trim();
		      		query += "(contains(subject, '" + term + "') > 0) OR " +
	           			 	 "(contains(place, '" + term + "') > 0) OR " +
	           			 	 "(contains(description, '" + term + "') > 0) ) ";
	            	
		            if ( ( !(request.getParameter("fromYear").equals("")) && !(request.getParameter("fromMonth").equals("")) 
		            	  && !(request.getParameter("fromDay").equals("")) ) ||
		            	  ( !(request.getParameter("toYear").equals("")) && !(request.getParameter("toMonth").equals("")) 
				            	  && !(request.getParameter("toDay").equals("")) ) ) {
		            	query += "AND ";
			        }
		            
	            } else {
		      		query += "FROM images " +
		      				 "WHERE ";
	            }
	            
	            if ( !(request.getParameter("fromYear").equals("")) && !(request.getParameter("fromMonth").equals("")) 
		            	  && !(request.getParameter("fromDay").equals("")) ) {
		            	
	            	query += "( timing >= TO_DATE('" +request.getParameter("fromYear") + "/" +
		            	  						request.getParameter("fromMonth") + "/" +
		            	  						request.getParameter("fromDay")  +
		            	  						"', 'YYYY-MM-DD') ) ";
		            	if ( !(request.getParameter("toYear").equals("")) && !(request.getParameter("toMonth").equals("")) 
				            	  && !(request.getParameter("toDay").equals("")) ) {
			            	query += "AND ";
		            	}
		            	
		            }
		            
	            if ( !(request.getParameter("toYear").equals("")) && !(request.getParameter("toMonth").equals("")) 
		            	  && !(request.getParameter("toDay").equals("")) ) {
	            	query += "( timing <= TO_DATE('" +request.getParameter("toYear") + "/" +
	  						request.getParameter("toMonth") + "/" +
	  						request.getParameter("toDay")  +
	  						"', 'YYYY-MM-DD') ) ";
		        }
	            
	          	if (request.getParameter("rank_by").equals("frequency")) {
	          		query += "ORDER BY (subjectFreq + placeFreq + descriptionFreq) DESC";
	          	} else if (request.getParameter("rank_by").equals("recent_first")) {
	          		query += "ORDER BY timing DESC";
	          	} else if (request.getParameter("rank_by").equals("recent_last")) {
	          		query += "ORDER BY timing";
	          	}
	          	
	           	//out.println(query);
	            PreparedStatement doSearch = m_con.prepareStatement(query);
	             	
	             	
	            ResultSet rset2 = doSearch.executeQuery();
	            out.println("<table border=1>");
	            out.println("<tr>");
	            out.println("<th>pic_id</th>");
	            out.println("<th>Subject</th>");
	            out.println("<th>Place</th>");
	            out.println("<th>Description</th>");
	            out.println("<th>Subject Score</th>");
	            out.println("<th>Place Score</th>");
	            out.println("<th>Description Score</th>");
	            out.println("</tr>");
	            while(rset2.next()) {
	            	out.println("<tr>");
	              	out.println("<td>"); 
	                out.println(rset2.getString(1));
	                out.println("</td>");
	                out.println("<td>"); 
	                out.println(rset2.getString(2)); 
	                out.println("</td>");
	                out.println("<td>");
	                out.println(rset2.getObject(3));
		            out.println("</td>");
	                out.println("<td>");
	                out.println(rset2.getObject(4));
		            out.println("</td>");
	                out.println("<td>");
	                out.println(rset2.getObject(5));
		            out.println("</td>");
	                out.println("<td>");
	                out.println(rset2.getObject(6));
		            out.println("</td>");
	                out.println("<td>");
	                out.println(rset2.getObject(7));
		            out.println("</td>");
		            out.println("</tr>");
	                
	                //out.println(rset2.getObject(1));
	
	            } 
	            out.println("</table>"); 
	            
	            //request.setParameter("query", query);

	            query = "SELECT photo_id FROM images";
	            out.println(query);
				//out.println("<input type='hidden' name='query' value = '" + query +"'>");
	            session.setAttribute("query", query);
				//session.sendRedirect("PictureBrowse");
	   
	  		//}	
	        m_con.close();
        }
        catch(SQLException e)
        {
          out.println("SQLException: " +
          e.getMessage());
			m_con.rollback();
        }
      */
      %>
      <tr>
	  	<td>
	    	<input type=submit value="Search" name="search">
	    </td>
	  </tr>
    </form>
  </body>
</html>
