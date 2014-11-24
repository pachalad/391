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

      try {
%>
      Query the database to see relevant items
      <br>
      <br>
      Enter the keywords you would like to search for, seperated by commas.
      <br>
      e.g.: parrot, cannonball, pirate ship
      
      <form name=search method=post action=searchModule.jsp> 
      <table>
        <tr>
          <td>
            <input type=text name=searchTerm>
          </td>
          <td>
            <input type=submit value="Search" name="search">
          </td>
        </tr>
      </table>
<%
      if (request.getParameter("search") != null) {
    	  	out.println("<br>");
        	out.println("Search term(s): " + request.getParameter("searchTerm"));
          	out.println("<br>");
          	
            if(!(request.getParameter("searchTerm").equals(""))) {
            	
            	String searchString = request.getParameter("searchTerm");
            	
				List<String> searchTerms = Arrays.asList(searchString.split(","));
            	
            	out.println(searchTerms);
				
            	String query = "SELECT photo_id, subject, place, description, ";
            	
            	String term;
            	
            	int count = searchTerms.size();
            	
            	
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
            			 "ORDER BY (subjectFreq + placeFreq + descriptionFreq) DESC";
	      		
            	out.println(query);
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
            } else {
            	out.println("<br><b>Please enter text for quering</b>");
            }            
          }
          m_con.close();
        }
        catch(SQLException e)
        {
          out.println("SQLException: " +
          e.getMessage());
			m_con.rollback();
        }
      %>
    </form>
  </body>
</html>
