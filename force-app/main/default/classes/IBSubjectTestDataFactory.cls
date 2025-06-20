/**
* This is used to Test the instance of List of IB_Subject__c
*
* @description Provides test data for IB_Subject__c records.
* @since   25-10-2024
* @Modification Log:
* Date            Created/Modified    Ticket           Description    
* 25-10-2024      Created             US-0002466       Created the class
*/
@isTest
public without sharing class IBSubjectTestDataFactory {

    private final static String DEFAULT_PROGRAMME = 'CP';
    private final static String DEFAULT_PROGRAMME_LONG = 'IB Career-related Programme';
    private final static String DEFAULT_SUBJECT_GROUP = 'Other';
    private final static String DEFAULT_SUBJECT_NAME = 'Career related study';
    private final static String DEFAULT_SUBJECT_CODE = 'careerstud';
    
    /**
     * @description - Creates a specified number of `IB_Subject__c` records, either cloned from a provided template 
     *                or initialized as new records. Each record is further customized using `createSubjectInstance`.
     * @param tempSubject - The template `IB_Subject__c` record to clone. If null, new empty records are created.
     * @param nSubjects - The number of `IB_Subject__c` records to create.
     * @return - A list of newly created `IB_Subject__c` records.
     */
    public static List<IB_Subject__c> createSubjects(IB_Subject__c tempSubject, Integer nSubjects) {
        List<IB_Subject__c> subjects = new List<IB_Subject__c>();
        for (Integer i = 0; i < nSubjects; i++) {
            IB_Subject__c subject;
            if(tempSubject != null) {
                subject = tempSubject.clone(false);
            } else {
                subject = new IB_Subject__c();
            }
            subject = createSubjectInstance(subject);
            subjects.add(subject);
        }
        return subjects;
    }

    /**
     * @description - Creates a single `IB_Subject__c` record, either cloned from a provided template 
     *                or initialized as a new record. The record is then customized using `createSubjectInstance`.
     * @param tempSubject - The template `IB_Subject__c` record to clone. If null, a new empty record is created.
     * @return - A newly created `IB_Subject__c` record with customized fields.
     */
    public static IB_Subject__c createSubject(IB_Subject__c tempSubject) {
        IB_Subject__c subject;
        if(tempSubject != null) {
            subject = tempSubject.clone(false);
        } else {
            subject = new IB_Subject__c();
        }
        return createSubjectInstance(subject);
    }

    /**
     * @description - Populates the fields of a given `IB_Subject__c` record with default values if they are not already set.
     *                Ensures that any blank or null fields in the provided record are populated with specified default values.
     * @param subjectRecord - The `IB_Subject__c` record to populate with field values.
     * @return - An `IB_Subject__c` record with populated fields, where unset fields are replaced with defaults.
     */
    public static IB_Subject__c createSubjectInstance(IB_Subject__c subjectRecord) {
        IB_Subject__c subjectInstance = subjectRecord;
        subjectInstance.IB_Programme__c = String.isBlank(subjectRecord.IB_Programme__c) ? DEFAULT_PROGRAMME : subjectRecord.IB_Programme__c;
        subjectInstance.IB_Programme_Long__c = String.isBlank(subjectRecord.IB_Programme_Long__c) ? DEFAULT_PROGRAMME_LONG : subjectRecord.IB_Programme_Long__c;
        subjectInstance.Subject_Group__c = String.isBlank(subjectRecord.Subject_Group__c) ? DEFAULT_SUBJECT_GROUP : subjectRecord.Subject_Group__c;
        subjectInstance.Subject_Name__c = String.isBlank(subjectRecord.Subject_Name__c) ? DEFAULT_SUBJECT_NAME : subjectRecord.Subject_Name__c;
        subjectInstance.Subject_Code__c = String.isBlank(subjectRecord.Subject_Code__c) ? DEFAULT_SUBJECT_CODE : subjectRecord.Subject_Code__c;
        
        return subjectInstance;
    }
}