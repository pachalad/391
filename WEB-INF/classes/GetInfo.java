import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.sql.*;

/**
 *  This servlet displays descriptive and security information for
 *  the given image.
 *
 *  The request must come with a query string as follows:
 *    GetInfo?12:        displays the image with photo_id = 12
 *    
 *  @author  Li-Yan Yuan
 *  Adapted by Benjamin Holmwood
 *
 */
public class GetInfo extends HttpServlet 
    implements SingleThreadModel {

    public void doGet(HttpServletRequest request,
		      HttpServletResponse response)
	throws ServletException, IOException {
    	
    	//  send out the HTML file
    	response.setContentType("text/html");
    	PrintWriter out = response.getWriter ();
	
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
    
			//  construct the query  from the client's QueryString
			String picid  = request.getQueryString();
			String query;
		
			query = "select owner_name, subject, place, timing, description from images where photo_id="
			        + picid;
		
			/*
			 *   to execute the given query
			 */
			Connection conn = null;
			try {
			    conn = getConnected();
			    Statement stmt = conn.createStatement();
		        
			    //First check if the user has permission to view the requested image

		        String permissionQuery = "SELECT count(*) " +
		        				  		 "FROM ( SELECT DISTINCT images.photo_id " +
		        				  	     		"FROM images, group_lists " +
		        				  	     		"WHERE ( (images.permitted = group_lists.group_id " +
		        				  	     			"AND group_lists.friend_id = '" + userID + "' ) " +
		        				  	     			"OR images.permitted = 1 " +
		        				  	     			"OR images.owner_name = '" + userID + "' ) " +
		        				  	     		  "AND photo_id = " + picid + ") ";
			    
				Statement checkstmt = conn.createStatement();
				ResultSet checkrset = checkstmt.executeQuery(permissionQuery);

		        checkrset.next();
		        int check = Integer.parseInt(checkrset.getObject(1).toString());

		        //Check is skipped if the user is admin.
		        if ( (check < 1) && !(userID.equals("admin")) ) {
		            out.println("<html><head><title>Access Denied</title></head>" +
		            		"<body bgcolor=\"#000000\" text=\"#cccccc\">" +
			                "<h3>Error: You do not have permission to view this photo!</h3>" +
							"</body></html>");
		        } else  {
		        
				    ResultSet rset = stmt.executeQuery(query);
			        String owner_name, subject, place, timing, description;	
			        		
				    if ( rset.next() ) {
				    	owner_name = rset.getString("owner_name");
				    	subject = rset.getString("subject");
				        place = rset.getString("place");
				        timing = rset.getString("timing");
				        description = rset.getString("description");	        
			            out.println("<html><head><title>"+owner_name + "'s photo " + "</title></head>" +
			            		"<body bgcolor=\"#000000\" text=\"#cccccc\">" +
				                "<center><img src = \"GetOnePic?big"+picid+"\">" +
				                "<h3>Subject: " + subject +" </h3>" +
				                "<h3>Location: " + place + " </h3>" +
				                "<h3>Owner: " + owner_name + " </h3>" +
								"<h3>Date: " + timing.substring(0, 10) + " </h3>" +
								"<h3>Description: " + description + " </h3>" +
								"</body></html>");
	
	
			            //Check if user has viwed image before
			            String viewed_query = "SELECT count(*) FROM distinct_views WHERE photo_id=" + picid +
			            		" AND user_id = '" + userID + "'";
						ResultSet viewed_rset = stmt.executeQuery(viewed_query);
						viewed_rset.next();
				    	int count = viewed_rset.getInt(1);
				    	
				    	//if they haven't, add them to the viwed table
						if ( count == 0 ) {
			                PreparedStatement viewed_stmt = conn.prepareStatement(
			                        "insert into distinct_views (photo_id, user_id) " +
			                    	"values (" + picid + ", '" + userID +"')" );
			
			                viewed_stmt.executeUpdate();
			                viewed_stmt.executeUpdate("commit");	
			                
						}
						
						if (owner_name.equals(userID)) {
							out.println("<FORM METHOD = LINK ACTION = update_picture.jsp?>");
							out.println("<input type='hidden' name='picID' value = " + picid +">");
							out.println("<INPUT TYPE= submit VALUE= Update Info>");
						}
					
			        } else {
			        	out.println("<html> Pictures are not avialable</html>");
			        }
		        }
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
