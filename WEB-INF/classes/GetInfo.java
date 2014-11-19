import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.sql.*;

/**
 *  This servlet sends one picture stored in the table below to the client 
 *  who requested the servlet.
 *
 *   picture( photo_id: integer, title: varchar, place: varchar, 
 *            sm_image: blob,   image: blob )
 *
 *  The request must come with a query string as follows:
 *    GetOnePic?12:        sends the picture in sm_image with photo_id = 12
 *    GetOnePicture?big12: sends the picture in image  with photo_id = 12
 *
 *  @author  Li-Yan Yuan
 *
 */
public class GetInfo extends HttpServlet 
    implements SingleThreadModel {

    /**
     *    This method first gets the query string indicating PHOTO_ID,
     *    and then executes the query 
     *          select image from yuan.photos where photo_id = PHOTO_ID   
     *    Finally, it sends the picture to the client
     */

    public void doGet(HttpServletRequest request,
		      HttpServletResponse response)
	throws ServletException, IOException {
	
	//  construct the query  from the client's QueryString
	String picid  = request.getQueryString();
	String query;

	query = "select owner_name, subject, place, timing, description from images where photo_id="
	        + picid;

	//ServletOutputStream out = response.getOutputStream();
	PrintWriter out = response.getWriter();

	/*
	 *   to execute the given query
	 */
	Connection conn = null;
	try {
	    conn = getConnected();
	    Statement stmt = conn.createStatement();
	    ResultSet rset = stmt.executeQuery(query);
	    response.setContentType("text/html");
            String owner_name, subject, place, timing, description;

	    if ( rset.next() ) {
	    	owner_name = rset.getString("owner_name");
	    	subject = rset.getString("subject");
	        place = rset.getString("place");
	        timing = rset.getString("timing");
	        description = rset.getString("description");	        
                out.println("<html><head><title>"+owner_name + "'s photo " + "</title>+</head>" +
	                 "<body bgcolor=\"#000000\" text=\"#cccccc\">" +
		 "<center><img src = \"/proj1/GetOnePic?big"+picid+"\">" +
			 "<h3>Subject: " + subject +" </h3>" +
			 "<h3>Location: " + place + " </h3>" +
			 "<h3>Owner: " + owner_name + " </h3>" +
			 "<h3>Date: " + timing + " </h3>" +
			 "<h3>Description: " + description + " </h3>" +
			 "</body></html>");
            /*
            	query = "SELECT * FROM images WHERE photo_id=" + picid +
            			"AND user_id = ";
                
                PreparedStatement stmt = conn.prepareStatement(
                        "insert into images (photo_id, owner_name, permitted, subject, place, timing, description, thumbnail, photo) " +
                    	"values (200,'kieran', 1, 'stuff', 'a place', NULL, 'test description', ?, ?)" );
              */  
            }
	    else
	      out.println("<html> Pictures are not avialable</html>");
	} catch( Exception ex ) {
	    out.println(ex.getMessage() );
	}
	// to close the connection
	finally {
	    try {
		conn.close();
	    } catch ( SQLException ex) {
		out.println( ex.getMessage() );
	    }
	}
    }

    /*
     *   Connect to the specified database
     */
    private Connection getConnected() throws Exception {

    	String username = "kboyle";
    	String password = "kieran92";
            /* one may replace the following for the specified database */
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
