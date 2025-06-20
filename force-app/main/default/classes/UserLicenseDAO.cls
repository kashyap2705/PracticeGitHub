public with sharing class UserLicenseDAO {

     public static final UserLicenseDAO INSTANCE = new UserLicenseDAO();
	
	 private UserLicenseDAO () {
			
	 }
		
	 public UserLicense getLicenseByProfileId (String profileId) {
			
		if ( String.isBlank(profileId)) {
		  	 throw new DAOException( ' profileId parameter can not be null or empty string !!');
		    	
		}
		List<UserLicense> result  = [Select u.Name, u.Id From UserLicense u where u.id IN (select  p.UserLicenseId From Profile p where id =: profileId)];
			   
		if (null == result || result.isEmpty()) {
        	return null;
        }
                
        return result.get(0);
        
	 }  
	   
   
}