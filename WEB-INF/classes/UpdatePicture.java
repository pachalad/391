import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.sql.*;
import java.util.*;
import oracle.sql.*;
import oracle.jdbc.*;
import java.awt.Image;
import java.awt.image.BufferedImage;
import javax.imageio.ImageIO;

public class UpdatePicture extends HttpServlet {
    public String response_message;
    public void doPost(HttpServletRequest request,HttpServletResponse response)
	throws ServletException, IOException {
	//  change the following parameters to connect to the oracle database
	String username = "kboyle";
	String password = "kieran92";
	String drivername = "oracle.jdbc.driver.OracleDriver";
	String dbstring ="jdbc:oracle:thin:@gwynne.cs.ualberta.ca:1521:CRS";
	
	HttpSession session = request.getSession(true);
	
	String permission = request.getParameter("permission");
	String subject = request.getParameter("subject") + ' ';
	String year = request.getParameter("year");
	String month = request.getParameter("month");
	String day = request.getParameter("day");
	String description = request.getParameter("description") + ' ';
	String place = request.getParameter("place") + ' ';
	String date = year+"-"+month+"-"+day;
	String userID = (String) session.getAttribute("userID");
    String pic_id = request.getParameter("picID");
	int permissionint=0;

	response.setContentType("text/html");
	PrintWriter out = response.getWriter();
	
	try {
	    
        // Connect to the database and create a statement
        Connection conn = getConnected(drivername,dbstring, username,password);
	    Statement stmt = conn.createStatement();
	    
	    ResultSet rset1 = stmt.executeQuery("SELECT group_id from groups where group_name='"+permission+"'");
	    rset1.next();
	    permissionint = rset1.getInt(1);
 
	    //Insert an empty blob into the table first. Note that you have to 
	    //use the Oracle specific function empty_blob() to create an empty blob
	    String statement = "UPDATE images " +
	    					"SET permitted = " + permissionint + ", subject = '" + subject +
	    					"', place = '" + place + "', timing = DATE '" + date + "', description = '" + description + "'" +
	    					"WHERE photo_id = " + pic_id;
	    stmt.execute(statement);
        stmt.executeUpdate("commit");
	    response_message = " Update OK!  ";
        stmt.close();
	    conn.close();

	} catch( Exception ex ) {
	    //System.out.println( ex.getMessage());
	    response_message = ex.getMessage();
	}

	//Output response to the client

	out.println("<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.0 " +
		    "Transitional//EN\">\n" +
		    "<HTML>\n" +
		    "<HEAD><TITLE>Update Picture</TITLE></HEAD>\n" +
		    "<BODY>\n" +
		    "<H1>" +
		            response_message + 
		    "</H1>\n" +
		    "</BODY></HTML>");
    }

    /*
      /*   To connect to the specified database
    */
    private static Connection getConnected( String drivername,
					    String dbstring,
					    String username, 
					    String password  ) 
	throws Exception {
	Class drvClass = Class.forName(drivername); 
	DriverManager.registerDriver((Driver) drvClass.newInstance());
	return( DriverManager.getConnection(dbstring,username,password));
    } 


}
