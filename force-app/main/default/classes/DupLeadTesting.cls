/**
* @description Test class for LeadTriggerHelper, utilizing LeadTestDataFactory
* @author: Satyanarayana Gajavalli
* @since 27-02-2025
*/
@isTest
private class DupLeadTesting {
    
    /**
    * @description Test method for DupLead
    */
    @isTest
    static void testDupLead() {
        
        User adminUser = [SELECT Id FROM User WHERE Profile.Name = 'System Administrator' AND IsActive = true LIMIT 1];
        System.runAs(adminUser) {
            
            Database.DMLOptions dml = new Database.DMLOptions();
            dml.DuplicateRuleHeader.AllowSave = true;
            dml.DuplicateRuleHeader.RunAsCurrentUser = true;
            
            Contact existingContact = new Contact(
                FirstName = 'John',
                LastName = 'Doe',
                Email = 'john.doe@example.com'
            );
            Database.insert(existingContact, dml);
            
            Lead existingLead = LeadTestDataFactory.createLead(new Lead(
                FirstName = 'John',
                LastName = 'Doe',
                Email = 'john.doe@example.com',
                Professional_Email__c = 'john.doe.prof@example.com',
                Company = 'Test Company',
                IsConverted = false,
                PYP_Interest__c = true
            ));
            Database.insert(existingLead, dml);
            
            Test.startTest();
            
            Lead duplicateLead = LeadTestDataFactory.createLead(new Lead(
                FirstName = 'John',
                LastName = 'Doe',
                Email = 'john.doe@example.com',           
                Professional_Email__c = 'john.doe.prof@example.com', 
                Company = 'Test Company',
                IsConverted = false,
                PYP_Interest__c = true
            ));
            
            Boolean exceptionThrown = false;
            String expectedErrorMessage = Label.IBEN_Duplicate_Contact;
            
            try {
                insert duplicateLead;
            } catch (DmlException e) {
                exceptionThrown = true;
            }
            
            if (!exceptionThrown) {
                try {
                    LeadTriggerHelper.DupLead(new List<Lead>{duplicateLead});
                } catch (Exception e) { 
                    exceptionThrown = true;
                    System.assert(e.getMessage().contains(expectedErrorMessage), 'Expected error message not found in: ' + e.getMessage());
                }
            }
            
            System.assert(exceptionThrown, 'DML Exception was expected but not thrown');
            Test.stopTest();
        }
    }
    
    /**
    * @description Test method for setIberoAmericaLead - School Lead
    */
    @isTest
    static void testsetIberoAmericaLeadSchoolLead() {
        Id schoolRecordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('School Lead').getRecordTypeId();
        List<IberoAmerica_Countries_Lead__mdt> iberoCountries = [SELECT Id, Label, DeveloperName FROM IberoAmerica_Countries_Lead__mdt LIMIT 1];
        System.assert(!iberoCountries.isEmpty(), 'There should be at least 1 IberoAmerica country configured.');
        
        String iberoCountry = iberoCountries[0].DeveloperName;
        
        Test.startTest();
        Database.DMLOptions dml = new Database.DMLOptions();
        dml.DuplicateRuleHeader.AllowSave = true;
        dml.DuplicateRuleHeader.RunAsCurrentUser = true;
        
        Lead newLead = LeadTestDataFactory.createLead(new Lead(
            FirstName = 'Test',
            LastName = 'Lead',
            Company = 'Test Company',
            RecordTypeId = schoolRecordTypeId,
            AE_Country__c = iberoCountry,
			PYP_Interest__c = true
        ));
        
        Database.SaveResult sr = Database.insert(newLead, dml);
        System.assert(sr.isSuccess(), 'Lead insert failed: ' + sr.getErrors());
        System.assertNotEquals(null, newLead.Id, 'Lead Id is null after insert');
        
        List<Lead> newLeads = new List<Lead>{newLead};
            LeadTriggerHelper.setIberoAmericaLead(newLeads); 
        Test.stopTest();
        
        List<Lead> updatedLeads = [SELECT Id, IberoAmerica__c FROM Lead WHERE Id = :newLead.Id];
        System.assertEquals(1, updatedLeads.size(), 'Lead not found in database after trigger execution');
        System.assert(updatedLeads[0].IberoAmerica__c, 'IberoAmerica__c should be true');
    }
}