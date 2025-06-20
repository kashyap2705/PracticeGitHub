/**
* @description - This is used to create test data for Custom_Label_Project__c object.
*
* @author: Vikash Kumar
* @since 19-03-2025
* @Modification Log:
* Date            Created/Modified    Ticket           Description    
* 19-03-2025      Created            US-0003035      Created the class
*/
@isTest
public without sharing class CustomProjectTestDataFactory { 

    private final static String DEFAULT_Name= 'ibAnswersTest';

    /**
     * @description - Creates a list of `Custom_Label_Project__c` records
     * @param projectName - The name of the profile to assign to each user record. Used to fetch the profile ID. 
     */
    public static Custom_Label_Project__c createProject(Custom_Label_Project__c tempProj){

		Custom_Label_Project__c proj;
		if(tempProj != null){
			proj = tempProj.clone(false);
		} else {
			proj = new Custom_Label_Project__c();
		}

		proj = createProjectInstance(proj);
        
        return proj;
    }

    /**
     * @description - Creates or updates a Custom_Label_Project__c instance with default or specified values. If a field is blank or null in 
     *                the provided Custom_Label_Project__c record, it assigns a default value to that field.
     * @param projRecord - The projRecord record to be used as a template. If fields are blank or null, defaults are applied.
     */
    public static Custom_Label_Project__c createProjectInstance(Custom_Label_Project__c projRecord){

        Custom_Label_Project__c projInstance = projRecord;
        
        projInstance.Name = String.isBlank(projRecord.Name) ? DEFAULT_Name : projRecord.Name;

        return projInstance;
    }
}