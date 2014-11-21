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
import java.lang.Integer;

/**
 *  The package commons-fileupload-1.0.jar is downloaded from 
 *         http://jakarta.apache.org/commons/fileupload/ 
 *  and it has to be put under WEB-INF/lib/ directory in your servlet context.
 *  One shall also modify the CLASSPATH to include this jar file.
 */
import org.apache.commons.fileupload.DiskFileUpload;
import org.apache.commons.fileupload.FileItem;

public class MUploadInfo extends HttpServlet {
    public String response_message;
    public void doPost(HttpServletRequest request,HttpServletResponse response)
	throws ServletException, IOException {
	//  change the following parameters to connect to the oracle database
	String username = "pachala";
	String password = "Cheapradio1";
	String drivername = "oracle.jdbc.driver.OracleDriver";
	String dbstring ="jdbc:oracle:thin:@gwynne.cs.ualberta.ca:1521:CRS";
	int number = Integer.valueOf(request.getParameter("numofphotos"));
	String permission = request.getParameter("permission");
	String subject = request.getParameter("subject");
	String year = request.getParameter("year");
	String month = request.getParameter("month");
	String day = request.getParameter("day");
	String desc = request.getParameter("description");
	String place = request.getParameter("place");

	String date = year+"-"+month+"-"+day;
	String user = "dummy";
	int permissionint=0;
	int pic_id = 0;

	try {
	    
            // Connect to the database and create a statement
        Connection conn = getConnected(drivername,dbstring, username,password);
	    Statement stmt = conn.createStatement();
	    for(int i=0;i<number;i++){
	    	ResultSet rset1 = stmt.executeQuery("SELECT pic_id_sequence.nextval from dual");
	    	rset1.next();
	    	pic_id = rset1.getInt(1);
	    
	    	rset1 = stmt.executeQuery("SELECT group_id from groups where group_name='"+permission+"'");
	    	rset1.next();
	    	permissionint = rset1.getInt(1);
	    //Insert an empty blob into the table first. Note that you have to 
	    //use the Oracle specific function empty_blob() to create an empty blob
	    	stmt.execute("INSERT INTO images VALUES("+pic_id+",'"+user+"',"+permissionint+",'"+subject+"','"+place+"',DATE '"+date+"','"+desc+"',empty_blob(),empty_blob())");
			stmt.executeUpdate("commit");
		}
	    response_message = " Upload OK!  ";
        conn.close();

	} catch( Exception ex ) {
	    //System.out.println( ex.getMessage());
	    response_message = ex.getMessage();
	}

	//Output response to the client
	response.setContentType("text/html");
	PrintWriter out = response.getWriter();
	out.println("<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.0 " +
		    "Transitional//EN\">\n" +
		    "<HTML>\n" +
		    "<HEAD><TITLE>Upload Message</TITLE></HEAD>\n" +
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