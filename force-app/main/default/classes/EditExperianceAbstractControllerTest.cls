@isTest
private class EditExperianceAbstractControllerTest {

    @isTest
    static void testAsInternalUser() {
        
        Test.setCurrentPage( new PageReference('/apex/nationalEducationKnowledge'));
        
        EditExperianceAbstractController controller = new TestController();
        
        System.assert(ApexPages.hasMessages());
    }


    @isTest
    static void testControllerForInternalUser() {
        
        User usr = TestsUtil.createPortalUser('test_user_name');
        insert usr;
        
        Test.setCurrentPage( new PageReference('/apex/nationalEducationKnowledge'));
        
        System.runAs(usr) {
            
            initBackgroundsForUser(usr);
            
            EditExperianceAbstractController controller = new TestController();
            
            System.assert(controller.getContactObject().Id == usr.ContactId);
            
            System.assertEquals(2, controller.getIBExperienceList().size());
            
            Pagereference myProfile = Page.myProfile;
            
            System.assert(controller.cancel().getUrl() == myProfile.getUrl());
        }
    }
        
    
    
    // test class
    private class TestController extends EditExperianceAbstractController {
        
        public TestController(){
            // existing IB_E_Background__c record type name
            super('Language Experience');
        }
        
    }


    private static void initBackgroundsForUser(User usr){
        
        RecordType rt1 = RecordTypeDAO.INSTANCE.getRecordTypeByNameAndsObjectType('Language Experience', 'IB_E_Background__c');
        //RecordType rt2 = RecordTypeDAO.INSTANCE.getRecordTypeByNameAndsObjectType('Educational Degrees', 'IB_E_Background__c');
        
        IB_E_Background__c myProfile1 = TestsUtil.createMyProfileObject(usr.ContactId, rt1.Id);
        IB_E_Background__c myProfile2 = TestsUtil.createMyProfileObject(usr.ContactId, rt1.Id);
        insert new List<IB_E_Background__c>{myProfile1,myProfile2};
    }
}