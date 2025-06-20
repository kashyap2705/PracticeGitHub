/**     
* <h1>SIPGERequestCase</h1>     
* This class is responsible for the functions from Request Form(Support Community) to Salesforce.
* 
* @author  Ammara Alvi  
* @version 1.0      
* @since   06/10/2021

Modification Log     :                                                                              

*------------------------------------------------------------------------------------------------------------------------------- 

* Developer                   Date                   Description                                                  Version                          

* ------------------------------------------------------------------------------------------------------------------------------ 
Ammara                     06-10-2021                Created                                                       1.0
Ammara                     08-11-2021                Update getcutoffdate and Add getsessionname                   2.0

*/
public without sharing class SIPGERequestCase {

    public static User user = [select contact.AccountId, contactid, LanguageLocaleKey, Name, Email from user where id =: userInfo.getUserId()];
    public static ID Recordtype_id = Schema.SObjectType.Case.getRecordTypeInfosByName().get('SIPGE Request').getRecordTypeId();

    //SOQL changed and formatted by Prerna Sobti for ECM00546 on 14/11/2022 --
    public static List<Cut_of_Date__c> session_cut_off = [SELECT Id, Name, Session_Open_Date__c, Session_Close_Date__c
        FROM Cut_of_Date__c
        WHERE Type__c = 'sipge'
        AND Session_Open_Date__c != null
        AND Session_Close_Date__c != null
        ORDER BY Name
    ];

    public static String case_Status;
    // public static String existingBody;  
    /** 
     * @author Ammara Alvi
     * @date 06/10/2021
     * @description saveFile that is uploaded from Support Community.
     * @returntype void
     * @param ID idParent, String strFileName, String struploadFileName, ID documentid
     */
    @AuraEnabled
    public static void saveFile(Id idParent, String strFileName, String struploadFileName, ID documentid) {
        system.debug('File: ' + documentid);
        system.debug('File: ' + struploadFileName);
        Case c = new Case();
        c = [Select id, CaseNumber from Case where RecordType.name IN('SIPGE Request') AND ContactId =: user.ContactId order by CreatedDate DESC Limit 1];
        system.debug('Javalog -- idParent## ' + idParent + 'strFileName' + strFileName);
        if (strFileName != 'Decalaration') {
            String extension = struploadFileName.substring(struploadFileName.lastIndexOf('.') + 1);
            strFileName = strFileName + ' - ' + c.CaseNumber + '.' + extension;
        } else {
            String extension = struploadFileName.substring(struploadFileName.lastIndexOf('.') + 1);
            integer index = struploadFileName.indexOf('.');
            String subString = struploadFileName.substring(0, index);
            //strFileName= struploadFileName;
            strFileName = subString + ' - ' + c.CaseNumber + '.' + extension;
        }
        system.debug('File 2: ' + struploadFileName);
        ContentVersion contentv = [
            SELECT Id, VersionData, ContentDocumentId, ContentDocument.Title
            FROM ContentVersion
            WHERE ContentDocumentId =: documentid
        ];

        ContentVersion cv = new ContentVersion();
        cv.Title = strFileName;
        cv.PathOnClient = '/' + strFileName;
        cv.VersionData = contentv.VersionData;
        cv.IsMajorVersion = false;
        if (!Test.isRunningTest())
            Insert cv;
        ContentDocument contentdoc = [
            SELECT Id
            FROM ContentDocument
            WHERE id =: documentid
        ];
        delete contentdoc;
        ContentDocumentLink cdl = createContentLink(cv.id, c.id);
    }
    /** 
     * @author Ammara Alvi
     * @date 06/10/2021
     * @description updateFile that is uploaded from Support Community.
     * @returntype void
     * @param ID idParent,Id fileid,String strFileName, String struploadFileName, ID documentid
     */
    @AuraEnabled
    public static void updateFile(ID idParent, Id fileid, Id caserecordid, String strFileName, String struploadFileName, ID documentid) {
        System.debug('Javalog - ' + fileid);
        Case c = new Case();
        c = [Select id, CaseNumber from Case where id =: caserecordid Limit 1];


        List<ContentVersion> cv = new List<ContentVersion>();
        List<ContentDocumentLink> cd = new List<ContentDocumentLink>();
        List<ContentDocumentLink> cd2 = new List<ContentDocumentLink>();
        if (fileid != null) {
            cd = [select id, ContentDocumentId, shareType from ContentDocumentLink where ContentDocumentId =: fileid];
            for (ContentDocumentLink cd_link: cd) {
                if (cd_link.shareType == 'V')
                    cd2.add(cd_link);
            }
            delete cd2;
        }
        if (strFileName != 'Decalaration') {
            String extension = struploadFileName.substring(struploadFileName.lastIndexOf('.') + 1);
            strFileName = strFileName + ' - ' + c.CaseNumber + '.' + extension;
        } else {
            String extension = struploadFileName.substring(struploadFileName.lastIndexOf('.') + 1);
            integer index = struploadFileName.indexOf('.');
            String subString = struploadFileName.substring(0, index);
            //strFileName= struploadFileName;
            strFileName = subString + ' - ' + c.CaseNumber + '.' + extension;
        }
        system.debug('File 2: ' + struploadFileName);
        ContentVersion contentv = [
            SELECT Id, VersionData, ContentDocumentId, ContentDocument.Title
            FROM ContentVersion
            WHERE ContentDocumentId =: documentid
        ];

        ContentVersion cv1 = new ContentVersion();
        cv1.Title = strFileName;
        cv1.PathOnClient = '/' + strFileName;
        cv1.VersionData = contentv.VersionData;
        cv1.IsMajorVersion = false;
        if (!Test.isRunningTest())
            Insert cv1;
        ContentDocument contentdoc = [
            SELECT Id
            FROM ContentDocument
            WHERE id =: documentid
        ];
        delete contentdoc;
        ContentDocumentLink cdl = createContentLink(cv1.id, c.id);
    }
    /** 
     * @author Ammara Alvi
     * @date 06/10/2021
     * @description gettermethod for Recordtype_id.
     * @returntype String
     * @param N/A
     */
    @AuraEnabled(cacheable = true)
    public static String getrecordtypeid() {
        return Recordtype_id;
    }

    @AuraEnabled(cacheable = true)

    public static Subject__c getSiPGESubject(String record) {
        try {
            Subject__c ibsubject = new Subject__c();
            ibsubject = [Select Name, English__c, Spanish__c, French__c from Subject__c where(id =: record or English__c =: record) Limit 1];
            return ibsubject;
        } catch (Exception ex) {
            return null;
        }
    }
    /** 
     * @author Ammara Alvi
     * @date 06/10/2021
     * @description creating a link between the file added in salesforce and Case Record.
     * @returntype ContentDocumentLink
     * @param String contentVersionId, String recordId
     */
    @testvisible
    private static ContentDocumentLink createContentLink(String contentVersionId, String recordId) {
        if (contentVersionId == null || recordId == null) {
            return null;
        }
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
        } catch (DMLException e) {
            System.debug(e);
            return null;
        }
    }
    /** 
     * @author Ammara Alvi
     * @date 06/10/2021
     * @description get the Accounts for which current user have confirmed HOS,PC and HOS(Overall)
     * @returntype List<Account>
     * @param N/A
     */
    @AuraEnabled(cacheable = true)
    public static List<Account> getconfirmedAccount() {
        System.debug('Javalog Confirmed Account');
        set<ID> acc_id = new Set<ID>();
        list<IB_Role__c> role = new list<IB_Role__c>();
        role = [select id, IB_Role_Name__c, IB_Account__r.id from IB_Role__c where IB_Contact__r.id =: user.contactId and Status__c = 'Confirmed'
            And IB_Role_Name__c IN('Head of School', 'Head of School (Overall)', 'Programme Coordinator')
        ];
        for (IB_Role__c accountid: role) {
            acc_id.add(accountid.IB_Account__r.id);
        }
        System.debug('Javalog Account ID Set Size: ' + acc_id.size());
        List<Account> ac = new List<Account>();
        ac = [select id, Name, IBIS_ID__c from Account where id IN: acc_id AND SIPGE_Registration__c = true];
        System.debug('Javalog Account List Size: ' + ac.size());
        return ac;
    }
    /** 
     * @author Ammara Alvi
     * @date 06/10/2021
     * @description Get Cases
     * @returntype List<Case>
     * @param N/A
     */

    @AuraEnabled(cacheable = true)
    public static List<Case> getCases() {
        List<Case> case_list = new List<Case>();
        //Below SOQL modified by Prerna on 16-07-2024 For Bug 219019
        case_list = [Select id, CaseNumber, SIPGE_Reason_for_cancellation__c, toLabel(Status), Subject from Case where RecordType.name IN('SIPGE Request') AND ContactId =: user.ContactId AND Status IN('Draft', 'Under Review', 'Submitted', 'Complete', 'Cancellation Requested', 'Need More Information')];
        return case_list;
    }
    /** 
     * @author Ammara Alvi
     * @date 06/10/2021
     * @description Get Cut off date
     * @returntype string
     * @param N/A
     */
    @AuraEnabled(cacheable = true)
    public static String getcutoffdate() {
        //Commented the below 2 lines - as we have to check the correct session based on Month difference.
        /*
        Date cut_off = session_cut_off.Session_Close_Date__c;
        String dateStr = String.valueOf(cut_off);
        */

        //Code written by Prerna Sobti for ECM00546 on 14/11/2022 -- START --
        String whichSession = getCutoffSessionName();
        System.debug('whichSession'+whichSession);
        return whichSession;
        //Code written by Prerna Sobti for ECM00546 on 14/11/2022 -- END --
    }
    /** 
     * @author Ammara Alvi
     * @date 08/11/2021
     * @description Get Session Name
     * @returntype string
     * @param N/A
     */
    @AuraEnabled(cacheable = true)
    public static String getsessionname() {
        //Commented the below line By Prerna - as we have to firstly get the valid session
        //  return session_cut_off.Name;

        //Code written by Prerna Sobti for ECM00546 on 14/11/2022 -- START --
        List<Cut_of_Date__c> lstValid = getValidSession();
        String sessionName = !lstValid.isEmpty() ? lstValid[0].Name : null;
        return sessionName;
        //Code written by Prerna Sobti for ECM00546 on 14/11/2022 -- END --
    }

    //Method written by Prerna Sobti for ECM00546 on 14/11/2022 -- START --
    //This method will return the valid ongoing session based on Session_Open_Date__c and Session_Close_Date__c
    public static List<Cut_of_Date__c> getValidSession() {
        List<Cut_of_Date__c> lstValidSession = new List<Cut_of_Date__c>();
        if (session_cut_off != null && !session_cut_off.isEmpty()) {
            for (Cut_of_Date__c cof: session_cut_off) {
                if (System.today() >= cof.Session_Open_Date__c &&
                    System.today() <= cof.Session_Close_Date__c) {
                    lstValidSession.add(cof);
                    break;
                }
            }
        }

        return lstValidSession;
    }
    //Method written by Prerna Sobti for ECM00546 on 14/11/2022 -- END --

    //Method written by Prerna Sobti for ECM00546 on 14/11/2022 -- START --
    // This method will populate the map of session name and their Months difference between today's date and session close date. 
    // Map will be populated if there is no ongoing/Valid session.
    public static String getCutoffSessionName() {
        List<Cut_of_Date__c> lstCODValid = getValidSession();
        String cutoffSpilledSession;
        Map<String,Date> mapSessionClosestDate = new Map<String,Date>();
        Date todayDate = System.Today();
        Integer may,nov;
        if (lstCODValid.isEmpty()) {
            for (Cut_of_Date__c cof: session_cut_off) {
                mapSessionClosestDate.put(cof.Name,cof.Session_Close_Date__c);
            }
            if(!mapSessionClosestDate.isEmpty()){
                //Both Past Close Dates
                if(mapSessionClosestDate.get('Cut of date May session') < todayDate && mapSessionClosestDate.get('Cut of date Nov session') < todayDate){
                    may = returnMonthDifference (todayDate,mapSessionClosestDate.get('Cut of date May session'));
                    nov = returnMonthDifference (todayDate,mapSessionClosestDate.get('Cut of date Nov session'));
                    cutoffSpilledSession = may < nov ? 'Cut of date May session' : 'Cut of date Nov session';
                }else if(mapSessionClosestDate.get('Cut of date May session') > todayDate && mapSessionClosestDate.get('Cut of date Nov session') > todayDate){
                    // Both Future Close Dates
                    cutoffSpilledSession = mapSessionClosestDate.get('Cut of date May session') > mapSessionClosestDate.get('Cut of date Nov session') ?'Cut of date May session':'Cut of date Nov session';
                }else if(mapSessionClosestDate.get('Cut of date May session') > todayDate && mapSessionClosestDate.get('Cut of date Nov session') < todayDate)  {
                    // May Future, Nov Past
                        cutoffSpilledSession ='Cut of date Nov session';
                }else if(mapSessionClosestDate.get('Cut of date May session') < todayDate && mapSessionClosestDate.get('Cut of date Nov session') > todayDate){
                    // Nov Future, May Past
                        cutoffSpilledSession ='Cut of date May session';
                }
            } 
        }
        return cutoffSpilledSession;
    }
    //Method written by Prerna Sobti for ECM00546 on 14/11/2022 -- END --

    public static Integer returnMonthDifference(Date firstDate, Date secondDate){
        Integer postiveDifference = firstDate.monthsBetween(secondDate) < 0 ? firstDate.monthsBetween(secondDate) * -1 : firstDate.monthsBetween(secondDate);
        return postiveDifference;
    }

    /** 
     * @author Ammara Alvi
     * @date 06/10/2021
     * @description Update Cancellation Request
     * @returntype Case
     * @param ID , String
     */
    @AuraEnabled
    public static void update_request_for_cancellation(ID recordid, String cancellation_Reason) {
        Case c = new Case(id = recordid);
        c.SIPGE_Reason_for_cancellation__c = cancellation_Reason;
        c.Status = 'Cancellation Requested';
        update c;
    }
    /** 
     * @author Ammara Alvi
     * @date 06/10/2021
     * @description Get Case record
     * @returntype Case
     * @param ID caserecordid
     */
    @AuraEnabled(cacheable = true)
    public static Case getcaserecord(ID caserecordid) {
        Case caserec = new Case();
        caserec = [Select id, IB_Feedback__c, Status, SIPGE_Reason_for_cancellation__c, CaseNumber, AccountId, Subject, Account.Name, Candidate_Session_Number__c, Candidate_Personal_Code__c, Candidate_Full_Name__c, Current_school_awarded_Predicted_Grade__c, Student_proposed_Predicted_Grade__c,
            school_agree_with_student__c, School_summary__c, Student_dispute__c, SIPGE_Subject__c, Basis_for_Enquiry__c, School_Code__c, Account_Name__c, SiPGE_Assessment_Session__c
            From Case
            Where id =: caserecordid
        ];
        return caserec;
    }
    /** 
     * @author Ammara Alvi
     * @date 06/10/2021
     * @description Get related case files
     * @returntype Map<ID, String>
     * @param ID caserecordid
     */
    @AuraEnabled(cacheable = true)
    public static Map<ID,String> getRelatedFilesByRecordId(ID caserecordid) {
        List<ContentDocumentLink> files = [SELECT ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId =: caserecordid];
        List<ID> fileIDs = new List<ID>();
        for (ContentDocumentLink docLink: files) {
            fileIDs.add(docLink.ContentDocumentId);
        }

        List<ContentVersion> docs = [SELECT ContentDocumentId, FileExtension, Title
            FROM ContentVersion WHERE ContentDocumentId IN: fileIDs
        ];
        Map<ID,String> mapIdTitle = new Map<ID,String>();
        for (ContentVersion docLink: docs) {
            mapIdTitle.put(docLink.ContentDocumentId, docLink.Title);
        }
        return mapIdTitle;
    }
    /** 
     * @author Ammara Alvi
     * @date 06/10/2021
     * @description Deleye the Case of SIPGE Request record type
     * @returntype void
     * @param N/A
     */
    @AuraEnabled
    public static void deletecase(list<Id> lstConIds) {
        try {
            list<Case> lstConsToDelete = new list<Case>();
            System.debug('lstConIds ====>' + lstConIds);
            for (Id idCon: lstConIds) {
                lstConsToDelete.add(new Case(Id = idCon));
            }
            if (!lstConsToDelete.isEmpty()) {
                delete lstConsToDelete;
            }
        } catch (Exception ex) {
            throw new AuraHandledException(ex.getMessage());
        }
    }
    /** 
     * @author Ammara Alvi
     * @date 06/10/2021
     * @description Update the Case of SIPGE Request record type
     * @returntype void
     * @param ID Accountid, String ibiscode, String CandidatePersonalCode, String CandidateSessionNumber,String Candidatefullname, String AssessmentSession, 
     *        String Currentschoolgrade, String studentpredictedgrade, String Schoolagreewithstudent,String BasisforEnquiry, String Schooldispute,String Schoolsummary,ID selectedSubject, String check_status
     */
    @AuraEnabled
    public static void updatecaserecord(ID Caserecorid, ID Accountid, String ibiscode, String CandidatePersonalCode, String CandidateSessionNumber,
        String Candidatefullname, String AssessmentSession, String Currentschoolgrade, String studentpredictedgrade,
        String Schoolagreewithstudent, String BasisforEnquiry, String Schooldispute, String Schoolsummary, String selectedSubject, String check_status) {
        Case case_record = new Case();
        case_record = [Select id, AccountId, Status, CaseNumber, Candidate_Personal_Code__c, SIPGE_Subject__c, Candidate_Full_Name__c, SiPGE_Assessment_Session__c,
            Candidate_Session_Number__c, Current_school_awarded_Predicted_Grade__c, Student_proposed_Predicted_Grade__c,
            school_agree_with_student__c, Basis_for_Enquiry__c, School_summary__c, Student_dispute__c from Case where id =: Caserecorid
        ];
        case_record.AccountId = Accountid;
        case_record.Candidate_Personal_Code__c = CandidatePersonalCode;
        case_record.SIPGE_Subject__c = selectedSubject;
        case_record.Candidate_Full_Name__c = Candidatefullname;
        case_record.SiPGE_Assessment_Session__c = AssessmentSession;
        case_record.Candidate_Session_Number__c = CandidateSessionNumber;
        case_record.Current_school_awarded_Predicted_Grade__c = Currentschoolgrade;
        case_record.Student_proposed_Predicted_Grade__c = studentpredictedgrade;
        case_record.school_agree_with_student__c = Schoolagreewithstudent;
        case_record.Basis_for_Enquiry__c = BasisforEnquiry;
        case_record.School_summary__c = Schoolsummary;
        case_record.Student_dispute__c = Schooldispute;
        if ((case_record.Status == 'Need More Information' && check_status == 'Submitted') || case_record.Status == 'Draft')
            case_record.Status = check_status;
        case_record.Subject = 'SIPGE – ' + case_record.SiPGE_Assessment_Session__c + ' - ' + case_record.CaseNumber + ' – ' + case_record.SIPGE_Subject__c;
        try {
            update case_record;
        } catch (Exception ex) {
            System.debug('Error; ' + ex);
        }
    }
    /** 
     * @author Ammara Alvi
     * @date 06/10/2021
     * @description Adding the Case of SIPGE Request record type
     * @returntype void
     * @param ID Accountid, String ibiscode, String CandidatePersonalCode, String CandidateSessionNumber,String Candidatefullname, String AssessmentSession, 
     *        String Currentschoolgrade, String studentpredictedgrade, String Schoolagreewithstudent,String BasisforEnquiry, String Schooldispute,String Schoolsummary,ID selectedSubject, String check_status
     */
    @AuraEnabled
    public static void addcaserecord(ID Accountid, String ibiscode, String CandidatePersonalCode, String CandidateSessionNumber, String Candidatefullname, String AssessmentSession, String Currentschoolgrade, String studentpredictedgrade, String Schoolagreewithstudent, String BasisforEnquiry, String Schooldispute, String Schoolsummary, String selectedSubject, string check_save) {
        Case case_record = new Case();
        if (Accountid != null)
            case_record.AccountId = Accountid;
        case_record.Candidate_Personal_Code__c = CandidatePersonalCode;
        case_record.ContactId = user.contactid;
        case_record.SIPGE_Subject__c = selectedSubject;
        case_record.Candidate_Full_Name__c = Candidatefullname;
        case_record.SiPGE_Assessment_Session__c = AssessmentSession;
        case_record.Candidate_Session_Number__c = CandidateSessionNumber;
        case_record.Current_school_awarded_Predicted_Grade__c = Currentschoolgrade;
        case_record.Student_proposed_Predicted_Grade__c = studentpredictedgrade;
        case_record.school_agree_with_student__c = Schoolagreewithstudent;
        case_record.Basis_for_Enquiry__c = BasisforEnquiry;
        case_record.School_summary__c = Schoolsummary;
        case_record.Student_dispute__c = Schooldispute;
        case_record.RecordTypeId = Recordtype_id;
        case_record.Origin = 'Web';
        case_record.Status = check_save;
        insert case_record;
        case_Status = check_save;
        Case caserecord = new Case();
        caserecord = [Select id, CaseNumber, SIPGE_Subject__c, SiPGE_Assessment_Session__c from Case where RecordType.name IN('SIPGE Request') AND ContactId =: user.ContactId AND Status =: check_save order by CreatedDate DESC Limit 1];
        caserecord.Subject = 'SIPGE – ' + caserecord.SiPGE_Assessment_Session__c + ' - ' + caserecord.CaseNumber + ' – ' + caserecord.SIPGE_Subject__c;
        update caserecord;
    }
    /** 
     * @author Ammara Alvi
     * @date 06/10/2021
     * @description getting user language
     * @returntype String
     * @param N/A
     */
    @AuraEnabled(cacheable = true)
    public static String getUserLocale() {
        return UserInfo.getLanguage();
    }
}