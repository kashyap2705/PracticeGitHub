/*** This is used to create the instance of List of School
 * @author: Vikash Kumar
 * @since 04-15-2025
 * @Modification Log:
 * Date            Created/Modified    Ticket           Description
 * 04-15-2025       Created            0002534             Created the class
 */

@isTest
public without sharing class SchoolSectionTestDataFactory {
    
    private final static String GRADEFROM = '0';
    private final static String GRADETO = '10';
    private final static Decimal STUDENTNO = 10;
    private final static Decimal CLASSNO = 10;
    
    public static SchoolSections__c createSchoolSection( SchoolSections__c tempSchoolSection){

        SchoolSections__c schoolSection;
        if(tempSchoolSection != null){
            schoolSection = tempSchoolSection.clone(false);
        }else{
            schoolSection = new SchoolSections__c();
        }  
        schoolSection = createSchoolSectionInstance(schoolSection); 
        return schoolSection;
    }
    
    
    public static SchoolSections__c createSchoolSectionInstance(SchoolSections__c schoolSectionRecord){
        SchoolSections__c schoolSectionInstance = schoolSectionRecord;  
        schoolSectionInstance.Grade_From__c = String.isBlank(schoolSectionInstance.Grade_From__c) ? GRADEFROM : schoolSectionInstance.Grade_From__c;
        schoolSectionInstance.Grade_To__c = String.isBlank(schoolSectionInstance.Grade_To__c) ? GRADETO : schoolSectionInstance.Grade_To__c;
        schoolSectionInstance.Number_Of_Students__c = String.isBlank(string.valueof(schoolSectionInstance.Number_Of_Students__c)) ? STUDENTNO : schoolSectionInstance.Number_Of_Students__c;
        schoolSectionInstance.Number_Of_Classes__c = String.isBlank(string.valueof(schoolSectionInstance.Number_Of_Classes__c))? CLASSNO : schoolSectionInstance.Number_Of_Classes__c;
        return schoolSectionInstance;
    }
    
}