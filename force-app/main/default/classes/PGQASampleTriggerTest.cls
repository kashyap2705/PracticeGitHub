@isTest
public class PGQASampleTriggerTest {
 public static testMethod void testMethod1(){
        Account acc;
        Contact con ;
        acc = PimsTestUtil.createAccount('Test Account', 'Association Account' );
        insert acc;
        con = PimsTestUtil.createContact('Test Contact', 'a@a.com', 'a@a.com', Date.newInstance(1980, 1, 1), acc);
        con.AccountId=acc.id;
        insert con;
        Case case1 = new Case();
        case1.Subject = 'PGQA – Nov 2021 - 01256958 – ALBANIAN A: Literature HL';
        // case1.PGQA_Subject_Level_Language__r.English__c ='Maths';
        case1.PGQA_Examiner_1__c=con.Id;
        case1.PGQA_Examiner_1_Review_Status__c='In-Progress';
        //  case1.PGQA_Subject_Level_Language__r.Name = 'PGQA school subject';
        insert case1;
        
        Subject__c subject = new Subject__c();
        subject.Name = 'PGQA school subject';
        subject.English__c = 'PGQA – Nov 2021 - 01256952 – PGQA school subject';
        subject.Spanish__c = 'PGQA – Nov 2021 - 01256952 – PGQA school subject';
        subject.French__c = 'PGQA – Nov 2021 - 01256952 – PGQA school subject';
        subject.Unavailable__c = false;
        insert subject;
        
        Test.startTest();
        
        
        PGQA_Sample__c PGQA1 = new PGQA_Sample__c();
        PGQA1.PGQA_Case__c = case1.Id; 
        PGQA1.PGQA_Name__c = 'Sample 1';
        insert PGQA1;
        PGQA_Sample__c PGQA2 = new PGQA_Sample__c();
        PGQA2.PGQA_Case__c = case1.Id; 
        PGQA2.PGQA_Name__c = 'Sample 2';
        insert PGQA2;
     
        Test.stopTest();
        
    }
}