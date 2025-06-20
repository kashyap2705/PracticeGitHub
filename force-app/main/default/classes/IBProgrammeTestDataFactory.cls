/**
* @description -This is used to create test data for IB_Programme__c object.
*
* @author  Satyanarayana Gajavalli
* @since 22-10-2024
* @ModificationLog 
* Date            Created/Modified   Ticket           Description    
* 21-10-2024      Created            US-0002466       Created the class
*/
@isTest
public without sharing class IBProgrammeTestDataFactory {

    // Default field values
    private final static String DEFAULT_EXAM_SESSION = 'May';
    private final static String DEFAULT_STATUS = 'Test';
    private final static String DEFAULT_IBCC_IMPLEMENTATION_PHASE = 'Phase 1';
    private final static String DEFAULT_PRIMARY_LANGUAGE = 'English';
    private final static String DEFAULT_STAGE_NAME = 'Evaluation';
    private final static String DEFAULT_STATUS_AUTHORIZED = 'Authorized';
    private final static Date DEFAULT_DATE_DECISION_ON_CANDIDACY = Date.today().addDays(365);
    private final static Date DEFAULT_DATE_DECISION_ON_AUTHORIZATION = Date.today().addDays(-20);
    private final static String DEFAULT_INVOICE_DATE = 'Feb 1 2015';

    /**
    * @description - Creates a list of IB_Programme__c records
    * @param recordTypeName - record Type name to be used for record
    * @param templateIBProgramme - template IB_Programme__c record to clone (can be null)
    * @param nProgrammes - number of records to create
    * @return list of IB_Programme__c records
    */
    public static List<IB_Programme__c> createIBProgrammes(String recordTypeName, IB_Programme__c templateIBProgramme, Integer nProgrammes) {
        Id recordTypeId;
        List<IB_Programme__c> ibProgrammes = new List<IB_Programme__c>();
        if(recordTypeName != ''){
            recordTypeId = getRecordTypeId(recordTypeName);
        }
        for (Integer i = 0; i < nProgrammes; i++) {
            IB_Programme__c ibProgramme;
            if (templateIBProgramme != null) {
                ibProgramme = templateIBProgramme.clone(false);
            } else {
                ibProgramme = new IB_Programme__c();
            }

            if (recordTypeId == null){
                ibProgramme = createIBProgrammeInstance(ibProgramme,null);
            } else {
                ibProgramme = createIBProgrammeInstance(ibProgramme,recordTypeId);
            }
            ibProgrammes.add(ibProgramme);
        }
        return ibProgrammes;
    }

    /**
    * @description - Creates a single IB_Programme__c record
    * @param recordTypeName - record Type name to be used for record
    * @param templateIBProgramme - template IB_Programme__c record to clone (can be null)
    * @return IB_Programme__c record
    */
    public static IB_Programme__c createIBProgramme(String recordTypeName, IB_Programme__c templateIBProgramme) {
        Id recordTypeId;
        if(recordTypeName != ''){
            recordTypeId = getRecordTypeId(recordTypeName);
        }
        IB_Programme__c ibProgramme;
        if (templateIBProgramme != null) {
            ibProgramme = templateIBProgramme.clone(false);
        } else {
            ibProgramme = new IB_Programme__c();
        }

        if (recordTypeId == null){
            ibProgramme = createIBProgrammeInstance(ibProgramme,null);
        } else {
            ibProgramme = createIBProgrammeInstance(ibProgramme,recordTypeId);
        }

        return ibProgramme;
    }

    /**
    * @description - Retrieves the Record Type Id for a given Record Type Name associated with the IB_Programme__c object.
    * @param recTypeName - The name of the Record Type to retrieve the Id for.
    * @return String - The Id of the Record Type corresponding to the given name. If the specified Record Type name is not found, the method will return the Id of the first available Record Type.
    */
    public static String getRecordTypeId(String recTypeName){
        String recTypeId = '';
        try{
            recTypeId = Schema.SObjectType.IB_Programme__c.getRecordTypeInfosByName().get(recTypeName).getRecordTypeId();
        } catch(Exception e){
            recTypeId = [SELECT Id FROM RecordType WHERE SobjectType = 'IB_Programme__c' LIMIT 1].Id;
        }
        return recTypeId;
    }

    /**
    * @description - Populates fields of an IB_Programme__c instance
    * @param ibProgrammeRecord - the record to populate fields
    * @param recordTypeId - the recordtype id to assign record type to new record
    * @return IB_Programme__c with populated fields
    */
    public static IB_Programme__c createIBProgrammeInstance(IB_Programme__c ibProgrammeRecord, String recordTypeId) {
        
        IB_Programme__c ibProgrammeInstance = ibProgrammeRecord;
        
        if(recordTypeId != null) {
            ibProgrammeInstance.recordTypeId = recordTypeId;
        }
        
        ibProgrammeInstance.Exam_Session__c = TestDataUtility.getValueOrDefault(ibProgrammeRecord.Exam_Session__c,DEFAULT_EXAM_SESSION);
        ibProgrammeInstance.Status__c = TestDataUtility.getValueOrDefault(ibProgrammeRecord.Status__c,DEFAULT_STATUS);
        ibProgrammeInstance.IBCC_Implementation_Phase__c = TestDataUtility.getValueOrDefault(ibProgrammeRecord.IBCC_Implementation_Phase__c,DEFAULT_IBCC_IMPLEMENTATION_PHASE);
        ibProgrammeInstance.Primary_Language_of_Instruction__c = TestDataUtility.getValueOrDefault(ibProgrammeRecord.Primary_Language_of_Instruction__c,DEFAULT_PRIMARY_LANGUAGE);
        ibProgrammeInstance.StageName__c = TestDataUtility.getValueOrDefault(ibProgrammeRecord.StageName__c,DEFAULT_STAGE_NAME);
        ibProgrammeInstance.Date_Decision_on_Candidacy__c = ibProgrammeRecord.Date_Decision_on_Candidacy__c != null ? ibProgrammeRecord.Date_Decision_on_Candidacy__c : DEFAULT_DATE_DECISION_ON_CANDIDACY;
        ibProgrammeInstance.Date_Decision_on_Authorization__c = ibProgrammeRecord.Date_Decision_on_Authorization__c != null ? ibProgrammeRecord.Date_Decision_on_Authorization__c : DEFAULT_DATE_DECISION_ON_AUTHORIZATION;
        ibProgrammeInstance.Invoice_Date__c =  TestDataUtility.getValueOrDefault(ibProgrammeRecord.Invoice_Date__c,DEFAULT_INVOICE_DATE);
       	if(String.isBlank(ibProgrammeInstance.Street_Address__c)){
			IB_Address__c ibAddress = IBAddressTestDataFactory.createIBAddress(null);
			insert ibAddress;
			ibProgrammeInstance.Street_Address__c = ibAddress.id;
            ibProgrammeInstance.Account__c = ibAddress.IB_Account__c;//.id;
		}
        return ibProgrammeInstance;
    }
    

}