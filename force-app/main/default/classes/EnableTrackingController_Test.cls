@isTest
private class EnableTrackingController_Test {
    @testSetup static void setup() {
     List<e_eat__Audit_Tracking_sObject__c> listDataTemplates = new List<e_eat__Audit_Tracking_sObject__c>();
     List<e_eat__Audit_Tracking_Field__c> listTemplateMappings = new List<e_eat__Audit_Tracking_Field__c>();
     e_eat__Audit_Tracking_sObject__c accountDataTemplate = createDataTemplate('Account Template', 'Account', false);
     e_eat__Audit_Tracking_sObject__c contactDataTemplate = createDataTemplate('Create Template', 'Contact', false);
     listDataTemplates.add(accountDataTemplate);
     listDataTemplates.add(contactDataTemplate);
     insert listDataTemplates;

     e_eat__Audit_Tracking_Field__c accountNameMapping = createTemplateMapping(accountDataTemplate, 'Account Name', 'Name', true, false);
     e_eat__Audit_Tracking_Field__c accountNumberMapping = createTemplateMapping(accountDataTemplate, 'Account Number', 'AccountNumber',true, false);
     e_eat__Audit_Tracking_Field__c contactFirstNameMapping = createTemplateMapping(contactDataTemplate, 'First Name', 'FirstName', true, false);
     e_eat__Audit_Tracking_Field__c contactLastNameMapping = createTemplateMapping(contactDataTemplate, 'Last Name', 'LastName', true, false);
     listTemplateMappings.add(accountNameMapping);
     listTemplateMappings.add(accountNumberMapping);
     listTemplateMappings.add(contactFirstNameMapping);
     listTemplateMappings.add(contactLastNameMapping);
     insert listTemplateMappings;

    }

    @isTest static void testGetTemplatesForObject() {
        List<e_eat__Audit_Tracking_sObject__c> listAccountDataTemplates = EnableTrackingController.getTemplatesForObject('Account');
        System.assertEquals(1, listAccountDataTemplates.size());
        List<e_eat__Audit_Tracking_sObject__c> listContactDataTemplates = EnableTrackingController.getTemplatesForObject('Contact');
        System.assertEquals(1, listContactDataTemplates.size());
    }

    @isTest static void testGetTemplatesByRecordId() {
        List<e_eat__Audit_Tracking_sObject__c> listAccountDataTemplates = [SELECT Id, e_eat__API_Name__c FROM e_eat__Audit_Tracking_sObject__c WHERE e_eat__API_Name__c = 'Account'];
        System.assertEquals(1, listAccountDataTemplates.size());
        if(listAccountDataTemplates.size() > 0) {
            String idString = listAccountDataTemplates[0].Id;
            List<e_eat__Audit_Tracking_Field__c> listTemplateMappings = EnableTrackingController.getTemplatesByRecordId(idString);
            System.assertEquals(2, listTemplateMappings.size());
        }
    }

    @isTest static void testGetTemplateMappingsByDeveloperName() {
        e_eat__Audit_Tracking_sObject__c accountDataTemplate = EnableTrackingController.getTemplateMappingsByDeveloperName('Account');
        System.assertEquals(2, accountDataTemplate.e_eat__Audit_Tracking_Fields__r.size());
        e_eat__Audit_Tracking_sObject__c contactDataTemplate = EnableTrackingController.getTemplateMappingsByDeveloperName('Contact');
        System.assertEquals(2, contactDataTemplate.e_eat__Audit_Tracking_Fields__r.size());
    }

    @isTest static void testGetObjectTemplatePickListOptions() {
        List<String> listPickListOptions = EnableTrackingController.getObjectTemplatePickListOptions();
        System.assertEquals(2, listPickListOptions.size());
    }    

    /* Test Util method for creating data templates */
    private static e_eat__Audit_Tracking_sObject__c createDataTemplate(String name, String objectName, Boolean insertRecord) {
        e_eat__Audit_Tracking_sObject__c dataTemplate = new e_eat__Audit_Tracking_sObject__c();
        dataTemplate.Name = name;
        dataTemplate.e_eat__API_Name__c = objectName;
        if(insertRecord) {
            insert dataTemplate;
        }
        return dataTemplate;
    }

    /* Test Util method for creating template mappings */
    private static e_eat__Audit_Tracking_Field__c createTemplateMapping(e_eat__Audit_Tracking_sObject__c dataTemplate, String label, String apiName, Boolean active, Boolean insertRecord) {
        e_eat__Audit_Tracking_Field__c templateMapping = new e_eat__Audit_Tracking_Field__c();
        templateMapping.Name = label;
        templateMapping.e_eat__Field_API_Name__c = apiName;
        templateMapping.e_eat__Audit_Tracking_sObject__c = dataTemplate.Id;
        templateMapping.e_eat__Active__c = active;
        if(insertRecord) {
            insert templateMapping;
        }
        return templateMapping;
    }    
}