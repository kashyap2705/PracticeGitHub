public without sharing class ContingencyMeasureRequest {
    
public static User user=[select contact.AccountId,contactid,LanguageLocaleKey, Name ,Email from user where id=:userInfo.getUserId()];
public static Id recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Contingency measure').getRecordTypeId();
public static Cut_of_Date__c sessionCutOff = [Select id,Name,Session_Close_Date__c,Session_Open_Date__c,Active__c,Type__c from Cut_of_Date__c where Active__c=true And Type__c = 'Contingency measure' Limit 1];
   
    /** 
    * @date 03/21/2022
    * @description get the Accounts for which current user have confirmed HOS,PC and HOS(Overall)
    * @returntype List<Account>
    * @param N/A
    */   
    @AuraEnabled (cacheable=true)
    public static List<Account> getConfirmedAccount(){
        try{
            set<Id> accId = new Set<Id>();
            for(IB_Role__c accountid : [select id,IB_Role_Name__c,IB_Account__r.id from IB_Role__c where IB_Contact__r.id = :user.contactId and Status__c = 'Confirmed' And IB_Role_Name__c IN ('Head of School','Head of School (Overall)','Programme Coordinator')]){
                accId.add(accountid.IB_Account__r.id);
            } 
            List<Account> accList = new List<Account>();
            accList = [select id,Name,IBIS_ID__c from Account where id IN :accId];
            return accList;          
        }
        catch(Exception ex) {
            System.debug('Error Message : '+ex.getMessage());
            return null;
        }
    }
    
    /** 
    * @date 03/21/2022
    * @description Update Cancellation Request
    * @returntype Case
    * @param ID , String
    */ 
    @AuraEnabled
    public static void updateRequestForCancellation(Id recordId, String cancellationReason){
        try{
            Case newCase = new Case(Id = recordId);
            newCase.Contingency_M_Reason_for_cancellation__c = cancellationReason;
            newCase.Status = 'Cancellation Requested';
            update newCase;
        }
        catch(Exception ex) {
            System.debug('Error Message : '+ex.getMessage());
        }
    }
    
	/** 
    * @date 03/21/2022
    * @description Delete the Case
    * @returntype void
    * @param list<Id>
    */ 
    @AuraEnabled
    public static void deleteCase(list<Id> lstCaseIds){
        try {
                list<Case> lstCaseToDelete = new list<Case>();
                for(Id idCase : lstCaseIds) {
                lstCaseToDelete.add(new Case(Id = idCase));
            }
            if(!lstCaseToDelete.isEmpty()) {
                delete lstCaseToDelete;
            }
        }
        catch(Exception ex) {
            System.debug('Error Message : '+ex.getMessage());
        }
    }
    
    /** 
    * @date 03/21/2022
    * @description get all related cases 
    * @returntype List<Case>
    * @param N/A
    */    
    @AuraEnabled(cacheable = true)
    public static List<Case> getCases(){
        try{
            List<Case> caseList = new List<Case>();
            caseList = [Select id,CaseNumber,toLabel(Status),Subject,Candidate_Full_Name__c,Candidate_Session_Number__c from Case where RecordType.name IN ('Contingency measure') AND ContactId =:user.ContactId AND Status IN ('Draft','Under Review','Submitted','complete') order by casenumber DESC ];
            return caseList;
        }
        catch(Exception ex) {
            System.debug('Error Message : '+ex.getMessage());
            return null;
        }
    }
    
    /** 
    * @date 03/21/2022
    * @description Get Cut off date
    * @returntype string
    * @param N/A
    */ 
    @AuraEnabled(cacheable = true)
    public static String getCutOffDate(){
        Date cutOff = sessionCutOff.Session_Close_Date__c;
        String dateStr = String.valueOf(cutOff);
        return dateStr;
    }
   
    @AuraEnabled (cacheable = true)
    public static Cut_of_Date__c NecmDate(){
        try {
            return  sessionCutOff;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled(cacheable = true)
    public static Id getRecordType(){
        Id tempID = recordTypeId;
        return tempID;
    }
    
    /** 
    * @date 03/21/2022
    * @description Get specified case record
    * @returntype Case
    * @param ID
    */     
    @AuraEnabled (cacheable = true)
    public static Case getCaseRecord(Id caseRecordId){
        try{
            Case caseRec = new Case();
            caseRec= [Select id,AccountId,ContactId,Contingency_Exam_Session__c,RecordTypeId,Origin,Status,
                      Description,ContingencyDate_quarantine_isolationends__c,Contingency_Reasons__c,
                      all_exams_are_affected__c,Individual_Group_request__c,Candidate_Personal_Code__c,
                      Candidate_Full_Name__c,Candidate_Session_Number__c,School_Code__c,CaseNumber,Account_Name__c 
                      From Case
                      Where id=:caseRecordId
                     ];
        	return caseRec;
        }
        catch(Exception ex) {
            System.debug('Error Message : '+ex.getMessage());
            return null;
        }
    }

    /** 
    * @date 03/21/2022
    * @description add the new case
    * @returntype void
    * @param ID, String
    */     
    @AuraEnabled
    public static void addCaseRecord(ID accountId, String ibisCode,  String examinationSession ,String checkStatus, 
                                     String description, String candidatePersonalCode, String candidateSessionNumber,
                                     String candidateFullName, String contingencyReasons , List<String> subjectsString, String quarantineEndDate,
                                    String groupOrIndividual, String examinationEffected){
        List<SubjectWrapper> subjectValues = new List<SubjectWrapper>();
        for(String sub: subjectsString)
        {
            SubjectWrapper wrapper=(SubjectWrapper)JSON.deserialize(sub,SubjectWrapper.class);
            subjectValues.add(wrapper);
        }
        List<Contingency_Measure_Requests_Subject__c> contingencySubjectList = new List<Contingency_Measure_Requests_Subject__c>();
        for(SubjectWrapper wrap : subjectValues)
            {
                Contingency_Measure_Requests_Subject__c contingency= new Contingency_Measure_Requests_Subject__c();
                contingency.Contingency_Subject_level__c = wrap.subjectLookup;
                contingency.Contingency_eCoursework_submitted__c = wrap.eCourcePicklist;
                contingency.examination_for_the_subject_taken__c = wrap.examTakenPicklist;
                contingencySubjectList.add(contingency);
            }
        Case caseRecord = new Case();
        if(accountId != null){
        caseRecord.AccountId = accountId;
        caseRecord.ContactId = user.contactid;
        caseRecord.Contingency_Exam_Session__c = examinationSession;
        caseRecord.RecordTypeId = recordTypeId;
        caseRecord.Origin = 'Web';
       // caseRecord.Status = checkStatus;
        caseRecord.Contingency_Details__c = description;
        System.debug('Umair Date = '+quarantineEndDate);
        if(quarantineEndDate != Null && !String.isEmpty(quarantineEndDate)){
            caseRecord.ContingencyDate_quarantine_isolationends__c = date.valueOf(quarantineEndDate);
        }
        caseRecord.Contingency_Reasons__c = ContingencyReasons;
        if(examinationEffected != Null){
          caseRecord.all_exams_are_affected__c = Boolean.valueOf(examinationEffected);
        }
        caseRecord.Individual_Group_request__c=  groupOrIndividual;
        if(candidatePersonalCode != null && candidateSessionNumber != null && 
           candidateFullName != null && contingencyReasons != null){
            caseRecord.Candidate_Personal_Code__c = candidatePersonalCode;
            caseRecord.Candidate_Full_Name__c = CandidateFullName;
            caseRecord.Candidate_Session_Number__c = candidateSessionNumber;
        }
        insert caseRecord;
        if(contingencySubjectList.size()>0){
            for(Contingency_Measure_Requests_Subject__c contingency : contingencySubjectList)
            {
                contingency.Contingency_Related_Case__c = caseRecord.id;
            }
            insert contingencySubjectList;    
        }
        caseRecord.Status = checkStatus;
        update caseRecord;
        }	
        
 
    }
    /** 
    * @date 03/21/2022
    * @description get subject id of PGQA_c
    * @returntype ID
    * @param  String
    */  
    @AuraEnabled
    public static Id returnSubjectID(String subjectName){
        List<PGQA__c> getID;
        if(String.isNotBlank(subjectName)){
           List<List<sObject>> searchList = [FIND :subjectName IN ALL FIELDS
           RETURNING PGQA__c(id,English__c)];
           getID = (List<PGQA__c>)searchList[0]; 
           if(!Test.isRunningTest()){
            return getID[0].id;
           }
           else{
             return null;
           }
           }
        else
            return null;   
    }
    /** 
    * @date 03/21/2022
    * @description save new files
    * @returntype void
    * @param ID, String
    */  
    @AuraEnabled
    public static void saveFile(Id idParent, String strFileName, String struploadFileName, Id documentId) {
        try{
            Case newCase = new Case();
            newCase = [Select id,CaseNumber from Case where RecordType.name IN ('Contingency measure') AND ContactId =:user.ContactId order by CreatedDate DESC Limit 1];
            if(strFileName != 'Decalaration'){
                String extension = struploadFileName.substring(struploadFileName.lastIndexOf('.')+1);
                strFileName = strFileName +' - '+newCase.CaseNumber+'.'+ extension;
            }
            else{
                String extension = struploadFileName.substring(struploadFileName.lastIndexOf('.')+1);
                integer index = struploadFileName.indexOf('.');
                String subString= struploadFileName.substring(0 , index); 
                strFileName = subString +' - '+newCase.CaseNumber+'.'+ extension;
            }
            ContentVersion contentv = [
                SELECT Id, VersionData,ContentDocumentId,ContentDocument.Title
                FROM ContentVersion
                WHERE ContentDocumentId = :documentid
            ];
             ContentVersion cv = new ContentVersion();
            cv.Title =  strFileName;
            cv.PathOnClient = '/' + strFileName;
            cv.VersionData = contentv.VersionData;
            cv.IsMajorVersion = false;
            if(!Test.isRunningTest())
            insert cv;
             ContentDocument contentdoc = [
                SELECT Id
                FROM ContentDocument
                WHERE id = :documentid
            ];
            delete contentdoc;
            ContentDocumentLink cdl = createContentLink(cv.id, newCase.id);
        }
        catch(Exception ex) {
            System.debug('Error Message : '+ex.getMessage());
        }
    }
    
    /** 
    * @date 03/21/2022
    * @description create the content link for document
    * @returntype ContentDocumentLink
    * @param  String
    */  
    @testvisible
    private static ContentDocumentLink createContentLink(String contentVersionId, String recordId) {
        try{
            if (contentVersionId == null || recordId == null) { return null; }
            ContentDocumentLink cdl = new ContentDocumentLink();
            cdl.ContentDocumentId = [
                SELECT ContentDocumentId 
                FROM ContentVersion 
                WHERE Id =: contentVersionId
            ].ContentDocumentId;
            cdl.LinkedEntityId = recordId;
            cdl.Visibility = 'AllUsers';
            cdl.ShareType = 'V';
            try {
                insert cdl;
                ContentDistribution cd = new ContentDistribution();
                cd.ContentVersionId = contentVersionId;
                cd.Name = [SELECT Title 
                FROM ContentVersion 
                WHERE Id =: contentVersionId].Title;
                cd.PreferencesNotifyOnVisit = false;
                insert cd;
                return cdl;
            } catch(DMLException e) {
                System.debug(e);
                return null;
            }
        }
        catch(Exception ex) {
            System.debug('Error Message : '+ex.getMessage());
            return null;
        }
    }
    
    /** 
    * @date 03/21/2022
    * @description wrapper class for contingency measure subjects data
    * @returntype SubjectWrapper
    * @param  N/A
    */
    public class SubjectWrapper{
        @AuraEnabled public String subjectLookup;
        @AuraEnabled public String eCourcePicklist;
        @AuraEnabled public String examTakenPicklist;
    }
    
    @AuraEnabled (cacheable=true)
    public static String getUserLocale() {
       return UserInfo.getLanguage();
   } 
}