public with sharing class UserBusinessService {
    @future
    public static void updateUsersProfile(List<String> userIds, String newProfileId) {

        FutureHelper.stopFuture();
        final List<User> usersInfo =  [Select u.Name, u.Id, u.FirstName, u.LastName, u.Email, u.Country, u.CountryCode, u.ContactId, u.AccountId From User u where Id IN : userIds];
        for(User userInfo :  usersInfo) {
            userInfo.profileId = newProfileId; 
        }
        
        update usersInfo;
    }
}