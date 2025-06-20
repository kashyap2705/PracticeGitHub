/*
* @Author : Vikranth Karollu
* @CreatedDate : 07 Aug 2023
* @Description : Constants
*/		
/*******************************************************************************************************************
* Version       Author              Date             Comment                                                                       
* 1.0           Vikranth    	    07Aug2023        Initial draft 
* 2.0           Tarun Sharma        21Nov2023        203747 - Honorarium Table: IB Programme field integration 
*******************************************************************************************************************/
public class IBConstants {
    
    
    public static final String REQUESTED_EVENT = 'Requested Event';
    public static final String REQUESTED_WORKSHOP = 'Requested Workshop';
    public static final String SCHEDULED_EVENT = 'Scheduled Event';
    public static final String SCHEDULED_WORKSHOP = 'Scheduled Workshop';
    //203747-START
    public static final String DPCP_IBPROGRAMME = 'DP+CP';
    public static final String DP_IBPROGRAMME = 'DP';
    public static final String IBED_IBPROGRAMME = 'IB Ed';
    public static final String LEAD_IBPROGRAMME = 'Lead';
    public static final String CONTINUUM_IBPROGRAMME = 'Continuum';
    //203747-END
    
    public static Set<Id>  fetchCampaignEMSRecordTypeIds()
    {
        Set<Id> setEMSRecordTypeIds = new Set<Id> ();
        setEMSRecordTypeIds.add(Schema.SObjectType.Campaign.getRecordTypeInfosByDeveloperName().get('Requested_Event').getRecordTypeId());
        setEMSRecordTypeIds.add(Schema.SObjectType.Campaign.getRecordTypeInfosByDeveloperName().get('Requested_Workshop').getRecordTypeId());
        setEMSRecordTypeIds.add(Schema.SObjectType.Campaign.getRecordTypeInfosByDeveloperName().get('Scheduled_Event').getRecordTypeId());
        setEMSRecordTypeIds.add(Schema.SObjectType.Campaign.getRecordTypeInfosByDeveloperName().get('Scheduled_Workshop').getRecordTypeId());
        return setEMSRecordTypeIds;
    }
}