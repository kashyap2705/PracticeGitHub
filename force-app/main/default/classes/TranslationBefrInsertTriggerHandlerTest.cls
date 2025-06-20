@isTest
public class TranslationBefrInsertTriggerHandlerTest {

    @isTest
    static void onBeforeInsert(){
        
        Custom_Label_Project__c proj = new Custom_Label_Project__c();
        proj.Name = 'Test Project';
        insert proj;
        
        CustomLabel__c label = new CustomLabel__c();
        label.Label__c = 'Test';
        label.Group__c = 'Section';
        label.Project__c = proj.Id;
        insert label;
        
        Translation__c tran = new Translation__c();
        tran.CustomLabel__c = label.Id;
        tran.Language__c = 'American English';
        tran.Value__c ='test value';
        insert tran;
    }
}