@isTest 
private class PimsProfileInfoControllerTest {
    
    @isTest 
    static void testUpdated() {
        try{
            PimsProfileInfoController controller;
            
            
            
            
            Account a = PimsTestUtil.createAccount('Coastal Cloud High School', 'School Account');
            a.Dial_code__c='Afghanistan (+93)';
            a.Phone_Number__c='315625011';
            insert a;
            Account a2 = PimsTestUtil.createAccount('Coastal Cloud High School 2', 'School Account');
            a2.Dial_code__c='Afghanistan (+93)';
            a2.Phone_Number__c='315625011';
            insert a2;
            a.Group_of_School__c = null;
            a.Group_of_schools_not_on_the_list__c = null;
            
            User u = PimsTestUtil.createPortalUserPYP('test.pims@gmail.com');
            insert u;
            Contact cont = [Select id,AccountId from Contact where id = :u.ContactId Limit 1];
            
            System.runAs(u) {
                
                PimsProfileInfoController test = new PimsProfileInfoController();
                PageReference pageRef = ApexPages.currentPage();
                
                test.redirectUrl=''    ;       
                test.gosCheckBox='false';
                test.isUpdatePage=false;
                test.activeTab = 'info';
                test.account = a;
                test.isNewSchoolPage=true;
                test.gosCheckBox = 'No';
                boolean ans = false;
                boolean val;
                
                val = test.getIsGroupOfSchoolsChecked();
                test.getAccount(cont.AccountId);
                pageRef = new PageReference('/pims/PimsProfile');
                
                test.save();
                test.gosCheckBox = 'No';
                test.save();
                
                test.gosCheckBox = 'Yes';
                test.account = a2;
                test.save();
                test.gosCheckBox = 'No';
                test.save();
            }
        }
        catch(Exception ex){
            System.debug('Exception: '+ex);
        }
    }
    
    @isTest 
    static void testNotUpdated() {
        
        PimsProfileInfoController controller;
        
        
        Account  a = PimsTestUtil.createAccount('Coastal Cloud High School', 'School Account');
        
        insert a;
        
        a.Group_of_School__c = null;
        a.Group_of_schools_not_on_the_list__c = null;
        
        User u = PimsTestUtil.createPortalUserPYP('test.pims@gmail.com');
        insert u;
        
        System.runAs(u) {
            
            PimsProfileInfoController test = new PimsProfileInfoController();
            PageReference pageRef = ApexPages.currentPage();
            
            test.gosCheckBox='Yes';
            test.isUpdatePage=true;
            test.activeTab = 'address';
            test.groupofschool = 'Coastal Cloud High School:abc';
            test.account = a;
            boolean ans = true;
            boolean val;
            
            val = test.getIsGroupOfSchoolsChecked();
            
            pageRef = new PageReference('/pims/PimsProfileNew');
            
            test.save();
            
        }
    }
    
    @isTest
    static void testForNotNull(){
        PimsProfileInfoController controller;
        
        
        Account  a = PimsTestUtil.createAccount('Coastal Cloud High School', 'School Account');
        insert a;
        //Errors with 'System.StringException: Invalid id: Coastal Cloud Group' which is a group
        //a.Group_of_School__c = 'Coastal Cloud Group';
        a.Group_of_schools_not_on_the_list__c = 'It is on the list';
        
    }
    
    //Added by Suraj as a part of ECM00665
    @testSetup static void methodName() {
        Profile p = [SELECT Id FROM Profile WHERE Name='ibportal Profile'];
        TestDataFactory.createUserTestData(p.id,1,True);
        User u = [SELECT Id, ProfileId FROM User WHERE Profile.Name ='ibportal Profile' LIMIT 1];
        Map<String,String> customLabelMap = new Map<String,String>();
        customLabelMap.put('Business_Registration_Num','Business_Registration_Num');
        customLabelMap.put('Vat_Gst_Ent','Vat_Gst_Ent');
        customLabelMap.put('Gst_Check','Gst_Check');
        customLabelMap.put('Gst_Check_Dec','Gst_Check_Dec');
        customLabelMap.put('Error_Message','Error_Message');
        customLabelMap.put('Country_Blank','Country_Blank');
        List<customlabel__c> customlabelList = TestDataFactory.customLabelRecords(customLabelMap.keySet(), true);
        
        List<Translation__c> transList = new List<Translation__c>();
        for(customlabel__c customLabel : customlabelList){
            transList.add(TestDataFactory.createTranslationTestData(customLabelMap.get(customLabel.Label__c),customLabel.id, 'American English'));
        }
        if(!transList.isEmpty())
            insert transList;
    }
    @isTest
    static void testPimsHelpModuleController() {
        Account a = PimsTestUtil.createAccount('Coastal Cloud High School', 'School Account');
        a.Dial_code__c='Afghanistan (+93)';
        a.Phone_Number__c='315625011';
        insert a;
        Account a2 = PimsTestUtil.createAccount('Coastal Cloud High School 2', 'School Account');
        a2.Dial_code__c='Afghanistan (+93)';
        a2.Phone_Number__c='315625011';
        insert a2;
        a.Group_of_School__c = null;
        a.Group_of_schools_not_on_the_list__c = null;
        
        User u = PimsTestUtil.createPortalUserPYP('test.pims@gmail.com');
        insert u;
        Contact cont = [Select id,AccountId from Contact where id = :u.ContactId Limit 1];
        
        
        
        
        List<customlabel__c> customlabelList = [select id from customlabel__c];
        
        List<Translation__c> translationList = [select id, Language__c, Value__c, CustomLabel__c from Translation__c];
        PimsProfileInfoController controller;
        System.runAs(u) {
            controller=new PimsProfileInfoController();
        }
        Map<String, String> translationsMap = controller.getTranslationsMap();
        system.assertEquals('Business_Registration_Num',controller.businessRegNum);
        system.assertEquals('Vat_Gst_Ent',controller.vatGstEnt);
        system.assertEquals('Gst_Check_Dec',controller.gstCheckDec);
        system.assertEquals('Gst_Check',controller.gstCheck);
        system.assertEquals('Error_Message',controller.errorMessage);
        system.assertEquals('Country_Blank',controller.countryBlank);
        
    }
    //END as a part of ECM00665
    
}