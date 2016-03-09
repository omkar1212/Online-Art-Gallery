package controller;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import model.AuthDAO;

/**
 * Servlet implementation class EnquiryServlet
 */
@WebServlet("/EnquiryServlet")
public class EnquiryServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public EnquiryServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doPost(request, response);
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String signupUrl = "/ContactUs.jsp";
		
		String name = request.getParameter("name");
		if(name == null)
			name = "";
		System.out.println("Name = "+name);
		
		String email = request.getParameter("email");
		if(email == null)
			email = "";
		System.out.println("email = "+email);
		
		String query = request.getParameter("query");
		if(query == null)
			query = "";
		System.out.println("query = "+query);

		int queryEntered = AuthDAO.enterEnquiry(name, email, query);
		
		response.sendRedirect(getServletContext().getContextPath()+signupUrl+"?status="+queryEntered);

	}

}
