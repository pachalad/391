import java.io.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.sql.*;
import oracle.jdbc.driver.*;
import java.text.*;
import java.net.*;

/**
 *  A module to display pictures.
 *  Adapted from Li-Yan Yuan's example.
 *
 *  @author  Benjamin Holmwood
 *
 */
public class Search extends HttpServlet implements SingleThreadModel {
    
    /**
     *  Generate and then send an HTML file that displays all the thermonail
     *  images of the photos.
     *
     *  Both the thermonail and images will be generated using another 
     *  servlet, called GetOnePic, with the photo_id as its query string
     *
     */
    public void doPost(HttpServletRequest request,
		      HttpServletResponse res)
	throws ServletException, IOException {
    	doGet(request, res);
    }
    public void doGet(HttpServletRequest request,
		      HttpServletResponse res)
	throws ServletException, IOException {
	
		//  send out the HTML file
		res.setContentType("text/html");
		PrintWriter out = res.getWriter ();
		
		HttpSession session = request.getSession(true);
		String userID = (String) session.getAttribute("userID");
	
		/*
		 *   to execute the given query
		 */
		String query = "SELECT DISTINCT photo_id, ";
      	
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
			
      		query += "FROM images, group_lists " +
      				 "WHERE (images.permitted = group_lists.group_id " +
				      	"AND group_lists.friend_id = '" + userID +"' ) " +
				      	"OR images.permitted = 1 " +
				      	"OR images.owner_name = '" + userID +"' " +
				      "AND ( ";
           	
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
      		query += "FROM images, group_lists " +
      				 "WHERE (images.permitted = group_lists.group_id " +
      				 	"AND group_lists.friend_id = '" + userID +"' ) " +
      				 	"OR images.permitted = 1 " +
      				 	"OR images.owner_name = '" + userID +"' " +
      				 "AND ";
      		
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
	  	
	    //request.setParameter("query", query);
	
	    //query = "SELECT photo_id FROM images";
	    //out.println(query);
		//out.println("<input type='hidden' name='query' value = '" + query +"'>");
	    session.setAttribute("QUERY", query);
		res.sendRedirect("/Photosight/PictureBrowse");
	
		//res.setContentType("text/html");
		//PrintWriter out = res.getWriter();
		out.println("<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.0 " +
			    "Transitional//EN\">\n" +
			    "<HTML>\n" +
			    "<HEAD><TITLE>Query</TITLE></HEAD>\n" +
			    "<BODY>\n" +
			    "<H1>" +
			            query + 
			    "</H1>\n" +
			    "</BODY></HTML>");
	    
		
	}
	    
    /*
     *   Connect to the specified database
     */
    private Connection getConnected() throws Exception {

		String username = "kboyle";
		String password = "kieran92";
	        /* one may replace the following for the specified database */
		//String dbstring = "jdbc.logicsql@luscar.cs.ualberta.ca:2000:database";
		//String driverName = "com.shifang.logicsql.jdbc.driver.LogicSqlDriver";
		String dbstring = "jdbc:oracle:thin:@gwynne.cs.ualberta.ca:1521:CRS";
		String driverName = "oracle.jdbc.driver.OracleDriver";
		/*
		 *  to connect to the database
		 */
		Class drvClass = Class.forName(driverName); 
		DriverManager.registerDriver((Driver) drvClass.newInstance());
		return( DriverManager.getConnection(dbstring,username,password) );
	}
    

}