/*******************************************************************************************
* @Name         IbPortalFooterControllerTest 
* @Author       Saurabh Singh Singhaniya(Epam)
* @Date          06/08/2023  
* @Group        Platform Team
* @Description   To cover the class IbPortalFooterController.
*******************************************************************************************/
/* MODIFICATION LOG
* Version          Developer          Date               Description
*-------------------------------------------------------------------------------------------
* 1.
*******************************************************************************************/
@isTest
public class IbPortalFooterControllerTest {
    @testSetup static void methodName() {
       Profile p = [SELECT Id FROM Profile WHERE Name='ibportal Profile'];
        TestDataFactory.createUserTestData(p.id,1,True);
        User u = [SELECT Id, ProfileId FROM User WHERE Profile.Name ='ibportal Profile' LIMIT 1];
            Map<String,String> customLabelMap = new Map<String,String>();
            customLabelMap.put('IB_privacy_policy','IB Privacy Policy');
            customLabelMap.put('Ib_language_policy','Language Policy');
            customLabelMap.put('Ib_terms_and_Conditions','Terms and Conditions');
            customLabelMap.put('Copyright','Copyright');
            List<customlabel__c> customlabelList = TestDataFactory.customLabelRecords(customLabelMap.keySet(), true);
         
            List<Translation__c> transList = new List<Translation__c>();
            for(customlabel__c customLabel : customlabelList){
            transList.add(TestDataFactory.createTranslationTestData(customLabelMap.get(customLabel.Label__c),customLabel.id, 'American English'));
            transList.add(New Translation__c(CustomLabel__c=customlabel.id,Language__c='French',Value__c='Politique de confidentialité de l\'IB'));        	
            }
        	if(!transList.isEmpty())
                insert transList;
    }
    @isTest
    static void testIbPortalFooterController() {
        User u = [SELECT Id, ProfileId FROM User WHERE Profile.Name ='ibportal Profile' LIMIT 1];
        u.Bypass_Validation_Rules__c = true;
        // Set the user's language to French
        System.runAs(u) {
            List<customlabel__c> customlabelList = [select id from customlabel__c];
            
            List<Translation__c> translationList = [select id, Language__c, Value__c, CustomLabel__c from Translation__c];
            IbPortalFooterController controller = new IbPortalFooterController();
            Map<String, String> translationsMap = controller.getTranslationsMap();
            system.assertEquals('Language Policy',controller.languagePolicy);
            system.assertEquals('Copyright',controller.copyright_ib);
            system.assertEquals('Terms and Conditions',controller.termsAndConditions);
            system.assertEquals('IB Privacy Policy',controller.IbPrivacyPolicy);
        }
    }
    @isTest
    static void testIbPortalFooterController2() {
        User u = [SELECT Id, ProfileId FROM User WHERE Profile.Name ='ibportal Profile' LIMIT 1];
        u.Bypass_Validation_Rules__c = true;
        System.runAs(u) {
            List<customlabel__c> customlabelList = [select id from customlabel__c];
            
            List<Translation__c> translationList = [select id, Language__c, Value__c, CustomLabel__c from Translation__c];
            IbPortalFooterController controller = new IbPortalFooterController();
            IbPortalFooterController.Languageparam='fr';
            Map<String, String> translationsMap = controller.getTranslationsMap();
            system.assertEquals('Politique de confidentialité de l\'IB',controller.copyright_ib);
            system.assertEquals('Politique de confidentialité de l\'IB',controller.termsAndConditions);
            system.assertEquals('Politique de confidentialité de l\'IB',controller.IbPrivacyPolicy);
        }
    }
}