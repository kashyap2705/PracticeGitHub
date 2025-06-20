public class UserDAO {

    public static final UserDAO instance = new UserDAO();

    private UserDAO() {}

    public static UserDAO getInstance() {
        return instance;
    }

    public User getCurrentUser() {

        Id userId = UserInfo.getUserId();

        User user = [
            SELECT Id, Name, ContactId, ProfileId, Username
            FROM User
            WHERE Id = :userId 
        ];

        return user;

    }

// THE FOLLOWING METHODS AND VARS ARE USED EXCLUSIVELY IN IBEN CENTRAL PORTAL
    private final String  INTERNAL_LICENSE = 'Salesforce';
    private final String PARTNER_COMMUNITY = 'Partner Community';

    //Check if current user is externa or internal user
    public boolean isInternalUserForProfileId () {
        
        UserLicense license  = UserLicenseDAO.INSTANCE.getLicenseByProfileId(Userinfo.getProfileId());
        system.debug(loggingLevel.ERROR, 'SITE NAME: ' + Site.getName());
        if (Site.getName() == 'My_School' || Site.getName() == 'ibportal') {
            return true;
        }
        else {
            return license.Name.contains(INTERNAL_LICENSE); 
        }     
        
    }

    
    public boolean isAcceptedExternalUserForProfileName (String name) {
        
        if ( String.isBlank(name)) {
             throw new DAOException( ' Name parameter can not be null or empty string !!');
                
        }
        
        final List<UserLicense> result  = [Select u.Name, u.Id From UserLicense u where u.id IN (select  p.UserLicenseId From Profile p where name =: name and Id = :Userinfo.getProfileId())];
               
        if (null == result || result.isEmpty()) {
            return false;
        }
                
        return result.get(0).Name.contains(INTERNAL_LICENSE);
        
    }  
     
            
    public User getUserById (String id) {

        if ( String.isBlank(id) ) {
            throw new DAOException(' Id can not be null or empty string !!');
            
        } 
        
        List<User> result = [Select u.Name, u.Username, u.Id, u.FirstName, u.LastModifiedDate, u.LastName, u.Email, u.Country, u.CountryCode, u.ContactId, u.AccountId, u.Profile.Name, u.Contact.IB_Region__c, u.UserPermissionsSupportUser From User u where Id =: id] ;
        
        if (null == result || result.isEmpty()) {
            return null;
        }
        
        return result.get(0);
    }
    
    public User getUserByContactId (String contid) {

        if ( String.isBlank(contid) ) {
            throw new DAOException(' Contact Id can not be null or empty string !!');
            
        } 
        
        List<User> result = [Select u.Name, u.Id, u.FirstName, u.LastName, u.Email, u.Country, u.CountryCode, u.ContactId, u.AccountId, u.IsActive, u.ProfileId From User u where u.ContactId =: contid] ;
        
        if (null == result || result.isEmpty()) {
            return null;
        }
        
        return result.get(0);
    }
    
    public User getFullUserPhotoUrlId (String id) {

        if ( String.isBlank(id) ) {
            throw new DAOException(' Id can not be null or empty string !!');
            
        } 
        
        List<User> result = [select FullPhotoUrl from User where Id = : id limit 1] ;
        
        if (null == result || result.isEmpty()) {
            return null;
        }
        
        return result.get(0);
    }

    public User getUserByUsername(String uName) {

        User user = null;

        try {

            user = [
                SELECT Id, Name, Username, ContactId, ProfileId 
                FROM User
                WHERE Username = :uName 
                LIMIT 1
            ];
        } 

        catch (Exception Ex) { }
        
        return user;
    }
    
}