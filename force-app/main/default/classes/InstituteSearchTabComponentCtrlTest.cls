@isTest
public class InstituteSearchTabComponentCtrlTest {
    public static IB_Role_Repository__c repo {get; set;}
    public static Account acc{get; set;}
    public static Contact con{get; set;}
    public static User u;
    @testSetup static void setup() {
        acc = PimsTestUtil.createAccount('Test Account', 'Association Account' );
        
        insert acc;
        con = PimsTestUtil.createContact('Test Contact', 'a@a.com', 'a@a.com', Date.newInstance(1980, 1, 1), acc);
        con.AccountId=acc.id;
        insert con;
        
        
        
    }
    @isTest public static void testOne()
    {
        user u=[select id,ContactId from user where contactId!=null and isactive=true limit 1];
        con=[select id from contact limit 1][0];
        u.ContactId=con.id;
        Test.startTest();
        System.runAs(u)
        {   
            
            InstituteSearchTabComponentController ct=new InstituteSearchTabComponentController();
            ct.citySelected='Test(+92)';
            InstituteSearchTabComponentController.phone='032313412';
            system.assertEquals('--None--', ct.getcitynames()[0].getValue());
            system.assertNotEquals('/ibportal/InstituteApplyForRole?phoneId=%2B929213412', ct.createPhone().getUrl());
            system.assertEquals('/ibportal/InstituteApplyForRole', ct.CancelPhone().getUrl());
           // system.debug(ct.getcitynames());
           // system.debug(ct.createPhone().getUrl());
           // system.debug(ct.CancelPhone().getUrl());
            
        }        
        Test.stopTest();
    }
    
}