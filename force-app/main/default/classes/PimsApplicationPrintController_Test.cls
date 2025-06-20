@isTest
public class PimsApplicationPrintController_Test {

    @testSetup
    static void setup(){
        
        Account theAccount = PimsTestUtil.createAccount('ThatThereSchool','School Account');
        theAccount.Lead_Account__c = true;
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
		System.debug('test theAppid '+ theApp.id);
        Profile p =  [select Id from profile where Name='SCU + Advanced' limit 1];

        User pu = new User(profileId = p.id, username = 'rs@em558861ail.com', email = 'rs@email.com',
                           emailencodingkey = 'UTF-8', localesidkey = 'en_US',
                           languagelocalekey = 'en_US', timezonesidkey = 'America/Los_Angeles',
                           alias='cspu', lastname='lastname', contactId = theContact.id);

        insert pu;


        Standards_Practices__c sNp = new Standards_Practices__c(
            Practice_ID__c = 'qwertyuiopa',
            Programme_Choice__c = 'MYP'
        );

        insert sNp;

        IB_Action_Plan__c theActionPlan = new IB_Action_Plan__c(
            name = 'MYP_ActionPlan_1',
            AP_Standard_Practice__c  = sNp.Id,
            programme__c = theProgramme.Id
        );

        insert theActionPlan;
    } 
    
    static testMethod void one(){
        Pagereference tmpRef = Page.AFC_Section_Print;
        tmpRef.getParameters().put('id',[select id from IB_Application__c][0].id);// Security Scanner False Positive
        System.debug('test tmpRef'+tmpRef);
        System.Test.setCurrentPage(tmpRef);
        PimsApplicationPrintController tmp = new PimsApplicationPrintController();
        
        System.runAs([select ContactId from user where contactId != null AND isActive = true limit 1][0]){
            tmp.callConga();
            tmp.clearMessage();
        } 
        
        System.assertEquals('success', tmp.outcome);
    }
    
    static testMethod void two(){
        Pagereference tmpRef = Page.AFC_Section_Print;
        tmpRef.getParameters().put('id',[select id from IB_Application__c][0].id);// Security Scanner False Positive
        System.Test.setCurrentPage(tmpRef);
        PimsApplicationPrintController tmp = new PimsApplicationPrintController();
        
        System.runAs([select ContactId from user where contactId != null AND isActive = true limit 1][0]){            
            tmp.callConga();
            tmp.clearMessage();
        } 
        
        System.assertEquals('success', tmp.outcome);
    }

	static testMethod void three(){
        Pagereference tmpRef = Page.AFC_Section_Print;
        tmpRef.getParameters().put('id',[select id from IB_Application__c][0].id);// Security Scanner False Positive
        System.debug('test tmpRef'+tmpRef);
        System.Test.setCurrentPage(tmpRef);
        PimsApplicationPrintController tmp = new PimsApplicationPrintController();
        
        //System.runAs([select ContactId from user where contactId != null AND isActive = true limit 1][0]){
            tmp.callConga();
            tmp.clearMessage();
        //} 
        
        System.assertEquals('success', tmp.outcome);
    }
        
}