global class IBConsultantFeedbackUpdater implements Database.Batchable<SObject> {

    global Set<String> fieldNames; 
    global String query;

    global IBConsultantFeedbackUpdater() {
        DescribeSObjectResult describeResult = IB_Consultant_Feedback__c.getSObjectType().getDescribe();
        fieldNames = new Set<String>();

        for (String fieldName : describeResult.fields.getMap().keySet()) {
            if (fieldName.containsIgnoreCase('Analysis_Findings__c') || fieldName.containsIgnoreCase('CV_EOC_Findings_and_Next_Steps__c')) {
                fieldNames.add(fieldName);
            }
        }

        this.query = 'SELECT ' + String.join(new List<String>(fieldNames), ',') + ', IB_Programme_Lookup__c ' +
                     'FROM IB_Consultant_Feedback__c ' +
                     'WHERE RecordType.Name = \'Initial Visit\' ' +
                     'AND Status__c IN (\'Published\') ' +
                     'AND IB_Programme_Lookup__c != null';
    }

    global Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<IB_Consultant_Feedback__c> initialVisitRecords) {
        List<IB_Consultant_Feedback__c> endOfProcessRecords = [
            SELECT Id, IB_Programme_Lookup__c
            FROM IB_Consultant_Feedback__c 
            WHERE RecordType.Name = 'End of Process' 
            AND Status__c NOT IN ('Published', 'Returned to Consultant', null) 
            AND IB_Programme_Lookup__c != null
        ];

        Map<Id, IB_Consultant_Feedback__c> feedbackMap = new Map<Id, IB_Consultant_Feedback__c>();

        for (IB_Consultant_Feedback__c record : initialVisitRecords) {
            feedbackMap.put(record.IB_Programme_Lookup__c, record);
        }

        List<IB_Consultant_Feedback__c> recordsToUpdate = new List<IB_Consultant_Feedback__c>();

        for (IB_Consultant_Feedback__c record : endOfProcessRecords) {
            if (record.IB_Programme_Lookup__c != null && feedbackMap.containsKey(record.IB_Programme_Lookup__c)){
                IB_Consultant_Feedback__c initialVisitRecord = feedbackMap.get(record.IB_Programme_Lookup__c);

                for (String exstFields : fieldNames) {
                    String newKey;
                    if (exstFields.containsIgnoreCase('Analysis_Findings__c')) {
                        String prefix = exstFields.replace('analysis_findings__c', '');
                        newKey = prefix + 'IV_Analysis_For_Reporting__c';
                    }
                    else if (exstFields.containsIgnoreCase('CV_EOC_Findings_and_Next_Steps__c')) {
                        String prefixEoc = exstFields.replace('cv_eoc_findings_and_next_steps__c', '');
                        newKey = prefixEoc + 'IV_Next_Steps_for_Reporting__c';
                    }

                    if (IB_Consultant_Feedback__c.SObjectType.getDescribe().fields.getMap().containsKey(newKey)) {
                        record.put(newKey, initialVisitRecord.get(exstFields)); 
                    }
                }
                recordsToUpdate.add(record);
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