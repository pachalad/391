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
public class PictureBrowse extends HttpServlet implements SingleThreadModel {
    
    /**
     *  Generate and then send an HTML file that displays all the thermonail
     *  images of the photos.
     *
     *  Both the thermonail and images will be generated using another 
     *  servlet, called GetOnePic, with the photo_id as its query string
     *
     */
    public void doGet(HttpServletRequest request,
		      HttpServletResponse res)
	throws ServletException, IOException {

	//  send out the HTML file
	res.setContentType("text/html");
	PrintWriter out = res.getWriter ();

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
	try {
		//TODO: get query from session
	    String query = "select photo_id from images";

	    Connection conn = getConnected();
	    Statement stmt = conn.createStatement();
	    ResultSet rset = stmt.executeQuery(query);
	    String p_id = "";

	    while (rset.next() ) {
		p_id = (rset.getObject(1)).toString();

	       // specify the servlet for the image
               out.println("<a href=\"/Photosight/GetInfo?"+p_id+"\">");
	       // specify the servlet for the themernail
	       out.println("<img src=\"/Photosight/GetOnePic?"+p_id +
	                   "\"></a>");
	    }
	    stmt.close();
	    conn.close();
	} catch ( Exception ex ){ out.println( ex.toString() );}
    //TODO change exception
	out.println("<P><a href=\"/yuan/servlets/logicsql.html\"> Return </a>");
	out.println("</body>");
	out.println("</html>");
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




