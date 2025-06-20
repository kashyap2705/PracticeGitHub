/*** This is used to Test the instance of List of Cases* * Ticket: *
 * @author: Alex Miller
 * @since 03-24-2025
 * @Modification Log:
 * Date            Created/Modified    Ticket           Description
 * 10-10-2024      Created             US-0003151       Created the class
 */
@isTest

public without sharing class CaseTestDataFactory {
    
    private final static String STATUS = 'New';
    
    
    public static List<Case> createCases(String recordTypeName, Case tempCase, Integer nCases){
        Id recordTypeId;
        List<Case> cases = new List<Case>();
        if(recordTypeName != ''){
            recordTypeId = getRecordTypeId(recordTypeName);
        }
        for (Integer i = 0; i < nCases; i++) {
            Case ca;
            if(tempCase != null){
                ca = tempCase.clone(false);
            }else{
                ca = new Case();
            }
            
            if (recordTypeId == null){
                ca = createCaseInstance(ca,null);
            } else {
                ca = createCaseInstance(ca,recordTypeId);
            }
            cases.add(ca);
        }
        return cases;
    }
    
    public static Case createCase(String recordTypeName, Case tempCase){
        Id recordTypeId;
        if(recordTypeName != ''){
            recordTypeId = getRecordTypeId(recordTypeName);
        }
        Case ca;
        if(tempCase != null){
            ca = tempCase.clone(false);
        }else{
            ca = new Case();
        }
        
        if (recordTypeId == null){
            ca = createCaseInstance(ca,null);
        } else {
            ca = createCaseInstance(ca,recordTypeId);
        }
        return ca;
    }
    
    public static String getRecordTypeId(String recTypeName){
        String recTypeId = '';
        try{
            recTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get(recTypeName).getRecordTypeId();
        } catch(Exception e){
            recTypeId = [SELECT Id FROM RecordType WHERE SobjectType = 'Case' LIMIT 1].Id;
        }
        return recTypeId;
    }
    
    public static Case createCaseInstance(Case caseRecord, String recordTypeId){
        Case caseInstance = caseRecord;
        if(recordTypeId != null) {
            caseInstance.RecordTypeId = recordTypeId;
        }
        
        caseInstance.Subject = String.isBlank(caseInstance.Subject) ? TestDataUtility.generateRandomString(5) : caseInstance.Subject;
        caseInstance.Status = String.isBlank(caseInstance.Status) ? STATUS : caseInstance.Status;
        
        return caseInstance;
    }
    
}