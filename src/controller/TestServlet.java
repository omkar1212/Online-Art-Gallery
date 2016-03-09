package controller;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.websocket.Session;

import model.AuthDAO;

import org.apache.jasper.tagplugins.jstl.core.Out;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.mysql.jdbc.UpdatableResultSet;

/**
 * Servlet implementation class TestServlet
 */
@WebServlet("/TestServlet")
public class TestServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
    /**
     * @see HttpServlet#HttpServlet()
     */
    public TestServlet() {
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
        
		int action = Integer.parseInt(request.getParameter("action"));
		int success = 0;
		if (action == 1) { // admin UI to update permissions
			int userId = Integer.parseInt(request.getParameter("userId"));
			System.out.println("USER ID =" + userId);
			int isManager = Integer.parseInt(request.getParameter("isManager"));
			System.out.println("isManager =" + isManager);
			success = AuthDAO.updatePermissions(isManager, userId);
	        response.setContentType("text/plain");
	        response.getWriter().write(success+"");
		}else if(action == 2){ // manager UI update item
			int id = Integer.parseInt(request.getParameter("id"));
			System.out.println("USER ID =" + id);
			String name = request.getParameter("name");
			System.out.println("name ="+name);
			String type = request.getParameter("type");
			System.out.println("type ="+type);
			String artist = request.getParameter("artist");
			System.out.println("artist ="+artist);
			float price = Float.parseFloat(request.getParameter("price"));
			System.out.println("price ="+price);
			int stock = Integer.parseInt(request.getParameter("stock"));
			System.out.println("stock ="+stock);
			String desc = request.getParameter("desc");
			System.out.println("desc ="+desc);
			success = AuthDAO.updateItem(id, name, type, artist, price, stock, desc);
	        response.setContentType("text/plain");
	        response.getWriter().write(success+"");
		}else if(action == 3){ // manager UI get queries
			JSONArray ja = AuthDAO.getQueries();
	        response.setContentType("application/json");
	        response.getWriter().write(ja+"");
		}else if(action == 4){ // customer add to wishlist
			int id = Integer.parseInt(request.getParameter("id"));
			System.out.println("USER ID =" + id);
			String name = request.getParameter("name");
			System.out.println("name ="+name);
			int customer = Integer.parseInt(request.getParameter("customer"));
			System.out.println("customer =" + customer);
			String type = request.getParameter("type");
			System.out.println("type ="+type);
			String artist = request.getParameter("artist");
			System.out.println("artist ="+artist);
			float price = Float.parseFloat(request.getParameter("price"));
			System.out.println("price ="+price);
			String image = request.getParameter("image");
			System.out.println("image ="+image);
			String desc = request.getParameter("desc");
			System.out.println("desc ="+desc);
			success = AuthDAO.addToWishList(id,name,customer,type, artist, price, image, desc);
			response.setContentType("text/plain");
	        response.getWriter().write(success+"");
		}else if(action == 5){ // customer remove from wishlist
			int id = Integer.parseInt(request.getParameter("id"));
			System.out.println("USER ID =" + id);
			int customer = Integer.parseInt(request.getParameter("customer"));
			System.out.println("customer =" + customer);
			success = AuthDAO.removeFromWishList(id,customer);
			response.setContentType("text/plain");
	        response.getWriter().write(success+"");
		}else if(action == 6){ // customer UI get wishlist
			int customer = Integer.parseInt(request.getParameter("customer"));
			System.out.println("customer =" + customer);
			JSONArray ja = AuthDAO.getWishList(customer);
	        response.setContentType("application/json");
	        response.getWriter().write(ja+"");
		}else if(action == 7){ // add to cart
			int id = Integer.parseInt(request.getParameter("id"));
			System.out.println("USER ID =" + id);
			String name = request.getParameter("name");
			System.out.println("name ="+name);
			int customer = Integer.parseInt(request.getParameter("customer"));
			System.out.println("customer =" + customer);
			String type = request.getParameter("type");
			System.out.println("type ="+type);
			String artist = request.getParameter("artist");
			System.out.println("artist ="+artist);
			float price = Float.parseFloat(request.getParameter("price"));
			System.out.println("price ="+price);
			String image = request.getParameter("image");
			System.out.println("image ="+image);
			String desc = request.getParameter("desc");
			System.out.println("desc ="+desc);
						
			HttpSession session = request.getSession();
			System.out.println("cart--"+session.getAttribute("cart"));
			JSONArray shoppingCart = (JSONArray) session.getAttribute("cart");

			
			System.out.println("initial cart -- "+shoppingCart);
			
			JSONObject jobj = new JSONObject();
			try{
				jobj.put("item_id", id);
				jobj.put("item_name", name);
				jobj.put("item_type", type);
				jobj.put("artist", artist);
				jobj.put("price", price);
				jobj.put("image_url", image);
				jobj.put("item_description", desc);
				jobj.put("customer", customer);
				shoppingCart.put(jobj);
			}catch(Exception e){
				
			}
			
			System.out.println("CART --> "+shoppingCart);

	        response.setContentType("application/json");
	        response.getWriter().write(shoppingCart+"");
		}else if(action == 8){ // customer UI show cart
			int customer = Integer.parseInt(request.getParameter("customer"));
			System.out.println("customer =" + customer);
			
			HttpSession session = request.getSession();
			System.out.println("cart--"+session.getAttribute("cart"));
			
			JSONArray ja = (JSONArray) session.getAttribute("cart");
	        response.setContentType("application/json");
	        response.getWriter().write(ja+"");
		}else if(action == 9){ // customer remove from cart
			int id = Integer.parseInt(request.getParameter("id"));
			System.out.println("USER ID =" + id);
			int customer = Integer.parseInt(request.getParameter("customer"));
			System.out.println("customer =" + customer);
			
			HttpSession session = request.getSession();
			System.out.println("cart-delete->"+session.getAttribute("cart"));
			
			JSONArray ja = (JSONArray) session.getAttribute("cart");
			
			for (int i = 0; i < ja.length(); i++) {
			    JSONObject jsonobject;
				try {
					jsonobject = ja.getJSONObject(i);
				    int itemId = jsonobject.getInt("item_id");
				    System.out.println(itemId);
				    if(itemId == id){
				    	System.out.println("MATCH");
				    	ja.remove(i);
				    	System.out.println("REMOVED "+itemId);
				    	success = 1;
				    }
				} catch (JSONException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}

			}
			
			response.setContentType("text/plain");
	        response.getWriter().write(success+"");
		}else if(action == 10){ // complete purchase
			String payment = request.getParameter("payment");
			System.out.println("payment ="+payment);
			int customer = Integer.parseInt(request.getParameter("customer"));
			System.out.println("customer =" + customer);
			int total = Integer.parseInt(request.getParameter("total"));
			System.out.println("total =" + total);
			String cardNumber = request.getParameter("cardNumber");
			System.out.println("cardNumber ="+cardNumber);
			String fname = request.getParameter("fname");
			System.out.println("fname ="+fname);
			String lname = request.getParameter("lname");
			System.out.println("lname ="+lname);
			String address = request.getParameter("address");
			System.out.println("address ="+address);
			String phone = request.getParameter("phone");
			System.out.println("phone ="+phone);
			

			success = AuthDAO.completePurchase(customer, total, payment, cardNumber, fname, lname, address, phone);
			
			HttpSession session = request.getSession();
			JSONArray ja = (JSONArray) session.getAttribute("cart");
			
			ja = new JSONArray();
			session.setAttribute("cart", ja);
			System.out.println("cart-after deletion->"+session.getAttribute("cart"));
			
			response.setContentType("text/plain");
	        response.getWriter().write(success+"");
		}else if(action == 11){ // manager get product list
			int customer = Integer.parseInt(request.getParameter("customer"));
			System.out.println("customer =" + customer);
			
			JSONArray ja = new JSONArray();
			
			ja = AuthDAO.getProductListByManager(customer);
			
	        response.setContentType("application/json");
	        response.getWriter().write(ja+"");
		}else if(action == 12){ // admin get product list		
			JSONArray ja = new JSONArray();
			
			ja = AuthDAO.getProductList();
			
	        response.setContentType("application/json");
	        response.getWriter().write(ja+"");
		}else if(action == 13){ // customer get order history		
			int customer = Integer.parseInt(request.getParameter("customer"));
			System.out.println("customer =" + customer);
			JSONArray ja = new JSONArray();
			ja = AuthDAO.getOrderHistory(customer);
			
	        response.setContentType("application/json");
	        response.getWriter().write(ja+"");
		}else if(action == 14){ // delete product
			int id = Integer.parseInt(request.getParameter("id"));
			System.out.println("product ID =" + id);
			success = AuthDAO.removeProduct(id);
			response.setContentType("text/plain");
	        response.getWriter().write(success+"");
		}else if(action == 15){ // delete user
			int id = Integer.parseInt(request.getParameter("userId"));
			System.out.println("user ID =" + id);
			success = AuthDAO.removeUser(id);
			response.setContentType("text/plain");
	        response.getWriter().write(success+"");
		}else if(action == 16){ // admin get users
			JSONArray ja = new JSONArray();
			ja = AuthDAO.getUserList();
	        response.setContentType("application/json");
	        response.getWriter().write(ja+"");
		}else if(action == 17){ // admin update order
			int id = Integer.parseInt(request.getParameter("id"));
			System.out.println("user ID =" + id);
			String status = request.getParameter("status");
			System.out.println("status =" + status);
			String review = request.getParameter("review");
			System.out.println("status =" + status);
			success = AuthDAO.updateOrder(id,status,review);
			response.setContentType("text/plain");
	        response.getWriter().write(success+"");
		}else if(action == 18){ // admin cancel order
			int id = Integer.parseInt(request.getParameter("id"));
			System.out.println("user ID =" + id);
			success = AuthDAO.cancelOrder(id);
			response.setContentType("text/plain");
	        response.getWriter().write(success+"");
		}
	}
}
