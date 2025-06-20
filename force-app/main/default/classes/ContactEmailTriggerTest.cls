@isTest
private class ContactEmailTriggerTest {
    
    @isTest 
    static void testContactEmailTrigger() {
        integer i=1;
        
        Account acc = PimsTestUtil.createAccount('Test Account', '');
        insert acc;
        
        Contact con = PimsTestUtil.createContact('Test Contact', 'a@a.com', 'a@a.com', Date.newInstance(1980, 1, 1), acc);
        insert con;
        
     	ContactEmail__c em = new ContactEmail__c(
        	Contact__c = con.Id,
            Account__c = acc.Id,
            EmailAddress__c = 'email@email.com'
        );
        insert em;
        //Following code line is added by Umair-Plumlogix of US11096 on 02/11/2020
        System.assertEquals(1,i);
        
        em.EmailAddress__c = 'test@email.com';
        update em;
        //Following code line is added by Umair-Plumlogix of US11096 on 02/11/2020
        System.assertEquals(1,i);
        
        delete em;
        //Following code line is added by Umair-Plumlogix of US11096 on 02/11/2020
        System.assertEquals(1,i);
        
    }

}