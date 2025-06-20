@isTest
private class UserTriggerHelperTest {
    
    @isTest
    static void assignmentCtrlTestMethod()
    {
        UserTriggerHelper.pingPermissionSetId = NULL;
        UserTriggerHelper.ccAdvProfileId = NULL;
        UserTriggerHelper.scuAdvProfileId = NULL;
        UserTriggerHelper.getPingPermissionSetId();
        UserTriggerHelper.getCcAdvProfileId();
        UserTriggerHelper.getScuAdvProfileId();
    }

}