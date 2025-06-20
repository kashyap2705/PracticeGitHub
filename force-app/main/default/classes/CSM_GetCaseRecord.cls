public with sharing class CSM_GetCaseRecord {
	@AuraEnabled
    public static Boolean getCase(String recordID){
        Boolean editChatter = true;
        if(recordID != null) {
            Case caseRecord = [SELECT Id,status FROM case where id =:recordID][0];
            if(caseRecord.status == 'Withdrawn' || caseRecord.status == 'Closed' ){
                editChatter = false;
            }
        }
        return editChatter;
    }
}