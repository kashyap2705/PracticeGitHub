public with sharing class MyStaffingEventDAO {
    
    public static MyStaffingEventDAO INSTANCE = null;
    
    private MyStaffingEventDAO() {
        
    }
    
    public static MyStaffingEventDAO getInstance() {
        if (INSTANCE == null) {
            INSTANCE = new MyStaffingEventDAO();
        }
        return INSTANCE;
    }
    
    public boolean exists(Id event, Id contact, Id role) {
        try
        {
            
            List<My_Staffing_Event__c> staffingEventList = [
                SELECT Id, Name, IB_Event__c, IB_Contact__c, IB_Role__c
                FROM My_Staffing_Event__c
                WHERE IB_Event__c = :event
                AND IB_Contact__c = :contact
                AND IB_Role__c = :role
            ];
            
            if (staffingEventList != null && staffingEventList.size() > 0) {
                return true;
            }
            else {
                return false;
            }
        }
        Catch(Exception x)
        {
            System.debug('Exception: '+x);
            return false;
        }
        
    }
    
    public Id getCampaignIdFromStaffingId(Id staffingEventId) {
        try
        {
            
            final Staffing_Event__c staffingEvent = [
                SELECT id, IB_Event__c 
                FROM Staffing_Event__c 
                WHERE Id = :staffingEventId
            ];
            return staffingEvent.IB_Event__c;
        }
        Catch(Exception x)
        {
            System.debug('Exception: '+x);
            return NULL;
        }
        
    }
     //below piece of code is added by developer Ammara as part of L&T Changes on 12/26/2020
     //start
    Public String getCampigneventType(Id staffingEventId){
          try
        {
            
            final Staffing_Event__c staffingEvent = [
                SELECT id, Staffing_Event_Type__c 
                FROM Staffing_Event__c 
                WHERE Id = :staffingEventId
            ];
            return staffingEvent.Staffing_Event_Type__c;
        }
        Catch(Exception x)
        {
            System.debug('Exception: '+x);
            return NULL;
        }
    }
    //End
    
    //Following code is added by Umair-Plumlogix of US-12160 R21 of SA Project on 2/10/2021
    //Start
    
    public static List<My_Staffing_Event__c> getAssignmentRecord(id parentID)
    {
        List<My_Staffing_Event__c> assgRecord = new List<My_Staffing_Event__c>();
        assgRecord = [Select id,IB_Event__c,Programme_From_Event_Role__c,Level_of_Interest__c,Withdrawal_Argumentation__c, WithdrawalReason__c, Application_Status__c,IB_Contact__c from My_Staffing_Event__c where IB_Event__c =: parentID];
        //ECM00694 WithdrawalReason__c(Single Select) changed from Withdrawal_Reason__c(Multiselect)
        return assgRecord;
    }
    //End
}