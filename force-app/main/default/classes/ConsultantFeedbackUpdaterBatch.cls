global class ConsultantFeedbackUpdaterBatch implements Database.Batchable<SObject> {

    global Set<String> fieldNames; 
    global String query;
    global List<Id> endOfProcessRecordIds; 

    global Database.QueryLocator start(Database.BatchableContext BC) {
        System.debug('endOfProcessRecordIds in start method=====>'+endOfProcessRecordIds);
        
        return Database.getQueryLocator([
            SELECT Id, IB_Programme_Lookup__c
            FROM IB_Consultant_Feedback__c
            WHERE Id IN :endOfProcessRecordIds
            AND RecordType.Name = 'End of Process'
        ]);
        
    }

    global void execute(Database.BatchableContext BC, List<IB_Consultant_Feedback__c> endOfProcessRecords) {
        Map<Id, IB_Consultant_Feedback__c> feedbackMap = new Map<Id, IB_Consultant_Feedback__c>();
         
        DescribeSObjectResult describeResult = IB_Consultant_Feedback__c.getSObjectType().getDescribe();
        fieldNames = new Set<String>();
        set<String> outputFields = new set<String>();
        
        for (String fieldName : describeResult.fields.getMap().keySet()) {
            if (fieldName.containsIgnoreCase('Analysis_Findings__c') || fieldName.containsIgnoreCase('CV_EOC_Findings_and_Next_Steps__c')) {
                fieldNames.add(fieldName);
            }
            if(fieldName.containsIgnoreCase('IV_Analysis_For_Reporting__c') || fieldName.containsIgnoreCase('IV_Next_Steps_for_Reporting__c')){
                outputFields.add(fieldName.toLowerCase());
                
            }
        }
        
        query = 'SELECT ' + String.join(new List<String>(fieldNames), ',') + ', IB_Programme_Lookup__c ' +
                     'FROM IB_Consultant_Feedback__c ' +
                     'WHERE RecordType.Name = \'Initial Visit\' ' +
                     'AND Status__c IN (\'Published\') ' +
                     'AND IB_Programme_Lookup__c != null';
        System.debug('query===>'+query);
        
        List<IB_Consultant_Feedback__c> initialVisitRecords = Database.query(query);
        System.debug('initialVisitRecords====>'+initialVisitRecords);
        for (IB_Consultant_Feedback__c record : initialVisitRecords) {
            feedbackMap.put(record.IB_Programme_Lookup__c, record);
        }

        List<IB_Consultant_Feedback__c> recordsToUpdate = new List<IB_Consultant_Feedback__c>();

        for (IB_Consultant_Feedback__c record : endOfProcessRecords) {
            if (record.IB_Programme_Lookup__c != null && feedbackMap.containsKey(record.IB_Programme_Lookup__c)) {
                IB_Consultant_Feedback__c initialVisitRecord = feedbackMap.get(record.IB_Programme_Lookup__c);

                for (String exstFields : fieldNames) {
                    String newKey = null;
                    if (exstFields.containsIgnoreCase('Analysis_Findings__c')) {
                        String prefix = exstFields.replace('analysis_findings__c', '');
                        newKey = prefix + 'IV_Analysis_For_Reporting__c';
                    }
                    else if (exstFields.containsIgnoreCase('CV_EOC_Findings_and_Next_Steps__c')) {
                        String prefixEoc = exstFields.replace('cv_eoc_findings_and_next_steps__c', '');
                        newKey = prefixEoc + 'IV_Next_Steps_for_Reporting__c';
                    }

                    if (newKey != null && outputFields.contains(newKey.toLowerCase())) {
                        record.put(newKey, initialVisitRecord.get(exstFields));
                    }
                }

                recordsToUpdate.add(record);
                System.debug('recordsToUpdate===>'+recordsToUpdate);
            }
        }

        if (!recordsToUpdate.isEmpty()) {
            update recordsToUpdate;
        }
    }

    global void finish(Database.BatchableContext BC) {
        System.debug('Batch Job finish method has been triggered.');
    }
}