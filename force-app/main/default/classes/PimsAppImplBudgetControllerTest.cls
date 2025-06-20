@isTest
public class PimsAppImplBudgetControllerTest {
    
    @testSetup static void methodName() {
        Account theAccount = PimsTestUtil.createAccount('ThatThereSchool','School Account');
        theAccount.Lead_Account__c = true;
        insert theAccount;
        
        Contact theContact = PimsTestUtil.createContact('Robert Strunk','RS@rs.com','rs@profEmail.com', Date.newInstance(1984, 09, 14), theAccount);
        insert theContact;
        
        IB_Programme__c theProgramme = PimsTestUtil.createProgrammeForAccount (theAccount,'MYP');
        theProgramme.Projected_Authorization_Date__c = Date.today();
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
        
        theApp.Application_Lookup_to_Programme__c = theProgramme.id;
        insert theApp;
        
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
        
        Map<String,String> customLabelMap = new Map<String,String>();
        customLabelMap.put('Ib_Agreement_Professional_Development','Professional Development');
        customLabelMap.put('Ib_Agreement_Other','Other');
        customLabelMap.put('Ib_Agreement_Fee','Fee');
        customLabelMap.put('Ib_Agreement_Resource','Resource');
        List<customlabel__c> customlabelList = TestDataFactory.customLabelRecords(customLabelMap.keySet(), true);
        
        List<Translation__c> transList = new List<Translation__c>();
        for(customlabel__c customLabel : customlabelList){
            transList.add(TestDataFactory.createTranslationTestData(customLabelMap.get(customLabel.Label__c),customLabel.id, 'American English'));
            system.debug('transList 0>>'+transList);
        }
        if(!transList.isEmpty())
            insert transList;
        system.debug('transList >>'+transList);
        
    }
    static testmethod void pimsAppImplBudgetController_1(){
        IB_Application__c theApp = [SELECt Id FROM IB_Application__c];
        
        System.Test.startTest();
        Pagereference tmp = Page.PimsApplicationForCandidacy;
        tmp.getParameters().put('id',theApp.Id);
        tmp.getParameters().put('tab','budget');
        
        System.Test.setCurrentPage(tmp);
        PageService.isActiveTabCached = true;
        PageService.activeTab = 'budget';
        List<customlabel__c> customlabelList = [select id from customlabel__c];         
        List<Translation__c> translationList = [select id, Language__c, Value__c, CustomLabel__c from Translation__c];
        system.debug('customlabelList >>'+customlabelList + 'translationList >>'+translationList);
        PimsAppImplBudgetController controller = new PimsAppImplBudgetController();
        
        try{
            controller.appId = theApp.Id;
            String tmp1 = controller.accId;
            String tmp2 = controller.programmeId;
            Account tmp3 = controller.account;
            List<Contact>  tmp4 = controller.contacts;
            List<IB_Role__c>  tmp5 = controller.roles;
            List<IB_Programme__c> tmp6 = controller.programmes;
            Application_Budget_Table__c tmp7 = controller.applicationBudget;
            List<Application_Budget_Table__c> tmp8 = controller.appBudget;
            List<IB_Role__c> tmp9 = controller.rolers;
            List<Application_Budget_Table__c> tmp10 = controller.buds;
            controller.removeBudgetItem();
            controller.updateStartDate();
            controller.saveBudget();
            controller.saveApp();
            controller.edit();
            controller.getPageHasErrors();
            controller.progId = null;
            controller.redirectUrl = null;
            controller.ibCompletionStatus = null;
            controller.showReqBdgtMsg = false;
            controller.removeBudget = null;
            controller.removeBudget = null;
            controller.lines = null;
            controller.url = null;
            Map<String, String> translationsMap = controller.getTranslationsMap();
            system.debug('transList 1>>'+translationsMap); 
            String TOther= controller.Other;
            String TProfessional_Development=controller.Professional_Development;
            String TFee= controller.Fee;
            String TResource= controller.Resource; 
            system.assertEquals('budget',controller.activeTab);
            
            
        }
        catch(Exception e){
            System.debug(String.valueOf(e));
        }
        
        System.Test.stopTest();
        
    }
}