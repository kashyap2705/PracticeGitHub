/**
 * Created by Pawel_Wiktorek on 18.05.2021.
 */

public with sharing class LeadTriggerHandler extends TriggerHandler{
    public override void beforeUpdate(){
        updateOpportunityFields((List<Lead>) Trigger.new);
       
    }
   
    @TestVisible
    private static void updateOpportunityFields(List<Lead> leads){
        try{
            system.debug('leads****'+leads);
            for(Lead l : leads)
            {
                l.LastName='Hii'+l.Name;
            
            }
        }
        catch(Exception ex){
            System.debug('The following exception has occurred: ' + ex.getMessage());
            throw ex;
        }
    }
   


}