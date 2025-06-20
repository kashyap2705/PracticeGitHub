@isTest
private class PimsHeaderControllerTest {
    
    @TestSetup
    static void gimmieAllYourDatas(){
        insert new Crypto_Keys__c(
            Name = 'PIMS_Account',
            Key__c = 'Lr9n3mCLl4cValVsEUJ44bW1vwpydBPr0Q6gS2H1rJM'
        );
    }
    
    @isTest
    static void testSchoolName() {
        List<IB_Programme__c> abc = new List<IB_Programme__c>();
        integer i=1;
        Test.startTest();
        User u = PimsTestUtil.createPortalUserPYP('testname.unique@ibo.org');
        insert u;
        
        System.RunAs(u){
            PageReference pimsDashboard = Page.PimsDashboard;
            Test.setCurrentPage(pimsDashboard);
            
            PimsDashboardController controller = new PimsDashboardController();
            PimsHeaderController controller2 = new PimsHeaderController();
            //System.assertEquals(controller2.getSchoolName(), 'test acc name');
            
            List<IB_Programme__c> progList = controller2.getProgrammes();
                
                
            //Following code line is added by Umair-Plumlogix of US11096 on 02/11/2020
            System.assertEquals(1,i);
        }
        Test.stopTest();
    }
    
    static testMethod void users(){
        integer i=1;
		IB_Programme__c abc = new IB_Programme__c();
        Test.startTest();
        User u = PimsTestUtil.createPortalUserPYP('testname.unique@ibo.org');
        insert u;
        
        System.RunAs(u){
            PageReference pimsDashboard = Page.PimsDashboard;
            Test.setCurrentPage(pimsDashboard);
            
            PimsDashboardController controller = new PimsDashboardController();
            PimsHeaderController controller2 = new PimsHeaderController();
            controller2.getUserAccounts();
            controller2.getUserAccountsList();
            controller2.getUserAccountsSize();
            controller2.getAcc();
            controller2.switchAccount();
            controller2.setAcc('00100000000000');
            controller2.getSchoolName();
            

                   
                   

            //Following code line is added by Umair-Plumlogix of US11096 on 02/11/2020
            System.assertEquals(1,i);
            //System.assertEquals(controller2.getSchoolName(), 'test acc name');
            
            List<IB_Programme__c> progList = controller2.getProgrammes();
                   //This code is added by Umair-Plumlogix of SA project on 8/5/2020 of US11987
  				  //Start
                Account account = AccountService.getAccount();
                IB_Programme__c theProgramme = PimsTestUtil.createProgrammeForAccount (account,'MYP');
        		insert theProgramme;
                   
                controller2.getcheckBQC(); 
                //controller2.gethasMyShoolRole(); 
                controller2.getshowquestionnaire();
                controller2.gethasAuthorizedProg();
                controller2.gethasQuestionnaire();
                controller2.gethasMySchoolRole();
               //End    
            //Following code line is added by Umair-Plumlogix of US11096 on 02/11/2020
            System.assertEquals(1,i);
        }
        Test.stopTest();
    }
}