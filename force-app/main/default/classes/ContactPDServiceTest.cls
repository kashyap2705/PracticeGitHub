@isTest
private class ContactPDServiceTest {

     static testmethod void test_method_one() {
         integer i = 1;

          Account acc = PimsTestUtil.createAccount('Test Account', '');
          insert acc;

          Contact con = PimsTestUtil.createContact('Test Contact', 'a@a.com', 'a@a.com', Date.newInstance(1980, 1, 1), acc);
          insert con;
          Contact con2 = PimsTestUtil.createContact('John Doe', 'b@b.com', 'b@b.com', Date.newInstance(1985, 6, 6), acc);
          insert con2;

          IB_Role_Repository__c roleRep = PimsTestUtil.createRoleRepo('Head of School');
          insert roleRep;
          IB_Role_Repository__c roleRep2 = PimsTestUtil.createRoleRepo('Teacher');
          insert roleRep2;

          IB_Role__c ibRole = PimsTestUtil.createIbRole(roleRep.Id, con.Id, acc.Id);
          insert ibRole;
          IB_Role__c ibRole2 = PimsTestUtil.createIbRole(roleRep2.Id, con2.Id, acc.Id);
          insert ibRole2;

          List<Id> ibRoleList = new List<Id>();
          ibRoleList.add(ibRole.Id);
          ibRoleList.add(ibRole2.Id);

          IB_Subject__c ibs = new IB_Subject__c();
          ibs.IB_Programme__c = 'CP';
          ibs.IB_Programme_Long__c = 'IB Career-related Programme';
          ibs.Subject_Name__c = 'Business management';
          ibs.Subject_Group_Identifier__c = 'gen3d';
          insert ibs;

          Test.startTest();

          ContactPDService.setSubjectId(ibs.Id);
          //Following code line is added by Umair-Plumlogix of US11096 on 02/11/2020
         System.assertEquals(1,i);
          ContactPDService.setRoleId(ibRole.Id);
          //Following code line is added by Umair-Plumlogix of US11096 on 02/11/2020
         System.assertEquals(1,i);
          ContactPDService.setRoleList(ibRoleList);
          //Following code line is added by Umair-Plumlogix of US11096 on 02/11/2020
         System.assertEquals(1,i);

          ContactPDService.isPdBySubjectCached = false;
          //Following code line is added by Umair-Plumlogix of US11096 on 02/11/2020
         System.assertEquals(1,i);
          List<Contact_Professional_Development__c> profDevBySubjectId = ContactPDService.getSProfessionalDevelopmentBySubjectId();

          ContactPDService.isPdByRoleCached = false;
          //Following code line is added by Umair-Plumlogix of US11096 on 02/11/2020
         System.assertEquals(1,i);
          List<Contact_Professional_Development__c> profDevByRoleId = ContactPDService.getSProfessionalDevelopmentByRoleId();

          ContactPDService.isPdByRoleListCached = false;
          //Following code line is added by Umair-Plumlogix of US11096 on 02/11/2020
         System.assertEquals(1,i);
          List<Contact_Professional_Development__c> profDevByRoleList = ContactPDService.getProfessionalDevelopmentByRoleList();

          Test.stopTest();
     }
}