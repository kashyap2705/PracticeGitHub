@isTest
public class TestCORFeedback {

    @isTest
	static void testOne()
    {
        
    
        Account acc = PimsTestUtil.createAccount('Test Account','');
        insert acc;
        
        IB_Address__c add = new IB_Address__c();
        add.Name = 'STRUNK';
        add.IB_Account__c = acc.Id;
        add.Address_Line_1__c = 'Test';
        add.City__c = 'Test city';
        add.Postal_Code__c = '12345';
        insert add;
              
        IB_Programme__c prog = new IB_Programme__c();
        prog.Account__c = acc.Id;
        prog.Exam_Session__c = 'May';
        prog.Status__c = 'Test';
        prog.IBCC_Implementation_Phase__c = 'Phase 1';
        prog.Primary_Language_of_Instruction__c = 'English';
        prog.Street_Address__c =add.id;
        prog.owner__c = '0050O0000076lXX';
        insert prog;
        
        IB_Programme__c prmemail = [Select Programme_Relationship_Manager_Email__c from IB_Programme__c where id = :prog.id ];
        
        IB_Application_Attachment__c aa = new IB_Application_Attachment__c(); 
        aa.IB_Programme__c = prog.Id;
        insert aa; 
         
        Course_Outline_Reading__c cor = new Course_Outline_Reading__c();
        cor.Application_Attachment__c = aa.Id;
        cor.Programme__c = prog.Id;   
        cor.Status__c ='Submitted';
        insert cor;    
    test.startTest();
    
    CORFeedback.SendMail(cor.id);
    test.stopTest();
    }
}