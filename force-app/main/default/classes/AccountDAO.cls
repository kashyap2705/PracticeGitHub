public class AccountDAO {
    
    private static final AccountDAO instance = new AccountDAO();
    private Account account;
    
    private AccountDAO() {}
    
    public static AccountDAO getInstance() {
        return instance;
    }
    
    public Account getAccountById(Id accountId) {
        // in this query custom field "VAT_GST_Sales_Tax_Id__c" is added by developer Ali Haider Bajwa-plumlogix to fullfill the requirement of US-11814 of staff aug project
        //replaced School_Relationship_Manager__c with OwnerId for ECM00420 - Sprint 23-3 by Shahrukh
        //added School_Relationship_Manager__c INC0183351 BenMcGarvey
        //Business_Registration_Number__c, VAT_GST_Sales_Tax_registered_entitiy__c, GST_registration_declaration__c and Country__c added in the SOQL Query by Prerna on 26-09-2023 for ECM00665 
        account = [
            SELECT Id, Name, RecordType.Name, Dial_code__c,Phone_Number__c,Short_Name__c, Type, Legal_Name__c,VAT_GST_Sales_Tax_Id__c, Website, Month_Founded__c, Year_Founded__c, Academic_Start_Month__c, Academic_End_Month__c, 
            Language_Of_Correspondance__c, Legal_Status__c, Phone, Fax, Total_Number_Of_Students__c, Accreditation_Organizations__c, Other_accreditation_organization__c,
            Group_Of_School__c, Group_Of_Schools_Not_On_The_List__c, Registered_Regional_Association_Network__c, IB_World_School_Association__c, 
            Educational_authority_that_granted_legal__c, Region__c, Sub_region__c, Has_Website__c, Authorized_Programmes__c, Candidate_Programmes__c, 
            PIMS_Step_1__c, PIMS_Step_2__c, PIMS_Step_3__c, PIMS_Step_4__c, PIMS_Step_5__c, IBIS_ID__c, Authorized_School__c, OwnerId, School_Relationship_Manager__c, School_Relationship_Manager_Name__c, School_Relationship_Manager_Email__c,
            Business_Registration_Number__c,VAT_GST_Sales_Tax_registered_entitiy__c, GST_registration_declaration__c, Country__c
            FROM Account
            WHERE Id = :accountId
        ];
        
        return account;
        
    }
    
    public List<Account> searchAccountsByName(String searchTerm) {
        
        List<Account> accounts = Database.query('SELECT Id, Name, IBIS_ID__c FROM Account WHERE Name LIKE \'%' + String.escapeSingleQuotes(searchTerm) + '%\'');
        return accounts;
        
    }
    
    public List<Account> searchAccountsByNameAndType(String searchTerm, String recordType) {
        
        Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(recordType).getRecordTypeId();
        
        List<Account> accounts = Database.query('SELECT Id, Name, IBIS_ID__c FROM Account WHERE Name LIKE \'%' + String.escapeSingleQuotes(searchTerm) + '%\' AND RecordTypeId = \'' + recordTypeId + '\'');
        return accounts;
        
    }
    
}