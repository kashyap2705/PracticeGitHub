/**
* This is used to Test the instance of List of Contact Information
* 
* Ticket: 
*
* @author: Gautam Manchanda 
* @since 30-10-2024
* @Modification Log:
* Date            Created/Modified    Ticket           Description    
* 30-10-2024      Created             US-0002660       Created the class
*/
@isTest
public with sharing class ContactInformationTestDataFactory {

    private final static String REGION = 'IBAEM';

    public static List<Contact_information__c> createContactInformations(String recordTypeName, Contact_information__c tempContactInformation, Integer nContactInformation){
        Id recordTypeId;
        List<Contact_information__c> contactInformations = new List<Contact_information__c>();
        if(recordTypeName != ''){
            recordTypeId = getRecordTypeId(recordTypeName);
        }
        for (Integer i = 0; i < nContactInformation; i++) {
            Contact_information__c cont;
            if(tempContactInformation != null){
                cont = tempContactInformation.clone(false);
            }else{
                cont = new Contact_information__c();
            }
            
            if (recordTypeId == null){
                cont = createContactInformationInstance(cont,null);
            } else {
                cont = createContactInformationInstance(cont,recordTypeId);
            }
            contactInformations.add(cont);
        }
        return contactInformations;
    }

    public static Contact_information__c createContactInformation(String recordTypeName, Contact_information__c tempContactInformation){
        Id recordTypeId;
        if(recordTypeName != ''){
            recordTypeId = getRecordTypeId(recordTypeName);
        }
        Contact_information__c cont;
        if(tempContactInformation != null){
            cont = tempContactInformation.clone(false);
        }else{
            cont = new Contact_information__c();
        }
        
        if (recordTypeId == null){
            cont = createContactInformationInstance(cont,null);
        } else {
            cont = createContactInformationInstance(cont,recordTypeId);
        }
        return cont;
    }

    public static String getRecordTypeId(String recTypeName){
        String recTypeId = '';
        try{
            recTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(recTypeName).getRecordTypeId();
        } catch(Exception e){
            recTypeId = [SELECT Id FROM RecordType WHERE SobjectType = 'Contact_information__c' LIMIT 1].Id;
        }
        return recTypeId;
    }

    public static Contact_information__c createContactInformationInstance(Contact_information__c contactInformationRecord, String recordTypeId){
        Contact_information__c contactInformationInstance = contactInformationRecord;            
        if(recordTypeId != null) {
            contactInformationInstance.RecordTypeId = recordTypeId;
        }
        contactInformationInstance.Name = String.isBlank(contactInformationRecord.Name) ? TestDataUtility.generateRandomString(5) : contactInformationRecord.Name;

        return contactInformationInstance;
    }
}