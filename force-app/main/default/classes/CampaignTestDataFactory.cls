/**
*  @description This is used to Test the instance of List of Campaigns
* 
* Ticket: 
*
* @author: Vikash Kumar
* @since 22-10-2024
* @Modification Log:
* Date            Created/Modified    Ticket           Description    
* 23-10-2024      Created            US-0002499       Created the class
*/
@isTest
public without sharing class CampaignTestDataFactory { 
    private final static String TYPE = 'Evaluation';
    private final static String SUBTYPE = 'Evaluation Reading';
	private final static String STATUS = 'Planned / Ready for Staffing';
    /**
     * @description - Creates a list of Campaign records
     * @param recordTypeName - record Type name to be used for record 
     * @param tempCampaign  - template Campaign record to clone (can be null)
     * @param nCampaign  - number of records to create   
     * @return List<Campaign>              
     */
    public static List<Campaign> createCampaigns(String recordTypeName, Campaign tempCampaign, Integer nCampaign){
        Id recordTypeId;
        List<Campaign> campaigns = new List<Campaign>();
        if(recordTypeName != ''){
            recordTypeId = getRecordTypeId(recordTypeName);
        }
        for (Integer i = 0; i < nCampaign; i++) {
            Campaign camp;
            if(tempCampaign != null){
                camp = tempCampaign.clone(false);
            }else{
                camp = new Campaign();
            }
            
            if (recordTypeId == null){
                camp = createCampaignInstance(camp,null);
            } else {
                camp = createCampaignInstance(camp,recordTypeId);
            }
            campaigns.add(camp);
        }
        return campaigns;
    }
    /**
     * @description - Creates a Campaign record      
     * @param recordTypeName - record Type name to be used for record  
     * @param tempCampaign   - template Campaign record to clone (can be null)
     * @return `Campaign`
     */
    public static Campaign createCampaign(String recordTypeName,  Campaign tempCampaign){
        Id recordTypeId;
        if(recordTypeName != ''){
            recordTypeId = getRecordTypeId(recordTypeName);
        }
        Campaign camp;
		if(tempCampaign != null){
			camp = tempCampaign.clone(false);
		}else{
			camp = new Campaign();
		}
        
        if (recordTypeId == null){
            camp = createCampaignInstance(camp,null);
        } else {
            camp = createCampaignInstance(camp,recordTypeId);
        }
        return camp;
    }
    
    /**
    * @description - Retrieves the Record Type Id for a given Record Type Name associated with the Campaign object.
     * @param recTypeName - The name of the Record Type to retrieve the Id for.
    * @return String - The Id of the Record Type corresponding to the given name. If the specified Record Type name is not found, the method will return the Id of the first available Record Type.
     */
    public static String getRecordTypeId(String recTypeName){
        String recTypeId = '';
        try{
            recTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(recTypeName).getRecordTypeId();
        } catch(Exception e){
            recTypeId = [SELECT Id FROM RecordType WHERE SobjectType = 'Campaign' LIMIT 1].Id;
        }
        return recTypeId;
    }

    /**
     * @description - Populates fields of a Campaign instance       
     * @param campaignRecord -Populates fields of an Campaign instance
     * @param recordTypeId - the recordtype id to assign record type to new record   
     * @return `Campaign`
     */
    public static Campaign createCampaignInstance(Campaign campaignRecord, String recordTypeId){
        Campaign campaignInstance = campaignRecord;  
		Account ibAccount;		
        if(recordTypeId != null) {
            campaignRecord.RecordTypeId = recordTypeId;
        }
        campaignInstance.Name = String.isBlank(campaignInstance.Name) ? 'Candidacy Remote Consultation ' + TestDataUtility.generateRandomString(5) : campaignRecord.Name;
        campaignInstance.Type = String.isBlank(campaignInstance.Type) ? TYPE : campaignRecord.Type;
		campaignInstance.Sub_Type__c = String.isBlank(campaignInstance.Sub_Type__c) ? SUBTYPE : campaignRecord.Sub_Type__c;
		campaignInstance.Status = String.isBlank(campaignInstance.Status) ? STATUS : campaignRecord.Status;
        if(String.isBlank(campaignInstance.Event_Organizer_Account__c)){
			ibAccount = AccountTestDataFactory.createAccount(null,null);
			insert ibAccount;
			campaignInstance.Event_Organizer_Account__c = ibAccount.id;
		}else{
			campaignInstance.Event_Organizer_Account__c = campaignRecord.Event_Organizer_Account__c;
		}
		if(String.isBlank(campaignInstance.Venue_Account__c)){
			campaignInstance.Venue_Account__c = campaignInstance.Event_Organizer_Account__c ;
		}else{
			campaignInstance.Venue_Account__c = campaignRecord.Venue_Account__c;
		}
		if(String.isBlank(campaignInstance.Related_IB_Programme__c)){
			IB_Programme__c ibProgramme = IBProgrammeTestDataFactory.createIBProgramme(null,null);
			insert ibProgramme;
			campaignInstance.Related_IB_Programme__c = ibProgramme.id;
		}
		
        return campaignInstance;
    }
    
}