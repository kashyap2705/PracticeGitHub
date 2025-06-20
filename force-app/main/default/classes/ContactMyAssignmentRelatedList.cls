public with sharing class ContactMyAssignmentRelatedList 
{
	public List<My_Staffing_Event__c> lstMyAssignments {get;set;}
	private String parentContactId;
	private final string APPLICATION_STATUS_CONFIRMED = 'Confirmed';
    
    /* Start Constructor */
       
    public ContactMyAssignmentRelatedList (ApexPages.StandardController stdController)
    {
    	lstMyAssignments = new List<My_Staffing_Event__c>();
        parentContactId = ApexPages.currentPage().getParameters().get('id');
        getRelatedAssignmentRecords();
    }
    
    /* End Constructor */
    
    private void getRelatedAssignmentRecords()
    {
    	lstMyAssignments = [Select Id, Staffing_Event_Type__c, Staffing_Event_Region__c, Staffing_Event_Country__c, Start_Date__c, Programme_s__c,
    								Category__c, Staffing_Event_Language_1__c, IB_Role_Name__c, Application_Status__c, Subject__c 
    						FROM My_Staffing_Event__c 
                            WHERE IB_Contact__c =: parentContactId
                           		// mike demeglio 4/12/2016 - CR11816: only Confirmed applications should be returned
                           		AND Application_Status__c = :APPLICATION_STATUS_CONFIRMED
                           ];
    }
}