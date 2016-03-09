package controller;

import java.io.IOException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import model.AuthDAO;

/**
 * Servlet implementation class SignupServlet
 */
@WebServlet("/SignupServlet")
public class SignupServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public SignupServlet() {
        super();
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
		String signupUrl = "/signup.jsp";
		
		String username = request.getParameter("username");
		if(username == null)
			username = "";
		System.out.println("Name = "+username);
		
		String checkUsername = request.getParameter("checkUsername");
		if(checkUsername == null)
			checkUsername = "";
		System.out.println("checkUsername = "+checkUsername);
		
		String firstName = request.getParameter("firstName");
		if(firstName == null)
			firstName = "";
		System.out.println("firstName = "+firstName);
		
		String lastName = request.getParameter("lastName");
		if(lastName == null)
			lastName = "";
		System.out.println("lastName = "+lastName);

		String password = request.getParameter("password");
		if(password == null)
			password = "";
		System.out.println("Password = "+password);
		
		String confirmPassword = request.getParameter("confirmPassword");
		if(confirmPassword == null)
			confirmPassword = "";
		System.out.println("confirmPassword = "+confirmPassword);
		
		String gender = request.getParameter("gender");
		if(gender == null)
			gender = "";
		System.out.println("gender = "+gender);
		
		String address = request.getParameter("address");
		if(address == null)
			address = "";
		System.out.println("address = "+address);
		
		String phone = request.getParameter("phone");
		if(phone == null)
			phone = "";
		System.out.println("phone = "+phone);
		
		if(checkUsername.equals("Check")){
			boolean isUsernameAvailable = false;
			if(username.equals("admin")){
				isUsernameAvailable = false;
			}else{
				isUsernameAvailable = AuthDAO.isUserNameAvailable(username);	
			}		
			System.out.println("isUsernameAvailable = "+isUsernameAvailable);
			response.sendRedirect(getServletContext().getContextPath()+signupUrl+"?status="+isUsernameAvailable);
		}else{
			boolean isUsernameAvailable = false;
			if(username.equals("admin")){
				isUsernameAvailable = false;
			}else{
				isUsernameAvailable = AuthDAO.isUserNameAvailable(username);	
			}	
			System.out.println("isUsernameAvailable = "+isUsernameAvailable);
			if(isUsernameAvailable){
				int newUser = AuthDAO.enterNewUser(username, password);
				System.out.println("newUser = "+newUser);
				if(newUser > 0){
					AuthDAO.enterUserName(newUser, firstName, lastName, gender, address, phone);
				}
				response.sendRedirect(getServletContext().getContextPath()+signupUrl+"?status="+newUser);
			}else{
				response.sendRedirect(getServletContext().getContextPath()+signupUrl+"?status="+isUsernameAvailable);
			}
		}
		
	}

}
