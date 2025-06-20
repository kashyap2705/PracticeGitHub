@isTest
private class PimsCommunityServiceTest {
    
     @isTest
    static void PimsCommunityServiceTestMethod()
    {
        PimsCommunityService obj = new PimsCommunityService();
        obj.user=NULL;
        obj.contact=NULL;
        obj.account=NULL;
        obj.accountOverrideId=NULL;
        obj.roles=NULL;
        obj.vsContact=NULL;
       
        obj.getCurrentUser();
        obj.getCurrentContact();
        obj.getCurrentAccount();
        obj.initUserData();
        obj.setAccountCookie(NULL);
        obj.getAccountCookie();
     
    }

}