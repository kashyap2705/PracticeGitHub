@isTest
private class WizardErrorMessagesHelperTest {
    
    @isTest
    static void assignmentCtrlTestMethod()
    {
        Account acc2 = PimsTestUtil.createAccount('Test Account 2', '');
        //        insert acc2;
        insert new List<Account>{acc2};      
            Contact con1 = PimsTestUtil.createContact('Jones', 'con1@home.com', 'con1@prof.com', Date.newInstance(1984, 09, 14), acc2);
        //       insert con1;
        WizardErrorMessagesHelper.getErrorMessageBy(WizardErrorMessagesHelper.ERROR_TYPE.TYPE_1, con1, NULL);
        
    }

}