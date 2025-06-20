@isTest
private class IbTranslationsUtilControllerTest {
    @testSetup static void testsetup() {
            Map<String,String> customLabelMap = new Map<String,String>();
            customLabelMap.put('academic_honesty','Academic honesty');
            customLabelMap.put('Mathematics','Mathematics');
            List<customlabel__c> customlabelList = customLabelRecords(customLabelMap.keySet(), true);
         
            List<Translation__c> transList = new List<Translation__c>();
            for(customlabel__c customLabel : customlabelList){
            transList.add(createTranslationTestData(customLabelMap.get(customLabel.Label__c),customLabel.id, 'American English'));
            }
            if(!transList.isEmpty()){
                insert transList;
            }
    }

    public static Translation__c createTranslationTestData(String value, Id customLabelRecordId, String language) {
         Translation__c trans = new Translation__c(
             Language__c = language,
             Value__c = value,
             CustomLabel__c = customLabelRecordId
             
         );
         return trans;
     }

    public static List<customlabel__c> customLabelRecords(Set<String> labels, Boolean isInsert){
        Custom_Label_Project__c clProject = projectRecords('IB Answers Template');
        List<customlabel__c> customRecordsList = new List<customlabel__c>();
        for(String label:labels){
            customlabel__c customRecord = new customlabel__c();
            customRecord.Label__c = label;
            customRecord.Group__c = 'Document';
            customRecord.Project__c = clProject.Id;
            customRecordsList.add(customRecord);
        }
        
        if(isInsert){
        	insert customRecordsList;
        }
        return customRecordsList;
    }

    public static Custom_Label_Project__c projectRecords(String label){
        Custom_Label_Project__c projectRecords = new Custom_Label_Project__c();
        projectRecords.Name = label;
        insert projectRecords;
        return projectRecords;
    }


    @isTest
    public static void testgetTranslationsMap() {
            Map<String, Map<String,String>> translationsMap = IbTranslationsUtilController.getTranslationsMap('IB Answers Template');
            system.assertEquals('Academic honesty',translationsMap.get('academic_honesty').get('American English'),'Translation value is not correct');
    }
}