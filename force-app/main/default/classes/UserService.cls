public class UserService { 

	public static User user = null;
    public static String userName = null;

	public static User getUser() {

		if (user == null) {
			UserDAO dao = UserDAO.getInstance();
			user = dao.getCurrentUser();
		}

		return user;

	}
    
    public static User getUserByUsername() {
        
        if (userName != null) {
            UserDAO dao = UserDAO.getInstance();
			user = dao.getUserByUsername(userName);
        }
        
        return user;
        
    }
    
    public static void setUserName(String uName) {
        userName = uName;
    }

}