public with sharing class IBEventRoleTriggerHandler {
	
	
	public void addStaffingEventBefore(final List<IB_Event_Role__c> data) {
                  
        final Set <String> acceptedIBEvents = new Set <String> ();
           
        for (IB_Event_Role__c role : data) {
            acceptedIBEvents.add(role.IB_Event__c);
            
        }
        
        final Map <Id, Campaign> campignes = new Map <Id, Campaign> ([Select id, Staffing_Event_Notice_Board__c, Required_Number_of_Educators__c, Staffing_Event_Published__c from Campaign  where id IN :acceptedIBEvents ]);
        
        addStaffingEvents(data , campignes, acceptedIBEvents);
    	
		
	}
	
	private void addStaffingEvents(final List<IB_Event_Role__c> data , final Map <Id, Campaign> campignes, final Set<String> acceptedIBEvents) {
		for (IB_Event_Role__c role : data) {
               
               final Campaign tempCamp = campignes.get(role.IB_Event__c);
               	   
               if (null != tempCamp && tempCamp.Staffing_Event_Published__c) {
               	   	   role.Staffing_Event__c = tempCamp.Staffing_Event_Notice_Board__c; 
               	   	   
               }
               
           }
	}
	
	public void validateAndUpdateData(final Map<Id, IB_Event_Role__c> mapData, final Map<Id, IB_Event_Role__c> oldData) {
                  
           final List <My_Staffing_Event__c> staffingEvents = [Select IB_Event_Role__c from My_Staffing_Event__c where  IB_Event_Role__c IN : mapData.keySet()];
           
           final Set <String> skipEventsId = new Set <String> ();
           	        
           for (My_Staffing_Event__c myStaffingEvent : staffingEvents) {
        	   
               if (mapData.keySet().contains(myStaffingEvent.IB_Event_Role__c)) {
               	   
               	   final IB_Event_Role__c oldRoleData = oldData.get(myStaffingEvent.IB_Event_Role__c);
        	       final IB_Event_Role__c newRoleData = mapData.get(myStaffingEvent.IB_Event_Role__c);
        	       
        	       if (mapData.keySet().contains(myStaffingEvent.IB_Event_Role__c) && (oldRoleData.IB_Role__c != newRoleData.IB_Role__c || oldRoleData.IB_Programme__c != newRoleData.IB_Programme__c) ) {
                  	   newRoleData.addError(Label.Staffing_Applications);
                  	   skipEventsId.add(myStaffingEvent.IB_Event_Role__c);
     	           }
        	       
     	       }
     	                	             
           }
           
           for (IB_Event_Role__c newRoleData : mapData.values()) {
           	   
           	   final IB_Event_Role__c oldRoleData = oldData.get(newRoleData.Id);
           	   
               if (oldRoleData.Number_of_Required_Educators__c == newRoleData.Number_of_Required_Educators__c) {
     	          skipEventsId.add(newRoleData.Id);
     	       }
     	       
           }
           
           final Set <String> acceptedIBEvents = new Set <String> ();
           
           for (String roleId : mapData.keySet()) {
        	        
               if (!skipEventsId.contains(roleId)) {
               	
                  	acceptedIBEvents.add(mapData.get(roleId).IB_Event__c);
     	       }
     	                	             
           }
           
           final Map <Id, Campaign> campignes = new Map <Id, Campaign> ([Select id, Staffing_Event_Published__c, Staffing_Event_Notice_Board__c, Required_Number_of_Educators__c from Campaign  where id IN :acceptedIBEvents ]);
           
           updateCampaigne(campignes, acceptedIBEvents);
		
	}
	
	public void validateDataWhenDelete(final Map<Id, IB_Event_Role__c> mapData) {
                  
           final List <My_Staffing_Event__c> staffingEvents = [Select IB_Event_Role__c from My_Staffing_Event__c where  IB_Event_Role__c IN : mapData.keySet()];
           	        
           for (My_Staffing_Event__c myStaffingEvent : staffingEvents) {
        	        
               if (mapData.keySet().contains(myStaffingEvent.IB_Event_Role__c)) {
                  	mapData.get(myStaffingEvent.IB_Event_Role__c).addError(Label.Staffing_Applications);
                  	
     	       }
     	                	             
           }
           		
	}
	
	public void updateCampaignes( final Map<Id, IB_Event_Role__c> mapData) {
		
		final Set <String> acceptedIBEvents = new Set <String> ();
           
        for (IB_Event_Role__c role : mapData.values()) {
            acceptedIBEvents.add(role.IB_Event__c);
            
        }
        
        final Map <Id, Campaign> campignes = new Map <Id, Campaign> ([Select id, Required_Number_of_Educators__c from Campaign  where id IN :acceptedIBEvents ]);

		updateCampaigne(campignes, acceptedIBEvents);
	}
	
	private void updateCampaigne(final Map <Id, Campaign> campignes, final Set<String> acceptedIBEvents) {
		   
		   if (campignes.isEmpty()) {
           	   return ;
           }
           
           final List <Campaign> updList = new List <Campaign>();  
           final List <AggregateResult> results = [SELECT IB_Event__c ibEvent, SUM(Number_of_Required_Educators__c) sum FROM IB_Event_Role__c where IB_Event__c IN  :acceptedIBEvents Group by IB_Event__c];
                    
           if (null != results && !results.isEmpty()) {
	            for (AggregateResult result : results) {
	       
	                final String ibEvent = (String) result.get('ibEvent');
                    final Double sum = (Double) result.get('sum');
               
                    final Campaign tempCamp = campignes.get(ibEvent);
               
                    if ( null != tempCamp ) {
               	        tempCamp.Required_Number_of_Educators__c = sum; 
               	        updList.add(tempCamp);  
                    }
	            } 
	               
	        } else {
	        	
	        	for (String eventId : acceptedIBEvents) {
	        		final Campaign tempCamp = campignes.get(eventId);
	        		
	        		if (null != tempCamp && tempCamp.Required_Number_of_Educators__c != 0.0 )  {
	                  tempCamp.Required_Number_of_Educators__c = 0.0;
	                  updList.add(tempCamp);
	                  
	              }
	              
	        	}
	        	
	       }
           
           update updList;
	}


}