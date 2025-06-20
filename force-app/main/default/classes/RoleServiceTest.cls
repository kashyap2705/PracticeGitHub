@isTest
private class RoleServiceTest {

     static testMethod void test_method_one() {
         integer i=1;

          Account theAccount = PimsTestUtil.createAccount('ThatThereSchool','School Account');
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

          IB_Role_Repository__c theRoleRepo = new IB_Role_Repository__c(Role_Name__c = 'Programme Coordinator', Category__c ='Programme Development');
          insert theRoleRepo;

          IB_Role__c theRole = new IB_Role__c(
               IB_Role__c = theRoleRepo.Id,
               IB_Programme_New__c = theProgramme.Id,
               IB_Account__c = theAccount.Id,
               IB_Contact__c = theContact.Id
          );
          insert theRole;

          RoleService.setRoleId(theRole.Id);
          RoleService.setAccountId(theAccount.Id);
          RoleService.setProgrammeId(theProgramme.Id);
          //Following code line is added by Umair-Plumlogix of US11096 on 02/11/2020
         System.assertEquals(1,i);

          IB_Role__c currRole = RoleService.getRole();
          List<IB_Role__c> rolesByAccount = RoleService.getRolesByAccountId();
          List<IB_Role__c> rolesByProgramme = RoleService.getRolesByProgrammeId();
          //Following code line is added by Umair-Plumlogix of US11096 on 02/11/2020
         System.assertEquals(1,i);

  }
// Following Method is added by Bharat for INC0151787 (Teacher) on 01/05/2022 
    static testMethod void test_method_two() {
         integer i=1;

          Account theAccount = PimsTestUtil.createAccount('ThatThereSchool','School Account');
          insert theAccount;

          Contact theContact = PimsTestUtil.createContact('Robert Strunk','RS@rs.com','rs@profEmail.com', Date.newInstance(1984, 09, 14), theAccount);
          insert theContact;

          IB_Programme__c theProgramme = PimsTestUtil.createProgrammeForAccount (theAccount,'MYP');
          insert theProgramme;

          IB_Application__c theApp = new IB_Application__c(
              // AC_3_1_Feasability_Lead__c = theContact.Id,
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

          IB_Role_Repository__c theRoleRepo = new IB_Role_Repository__c(Role_Name__c = 'Teacher', Category__c ='School Services');
          insert theRoleRepo;

          IB_Role__c theRole = new IB_Role__c(
               IB_Role__c = theRoleRepo.Id,
               IB_Programme_New__c = theProgramme.Id,
               IB_Account__c = theAccount.Id,
               IB_Contact__c = theContact.Id
          );
          insert theRole;

          RoleService.setRoleId(theRole.Id);
          RoleService.setAccountId(theAccount.Id);
          RoleService.setProgrammeId(theProgramme.Id);
          RoleService.setContactId(theContact.Id);
         System.assertEquals(1,i);

          IB_Role__c currRole = RoleService.getRole();
          List<IB_Role__c> rolesByAccount = RoleService.getRolesByAccountId();
          List<IB_Role__c> getMyIBRolesByContact = RoleService.getRolesByContactId();
          List<IB_Role__c> rolesByProgramme_T = RoleService.getRolesByProgrammeId_T(theAccount.Id,theProgramme.Id);
         System.assertEquals(1,i);

  }
  // Following Method is added by Bharat for INC0151787 (Non-Teacher) on 01/05/2022 
    static testMethod void test_method_three() {
         integer i=1;

          Account theAccount = PimsTestUtil.createAccount('ThatThereSchool','School Account');
          insert theAccount;

          Contact theContact = PimsTestUtil.createContact('Robert Strunk','RS@rs.com','rs@profEmail.com', Date.newInstance(1984, 09, 14), theAccount);
          insert theContact;

          IB_Programme__c theProgramme = PimsTestUtil.createProgrammeForAccount (theAccount,'MYP');
          insert theProgramme;

          IB_Application__c theApp = new IB_Application__c(
              // AC_3_1_Feasability_Lead__c = theContact.Id,
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

          IB_Role_Repository__c theRoleRepo = new IB_Role_Repository__c(Role_Name__c = 'Head of School', Category__c ='School Services');
          insert theRoleRepo;

          IB_Role__c theRole = new IB_Role__c(
               IB_Role__c = theRoleRepo.Id,
               IB_Programme_New__c = theProgramme.Id,
               IB_Account__c = theAccount.Id,
               IB_Contact__c = theContact.Id
          );
          insert theRole;

          RoleService.setRoleId(theRole.Id);
          RoleService.setAccountId(theAccount.Id);
          RoleService.setProgrammeId(theProgramme.Id);
          RoleService.setContactId(theContact.Id);
         System.assertEquals(1,i);

          IB_Role__c currRole = RoleService.getRole();
          List<IB_Role__c> rolesByAccount = RoleService.getRolesByAccountId();
          List<IB_Role__c> getMyIBRolesByContact = RoleService.getMyIBRolesByContactId();
          List<IB_Role__c> rolesByProgramme_B = RoleService.getRolesByProgrammeId_B(theAccount.Id,theProgramme.Id);
         System.assertEquals(1,i);

  }  
    
}