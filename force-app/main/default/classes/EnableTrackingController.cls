public with sharing class EnableTrackingController {
    
/*
Description: Get List of Audit Tracking sObject and Audit Tracking Fields. 
Parameters: 
objectAPIName(String) - Object API Name. Ex: Account, Contact, Custom_Object__c
Return Type: List<e_eat__Audit_Tracking_sObject__c>    
*/
    @AuraEnabled(cacheable=true)
    public static List<e_eat__Audit_Tracking_sObject__c> getTemplatesForObject(String objectAPIName){
        List<e_eat__Audit_Tracking_sObject__c> listDataTemplates;
        
        if(Schema.SObjectType.e_eat__Audit_Tracking_sObject__c.isAccessible()
           && Schema.SObjectType.e_eat__Audit_Tracking_Field__c.isAccessible()
           && Schema.SObjectType.e_eat__Audit_Tracking_sObject__c.fields.Name.isAccessible()
           && Schema.SObjectType.e_eat__Audit_Tracking_sObject__c.fields.e_eat__API_Name__c.isAccessible()
           && Schema.SObjectType.e_eat__Audit_Tracking_Field__c.fields.Name.isAccessible()
           && Schema.SObjectType.e_eat__Audit_Tracking_Field__c.fields.e_eat__Field_API_Name__c.isAccessible()) {
               listDataTemplates =  [SELECT Id, Name, e_eat__API_Name__c, (SELECT Id, Name,  e_eat__Field_API_Name__c FROM e_eat__Audit_Tracking_Fields__r) FROM e_eat__Audit_Tracking_sObject__c WHERE e_eat__API_Name__c =: objectAPIName Order By CreatedDate];
           }  
        else {
            throw new SecurityException('You don\'t have access to the fields/records. Please contact System Administrator');
        }
        return listDataTemplates;
    }
    
/*
Description: Get Audit Tracking Fields by Data Template Record Id. 
Parameters: 
recordId(String) - recordId of Audit tracking sObject   
Return Type: List<e_eat__Audit_Tracking_Field__c>               
*/
    @AuraEnabled(cacheable=true)
    public static List<e_eat__Audit_Tracking_Field__c> getTemplatesByRecordId(String recordId){
        if(Schema.SObjectType.e_eat__Audit_Tracking_Field__c.isAccessible()
           && Schema.SObjectType.e_eat__Audit_Tracking_Field__c.fields.Name.isAccessible()
           && Schema.SObjectType.e_eat__Audit_Tracking_Field__c.fields.e_eat__Field_API_Name__c.isAccessible()
           && Schema.SObjectType.e_eat__Audit_Tracking_Field__c.fields.e_eat__Active__c.isAccessible()
           && Schema.SObjectType.e_eat__Audit_Tracking_Field__c.fields.e_eat__Audit_Tracking_sObject__c.isAccessible()) {
            return [SELECT Id, Name, e_eat__Field_API_Name__c, e_eat__Active__c FROM e_eat__Audit_Tracking_Field__c WHERE e_eat__Audit_Tracking_sObject__c =: recordId ORDER BY CreatedDate];
        } else {
            throw new SecurityException('You don\'t have access to the fields/records. Please contact System Administrator');
        }
        
    }
    
/*
Description: Get Object Picklist Options for Home Page Component. 
Parameters: None        
Return Type: List<String>             
*/
    @AuraEnabled(cacheable=true)
    public static List<String> getObjectTemplatePickListOptions() {
        List<String> selectOptions = new List<String>();
        if(Schema.SObjectType.e_eat__Audit_Tracking_sObject__c.isAccessible()
           && Schema.SObjectType.e_eat__Audit_Tracking_sObject__c.fields.e_eat__API_Name__c.isAccessible()) {
               AggregateResult[] groupedResults = [SELECT e_eat__API_Name__c, Count(Id) FROM e_eat__Audit_Tracking_sObject__c GROUP BY e_eat__API_Name__c LIMIT 50];          
               for (AggregateResult ar : groupedResults)  {    
                   selectOptions.add(String.valueOf(ar.get('e_eat__API_Name__c')));                   
               }
               return selectOptions;
           } else {
               throw new SecurityException('You don\'t have access to the fields/records. Please contact System Administrator');
           }
    }

/*
Description: Get Audit Tracking Fields by Audit Tracking sObject Record Id. 
Parameters: 
recordId(String) - recordId of Audit Tracking sObject   
Return Type: List<e_eat__Audit_Tracking_Field__c>               
*/
    @AuraEnabled(cacheable=true)
    public static e_eat__Audit_Tracking_sObject__c getTemplateMappingsByDeveloperName(String developerName){
        e_eat__Audit_Tracking_sObject__c dataTemplate;
        if(Schema.SObjectType.e_eat__Audit_Tracking_sObject__c.isAccessible()
                && Schema.SObjectType.e_eat__Audit_Tracking_Field__c.isAccessible()
                && Schema.SObjectType.e_eat__Audit_Tracking_sObject__c.fields.Name.isAccessible()
                && Schema.SObjectType.e_eat__Audit_Tracking_sObject__c.fields.e_eat__API_Name__c.isAccessible()
                && Schema.SObjectType.e_eat__Audit_Tracking_Field__c.fields.Name.isAccessible()
                && Schema.SObjectType.e_eat__Audit_Tracking_Field__c.fields.e_eat__Field_API_Name__c.isAccessible()) {
                    dataTemplate =  [SELECT Id, Name, e_eat__API_Name__c, (SELECT Id, Name, e_eat__Field_API_Name__c FROM e_eat__Audit_Tracking_Fields__r) FROM e_eat__Audit_Tracking_sObject__c WHERE e_eat__API_Name__c =: developerName];
                }  
                else {
                    throw new SecurityException('You don\'t have access to the fields/records. Please contact System Administrator');
                }
                return dataTemplate;
    }
    
    public class SecurityException extends Exception{}
}