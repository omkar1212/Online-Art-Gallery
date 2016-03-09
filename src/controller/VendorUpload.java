package controller;

import java.io.File;
import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;

import model.AuthDAO;

/**
 * Servlet implementation class VendorUpload
 */
@WebServlet("/VendorUpload")
public class VendorUpload extends HttpServlet {
	private static final long serialVersionUID = 1L;
	
	private final String UPLOAD_DIRECTORY = "C:/Users/Omkar/workspace/Online Art Gallery/WebContent/images";
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public VendorUpload() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doPost(request,response);
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		String url = "/VendorUpload.jsp";
		
		String fileName = "";
		//process only if its multipart content
        if(ServletFileUpload.isMultipartContent(request)){
            try {
                List<FileItem> multiparts = new ServletFileUpload(new DiskFileItemFactory()).parseRequest(request);
              for(FileItem item : multiparts){
                    if(!item.isFormField()){
                    	fileName = new File(item.getName()).getName();
                        item.write( new File(UPLOAD_DIRECTORY + File.separator + fileName));
                      String Ipath=UPLOAD_DIRECTORY + File.separator + fileName;
                    }
                }
           
               //File uploaded successfully
              System.out.println("SUCCESS !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");

            } catch (Exception ex) {
            	
            }          
    		System.out.println("fileName = "+fileName);
    		response.sendRedirect(getServletContext().getContextPath()+url+"?fileName="+fileName);
        }else{
    		String name = request.getParameter("name");
    		if(name == null)
    			name = "";
    		System.out.println("Name = "+name);
    		
    		String type = request.getParameter("type");
    		if(type == null)
    			type = "";
    		System.out.println("type = "+type);
    		
    		String artist = request.getParameter("artist");
    		if(artist == null)
    			artist = "";
    		System.out.println("artist = "+artist);
    		
    		float price = Float.parseFloat(request.getParameter("price"));
    		System.out.println("price = "+price);

    		int stock = Integer.parseInt(request.getParameter("stock"));
    		System.out.println("stock = "+stock);
    		
    		String imgurl = request.getParameter("imgURL");
    		System.out.println("imgurl = "+imgurl);
    		
    		int owner = Integer.parseInt(request.getParameter("myId"));
    		System.out.println("owner = "+owner);
    		
    		String desc = request.getParameter("desc");
    		if(desc == null)
    			desc = "";
    		System.out.println("desc = "+desc);
    		int success = 0;
    		success = AuthDAO.addToRepository(name, type, artist, price, stock, imgurl, desc, owner);
    		System.out.println("success = "+success);
    		response.sendRedirect(getServletContext().getContextPath()+url+"?status="+success);
    		
        }
        


	}

}
