public with sharing class AssignmentsCtrl {
    
    public List<Staffing_Event__c> assignments; 
    public String test;
    
    public AssignmentsCtrl() {
        test = 'foo';
        try
        {
            assignments	= [SELECT Name, Start_Date__c, End_Date__c, Staffing_Event_Type__c, Staffing_Event_Sub_Region__c, Staffing_Event_Region__c FROM Staffing_Event__c];
        }
        Catch(Exception x)
        {
            System.debug('Exception: '+x);
            
        }
    }
    
    public String getTest() {
        return test;
    }
    
    public List<Staffing_Event__c> getAssignments(){
        return assignments;
    }
}