@isTest
public class PimsAppCourseOutlineControllerTest {
    @isTest static void testPimsAppCourseOutlineController() 
    {
       try
        {
            
        Test.startTest();
  		Account theAccount = PimsTestUtil.createAccount('ThatThereSchool', 'School Account');
		insert theAccount;

		Contact theContact = PimsTestUtil.createContact('Robert Strunk', 'RS@rs.com', 'rs@profEmail.com', Date.newInstance(1984, 09, 14), theAccount);
		insert theContact;

		List<Contact> currContacts = new List<Contact>();
		currContacts.add(theContact);

		IB_Programme__c theProgramme = PimsTestUtil.createProgrammeForAccount (theAccount, 'MYP');
		insert theProgramme;
        
        IB_Subject__c ibsubject = new IB_Subject__c();
        ibsubject.IB_Programme__c = 'MYP';
        ibsubject.Subject_Name__c = 'Test Subject';
        insert ibsubject;
        
    

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

        Roles_and_Applications_Subject_Proposal__c subprop = new Roles_and_Applications_Subject_Proposal__c();
        subprop.IB_Application_Lookup__c = theApp.id;
        subprop.Subject_Lookup__c = ibsubject.id;
        insert subprop;
        
		Application_Coordinator_Time__c progCoordTime = new Application_Coordinator_Time__c(
		    Type__c = 'Programme coordinator',
		    IB_Application_Lookup__c = theApp.Id
		);
		insert progCoordTime;

		IB_Role_Repository__c theRoleRepo = new IB_Role_Repository__c(Role_Name__c = 'Programme Coordinator', Category__c = 'Programme Development');
		insert theRoleRepo;

		IB_Role__c theRole = new IB_Role__c(
		    IB_Role__c = theRoleRepo.Id,
		    IB_Programme_New__c = theProgramme.Id,
		    IB_Account__c = theAccount.Id,
		    IB_Contact__c = theContact.Id
		);
		insert theRole;

		List<IB_Role__c> currRoles = new List<IB_Role__c>();
		currRoles.add(theRole);

		Profile p =  [select Id from profile where Name = 'System Administrator' limit 1];
		User pu = new User(profileId = p.id, username = 'rs123@email.com', email = 'rs@email.com',
		                   emailencodingkey = 'UTF-8', localesidkey = 'en_US',
		                   languagelocalekey = 'en_US', timezonesidkey = 'America/Los_Angeles',
		                   alias = 'cspu', lastname = 'lastname');
		insert pu;

		//System.Test.startTest();

			System.runAs(pu) {
				Pagereference tmp = Page.PimsApplicationForAuthorization;
				tmp.getParameters().put('id', theApp.Id);

				System.Test.setCurrentPage(tmp);

				PageService.isActiveTabCached = true;
				PageService.ActiveTab = 'prog';
                
        PimsAppCourseOutlineController obj= new PimsAppCourseOutlineController();
        obj.initializeAllcomponentsfortest(ibsubject.id,subprop.id);
     
        //obj.programme.id='a1R0D000000BTn3';
     //   Test.stopTest();
        }
        }
        catch(exception x)
        {
            system.debug('exception occurred '+x);
        }
            
    }

	@isTest static void testPimsAppCourseOutlineController1() 
    {
       try
        {
            
  		Account theAccount = PimsTestUtil.createAccount('ThatThereSchool', 'School Account');
		insert theAccount;

		Contact theContact = PimsTestUtil.createContact('Robert Strunk', 'RS@rs.com', 'rs@profEmail.com', Date.newInstance(1984, 09, 14), theAccount);
		insert theContact;

		List<Contact> currContacts = new List<Contact>();
		currContacts.add(theContact);

		IB_Programme__c theProgramme = PimsTestUtil.createProgrammeForAccount (theAccount, 'Diploma_Programme');
		insert theProgramme;
        
        IB_Subject__c ibsubject = new IB_Subject__c();
        ibsubject.IB_Programme__c = 'DP';
        ibsubject.Subject_Name__c = 'Extended essay';
		ibsubject.Subject_Group__c = 'Diploma Programme Core';
        insert ibsubject;
        
    

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

        Roles_and_Applications_Subject_Proposal__c subprop = new Roles_and_Applications_Subject_Proposal__c();
        subprop.IB_Application_Lookup__c = theApp.id;
        subprop.Subject_Lookup__c = ibsubject.id;
        insert subprop;

		IB_Application_Attachment__c ibApplicationAttachIns = new IB_Application_Attachment__c();
		ibApplicationAttachIns.IB_Programme__c = theProgramme.Id;
		ibApplicationAttachIns.IB_Subject__c = ibsubject.Id;
		ibApplicationAttachIns.Type__c = 'Course outline';
		ibApplicationAttachIns.Category__c = 'Request for Authorization';
		ibApplicationAttachIns.Subject_Proposal__c = subprop.Id;
		insert ibApplicationAttachIns;
        
		Application_Coordinator_Time__c progCoordTime = new Application_Coordinator_Time__c(
		    Type__c = 'Programme coordinator',
		    IB_Application_Lookup__c = theApp.Id
		);
		insert progCoordTime;

		IB_Role_Repository__c theRoleRepo = new IB_Role_Repository__c(Role_Name__c = 'Programme Coordinator', Category__c = 'Programme Development');
		insert theRoleRepo;

		IB_Role__c theRole = new IB_Role__c(
		    IB_Role__c = theRoleRepo.Id,
		    IB_Programme_New__c = theProgramme.Id,
		    IB_Account__c = theAccount.Id,
		    IB_Contact__c = theContact.Id
		);
		insert theRole;

		List<IB_Role__c> currRoles = new List<IB_Role__c>();
		currRoles.add(theRole);

		Profile p =  [select Id from profile where Name = 'System Administrator' limit 1];
		User pu = new User(profileId = p.id, username = 'rs123@email.com', email = 'rs@email.com',
		                   emailencodingkey = 'UTF-8', localesidkey = 'en_US',
		                   languagelocalekey = 'en_US', timezonesidkey = 'America/Los_Angeles',
		                   alias = 'cspu', lastname = 'lastname');
		insert pu;

		Test.startTest();

			System.runAs(pu) {
				Pagereference tmp = Page.PimsApplicationForAuthorization;
				tmp.getParameters().put('id', theApp.Id);

				System.Test.setCurrentPage(tmp);

				PageService.isActiveTabCached = true;
				PageService.ActiveTab = 'prog';
						
				PimsAppCourseOutlineController obj= new PimsAppCourseOutlineController();
				obj.validateCourseOutlines();
				// obj.initializeAllcomponentsfortest(ibsubject.id,subprop.id);
				obj.deleteAppDocId = ibApplicationAttachIns.id;
				obj.removeAppDocument();
				
     
        	}
		Test.stopTest();
        }
        catch(exception x)
        {
            system.debug('exception occurred '+x);
        }
            
    }

	@isTest static void testPimsAppCourseOutlineController2() 
    {
       try
        {
            
  		Account theAccount = PimsTestUtil.createAccount('ThatThereSchool', 'School Account');
		insert theAccount;

		Contact theContact = PimsTestUtil.createContact('Robert Strunk', 'RS@rs.com', 'rs@profEmail.com', Date.newInstance(1984, 09, 14), theAccount);
		insert theContact;

		List<Contact> currContacts = new List<Contact>();
		currContacts.add(theContact);

		IB_Programme__c theProgramme = PimsTestUtil.createProgrammeForAccount (theAccount, 'Diploma_Programme');
		insert theProgramme;
        
        IB_Subject__c ibsubject = new IB_Subject__c();
        ibsubject.IB_Programme__c = 'DP';
        ibsubject.Subject_Name__c = 'Extended essay';
		ibsubject.Subject_Group__c = 'Diploma Programme Core';
        insert ibsubject;
        
    

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

        Roles_and_Applications_Subject_Proposal__c subprop = new Roles_and_Applications_Subject_Proposal__c();
        subprop.IB_Application_Lookup__c = theApp.id;
        subprop.Subject_Lookup__c = ibsubject.id;
        insert subprop;

		IB_Application_Attachment__c ibApplicationAttachIns = new IB_Application_Attachment__c();
		ibApplicationAttachIns.IB_Programme__c = theProgramme.Id;
		ibApplicationAttachIns.IB_Subject__c = ibsubject.Id;
		ibApplicationAttachIns.Type__c = 'Course outline';
		ibApplicationAttachIns.Category__c = 'Request for Authorization';
		ibApplicationAttachIns.Subject_Proposal__c = subprop.Id;
		insert ibApplicationAttachIns;
        
		Application_Coordinator_Time__c progCoordTime = new Application_Coordinator_Time__c(
		    Type__c = 'Programme coordinator',
		    IB_Application_Lookup__c = theApp.Id
		);
		insert progCoordTime;

		IB_Role_Repository__c theRoleRepo = new IB_Role_Repository__c(Role_Name__c = 'Programme Coordinator', Category__c = 'Programme Development');
		insert theRoleRepo;

		IB_Role__c theRole = new IB_Role__c(
		    IB_Role__c = theRoleRepo.Id,
		    IB_Programme_New__c = theProgramme.Id,
		    IB_Account__c = theAccount.Id,
		    IB_Contact__c = theContact.Id
		);
		insert theRole;

		List<IB_Role__c> currRoles = new List<IB_Role__c>();
		currRoles.add(theRole);

		Profile p =  [select Id from profile where Name = 'System Administrator' limit 1];
		User pu = new User(profileId = p.id, username = 'rs123@email.com', email = 'rs@email.com',
		                   emailencodingkey = 'UTF-8', localesidkey = 'en_US',
		                   languagelocalekey = 'en_US', timezonesidkey = 'America/Los_Angeles',
		                   alias = 'cspu', lastname = 'lastname');
		insert pu;

		Test.startTest();

			System.runAs(pu) {
				Pagereference tmp = Page.PimsApplicationForAuthorization;
				tmp.getParameters().put('id', theApp.Id);

				System.Test.setCurrentPage(tmp);

				PageService.isActiveTabCached = true;
				PageService.ActiveTab = 'prog';
						
				PimsAppCourseOutlineController obj= new PimsAppCourseOutlineController();
				obj.upload();
				obj.save();
        	}
		Test.stopTest();
        }
        catch(exception x)
        {
            system.debug('exception occurred '+x);
        }
            
    }
}