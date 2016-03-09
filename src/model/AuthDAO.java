package model;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;

import org.json.JSONArray;
import org.json.JSONObject;

import jdk.nashorn.internal.runtime.JSONFunctions;

import com.mysql.jdbc.Statement;

public class AuthDAO {
	private static Connection connection = null;
	private static PreparedStatement ps = null;
	private static ResultSet rs = null;
	
	public static int checkUserPass(String userName, String password, User user){
		int userId = 0;
		try{
			Class.forName("com.mysql.jdbc.Driver");
		} catch (ClassNotFoundException ex) {
			System.out.println("Error 1 :: checkUserPass :: "+ex);
		}
		try{
			connection = DriverManager.getConnection("jdbc:mysql://localhost:3306/se", "root", "root");			
			String query = "SELECT userId,isManager from user where username = ? AND password = ?";
			ps = connection.prepareStatement(query);
			ps.setString(1, userName);
			ps.setString(2, password);
			rs = ps.executeQuery();
			
			if(rs.next()){
				userId = rs.getInt("userId");
				user.setIsManager(rs.getInt("isManager"));
			}
		}catch (Exception ex){
			userId = 0;
			System.out.println("Error 2 :: checkUserPass :: "+ex);
		}finally{
			try{
				DB_Close();
				System.out.println("Connection closed successfully !");
			}catch(SQLException se){
				System.out.println("Exception while closing connection - "+se);
			}
		}
		return userId;
	}
	
	public static User getUserById(int userId, User user){
		try{
			Class.forName("com.mysql.jdbc.Driver");
		} catch (ClassNotFoundException ex) {
			System.out.println("Error 1 :: checkUserPass :: "+ex);
		}
	
		try{
			connection = DriverManager.getConnection("jdbc:mysql://localhost:3306/se", "root", "root");			
			String query = "SELECT firstName,lastName from user_profile where userId = ?";
			System.out.println("====="+userId);
			ps = connection.prepareStatement(query);
			ps.setInt(1, userId);
			rs = ps.executeQuery();
			
			if(rs.next()){
				user.setName(rs.getString("firstName"));
				user.setLastName(rs.getString("lastName"));
				System.out.println("name = "+user.getName());
			}
		}catch (Exception ex){
			System.out.println("Error 2 :: checkUserPass :: "+ex);
		}finally{
			try{
				DB_Close();
				System.out.println("Connection closed successfully !");
			}catch(SQLException se){
				System.out.println("Exception while closing connection - "+se);
			}
		}
		return user;
	}
	
	public static int enterNewUser(String userName, String password){
		int result = -1;
		try{
			Class.forName("com.mysql.jdbc.Driver");
		} catch (ClassNotFoundException ex) {
			System.out.println("Error 1 :: checkUserPass :: "+ex);
		}
		try{
			connection = DriverManager.getConnection("jdbc:mysql://localhost:3306/se", "root", "root");			
			String query = "INSERT INTO user (username,password) VALUES (?,?)";
			
			ps = connection.prepareStatement(query,Statement.RETURN_GENERATED_KEYS);
			ps.setString(1, userName);
			ps.setString(2, password);
			ps.executeUpdate();
			
			rs = ps.getGeneratedKeys();
			
			if(rs.next()){
				result = rs.getInt(1);
			}
			
			System.out.println("result = "+result);
			
		}catch (Exception ex){
			System.out.println("Error 2 :: checkUserPass :: "+ex);
		}finally{
			try{
				DB_Close();
				System.out.println("Connection closed successfully !");
			}catch(SQLException se){
				System.out.println("Exception while closing connection - "+se);
			}
		}
		return result;
	}
	
	public static boolean enterUserName(int userId, String firstName, String lastName, String gender, String address, String phone){
		int result = -1;
		boolean inserted = false;
		try{
			Class.forName("com.mysql.jdbc.Driver");
		} catch (ClassNotFoundException ex) {
			System.out.println("Error 1 :: enterUserName :: "+ex);
		}
		try{
			connection = DriverManager.getConnection("jdbc:mysql://localhost:3306/se", "root", "root");			
			String query = "INSERT INTO user_profile (userId,firstName,lastName,gender,address,phone_no) VALUES (?,?,?,?,?,?)";
			ps = connection.prepareStatement(query);
			ps.setInt(1, userId);
			ps.setString(2, firstName);
			ps.setString(3, lastName);
			ps.setString(4, gender);
			ps.setString(5, address);
			ps.setString(6, phone);
			result = ps.executeUpdate();
			System.out.println("result = "+result);
			
			if(result > 0){
				inserted = true;
			}
			
		}catch (Exception ex){
			System.out.println("Error 2 :: enterUserName :: "+ex);
		}finally{
			try{
				DB_Close();
				System.out.println("Connection closed successfully !");
			}catch(SQLException se){
				System.out.println("Exception while closing connection - "+se);
			}
		}
		return inserted;

	}
	
	public static boolean isUserNameAvailable(String userName){
		int userId = 0;
		boolean isAvailable = true;
		try{
			Class.forName("com.mysql.jdbc.Driver");
		} catch (ClassNotFoundException ex) {
			System.out.println("Error 1 :: isUserNameAvailable :: "+ex);
		}
		try{
			connection = DriverManager.getConnection("jdbc:mysql://localhost:3306/se", "root", "root");			
			String query = "SELECT userId from user where username = ?";
			ps = connection.prepareStatement(query);
			ps.setString(1, userName);
			rs = ps.executeQuery();
			
			if(rs.next()){
				userId = rs.getInt("userId");
			}
			if(userId > 0){
				isAvailable = false;
			}
		}catch (Exception ex){
			userId = 0;
			System.out.println("Error 2 :: isUserNameAvailable :: "+ex);
		}finally{
			try{
				DB_Close();
				System.out.println("Connection closed successfully !");
			}catch(SQLException se){
				System.out.println("Exception while closing connection - "+se);
			}
		}
		
		return isAvailable;
	}
	
	public static void DB_Close() throws SQLException{
		if(ps != null){
				ps.close();
		}
		if(rs != null){
				rs.close();
		}
		if(connection != null){
				connection.close();

		}
	}
	
	public static int enterEnquiry(String name, String email, String enquiry){
		int result = -1;
		try{
			Class.forName("com.mysql.jdbc.Driver");
		} catch (ClassNotFoundException ex) {
			System.out.println("Error 1 :: checkUserPass :: "+ex);
		}
		try{
			connection = DriverManager.getConnection("jdbc:mysql://localhost:3306/se", "root", "root");			
			String query = "INSERT INTO contactus (contact_name,email_id,query) VALUES (?,?,?)";
			
			ps = connection.prepareStatement(query,Statement.RETURN_GENERATED_KEYS);
			ps.setString(1, name);
			ps.setString(2, email);
			ps.setString(3, enquiry);
			ps.executeUpdate();
			
			rs = ps.getGeneratedKeys();
			
			if(rs.next()){
				result = rs.getInt(1);
			}
			
			System.out.println("result = "+result);
			
		}catch (Exception ex){
			System.out.println("Error 2 :: checkUserPass :: "+ex);
		}finally{
			try{
				DB_Close();
				System.out.println("Connection closed successfully !");
			}catch(SQLException se){
				System.out.println("Exception while closing connection - "+se);
			}
		}
		return result;
	}
	
	public static JSONArray getProductList(){
		//JSONObject json = new JSONObject();
		JSONArray json = new JSONArray();
		
		try{
			Class.forName("com.mysql.jdbc.Driver");
		} catch (ClassNotFoundException ex) {
			System.out.println("Error 1 :: checkUserPass :: "+ex);
		}
		try{
			connection = DriverManager.getConnection("jdbc:mysql://localhost:3306/se", "root", "root");			
			String query = "SELECT item_id,item_name,item_type,artist,price,stock,image_url,item_description from store";
			ps = connection.prepareStatement(query);
			rs = ps.executeQuery();

			while(rs.next()){
				Product product = new Product();
				product.setItemId(rs.getInt("item_id"));
				product.setItemName(rs.getString("item_name"));
				product.setItemtype(rs.getString("item_type"));
				product.setArtist(rs.getString("artist"));
				product.setPrice(rs.getString("price"));
				product.setStock(rs.getString("stock"));
				JSONObject jobj = new JSONObject();
				jobj.put("itemId", rs.getInt("item_id"));
				jobj.put("itemName", rs.getString("item_name"));
				jobj.put("itemType", rs.getString("item_type"));
				jobj.put("artist", rs.getString("artist"));
				jobj.put("price", rs.getString("price"));
				jobj.put("stock", rs.getString("stock"));
				jobj.put("image_url", rs.getString("image_url"));
				jobj.put("description", rs.getString("item_description"));
				json.put(jobj);
			}
			
			System.out.println("JSON -- "+json);
			
		}catch (Exception ex){
			System.out.println("Error 2 :: checkUserPass :: "+ex);
		}finally{
			try{
				DB_Close();
				System.out.println("Connection closed successfully !");
			}catch(SQLException se){
				System.out.println("Exception while closing connection - "+se);
			}
		}
		return json;
	}
	
	public static JSONArray getOrderHistory(int customer){
		//JSONObject json = new JSONObject();
		JSONArray json = new JSONArray();
		
		try{
			Class.forName("com.mysql.jdbc.Driver");
		} catch (ClassNotFoundException ex) {
			System.out.println("Error 1 :: checkUserPass :: "+ex);
		}
		try{
			connection = DriverManager.getConnection("jdbc:mysql://localhost:3306/se", "root", "root");		
			String tempQuery = "";
			if(customer > 0){
				tempQuery = " where customer_id = ?";
			}
			String query = "select purchase_id,price,payment_method,fname,lname,address,phone,purchase_date,order_status,purchase_review from purchase"+tempQuery;
			ps = connection.prepareStatement(query);
			if(customer > 0){
				ps.setInt(1, customer);
			}
			rs = ps.executeQuery();

			while(rs.next()){
				JSONObject jobj = new JSONObject();
				jobj.put("purchase_id", rs.getInt("purchase_id"));
				jobj.put("payment_method", rs.getString("payment_method"));
				jobj.put("fname", rs.getString("fname"));
				jobj.put("lname", rs.getString("lname"));
				jobj.put("price", rs.getString("price"));
				jobj.put("phone", rs.getString("phone"));
				jobj.put("purchase_date", rs.getString("purchase_date"));
				jobj.put("address", rs.getString("address"));
				jobj.put("order_status", rs.getString("order_status"));
				jobj.put("purchase_review", rs.getString("purchase_review"));
				json.put(jobj);
			}
			
			System.out.println("JSON -- "+json);
			
		}catch (Exception ex){
			System.out.println("Error 2 :: checkUserPass :: "+ex);
		}finally{
			try{
				DB_Close();
				System.out.println("Connection closed successfully !");
			}catch(SQLException se){
				System.out.println("Exception while closing connection - "+se);
			}
		}
		return json;
	}
	
	public static JSONArray getProductListByManager(int manager){
		//JSONObject json = new JSONObject();
		JSONArray json = new JSONArray();
		
		try{
			Class.forName("com.mysql.jdbc.Driver");
		} catch (ClassNotFoundException ex) {
			System.out.println("Error 1 :: checkUserPass :: "+ex);
		}
		try{
			connection = DriverManager.getConnection("jdbc:mysql://localhost:3306/se", "root", "root");			
			String query = "SELECT item_id,item_name,item_type,artist,price,stock,image_url,item_description from store where owner = ?";
			ps = connection.prepareStatement(query);
			ps.setInt(1, manager);
			rs = ps.executeQuery();

			while(rs.next()){
				Product product = new Product();
				product.setItemId(rs.getInt("item_id"));
				product.setItemName(rs.getString("item_name"));
				product.setItemtype(rs.getString("item_type"));
				product.setArtist(rs.getString("artist"));
				product.setPrice(rs.getString("price"));
				product.setStock(rs.getString("stock"));
				JSONObject jobj = new JSONObject();
				jobj.put("itemId", rs.getInt("item_id"));
				jobj.put("itemName", rs.getString("item_name"));
				jobj.put("itemType", rs.getString("item_type"));
				jobj.put("artist", rs.getString("artist"));
				jobj.put("price", rs.getString("price"));
				jobj.put("stock", rs.getString("stock"));
				jobj.put("image_url", rs.getString("image_url"));
				jobj.put("description", rs.getString("item_description"));
				json.put(jobj);
			}
			
			System.out.println("JSON -- "+json);
			
		}catch (Exception ex){
			System.out.println("Error 2 :: checkUserPass :: "+ex);
		}finally{
			try{
				DB_Close();
				System.out.println("Connection closed successfully !");
			}catch(SQLException se){
				System.out.println("Exception while closing connection - "+se);
			}
		}
		return json;
	}
	
	
	public static JSONArray getUserList(){
		//JSONObject json = new JSONObject();
		JSONArray json = new JSONArray();
		
		try{
			Class.forName("com.mysql.jdbc.Driver");
		} catch (ClassNotFoundException ex) {
			System.out.println("Error 1 :: checkUserPass :: "+ex);
		}
		try{
			connection = DriverManager.getConnection("jdbc:mysql://localhost:3306/se", "root", "root");			
			String query = "SELECT userId, username, isManager from user";
			ps = connection.prepareStatement(query);
			rs = ps.executeQuery();

			while(rs.next()){
				JSONObject jobj = new JSONObject();
				jobj.put("userId", rs.getInt("userId"));
				jobj.put("username", rs.getString("username"));
				jobj.put("isManager", rs.getInt("isManager"));
				json.put(jobj);
			}
			
			System.out.println("JSON -- "+json);
			
		}catch (Exception ex){
			System.out.println("Error 2 :: checkUserPass :: "+ex);
		}finally{
			try{
				DB_Close();
				System.out.println("Connection closed successfully !");
			}catch(SQLException se){
				System.out.println("Exception while closing connection - "+se);
			}
		}
		return json;
	}
	
	
	public static int updatePermissions(int status,int userId){
		int result = -1;
		try{
			Class.forName("com.mysql.jdbc.Driver");
		} catch (ClassNotFoundException ex) {
			System.out.println("Error 1 :: checkUserPass :: "+ex);
		}
		try{
			connection = DriverManager.getConnection("jdbc:mysql://localhost:3306/se", "root", "root");			
			String query = "UPDATE user SET isManager = ? where userId = ?";
			
			ps = connection.prepareStatement(query);
			ps.setInt(1, status);
			ps.setInt(2, userId);
			result = ps.executeUpdate();
			
			System.out.println("updatePermissions : result = "+result);
			
		}catch (Exception ex){
			System.out.println("Error 2 :: checkUserPass :: "+ex);
		}finally{
			try{
				DB_Close();
				System.out.println("Connection closed successfully !");
			}catch(SQLException se){
				System.out.println("Exception while closing connection - "+se);
			}
		}
		return result;
	}
	
	public static int updateItem(int id, String name, String type, String artist, float price, int stock, String desc){
		int result = -1;
		try{
			Class.forName("com.mysql.jdbc.Driver");
		} catch (ClassNotFoundException ex) {
			System.out.println("Error 1 :: checkUserPass :: "+ex);
		}
		try{
			connection = DriverManager.getConnection("jdbc:mysql://localhost:3306/se", "root", "root");			
			String query = "UPDATE store SET item_name = ?, item_type = ?, artist = ?, price = ?, stock = ?, item_description = ? where item_id = ?";
			
			ps = connection.prepareStatement(query);
			ps.setString(1, name);
			ps.setString(2, type);
			ps.setString(3, artist);
			ps.setDouble(4, price);
			ps.setInt(5, stock);
			ps.setString(6, java.net.URLDecoder.decode(desc, "UTF-8"));
			ps.setInt(7, id);
			result = ps.executeUpdate();
			
			System.out.println("updatePermissions : result = "+result);
			
		}catch (Exception ex){
			System.out.println("Error 2 :: checkUserPass :: "+ex);
		}finally{
			try{
				DB_Close();
				System.out.println("Connection closed successfully !");
			}catch(SQLException se){
				System.out.println("Exception while closing connection - "+se);
			}
		}
		return result;
	}
	
	public static JSONArray getQueries(){
		JSONArray json = new JSONArray();
		
		try{
			Class.forName("com.mysql.jdbc.Driver");
		} catch (ClassNotFoundException ex) {
			System.out.println("Error 1 :: checkUserPass :: "+ex);
		}
		try{
			connection = DriverManager.getConnection("jdbc:mysql://localhost:3306/se", "root", "root");			
			String query = "select contact_id, contact_name, email_id, query from contactus order by contact_id desc";
			ps = connection.prepareStatement(query);
			rs = ps.executeQuery();

			while(rs.next()){
				JSONObject jobj = new JSONObject();
				jobj.put("contact_id", rs.getInt("contact_id"));
				jobj.put("contact_name", rs.getString("contact_name"));
				jobj.put("email_id", rs.getString("email_id"));
				jobj.put("query", rs.getString("query"));
				json.put(jobj);
			}
			
			System.out.println("JSON -- "+json);
			
		}catch (Exception ex){
			System.out.println("Error 2 :: checkUserPass :: "+ex);
		}finally{
			try{
				DB_Close();
				System.out.println("Connection closed successfully !");
			}catch(SQLException se){
				System.out.println("Exception while closing connection - "+se);
			}
		}
		return json;
	}
	
	public static int addToWishList(int id, String name,int customer, String type, String artist, float price, String image, String desc){
		int result = -1;
		try{
			Class.forName("com.mysql.jdbc.Driver");
		} catch (ClassNotFoundException ex) {
			System.out.println("Error 1 :: checkUserPass :: "+ex);
		}
		try{
			connection = DriverManager.getConnection("jdbc:mysql://localhost:3306/se", "root", "root");			
			String query = "INSERT INTO wishlist (item_id,item_name,customer_id,item_type,artist,price,image_url,item_description) VALUES (?,?,?,?,?,?,?,?)";
			
			ps = connection.prepareStatement(query,Statement.RETURN_GENERATED_KEYS);
			ps.setInt(1, id);
			ps.setString(2, name);
			ps.setInt(3, customer);
			ps.setString(4, type);
			ps.setString(5, artist);
			ps.setFloat(6, price);
			ps.setString(7, java.net.URLDecoder.decode(image, "UTF-8"));
			ps.setString(8, java.net.URLDecoder.decode(desc, "UTF-8"));
			ps.executeUpdate();
			
			rs = ps.getGeneratedKeys();
			
			if(rs.next()){
				result = rs.getInt(1);
			}
			
			System.out.println("result = "+result);
			
		}catch (Exception ex){
			System.out.println("Error 2 :: checkUserPass :: "+ex);
		}finally{
			try{
				DB_Close();
				System.out.println("Connection closed successfully !");
			}catch(SQLException se){
				System.out.println("Exception while closing connection - "+se);
			}
		}
		return result;
	}
	
	public static int removeFromWishList(int id, int customer){
		int result = -1;
		try{
			Class.forName("com.mysql.jdbc.Driver");
		} catch (ClassNotFoundException ex) {
			System.out.println("Error 1 :: checkUserPass :: "+ex);
		}
		try{
			connection = DriverManager.getConnection("jdbc:mysql://localhost:3306/se", "root", "root");			
			String query = "delete from wishlist where item_id = ? and customer_id = ?";
			
			ps = connection.prepareStatement(query);
			ps.setInt(1, id);
			ps.setInt(2, customer);

			result = ps.executeUpdate();
			
			System.out.println("updatePermissions : result = "+result);
			
		}catch (Exception ex){
			System.out.println("Error 2 :: checkUserPass :: "+ex);
		}finally{
			try{
				DB_Close();
				System.out.println("Connection closed successfully !");
			}catch(SQLException se){
				System.out.println("Exception while closing connection - "+se);
			}
		}
		return result;
	}
	
	public static int removeProduct(int id){
		int result = -1;
		try{
			Class.forName("com.mysql.jdbc.Driver");
		} catch (ClassNotFoundException ex) {
			System.out.println("Error 1 :: checkUserPass :: "+ex);
		}
		try{
			connection = DriverManager.getConnection("jdbc:mysql://localhost:3306/se", "root", "root");			
			String query = "delete from store where item_id = ?";
			
			ps = connection.prepareStatement(query);
			ps.setInt(1, id);

			result = ps.executeUpdate();
			
			System.out.println("updatePermissions : result = "+result);
			
		}catch (Exception ex){
			System.out.println("Error 2 :: checkUserPass :: "+ex);
		}finally{
			try{
				DB_Close();
				System.out.println("Connection closed successfully !");
			}catch(SQLException se){
				System.out.println("Exception while closing connection - "+se);
			}
		}
		return result;
	}
	
	public static int removeUser(int id){
		int result = -1;
		try{
			Class.forName("com.mysql.jdbc.Driver");
		} catch (ClassNotFoundException ex) {
			System.out.println("Error 1 :: checkUserPass :: "+ex);
		}
		try{
			connection = DriverManager.getConnection("jdbc:mysql://localhost:3306/se", "root", "root");			
			String query = "delete from user_profile where userId = ?";
			
			ps = connection.prepareStatement(query);
			ps.setInt(1, id);

			result = ps.executeUpdate();
			
			String query1 = "delete from user where userId = ?";
			
			ps = connection.prepareStatement(query1);
			ps.setInt(1, id);

			result = ps.executeUpdate();
			
			System.out.println("updatePermissions : result = "+result);
			
		}catch (Exception ex){
			System.out.println("Error 2 :: checkUserPass :: "+ex);
		}finally{
			try{
				DB_Close();
				System.out.println("Connection closed successfully !");
			}catch(SQLException se){
				System.out.println("Exception while closing connection - "+se);
			}
		}
		return result;
	}
	
	public static int updateOrder(int id, String status, String review){
		int result = -1;
		try{
			Class.forName("com.mysql.jdbc.Driver");
		} catch (ClassNotFoundException ex) {
			System.out.println("Error 1 :: checkUserPass :: "+ex);
		}
		try{
			connection = DriverManager.getConnection("jdbc:mysql://localhost:3306/se", "root", "root");			
			String query = "update purchase set order_status = ?,purchase_review = ? where purchase_id = ?";
			
			ps = connection.prepareStatement(query);
			ps.setString(1, status);
			ps.setString(2, review);
			ps.setInt(3, id);
			
			result = ps.executeUpdate();
						
			System.out.println("updatePermissions : result = "+result);
			
		}catch (Exception ex){
			System.out.println("Error 2 :: checkUserPass :: "+ex);
		}finally{
			try{
				DB_Close();
				System.out.println("Connection closed successfully !");
			}catch(SQLException se){
				System.out.println("Exception while closing connection - "+se);
			}
		}
		return result;
	}
	
	public static int cancelOrder(int id){
		int result = -1;
		try{
			Class.forName("com.mysql.jdbc.Driver");
		} catch (ClassNotFoundException ex) {
			System.out.println("Error 1 :: checkUserPass :: "+ex);
		}
		try{
			connection = DriverManager.getConnection("jdbc:mysql://localhost:3306/se", "root", "root");			
			String query = "delete from purchase where purchase_id = ?";
			
			ps = connection.prepareStatement(query);
			ps.setInt(1, id);
			
			result = ps.executeUpdate();
						
			System.out.println("updatePermissions : result = "+result);
			
		}catch (Exception ex){
			System.out.println("Error 2 :: checkUserPass :: "+ex);
		}finally{
			try{
				DB_Close();
				System.out.println("Connection closed successfully !");
			}catch(SQLException se){
				System.out.println("Exception while closing connection - "+se);
			}
		}
		return result;
	}
	
	public static JSONArray getWishList(int customerId){
		JSONArray json = new JSONArray();
		
		try{
			Class.forName("com.mysql.jdbc.Driver");
		} catch (ClassNotFoundException ex) {
			System.out.println("Error 1 :: checkUserPass :: "+ex);
		}
		try{
			connection = DriverManager.getConnection("jdbc:mysql://localhost:3306/se", "root", "root");			
			String query = "select item_id,item_name,item_type,artist,price,image_url,item_description from wishlist where customer_id = ?";
			ps = connection.prepareStatement(query);
			ps.setInt(1, customerId);
			rs = ps.executeQuery();

			while(rs.next()){
				JSONObject jobj = new JSONObject();
				jobj.put("item_id", rs.getInt("item_id"));
				jobj.put("item_name", rs.getString("item_name"));
				jobj.put("item_type", rs.getString("item_type"));
				jobj.put("artist", rs.getString("artist"));
				jobj.put("price", rs.getString("price"));
				jobj.put("image_url", rs.getString("image_url"));
				jobj.put("item_description", rs.getString("item_description"));
				json.put(jobj);
			}
			
			System.out.println("JSON -- "+json);
			
		}catch (Exception ex){
			System.out.println("Error 2 :: checkUserPass :: "+ex);
		}finally{
			try{
				DB_Close();
				System.out.println("Connection closed successfully !");
			}catch(SQLException se){
				System.out.println("Exception while closing connection - "+se);
			}
		}
		return json;
	}
	
	public static int addToRepository(String name,String type, String artist, float price, int stock, String image, String desc, int owner){
		int result = -1;
		try{
			Class.forName("com.mysql.jdbc.Driver");
		} catch (ClassNotFoundException ex) {
			System.out.println("Error 1 :: checkUserPass :: "+ex);
		}
		try{
			connection = DriverManager.getConnection("jdbc:mysql://localhost:3306/se", "root", "root");			
			String query = "INSERT INTO store (item_name,item_type,artist,price,stock,image_url,item_description,owner) VALUES (?,?,?,?,?,?,?,?)";
			
			ps = connection.prepareStatement(query,Statement.RETURN_GENERATED_KEYS);
			ps.setString(1, name);
			ps.setString(2, type);
			ps.setString(3, artist);
			ps.setFloat(4, price);
			ps.setInt(5, stock);
			ps.setString(6, java.net.URLDecoder.decode(image, "UTF-8"));
			ps.setString(7, java.net.URLDecoder.decode(desc, "UTF-8"));
			ps.setInt(8, owner);
			ps.executeUpdate();
			
			rs = ps.getGeneratedKeys();
			
			if(rs.next()){
				result = rs.getInt(1);
			}
			
			System.out.println("result = "+result);
			
		}catch (Exception ex){
			System.out.println("Error 2 :: checkUserPass :: "+ex);
		}finally{
			try{
				DB_Close();
				System.out.println("Connection closed successfully !");
			}catch(SQLException se){
				System.out.println("Exception while closing connection - "+se);
			}
		}
		return result;
	}
	
	
	public static int completePurchase(int customer, int total, String payment, String cardNumber, String fname, String lname, String address, String phone){
		int result = -1;
		try{
			Class.forName("com.mysql.jdbc.Driver");
		} catch (ClassNotFoundException ex) {
			System.out.println("Error 1 :: checkUserPass :: "+ex);
		}
		try{
			connection = DriverManager.getConnection("jdbc:mysql://localhost:3306/se", "root", "root");			
			String query = "INSERT INTO purchase (price,payment_method,customer_id,card_number,fname,lname,address,phone,purchase_date,order_status,purchase_review) VALUES (?,?,?,?,?,?,?,?,?,?,?)";
			
			DateFormat dateFormat = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
			Date date = new Date();
			String formattedDate = dateFormat.format(date);
			System.out.println(formattedDate); //2014/08/06 15:59:48
			
			ps = connection.prepareStatement(query,Statement.RETURN_GENERATED_KEYS);
			ps.setInt(1, total);
			ps.setString(2, payment);
			ps.setInt(3, customer);
			ps.setString(4, cardNumber);
			ps.setString(5, fname);
			ps.setString(6, lname);
			ps.setString(7, address);
			ps.setString(8, phone);
			ps.setString(9, formattedDate);
			ps.setString(10, "Order Received");
			ps.setString(11, "No Reviews yet");
			ps.executeUpdate();
			
			rs = ps.getGeneratedKeys();
			
			if(rs.next()){
				result = rs.getInt(1);
			}
			
			System.out.println("result = "+result);
			
		}catch (Exception ex){
			System.out.println("Error 2 :: checkUserPass :: "+ex);
		}finally{
			try{
				DB_Close();
				System.out.println("Connection closed successfully !");
			}catch(SQLException se){
				System.out.println("Exception while closing connection - "+se);
			}
		}
		return result;
	}
	
}
