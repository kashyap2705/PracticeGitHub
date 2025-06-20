/**
* <h1> PGEnquiryReviewerFeedbackController </h1>
* This class is created to test the functionality of PGEnquiryReviewerFeedback Page Controller
* 
* @author  Shehryar - Plumlogix
* @version 1.0
* @since   2021-06-07 

Modification Log     :                                                                              

*-------------------------------------------------------------------------------------------------- 

* Developer                   Date                   Description                     Version                          

* ------------------------------------------------------------------------------------------------- 
  Shehryar                    2021-06-07             Created the Controller            1.0

*/

public class PGEnquiryReviewerFeedbackController {
    
    public String PredictedString {get;set;}
    public Case CaseFB {get;set;}
    public String caseID = ApexPages.currentPage().getParameters().get('Id');
    public String ReviewerName {get;set;}
    public String SubjectName {get;set;}
    public String justify {get;set;}
    public boolean AgreeChk {get;set;}
    public String Decision_value {get;set;}

    public static string transcript_file_url{get; set;}
    public static string Evidence_1_file_url{get; set;}
    public static string Evidence_2_file_url{get; set;}
    public static string Evidence_3_file_url{get; set;}
    
    public PGEnquiryReviewerFeedbackController()
    {
        caseFb=CaseData();
        getRelatedFilesByRecordId(caseID);
    }
    public static String getuserLanguage() {
       return UserInfo.getLanguage();
   } 
    public List<SelectOption> getPredictedList(){
        List<SelectOption> options = new List<SelectOption>();
     Schema.DescribeFieldResult fieldResult = case.Student_proposed_Predicted_Grade__c.getDescribe();
           List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
                    options.add(new SelectOption('0', '0'));
           for(Schema.PicklistEntry p : ple)
           {
               
               options.add(new SelectOption(p.getValue(), p.getValue()));
           }
        return options;
    }
    
    public Case CaseData()
    {
        Case caserec=new case();
        caserec= [Select CaseNumber,Examiner_1__c,Examiner_2__c,Examiner_1_Predicted_Grade__c,Examiner_2_Predicted_Grade__c,toLabel(SiPGE_Assessment_Session__c),Subject,Case_Language__c,toLabel(Current_school_awarded_Predicted_Grade__c),toLabel(Student_proposed_Predicted_Grade__c),
                toLabel(school_agree_with_student__c),School_summary__c,Student_dispute__c,Examiner_1_Decision__c,Examiner_1_Justification_for_theDecision__c,
                  Examiner_1_Review_Status__c,Examiner_2_Decision__c,Examiner_2_Justification_for_theDecision__c,Examiner_2_Review_Status__c,SIPGE_Subject__c
                From Case
                Where id=:caseID
               ];
        
        if(caserec.Examiner_1__c!=null && caserec.Examiner_1_Review_Status__c=='In-Progress')
        {
            ReviewerName = [select name from contact where id=: caserec.Examiner_1__c limit 1].name;
        }
        else if(caserec.Examiner_2__c!=null && caserec.Examiner_1_Review_Status__c=='complete')
            {
            ReviewerName = [select name from contact where id=: caserec.Examiner_2__c limit 1].name;
        }
        if(caserec.SIPGE_Subject__c != '' || caserec.SIPGE_Subject__c != null){
        Subject__c subject_sipge = getSiPGESubject(caserec.SIPGE_Subject__c);
        if(getuserLanguage() == 'en_US' && subject_sipge != null){
            SubjectName = subject_sipge.English__c;
        }
        else if(getuserLanguage() == 'es'&& subject_sipge != null){
            SubjectName = subject_sipge.Spanish__c;
        }
        else if (getuserLanguage() == 'fr'&& subject_sipge != null){
            SubjectName = subject_sipge.French__c;
        }
        }
        return caserec;
    }
      public static Subject__c getSiPGESubject(String record){
          try{
        Subject__c ibsubject = new Subject__c();
          ibsubject = [Select Name,English__c,Spanish__c,French__c  from Subject__c where (id =:record or English__c = :record) Limit 1];
              return ibsubject;}
          catch(Exception ex){
              return null;
          }
    }
    public PageReference UpdateCase()
    {
        try{   

       Case update_case = new Case(id=casefb.id);

        system.debug('case examiner 12' + casefb.Examiner_1__c);
        system.debug('case examiner 12' + UserInfo.getUserId());
        if(casefb.Examiner_1__c!=null && casefb.Examiner_1_Review_Status__c=='In-Progress')
        {
            if(Decision_value=='upheld')
                {

                    update_case.Examiner_1_Decision__c='Enquiry upheld - predicted grade change';
                }
            else if (Decision_value=='rejected')
                {
                    update_case.Examiner_1_Decision__c='Enquiry rejected – predicted grade unchanged';
                }
            else if(Decision_value=='Flag')
                {
                    update_case.Examiner_1_Decision__c='Flag for Assessment escalation – predicted grade should be lower or higher';
                }
                     
            system.debug('justification11: ' + justify);
            update_case.Examiner_1_Justification_for_theDecision__c=justify;
            update_case.Examiner_1_Review_Status__c='Complete';
            if(PredictedString != '0')     
            update_case.Examiner_1_Predicted_Grade__c = PredictedString;

        }
        else if(casefb.Examiner_2__c!=null && casefb.Examiner_1_Review_Status__c=='complete')
        {
            if(Decision_value=='upheld')
                {

                    update_case.Examiner_2_Decision__c='Enquiry upheld - predicted grade change';
                }
            else if (Decision_value=='rejected')
                {
                    update_case.Examiner_2_Decision__c='Enquiry rejected – predicted grade unchanged';
                }
            else if(Decision_value=='Flag')
                {
                    update_case.Examiner_2_Decision__c='Flag for Assessment escalation – predicted grade should be lower or higher';
                }
            
            system.debug('justification11: ' + justify);
            update_case.Examiner_2_Justification_for_theDecision__c=justify;
            update_case.Examiner_2_Review_Status__c='Complete';
            if(PredictedString != '0')     
            update_case.Examiner_2_Predicted_Grade__c = PredictedString;
           system.debug('case examiner 123' + caseFb.Examiner_2_Decision__c);
        }
            if(update_case != null)
        update update_case;

        PageReference pageref = new PageReference('/educator/apex/dashboard');
                pageref.setRedirect(true);
                return pageref;
        }
        catch (Exception ex) {
            ApexPages.addMessages(ex);
            
    return null;
        }
    }
    public static void getRelatedFilesByRecordId(ID caserecordid){
        List<ContentDocumentLink> files = [SELECT ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId = :caserecordid];
        List<ID> fileIDs = new List<ID>();
        for (ContentDocumentLink docLink : files) {
            fileIDs.add(docLink.ContentDocumentId);
        }
         List<ContentVersion> docs = [SELECT ContentDocumentId, FileExtension, Title 
                                     FROM ContentVersion WHERE ContentDocumentId IN : fileIDs];
        System.debug('File ID: '+fileIDs.size());
        System.debug('File Docs: '+docs.size());
        Map<ID, String> mapIdTitle = new Map<ID, String>();
        for (ContentVersion docLink : docs) {
            string str = docLink.Title;
               if(str.contains('Transcript'))
               transcript_file_url = [SELECT DistributionPublicUrl FROM ContentDistribution where ContentVersionId = :docLink.id LIMIT 1].DistributionPublicUrl;
               if(str.contains('evidence 1'))
               Evidence_1_file_url = [SELECT DistributionPublicUrl FROM ContentDistribution where ContentVersionId = :docLink.id  LIMIT 1].DistributionPublicUrl;
               if(str.contains('evidence 2'))
               Evidence_2_file_url = [SELECT DistributionPublicUrl FROM ContentDistribution where ContentVersionId = :docLink.id  LIMIT 1].DistributionPublicUrl;
               if(str.contains('evidence 3'))
               Evidence_3_file_url = [SELECT DistributionPublicUrl FROM ContentDistribution where ContentVersionId = :docLink.id  LIMIT 1].DistributionPublicUrl;
           
        }
         System.debug('File ID: '+Evidence_3_file_url);
         System.debug('File ID: '+transcript_file_url);
    }
}