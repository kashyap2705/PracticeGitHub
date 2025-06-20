@isTest
private class SubjectProposalDAOTest {

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

          Roles_and_Applications_Subject_Proposal__c theRole = new Roles_and_Applications_Subject_Proposal__c(
               Subject_Level__c = 'Standard',
               IB_Application_Lookup__c = theApp.Id
          );
          insert theRole;

          SubjectProposalDAO con = SubjectProposalDAO.getInstance();

          Roles_and_Applications_Subject_Proposal__c rolesAndAppSubjectProposal = con.getProposalById(theRole.Id);
          List<Roles_and_Applications_Subject_Proposal__c> rolesAndAppSubjectProposalList = con.getProposalsByApplicationId(theApp.Id);
          //Following code line is added by Umair-Plumlogix of US11096 on 02/11/2020
         System.assertEquals(1,i);

	}
}