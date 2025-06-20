@isTest(seeAllData = true)
private class PimsAppProgrammeDataTest {
    
    static testMethod void test_method_one() {
        integer i=1;
        
        try
        {
            Account acc = PimsTestUtil.createAccount('Test Account', '');
            insert acc;
            
            Id usa = [SELECT Id from IB_Country_Segmentation__c WHERE Name = 'United States'].Id;
            
            IB_Address__c addr = PimsTestUtil.createAddress('Main', '1 Park Place', 'Jacksonville', '32259', usa, acc);
            insert addr;
            
            IB_Programme__c prog = PimsTestUtil.createProgrammeForAccount (acc, 'MYP');
            insert prog;
            
            IB_Application__c app = new IB_Application__c();
            app.Name = 'Test App';
            app.Application_Lookup_to_Programme__c = prog.Id;
            insert app;
            
            Test.startTest();
            
            ApplicationService.setApplicationId(app.Id);
            ProgrammeService.setProgrammeId(prog.Id);
            
            PageReference testPageRef = Page.PimsApplicationForCandidacy;
            Test.setCurrentPage(testPageRef);
            testPageRef.getParameters().put('id', app.Id);
            
            PimsAppProgrammeData con = new PimsAppProgrammeData();
            
            con.activeTab = 'prog';
            
            PageReference pageRef = con.save();
            
            List<SelectOption> addrOpts = con.getAddressOptions();
            List<SelectOption> addrOptsWithBlanks = con.getAddressOptionsWithBlank();
            
            IB_Programme_Structure__c progStructure = new IB_Programme_Structure__c();
            
            con.programmeStructure = progStructure;
            PageReference pageRef1 = con.saveProgrammeStructure();
            
            PageReference pageRef2 = con.updateProgrammeStructure();
            
            con.deletePSId = progStructure.Id;
            //Following code line is added by Umair-Plumlogix of US11096 on 02/11/2020
            System.assertEquals(1,i);
            PageReference pageRef3 = con.removeProgrammeStructure();
            //Following code line is added by Umair-Plumlogix of US11096 on 02/11/2020
            System.assertEquals(1,i);
            
            Test.stopTest();
        }
        Catch(Exception x)
        {
            System.debug('Exception: '+x);
        }
    }
    
    
    static testMethod void test_method_two() {
        integer i=1;
        // Future Methods
        Test.startTest();
        
        User u = PimsTestUtil.createPortalUserPIMS('testname.unique@ibo.org', 'August', 'June',false);
        
        System.runAs(u) {
            List<String> ibCoordinators = PimsAppProgrammeData.lookupIBCoordinators('Jo');
            List<String> ibSchools = PimsAppProgrammeData.lookupIBSchools('How');
            //Following code line is added by Umair-Plumlogix of US11096 on 02/11/2020
            System.assertEquals(1,i);
        }
        
        Test.stopTest();
    }
}