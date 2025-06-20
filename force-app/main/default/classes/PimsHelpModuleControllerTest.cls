/*******************************************************************************************
* @Name         PimsHelpModuleControllerTest 
* @Author       Suraj Parihar(Epam)
* @Date          10/06/2023  
* @Group        CR Team
* @Description   To cover the class PimsHelpModuleController.
*******************************************************************************************/
@isTest
public class PimsHelpModuleControllerTest {
    @testSetup static void methodName() {
       Profile p = [SELECT Id FROM Profile WHERE Name='ibportal Profile'];
        TestDataFactory.createUserTestData(p.id,1,True);
        User u = [SELECT Id, ProfileId FROM User WHERE Profile.Name ='ibportal Profile' LIMIT 1];
            Map<String,String> customLabelMap = new Map<String,String>();
            customLabelMap.put('Business_Registration','Business_Registration');
            customLabelMap.put('Vat_HelpText','Vat_HelpText');
            customLabelMap.put('Sales_HelpText','Sales_HelpText');
            customLabelMap.put('Gst_HelpText','Gst_HelpText');
            List<customlabel__c> customlabelList = TestDataFactory.customLabelRecords(customLabelMap.keySet(), true);
         
            List<Translation__c> transList = new List<Translation__c>();
            for(customlabel__c customLabel : customlabelList){
            transList.add(TestDataFactory.createTranslationTestData(customLabelMap.get(customLabel.Label__c),customLabel.id, 'American English'));
            }
            if(!transList.isEmpty())
                insert transList;
    }
    @isTest
    static void testPimsHelpModuleController() {
        User u = [SELECT Id, ProfileId FROM User WHERE Profile.Name ='ibportal Profile' LIMIT 1];
        u.Bypass_Validation_Rules__c = true;
        // Set the user's language to French
        System.runAs(u) {
            List<customlabel__c> customlabelList = [select id from customlabel__c];
            
            List<Translation__c> translationList = [select id, Language__c, Value__c, CustomLabel__c from Translation__c];
            PimsHelpModuleController controller = new PimsHelpModuleController();
            Map<String, String> translationsMap = controller.getTranslationsMap();
            system.assertEquals('Business_Registration',controller.businessReg);
            system.assertEquals('Vat_HelpText',controller.vatIdHelpText);
            system.assertEquals('Sales_HelpText',controller.salesNumHelpText);
            system.assertEquals('Gst_HelpText',controller.gstNumHelpText);
        }
    }
}