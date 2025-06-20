public class IB_ApplicationAfterUpdateTriggerHandler extends TriggerHandlerBase {
    
    public override void mainEntry(TriggerParameters tp) {
        if(TriggerContextUtility.isFirstRun()){
            TriggerContextUtility.setFirstRunFalse();
            process((Map<Id,IB_Application__c>)tp.oldMap, (Map<Id,IB_Application__c>)tp.newMap);
        }
    }
    
    private static void process (Map<Id,IB_Application__c> oldApplication, Map<Id,IB_Application__c> newApplication) {
        courseOutlineAutomation(oldApplication, newApplication);
    }
    
    private static void courseOutlineAutomation(Map<Id,IB_Application__c> oldMap, Map<Id,IB_Application__c> newMap) {
        RecordType recType = RecordTypeService.getRecordTypeByTypeAndName('IB_Application__c', 'Application_for_Authorization');
        Set<Id> progIdSet = new Set<Id>();
        for (IB_Application__c app : newMap.values()) {
            if (newMap.get(app.Id).RecordTypeId == recType.Id && oldMap.get(app.Id).Status__c != 'Submitted' && newMap.get(app.Id).Status__c == 'Submitted') {
                progIdSet.add(app.Programme_ID__c);
            }
        }
        
        CourseOutlineReadingService.createCourseOutlineReadings(progIdSet);
    }
}