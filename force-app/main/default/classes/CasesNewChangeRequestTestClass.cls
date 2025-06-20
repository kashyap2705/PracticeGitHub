@isTest 
private class CasesNewChangeRequestTestClass {
    static testMethod void CasesNewChangeRequestTest() {
       //This Part is being updated by Ammara-Plumlogix on 7-27-2019,US-10851 
       //Begin
       String recordTypeName = 'Support';
       String recordTypeName2 = 'Support';
       //End
       Map<String,Schema.RecordTypeInfo> rtMapByName = Schema.SObjectType.Case.getRecordTypeInfosByName();
       
       Schema.RecordTypeInfo rtInfo =  rtMapByName.get(recordTypeName);
       id recordTypeId = rtInfo.getRecordTypeId();
       
       Schema.RecordTypeInfo rtInfo2 =  rtMapByName.get(recordTypeName2);
       id recordTypeId2 = rtInfo2.getRecordTypeId();
        
       //This Part is being updated by Ammara-Plumlogix on 7-27-2019,US-10851 
       //Begin
       Case c = new Case(Origin='Web', Status='New', Priority='Low', Description='Testing Change Request');
       //End
       c.RecordTypeId = recordTypeId;
       
       // Insert case
       insert c;
    
       //c = [Select Approver__c From Case WHERE Id =:c.Id];
       //System.debug('Approver: ' + c.Approver__c);
       
       c.RecordTypeId = recordTypeId2;
     
       update( c );
       
      // update( c );       
    }
}