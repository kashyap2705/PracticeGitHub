public  class ContactDetailsWrapper {

    public static boolean isFirstLoad=true;
    public static string JobTitle;
    public static string email;
    public static string phone; 
    public static string phonenumber;
    public static string countrycode;
    
    public static Void SetFirstLoadComplete()
    {
        isFirstLoad=false;
    }
}