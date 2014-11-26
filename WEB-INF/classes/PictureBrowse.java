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
 *  @author  Benjamin Holmwood, adpated from Li-Yan Yuan.
 *
 */
public class PictureBrowse extends HttpServlet implements SingleThreadModel {
    
    /**
     *  Generate and then send an HTML file that displays all the thumbnail
     *  images of the photos.
     *
     *  Both the thumbnail and images will be generated using another 
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
	if (session.getAttribute("userID") == null) {
	    // Session is not created.
		out.println("<CENTER>");    
	    out.println("<h1>Photosight</h1>");
		out.println("<FORM METHOD = link ACTION = login.html>");
		out.println("<INPUT TYPE= submit VALUE = Login>");
		out.println("</FORM>");
		out.println("</CENTER>");


	} else {
		out.println("<html>");
		out.println("<head>");
		out.println("<title> Photo List </title>");
		out.println("</head>");
		out.println("<body bgcolor=\"#000000\" text=\"#cccccc\" >");
		out.println("<center>");
		out.println("<h3>The List of Images </h3>");
	
		/*
		 *   to execute the given query
		 */
		
		Connection conn = null;
		try {
			
			String query;
			
			String requestQueryString  = request.getQueryString();
			
			//If user wants to view top images
		    if ("top".equals(requestQueryString) ) {

		    	//Select each photo_id
				query = "SELECT DISTINCT photo_id " +
						"FROM (SELECT distinct_views.photo_id, count(distinct_views.photo_id) " +
      					"FROM distinct_views ";
      			//If user is not admin, check for permissions
      			if ( !(userID.equals("admin"))) {
      				query += ", (SELECT DISTINCT images.photo_id AS permitted_id " +
         				 	 	"FROM images, group_lists " +
        				 		"WHERE ( (images.permitted = group_lists.group_id " +
          				 		"AND group_lists.friend_id = '" + userID +"' ) " +
          				 		"OR images.permitted = 1 " +
          				 		"OR images.owner_name = '" + userID +"' ) ) " +
      					 		"WHERE distinct_views.photo_id = permitted_id ";
      			}
      			//Order by distinct views in descending order and display first 5 results.
      			query += "GROUP BY distinct_views.photo_id " +
      					 "ORDER BY count(distinct_views.photo_id) desc) " +
						 "WHERE rownum <= 5 ";
		    }
		    
		    //If user wants to view all images
		    else  if ("all".equals(requestQueryString) ) {
		    	//Select each photo id
				query = "SELECT DISTINCT photo_id " +
						"FROM images, group_lists ";
				//If user is not admin, check for permissions.
				if ( !(userID.equals("admin"))) {
						query += "WHERE (images.permitted = group_lists.group_id " +
								 "AND group_lists.friend_id = '" + userID +"' ) " +
								 "OR images.permitted = 1 " +
								 "OR images.owner_name = '" + userID +"' ";
				}
		    }
		    
		    //If user is not viewing all or top images, retrieve the query provided by the search module
		    else {
		    	query = (String) session.getAttribute("QUERY");
		    }
		    
			out.println(query);

		    //Connect to the database and execute the query.
		    conn = getConnected();
		    Statement stmt = conn.createStatement();
		    ResultSet rset = stmt.executeQuery(query);
		    String p_id = "";

		    
		    while (rset.next() ) {
			p_id = (rset.getObject(1)).toString();
	
		       // specify the servlet for the image information page
	               out.println("<a href=\"/Photosight/GetInfo?"+p_id+"\">");
		       // specify the servlet for the thumbnail
		       out.println("<img src=\"/Photosight/GetOnePic?"+p_id +
		                   "\"></a>");
		    }
		} catch ( Exception ex ){ 
			out.println( ex.toString() );
		} finally {
			try {
		    	conn.close();
		    } catch ( SQLException ex) {
		    	out.println( ex.getMessage() );
		    }
	    }
	}


	out.println("<P><a href=\"/Photosight/main_page.jsp\"> Return </a>");
	out.println("</body>");
	out.println("</html>");
}
	    
    /*
     *   Connect to the specified database
     */
    private Connection getConnected() throws Exception {

	String username = "kboyle";
	String password = "kieran92";
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




