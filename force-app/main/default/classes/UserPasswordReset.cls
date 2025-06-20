public class UserPasswordReset {
    @InvocableMethod(label='Reset User Password' description='Iterate over Users, resetting their passwords.')
    public static void resetPassword(List<ResetRequest> request){
        
        //parse inputs and variables
        List<User> userList = request.get(0).users;
        
        for(User u : userList)   
        {
            System.resetPassword(u.Id,true);
        }
        return;
    }
    
    
    public class ResetRequest{
        
        @InvocableVariable
        public List<User> users;
        
    }
}