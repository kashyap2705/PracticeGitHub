@isTest
public class UpdateNonSchoolAccountsBatchTest {
    
    @isTest
    static void testOne() {
        
        Account a = PimsTestUtil.createAccount('Coastal Cloud Institutw', 'School Account');
        a.Website = 'www.test.com';
        insert a;
        
        if(a.IBIS_ID__C == null){
            update a;
        }
        Test.startTest();
        Database.executeBatch(new UpdateNonSchoolAccountsBatch(),10);
        Test.stopTest();
    }
}