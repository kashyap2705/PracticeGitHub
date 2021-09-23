trigger AuditTrackingObjectTrigger on e_eat__Audit_Tracking_sObject__c (before insert, before update) {
    Map<String,String> apiNamesMap = new Map<String,String>();
    for ( Schema.SObjectType obj : Schema.getGlobalDescribe().values()) {
        Schema.DescribeSObjectResult objResult = obj.getDescribe();
        apiNamesMap.put(objResult.getName(), objResult.getLabel());
    }
    for(e_eat__Audit_Tracking_sObject__c objEAT : trigger.new) {
        if(objEAT.e_eat__API_Name__c != null && objEAT.e_eat__API_Name__c != ''){
            if(! apiNamesMap.containsKey(objEAT.e_eat__API_Name__c)){
                objEAT.addError('Please enter a valid object API Name');
            }
            
        }
    }

}