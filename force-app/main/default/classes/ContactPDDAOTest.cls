@isTest
private class ContactPDDAOTest {

     static testmethod void ContactPDDAOTest() {

          ContactPDDAO conPDDAO = ContactPDDAO.getInstance();

          Account acc = PimsTestUtil.createAccount('Test Account', '');
          insert acc;

          Contact con = PimsTestUtil.createContact('Test Contact', 'a@a.com', 'a@a.com', Date.newInstance(1980, 1, 1), acc);
    //      insert con;

          Contact con2 = PimsTestUtil.createContact('John Doe', 'b@b.com', 'b@b.com', Date.newInstance(1985, 6, 6), acc);
  //        insert con2;
           insert new List<contact>{con,con2};
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

          IB_Subject__c ibs2 = new IB_Subject__c();
          ibs2.IB_Programme__c = 'CP';
          ibs2.IB_Programme_Long__c = 'IB Career-related Programme';
          ibs2.Subject_Name__c = 'Theory of knowledge';
          ibs2.Subject_Group_Identifier__c = 'gen0d';
          insert ibs2;

          Role_Application_Subject__c ras = new Role_Application_Subject__c();
          ras.IB_Subject__c = ibs.Id;
          ras.Role_And_Application__c = ibRole.id;
          insert ras;

          Role_Application_Subject__c ras2 = new Role_Application_Subject__c();
          ras2.IB_Subject__c = ibs2.Id;
          ras2.Role_And_Application__c = ibRole2.id;
          insert ras2;

          Contact_Professional_Development__c cpd = new Contact_Professional_Development__c();
          cpd.Contact__c = con.Id;
          cpd.Region__c = 'Americas';
          cpd.Role__c = ibRole.Id;
          cpd.Role_Subject__c = ras.Id;
          cpd.Workshop_Category__c = 'Professional Development';
          cpd.Workshop_Name__c = 'Project Management Essentials';
          cpd.City__c = 'Jacksonville';
          insert  cpd;

          Contact_Professional_Development__c cpd2 = new Contact_Professional_Development__c();
          cpd2.Contact__c = con2.Id;
          cpd2.Region__c = 'Americas';
          cpd2.Role__c = ibRole2.Id;
          cpd2.Role_Subject__c = ras2.Id;
          cpd2.Workshop_Category__c = 'Cirruculum Planning';
          cpd2.Workshop_Name__c = 'Exploratory knowledge Instruction';
          cpd2.City__c = 'Atlanta';
          insert  cpd2;

          List<Contact_Professional_Development__c> proDevBySubject = conPDDAO.getProDevBySubjectId(cpd.Role_Subject__c);
          List<Contact_Professional_Development__c> proDevByRoleId = conPDDAO.getProDevByRoleId(ibRole.Id);
          List<Contact_Professional_Development__c> proDevByRoleList = conPDDAO.getProDevByRoleList(ibRoleList);

          system.assertEquals(proDevBySubject.size(), 1);
          system.assertEquals(proDevByRoleId.size(), 1);
          system.assertEquals(proDevByRoleList.size(), 2);
	}
}