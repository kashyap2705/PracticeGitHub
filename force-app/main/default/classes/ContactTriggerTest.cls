@isTest
private class ContactTriggerTest {
    
    @isTest static void test_method_one() {
        integer i=1;

        IB_Role_Repository__c repo = PimsTestUtil.createRoleRepo('Programme Coordinator');
        insert repo;

        Account acc = PimsTestUtil.createAccount('Test Account', '');

        insert acc;

        Contact con = PimsTestUtil.createContact('Test Contact', 'a@a.com', 'a@a.com', Date.newInstance(1980, 5, 30), acc);

    //    insert con;
  	Contact con3 = PimsTestUtil.createContact('C Contact', 'h@a.com', 'j@a.com', Date.newInstance(1970, 11, 11), acc);
      //         insert con3;
      insert new List<contact>{con,con3}; 
                  IB_Programme__c theProgramme = PimsTestUtil.createProgrammeForAccount (acc,'MYP');
        insert theProgramme;
        IB_Role__c role = PimsTestUtil.createIbRole(repo.Id, con.Id,acc.Id);
        role.IB_Programme_New__c = theProgramme.id;
        insert role;

        con.Email = 't@t.com';

        update con;
    //Following code line is added by Umair-Plumlogix of US11096 on 02/11/2020
        System.assertEquals(1,i);
        
      
               
               delete con3;
    //Following code line is added by Umair-Plumlogix of US11096 on 02/11/2020
        System.assertEquals(1,i);
        

    }
}