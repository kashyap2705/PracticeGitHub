global with sharing class TrackingHistory implements Queueable{
    global Map<Id,sObject> newMap;
    global Map<Id,sObject> oldMap;
    global Schema.sObjectType sObjType; 
    
    global TrackingHistory(Schema.sObjectType sObjType, Map<Id, sObject> oldMap, Map<Id, sObject> newMap){
        this.newMap = newMap;
        this.oldMap = oldMap;
        this.sObjType = sObjType;
    }
    
    global void execute(QueueableContext context) {
        Map<String, Id> selectedfieldsMap = new Map<String, Id>();
        List<e_eat__Audit_Tracking_History__c> trackHistoryList = new List<e_eat__Audit_Tracking_History__c>();
        
        if(Schema.SObjectType.e_eat__Audit_Tracking_sObject__c.isAccessible()
           && Schema.SObjectType.e_eat__Audit_Tracking_sObject__c.fields.e_eat__API_Name__c.isAccessible()
           && Schema.SObjectType.e_eat__Audit_Tracking_Field__c.isAccessible()
           && Schema.SObjectType.e_eat__Audit_Tracking_Field__c.fields.e_eat__Field_API_Name__c.isAccessible()) {
               
                for(e_eat__Audit_Tracking_Field__c objFields : [select Id, e_eat__Field_API_Name__c from e_eat__Audit_Tracking_Field__c where 
                e_eat__Audit_Tracking_sObject__r.e_eat__API_Name__c=: String.valueOf(sObjType) AND 
                                                                          e_eat__Active__c=true]) { 
                    selectedfieldsMap.put(objFields.e_eat__Field_API_Name__c.toLowerCase(), objFields.Id);
                }
               if(Schema.SObjectType.e_eat__Audit_Tracking_History__c.isCreateable()
                  && Schema.SObjectType.e_eat__Audit_Tracking_History__c.fields.e_eat__Audit_Tracking_Field__c.isCreateable()
                  && Schema.SObjectType.e_eat__Audit_Tracking_History__c.fields.e_eat__Original_Value__c.isCreateable()
                  && Schema.SObjectType.e_eat__Audit_Tracking_History__c.fields.e_eat__New_Value__c.isCreateable()
                  && Schema.SObjectType.e_eat__Audit_Tracking_History__c.fields.e_eat__Related_Record_ID__c.isCreateable()) {
                    
                      Map<String, Schema.SObjectField> fieldMap = sObjType.getDescribe().fields.getMap();
                      for(SObject obj : newMap.values()){
                          SObject oldObj;
                          if(oldMap != null && oldMap.containsKey(obj.Id)) {
                              oldObj = oldMap.get(obj.Id);
                          }
                          for(String field: fieldMap.keySet()) {
                            e_eat__Audit_Tracking_History__c trackHistoryObj = new e_eat__Audit_Tracking_History__c();
                              if(selectedfieldsMap.keySet().contains(field) && (oldMap == null || oldMap.get(obj.Id).get(field) != newMap.get(obj.Id).get(field))) {
                                  trackHistoryObj.e_eat__Audit_Tracking_Field__c = selectedfieldsMap.get(field);
                                  //Schema.DisplayType objType = selectedfieldsTypeMap.get(field);
                                  if(oldObj != null) {
                                      String strOriginalVal;
                                      strOriginalVal = ''+oldMap.get(obj.Id).get(field);
                                      trackHistoryObj.e_eat__Original_Value__c = ((strOriginalVal != null && strOriginalVal != 'null') ? strOriginalVal : '');
                                   } else {
                                      trackHistoryObj.e_eat__Original_Value__c = '';
                                  }
                                  String strNewVal;
                                  strNewVal = ''+newMap.get(obj.Id).get(field);
                                  trackHistoryObj.e_eat__New_Value__c = ((strNewVal != null && strNewVal != 'null')? strNewVal : '');
                                  trackHistoryObj.e_eat__Related_Record_ID__c = ''+newMap.get(obj.Id).get('Id'); 
                                  trackHistoryList.add(trackHistoryObj);
                              }
                          }
                      }
                      if(trackHistoryList != null && ! trackHistoryList.isEmpty()) {
                          insert trackHistoryList;
                      }
               }
           }
           
        }
}