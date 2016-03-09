package controller;

import java.io.IOException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.JSONArray;

import model.AuthDAO;
import model.Product;
import model.User;

/**
 * Servlet implementation class LoginServlet
 */
@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private static String adminUsername = "admin";
	private static String adminPassword = "admin";
    /**
     * @see HttpServlet#HttpServlet()
     */
    public LoginServlet() {
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
		String indexUrl = "/index.jsp";
		String loginUrl = "/login.jsp";
		String isLoginSuccessful = "false";
		JSONArray json = null;
		HttpSession session = null;
		
		String name = request.getParameter("name");
		if(name == null)
			name = "";
		System.out.println("Name = "+name);

		String pass = request.getParameter("pass");
		if(pass == null)
			pass = "";
		System.out.println("Password = "+pass);
		User user = new User();
		int authenticationSuccessful = 0;
		if(name.equals(adminUsername) && pass.equals(adminPassword)){
			authenticationSuccessful = 1;
			System.out.println("authenticationSuccessful = "+authenticationSuccessful);
			if(authenticationSuccessful > 0){
				isLoginSuccessful = "true";
				user.setName(adminUsername);
				user.setLastName(adminPassword);
				user.setIsManager(2);
				session = request.getSession();
				session.setAttribute("userObject", user);
				session.setAttribute("isLoginSuccessful", isLoginSuccessful);
				json = AuthDAO.getUserList();
				session.setAttribute("userList", json);
				json = AuthDAO.getProductList();
			}
		}else{
			authenticationSuccessful = AuthDAO.checkUserPass(name, pass, user);
			System.out.println("authenticationSuccessful = "+authenticationSuccessful);
			if(authenticationSuccessful > 0){
				isLoginSuccessful = "true";
				User userObject = AuthDAO.getUserById(authenticationSuccessful, user);
				session = request.getSession();
				System.out.println(userObject.getName());
				session.setAttribute("userId", authenticationSuccessful);
				session.setAttribute("userObject", userObject);
				session.setAttribute("isLoginSuccessful", isLoginSuccessful);		
				
				if(userObject.getIsManager() == 1){
					json = AuthDAO.getProductListByManager(authenticationSuccessful);
				}else{
					json = AuthDAO.getProductList();
					JSONArray cart = new JSONArray();
					session.setAttribute("cart",cart);
					System.out.println("cart created--"+session.getAttribute("cart"));
				}
			}
		}
		
		
		session.setAttribute("productList", json);
		System.out.println("productlist = "+json);
		System.out.println("isLoginSuccessful ? "+isLoginSuccessful);
		if(isLoginSuccessful.equals("true")){
			response.sendRedirect(getServletContext().getContextPath()+indexUrl);	
		}else{
			response.sendRedirect(getServletContext().getContextPath()+loginUrl+"?message=Please check your username or password !");
		}
		
		System.out.println("-----------");
	}

}
