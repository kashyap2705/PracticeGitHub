/**     
* <h1>PGQARequestCase</h1>     
* This class is responsible for the functions from Request Form(Support Community) to Salesforce.
* 
* @author  Muhammad Shehryar  
* @version 1.0      
* @since   09/28/2021

Modification Log     :                                                                              

*------------------------------------------------------------------------------------------------------------------------------- 

* Developer                   Date                   Description                                                  Version                          

* ------------------------------------------------------------------------------------------------------------------------------ 
Muhammad Shehryar                     09-28-2021            Created and added functions                                       1.0

*/
public without sharing class PGQARequestCase {
      public static User user=[select contact.AccountId,contactid,LanguageLocaleKey, Name ,Email from user where id=:userInfo.getUserId()];
      public static Map<String,ID> count_transcript_file =new Map<String,ID>();
     public static Map<String,ID> count_Ev1_file = new Map<String,ID>();
    public static Map<String,ID> count_Ev2_file = new Map<String,ID>();
    public static Map<String,ID> count_Ev3_file = new Map<String,ID>();
    
    
    
   @AuraEnabled(cacheable=true)public static List<Case> getCases(){
       system.debug('get Cases');
        List<Case> case_list = new List<Case>();

        case_list = [Select id,CaseNumber,toLabel(Status),Subject from Case where RecordType.name IN ('PGQA') AND ContactId =:user.ContactId AND Status IN ('Evidence Requested','Under Review','Submitted','Need More Information','Complete','Cancelled') order by CaseNumber];

         system.debug('contact id'+user.ContactId );
        return case_list;
    }
    
    @AuraEnabled(cacheable = true)
     public static List<Account> getconfirmedAccount(){
        System.debug('Javalog Confirmed Account');
        set<ID> acc_id = new Set<ID>();
        list<IB_Role__c> role = new list<IB_Role__c>();
        role = [select id,IB_Role_Name__c,IB_Account__r.id from IB_Role__c where IB_Contact__r.id = :user.contactId and Status__c = 'Confirmed' And IB_Role_Name__c IN ('Head of School','Head of School (Overall)','Programme Coordinator')  ];
        for(IB_Role__c accountid : role){
            acc_id.add(accountid.IB_Account__r.id);
        } 
        System.debug('Javalog Account ID Set Size: '+acc_id.size());
        List<Account> ac = new List<Account>();
        ac = [select id,Name,IBIS_ID__c from Account where id IN :acc_id AND SIPGE_Registration__c = true];
        System.debug('Javalog Account List Size: '+ac.size());
        return ac;
    }
    
    
      @AuraEnabled
    public static void updatecaserecord(ID Caserecorid ,  String check_status){
                                            Case case_record = new Case();   
                                            case_record = [Select id,AccountId,toLabel(Status),CaseNumber,Candidate_Personal_Code__c,SIPGE_Subject__c,Candidate_Full_Name__c,SiPGE_Assessment_Session__c,
                                                           Candidate_Session_Number__c,Current_school_awarded_Predicted_Grade__c,Student_proposed_Predicted_Grade__c,
                                                           school_agree_with_student__c,Basis_for_Enquiry__c,School_summary__c,Student_dispute__c from Case where id=:Caserecorid];
                                            case_record.Status = check_status;
                                            try{
                                            update case_record;
                                            }
                                            catch(Exception ex){
                                                System.debug('Error; '+ex);
                                            }
                                        }
    
    @AuraEnabled
    public static Id updateFile(ID idParent,Id fileid,Id caserecordid, String strFileName,String struploadFileName,ID documentid){
        System.debug('Javalog - '+fileid);

        PGQA_Sample__c c = new PGQA_Sample__c();
        c = [Select id,PGQA_Candidate_Session_Number__c,PGQA_Case__r.CaseNumber,PGQA_Name__c from PGQA_Sample__c where  id =:idParent order by CreatedDate DESC Limit 1];

      List<ContentVersion> cv = new List<ContentVersion>();
        List<ContentDocumentLink> cd = new List<ContentDocumentLink>();
        List<ContentDocumentLink> cd2 = new List<ContentDocumentLink>();
        if(fileid != null){
        cd = [select id,ContentDocumentId,shareType from ContentDocumentLink where ContentDocumentId  =:fileid];
              for(ContentDocumentLink cd_link:cd){
                  system.debug('javalog- cdlink: '+ cd_link.ShareType);
                  if(cd_link.shareType == 'V' )
                      cd2.add(cd_link);
              }
        delete cd2;
        }
         if(strFileName != 'Decalaration'){
            String extension = struploadFileName.substring(struploadFileName.lastIndexOf('.')+1);
            strFileName = strFileName +' - '+c.PGQA_Name__c+'-'+c.PGQA_Case__r.CaseNumber+'.'+ extension;
        }
        else{
            String extension = struploadFileName.substring(struploadFileName.lastIndexOf('.')+1);
            integer index = struploadFileName.indexOf('.');
            String subString= struploadFileName.substring(0 , index); 
            //strFileName= struploadFileName;
          //  strFileName = subString +' - '+c.CaseNumber+'.'+ extension;
        }
        system.debug('File 2: '+struploadFileName);
         ContentVersion contentv = [
            SELECT Id, VersionData,ContentDocumentId,ContentDocument.Title
            FROM ContentVersion
            WHERE ContentDocumentId = :documentid
        ];

         ContentVersion cv1 = new ContentVersion();
        cv1.Title =  strFileName;
        cv1.PathOnClient = '/' + strFileName;
        cv1.VersionData = contentv.VersionData;
        cv1.IsMajorVersion = false;
        if(!Test.isRunningTest())
        Insert cv1;
         ContentDocument contentdoc = [
            SELECT Id
            FROM ContentDocument
            WHERE id = :documentid
        ];
        delete contentdoc;
        ContentDocumentLink cdl = createContentLink(cv1.id, c.id);
        if(cdl != null)
        return cdl.ContentDocumentId;
        else
            return null;
    }
  
 @AuraEnabled
    public static void removefile(ID contentdocumentid){
       List<ContentVersion> cv = new List<ContentVersion>();
        List<ContentDocumentLink> cd = new List<ContentDocumentLink>();
        List<ContentDocumentLink> cd2 = new List<ContentDocumentLink>();
        if(contentdocumentid != null){
        cd = [select id,ContentDocumentId,shareType from ContentDocumentLink where ContentDocumentId  =:contentdocumentid];
              for(ContentDocumentLink cd_link:cd){
                  system.debug('javalog- cdlink: '+ cd_link.ShareType);
                  if(cd_link.shareType == 'V' )
                      cd2.add(cd_link);
              }
        delete cd2;
        }
    }    
     @AuraEnabled 
    public static Map<ID, String> getRelatedFilesByRecordId(ID caserecordid){
        List<ContentDocumentLink> files = [SELECT ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId = :caserecordid];
        List<ID> fileIDs = new List<ID>();
        for (ContentDocumentLink docLink : files) {
            fileIDs.add(docLink.ContentDocumentId);
        }
        System.debug('fileIDs: '+fileIDs.size());
        List<ContentVersion> docs = [SELECT ContentDocumentId, FileExtension, Title 
                                     FROM ContentVersion WHERE ContentDocumentId IN : fileIDs];
         System.debug('ContentVersion-docs: '+docs.size());
        Map<ID, String> mapIdTitle = new Map<ID, String>();
        for (ContentVersion docLink : docs) {
            mapIdTitle.put(docLink.ContentDocumentId, docLink.Title);
        }
        return mapIdTitle;
    }

@testvisible
    private static ContentDocumentLink createContentLink(String contentVersionId, String recordId) {
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
            WHERE Id =: contentVersionId
        ].Title;
cd.PreferencesNotifyOnVisit = false;
            insert cd;
            return cdl;
        } catch(DMLException e) {
            System.debug(e);
            return null;
        }
    }
    
     @AuraEnabled (cacheable = true)
    public static Case getcaserecord(ID caserecordid){
        Case caserec = new Case();
        caserec= [Select id,PGQA_Subject_Level_Language__r.English__c,PGQA_Subject_Level_Language__r.French__c,PGQA_Subject_Level_Language__r.Spanish__c,

                  IB_Feedback__c,toLabel(Final_decision__c),PGQA_Reason_for_cancellation__c,PGQA_Justification__c,toLabel(Status),SIPGE_Reason_for_cancellation__c,

                  CaseNumber,AccountId,Subject,Account.Name,Candidate_Session_Number__c,Candidate_Personal_Code__c,Candidate_Full_Name__c,
                  Current_school_awarded_Predicted_Grade__c,Student_proposed_Predicted_Grade__c,PGQA_Subject_Level_Language__r.Unavailable__c,
                  school_agree_with_student__c,School_summary__c,Student_dispute__c,SIPGE_Subject__c,Basis_for_Enquiry__c,School_Code__c,Account_Name__c,
                  PGQA_Assessment_Session__c
                  From Case
                  Where id=:caserecordid
                 ];
        
        return caserec;
    }
     @AuraEnabled (cacheable = true)

    public static PGQA__c getSiPGESubject(String record){
        try{
        PGQA__c ibsubject = new PGQA__c();
          ibsubject = [Select Name,English__c  from PGQA__c where (id =:record ) Limit 1];
            return ibsubject;}
          catch(Exception ex){
              return null;
          }
    }
    
    
    
     @AuraEnabled (cacheable = true)
    public static List <PGQA_Sample__c> getsamplerecord(ID caserecordid){
        System.debug('Record ID: '+caserecordid);
        List <PGQA_Sample__c> sampleList = new List<PGQA_Sample__c>();
        sampleList= [Select PGQA_Case__r.Status , PGQA_Case__r.CaseNumber,PGQA_Case__r.PGQA_Assessment_Session__c,PGQA_Candidate_Full_Name__c,
PGQA_Case__r.PGQA_Examiner_1_Start_Date__c,PGQA_Case__r.PGQA_Examiner_2_Start_Date__c,
PGQA_Case__r.SIPGE_Subject__c, PGQA_Case__r.Examiner_1_Decision__c,PGQA_Case__r.Examiner_2_Decision__c,
PGQA_Candidate_Session_Number__c,PGQA_Canidate_Predicted_Grade__c,CurrencyIsoCode,
Ex1_PGQA_Proposed_Predicted_Grade__c, Ex1_PGQA_Recommendation__c,Ex2_PGQA_Proposed_Predicted_Grade__c,

Ex2_PGQA_Recommendation__c, tolabel(PGQA_Name__c), Name, PGQA_Case__r.PGQA_Examiner_1__c,

PGQA_Case__r.PGQA_Examiner_1_Review_Status__c,PGQA_Case__r.PGQA_Examiner_2__c,PGQA_Case__r.PGQA_Examiner_2_Review_Status__c From PGQA_Sample__c
Where PGQA_Case__c= :caserecordid order by PGQA_Name__c ASC
                 ];
        
        return sampleList;
    }
    
    
     @AuraEnabled (cacheable=true)
    public static String getUserLocale() {
       return UserInfo.getLanguage();
   } 
}