@isTest
private class WelcomeEmailTriggerHelperTest {
    
    @isTest
    static void WelcomeEmailTriggerHelperTestMethod()
    {
        WelcomeEmailTriggerHelper.et= NULL;
        WelcomeEmailTriggerHelper.oldUserMap= NULL;
        WelcomeEmailTriggerHelper.owea= NULL;
        WelcomeEmailTriggerHelper.getEt();
        WelcomeEmailTriggerHelper.resetUserMap();
        WelcomeEmailTriggerHelper.getoldUserMap(NULL);
        WelcomeEmailTriggerHelper.getOrgWideEmails();
    }

}