trigger AuditTrackingFieldTrigger on e_eat__Audit_Tracking_Field__c (before insert, before update) {
    Map<String,String> apiNamesMap = new Map<String,String>();
    Map<String, Set<String>> fieldApiMap = new Map<String, Set<String>>();

    for ( Schema.SObjectType obj : Schema.getGlobalDescribe().values()) {
        Schema.DescribeSObjectResult objResult = obj.getDescribe();
        apiNamesMap.put(objResult.getName(), objResult.getLabel());
        fieldApiMap.put(String.valueOf(obj),obj.newSObject().getSObjectType().getDescribe().fields.getMap().keyset());
    }
    
    for(e_eat__Audit_Tracking_Field__c objField : trigger.new) {
        if(fieldApiMap != null && fieldApiMap.containsKey(objField.e_eat__Object_Name__c) 
           && ! (fieldApiMap.get(objField.e_eat__Object_Name__c).contains((objField.e_eat__Field_API_Name__c).tolowercase()))) {
            objField.addError('Please enter a valid Field API Name');    
        }        
    }
}