@istest
public class PimsActionPlanItemControllerTest {
    
    static testmethod void PimsActionPlanItemController_1() {
        Account theAccount = PimsTestUtil.createAccount('ThatThereSchool','School Account');
        theAccount.Lead_Account__c = true;
        insert theAccount;
        Contact theContact = PimsTestUtil.createContact('Robert Strunk','RS@rs.com','rs@profEmail.com', Date.newInstance(1984, 09, 14), theAccount);
        insert theContact;
        Profile p =  [select Id from profile where Name = 'SCU + Advanced' limit 1];
        
        User pu = new User(profileId = p.id, username = 'rs@em558861ail.com', email = 'rs@email.com',
                           emailencodingkey = 'UTF-8', localesidkey = 'en_US',
                           languagelocalekey = 'en_US', timezonesidkey = 'America/Los_Angeles',
                           alias='cspu', lastname='lastname', contactId = theContact.id);
        
        insert pu;
        IB_Programme__c theProgramme = PimsTestUtil.createProgrammeForAccount (theAccount,'MYP');
        insert theProgramme;
        
        Standards_Practices__c sNp = new Standards_Practices__c(
            Practice_ID__c = 'qwertyuiopa',
            Programme_Choice__c = 'MYP'
        );
        insert sNp;
        
        IB_Action_Plan__c theActionPlan = new IB_Action_Plan__c(
            name = 'MYP_ActionPlan_1',
            AP_Standard_Practice__c  = sNp.Id,
            programme__c = theProgramme.Id,
            AP_Due_Date__c = Date.today()
        );
        insert theActionPlan;
        
        System.Test.startTest();
        
        System.runAs(pu){
            Pagereference tmp = Page.PimsActionPlanItem;
            tmp.getParameters().put('id',theActionPlan.Id);
            
            System.Test.setCurrentPage(tmp);
            
            PimsActionPlanItemController controller1 = new PimsActionPlanItemController();
            controller1.init();
            controller1.save();
            controller1.upload();
            DateUtility util = controller1.dateUtil;
            String tmpStr = controller1.Description;
            String tmpStr2 = controller1.FileName;
            blob tmpBlob = controller1.Filebody;
            
            controller1.Description = 'desc';
            controller1.FileName = 'name';
            controller1.Filebody = Blob.valueOf('Body');
            controller1.upload();
            controller1.actionPlanDate = null;
            controller1.save();
            controller1.getUrlCommunityPath();
            controller1.removeDocument();
            
            System.Test.stopTest();
        }
    }
    @testSetup 
    static void methodName() {
        Profile p = [SELECT Id FROM Profile WHERE Name='ibportal Profile'];
        TestDataFactory.createUserTestData(p.id,1,True);
        User u = [SELECT Id, ProfileId FROM User WHERE Profile.Name ='ibportal Profile' LIMIT 1];
        Map<String,String> customLabelMap = new Map<String,String>();
        customLabelMap.put('Action_Plan','Action Plan');
        customLabelMap.put('Due_Date','Due Date');
        customLabelMap.put('Documents','Documents');
        customLabelMap.put('Created_Date','Created Date');
        customLabelMap.put('Budgetary_Implications','Budgetary Implications');
        customLabelMap.put('Back_to_Action_Plan','Back to Action Plan');
        customLabelMap.put('Action_Type','Action Type');
        customLabelMap.put('Action_Plan_Item','Action Plan Item');
        customLabelMap.put('Action_Item','Action Item');
        customLabelMap.put('Upload_Document','Upload Document');        
        customLabelMap.put('Add_Document','Add Document');
        customLabelMap.put('File','File');
        customLabelMap.put('Description','Description');
        customLabelMap.put('Update_Action_Item','Update Action Item');
        customLabelMap.put('Status','Status');
        customLabelMap.put('Standard','Standard');
        customLabelMap.put('Requirement','Requirement');
        customLabelMap.put('Programme','Programme');
        customLabelMap.put('Process_Stage','Process Stage');
        customLabelMap.put('Action','Action');
        customLabelMap.put('Practice','Practice');
        customLabelMap.put('Person_Responsible','Person Responsible');
        customLabelMap.put('MTBA_Review','MTBA Review');
        customLabelMap.put('MTBA_Evidence','MTBA Evidence');
        customLabelMap.put('Evidence_of_Achievement','Evidence of Achievement');
        customLabelMap.put('Limit_Message_For_File_Upload','Limit Message For File Upload');        
        
        List<customlabel__c> customlabelList = TestDataFactory.customLabelRecordsForAction(customLabelMap.keySet(), true);
        
        List<Translation__c> transList = new List<Translation__c>();
        for(customlabel__c customLabel : customlabelList){
            transList.add(TestDataFactory.createTranslationTestData(customLabelMap.get(customLabel.Label__c),customLabel.id, 'American English'));
        }
        if(!transList.isEmpty())
            insert transList;
    }
    @isTest
    static void testPimsActionPlanItemController() {
        
        List<customlabel__c> customlabelList = [select id from customlabel__c];
        List<Translation__c> translationList = [select id, Language__c, Value__c, CustomLabel__c from Translation__c];
        PimsActionPlanItemController controller = new PimsActionPlanItemController();
        Map<String, String> translationsMap = controller.getTranslationsMap();
        system.assertEquals('Action Plan',controller.Action_Plan); 
        system.assertEquals('Due Date',controller.Due_Date);
        system.assertEquals('Documents',controller.Documents);
        system.assertEquals('Created Date',controller.Created_Date);
        system.assertEquals('Budgetary Implications',controller.Budgetary_Implications);
        system.assertEquals('Back to Action Plan',controller.Back_to_Action_Plan);
        system.assertEquals('Action Type',controller.Action_Type);
        system.assertEquals('Action Plan Item',controller.Action_Plan_Item);
        system.assertEquals('Action Item',controller.Action_Item);
        system.assertEquals('Upload Document',controller.Upload_Document);
        system.assertEquals('Add Document',controller.Add_Document);
        system.assertEquals('File',controller.File);
        system.assertEquals('Description',controller.IB_Description);
        system.assertEquals('Update Action Item',controller.Update_Action_Item);
        system.assertEquals('Status',controller.Status);
        system.assertEquals('Standard',controller.Standard);
        system.assertEquals('Requirement',controller.Requirement);
        system.assertEquals('Programme',controller.IB_Programme);
        system.assertEquals('Process Stage',controller.Process_Stage);
        system.assertEquals('Action',controller.Action);
        system.assertEquals('Practice',controller.Practice);
        system.assertEquals('Person Responsible',controller.Person_Responsible);
        system.assertEquals('MTBA Review',controller.MTBA_Review);
        system.assertEquals('MTBA Evidence',controller.MTBA_Evidence);
        system.assertEquals('Evidence of Achievement',controller.Evidence_of_Achievement);
        system.assertEquals('Limit Message For File Upload',controller.Limit_Message_For_File_Upload);    
    }
}