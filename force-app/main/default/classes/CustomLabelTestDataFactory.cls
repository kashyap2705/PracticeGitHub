/**
* @description - This is used to create test data for CustomLabel__c object.
*
* @author: Vikash Kumar
* @since 20-03-2025
* @Modification Log:
* Date            Created/Modified    Ticket           Description    
* 20-03-2025      Created            US-0003035      Created the class
*/
@isTest
public without sharing class CustomLabelTestDataFactory { 

    private final static String DEFAULT_LABEL = 'view_case';
    private final static String DEFAULT_Group = 'FeedCommentHandler';
    /**
     * @description - Creates a list of `Custom_Label_Project__c` records
     * @param projectName - The name of the profile to assign to each user record. Used to fetch the profile ID. 
     */
    public static CustomLabel__c createLabel(CustomLabel__c tempLabel){

		CustomLabel__c label;
		if(tempLabel != null){
			label = tempLabel.clone(false);
		} else {
			label = new CustomLabel__c();
		}

		label = createLabelInstance(label);
        
        return label;
    }

    /**
     * @description - Creates or updates a CustomLabel__c instance with default or specified values. If a field is blank or null in 
     *                the provided CustomLabel__c record, it assigns a default value to that field.
     * @param labelRecord - The labelRecord record to be used as a template. If fields are blank or null, defaults are applied.
     */
    public static CustomLabel__c createLabelInstance(CustomLabel__c labelRecord){

        CustomLabel__c labelInstance = labelRecord;

		labelInstance.Label__c = String.isBlank(labelRecord.Label__c) ? DEFAULT_LABEL : labelRecord.Label__c;
        labelInstance.Group__c = String.isBlank(labelRecord.Group__c) ? DEFAULT_Group : labelRecord.Group__c;
        return labelInstance;
    }
}