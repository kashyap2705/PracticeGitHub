public class ProfileUpdateController {
    //This code is added as a part of ADASUS05 of Admin Assistant Project on 11/2/2021
    //Start 
    public void doProfileUpdate()
    {     
        try
        {
            System.debug('in doProfileUpdate');
            String userId = ApexPages.currentPage().getParameters().get('userId');
            String profileId = ApexPages.currentPage().getParameters().get('profileId');
            update new User(Id=userId,ProfileId = profileId);
        }
        Catch(Exception exp)
        {
            System.debug('in ProfileUpdateController::::user profile not update'+exp);
        }
    }
	//End
}