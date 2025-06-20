@isTest
public with sharing class PimsViewReportsControllerTest {

	@testSetup
	static void setup(){

        Account theAccount = PimsTestUtil.createAccount('ThatThereSchool','School Account');
        theAccount.Lead_Account__c = true;
        insert theAccount;

        Contact theContact = PimsTestUtil.createContact('Robert Strunk','RS@rs.com','rs@profEmail.com', Date.newInstance(1984, 09, 14), theAccount);
        insert theContact;

        IB_Programme__c theProgramme = PimsTestUtil.createProgrammeForAccount (theAccount,'MYP');
        insert theProgramme;

        IB_Application__c theApp = new IB_Application__c(
            AC_3_1_Feasability_Lead__c = theContact.Id,
            Application_Lookup_to_Programme__c = theProgramme.Id,
            AFC_Assessment_Status__c = 'Complete',
            AFC_Collaborative_Planning_Status__c = 'Complete' ,
            AFC_Documents_Status__c = 'Complete' ,
            AFC_Implementation_Budget_Status__c = 'Complete' ,
            AFC_Leadership_Structure_Status__c = 'Complete' ,
            AFC_Philosophy_Status__c = 'Complete' ,
            AFC_Profile_Review_Status__c = 'Complete' ,
            AFC_Programme_Information_Status__c = 'Complete' ,
            AFC_Resources_Support_Status__c = 'Complete' ,
            AFC_School_Description_Status__c = 'Complete' ,
            AFC_Subject_Proposal_Status__c = 'Complete' ,
            AFC_Written_Curriculum_Status__c = 'Complete'
        );

        insert theApp;

        Profile p =  [select Id from profile where Name='Customer Community Advanced' limit 1];

        User pu = new User(profileId = p.id, username = 'rs1@email.com', email = 'rs1@email.com',
                           emailencodingkey = 'UTF-8', localesidkey = 'en_US',
                           languagelocalekey = 'en_US', timezonesidkey = 'America/Los_Angeles',
                           alias='cspu', lastname='lastname', contactId = theContact.id);

        insert pu;
	}

	static testmethod void success(){

		Boolean hasError = false;

		System.Test.startTest();

			try{
				User u = [SELECT Id FROM User WHERE Username = 'rs1@email.com' limit 1];

				System.runAs(u){

					Pagereference tmpRef = Page.PimsViewReports;
					tmpRef.getParameters().put('pid', [select Id from ib_programme__c limit 1][0].Id);
					System.Test.setCurrentPage(tmpRef);
					PimsViewReportsController con = new PimsViewReportsController();
					con.application = new IB_Application__c();
					con.programmes = new List<IB_Programme__c>();
					IB_Application__c tmpApp = con.application;
					List<IB_Programme__c> tmpProgs = con.programmes;
	            }
			}
			catch(Exception e){
				hasError = true;
			}

		System.Test.stopTest();

		System.Assert(!hasError);
	}

	static testmethod void fail(){

		Boolean hasError = false;

		System.Test.startTest();

			try{
				User u = [SELECT Id FROM User WHERE Username = 'rs1@email.com' limit 1];

				System.runAs(u){

					Pagereference tmpRef = Page.PimsViewReports;
					//tmpRef.getParameters().put('pid', [select Id from ib_programme__c limit 1][0].Id);
					System.Test.setCurrentPage(tmpRef);
					PimsViewReportsController con = new PimsViewReportsController();
	            }
			}
			catch(Exception e){
				hasError = true;
			}

		System.Test.stopTest();

		System.Assert(hasError);
	}
}