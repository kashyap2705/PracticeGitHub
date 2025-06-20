/**
* <h1> PGQAReviewerFeedbackController </h1>
* This class is created to test the functionality of PGQAReviewerFeedback Page Controller
* 
* @author  Ammara/Arbaz - Plumlogix
* @version 1.0
* @since   2021-06-07 

Modification Log     :                                                                              

*-------------------------------------------------------------------------------------------------- 

* Developer                   Date                   Description                     Version                          

* ------------------------------------------------------------------------------------------------- 
  Ammara/Arbaz                    2021-10-06             Created the Controller            1.0

*/
public without sharing class PGQAReviewerFeedbackController {
    
    public List<PGQA_Sample__c> mySampleList;
    public Sample Sample1 { get; set; }
    public Sample Sample2 { get; set; }
    public Sample Sample3 { get; set; }
    public Sample Sample4 { get; set; }
    public Sample Sample5 { get; set; }
    public boolean check_examiner_1{ get; set; }
    public boolean check_examiner_2{ get; set; }
    public String caseID = ApexPages.currentPage().getParameters().get('Id');
    public String ReviewerName {get;set;}
    public String SubjectName {get;set;}
    public String SubjectName_SP {get;set;}
    public String SubjectName_FR {get;set;}
    public Case case_record {get;set;}    
    
    public void init()
    {
        mySampleList = new List<PGQA_Sample__c>();
        check_examiner_1 = false;
        check_examiner_2 = false;
        mySampleList = SampleData();
        Sample1 = null;
        Sample2 = null;
        Sample3 = null;
        Sample4 = null;
        Sample5 = null;
        integer i=0;
        for(PGQA_Sample__c casesample:mySampleList){
            Sample samplerecord = new Sample(casesample,check_examiner_1,check_examiner_2);
             if(i == 0)  Sample1 = samplerecord;
             else if(i == 1) Sample2 = samplerecord;
             else if(i == 2) Sample3 = samplerecord;
             else if(i == 3) Sample4 = samplerecord;
             else if(i == 4) Sample5 = samplerecord;
            i++;
        }
         System.debug('check_examiner_1: '+check_examiner_1);
        System.debug('check_examiner_2: '+check_examiner_2);
    } 
    public static String getuserLanguage() {
        return UserInfo.getLanguage();
    } 
    public List<PGQA_Sample__c> SampleData()
    {
        List<PGQA_Sample__c> mySampleList1 = new List<PGQA_Sample__c>();
        System.debug('caseID: '+caseID);
        mySampleList1 = [Select PGQA_Case__r.RecordType.Name, PGQA_Case__c, PGQA_Case__r.CaseNumber,PGQA_Case__r.PGQA_Assessment_Session__c,
                        PGQA_Case__r.PGQA_Examiner_1_Start_Date__c,PGQA_Case__r.PGQA_Examiner_2_Start_Date__c,PGQA_Case__r.Ex1_PGQA_Justifcation_for_Recommendation__c,   
                        PGQA_Case__r.SIPGE_Subject__c, PGQA_Case__r.Examiner_1_Decision__c,PGQA_Case__r.Examiner_2_Decision__c, 
                        PGQA_Candidate_Session_Number__c,PGQA_Canidate_Predicted_Grade__c,CurrencyIsoCode,PGQA_Case__r.Examiner_1_PGQA_Overall_Recommendation__c,
                        PGQA_Case__r.Examiner_2_PGQA_Overall_Recommendation__c, PGQA_Case__r.PGQA_Subject_Level_Language__c,
                        Ex1_PGQA_Proposed_Predicted_Grade__c, Ex1_PGQA_Recommendation__c,Ex2_PGQA_Proposed_Predicted_Grade__c,
                        Ex2_PGQA_Recommendation__c, toLabel(PGQA_Name__c),  Name, PGQA_Case__r.PGQA_Examiner_1__c,
                        PGQA_Case__r.PGQA_Examiner_1_Review_Status__c,PGQA_Case__r.PGQA_Examiner_2__c,PGQA_Case__r.PGQA_Examiner_2_Review_Status__c From PGQA_Sample__c
                        Where PGQA_Case__c= :caseID ORDER BY PGQA_Name__c
                       ];
        case_record = [Select id,PGQA_Assessment_Session__c,CaseNumber,PGQA_Examiner_1__c,PGQA_Examiner_1__r.Name,PGQA_Examiner_2__c,
                       Examiner_1_PGQA_Overall_Recommendation__c,PGQA_Justification__c,Ex1_PGQA_Justifcation_for_Recommendation__c,Examiner_2_PGQA_Overall_Recommendation__c,
                       Ex2_PGQA_Justifcation_for_Recommendation__c,PGQA_Examiner_2__r.Name,PGQA_Examiner_1_Review_Status__c,PGQA_Subject_Level_Language__c,
                       PGQA_Subject_Level_Language__r.Name,PGQA_Subject_Level_Language__r.Spanish__c,PGQA_Subject_Level_Language__r.French__c from case where id = :mySampleList1[0].PGQA_Case__c ];
        System.debug('List Size: '+mySampleList1.size());
        System.debug('case_record: '+case_record);
        
        if(case_record.PGQA_Examiner_1__c !=null && case_record.PGQA_Examiner_1_Review_Status__c =='In-Progress')
        {
            ReviewerName = case_record.PGQA_Examiner_1__r.Name;
            check_examiner_1 = true;
        }
        else if(case_record.PGQA_Examiner_2__c !=null && case_record.PGQA_Examiner_1_Review_Status__c =='complete')
        {
            ReviewerName = case_record.PGQA_Examiner_2__r.Name;
            check_examiner_2 = true;
        }
        if( case_record.PGQA_Subject_Level_Language__c != null){
            
            SubjectName = case_record.PGQA_Subject_Level_Language__r.Name;
            SubjectName_SP = case_record.PGQA_Subject_Level_Language__r.Spanish__c;
            SubjectName_FR = case_record.PGQA_Subject_Level_Language__r.French__c;
            System.debug('Subject_PGQA : ' + SubjectName);
        }
        return mySampleList1;  
    }
        public List<SelectOption> getoverall() {
        List<SelectOption> options = new List<SelectOption>(); 
                    Schema.DescribeFieldResult fieldResult = Case.Examiner_1_PGQA_Overall_Recommendation__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        
        for( Schema.PicklistEntry f : ple){
            system.debug('labels = ' + f.getLabel() + ',' +  f.getValue() );
                options.add(new SelectOption( f.getValue(), f.getLabel() ));
    }
            return options; 
        }
    public PageReference UpdateSample()
    {
        try{
            List<PGQA_Sample__c> sample_list = new List<PGQA_Sample__c>();
            sample_list.add(Sample1.checkPreidictedgrade(Sample1.pgqasample));
        if(Sample2 != null) sample_list.add(Sample2.checkPreidictedgrade(Sample2.pgqasample));
        if(Sample3 != null) sample_list.add(Sample3.checkPreidictedgrade(Sample3.pgqasample));
        if(Sample4 != null) sample_list.add(Sample4.checkPreidictedgrade(Sample4.pgqasample));
        if(Sample5 != null) sample_list.add(Sample5.checkPreidictedgrade(Sample5.pgqasample));
            if(check_examiner_1)
            case_record.PGQA_Examiner_1_Review_Status__c = 'Complete';
            else if(check_examiner_2)
             case_record.PGQA_Examiner_2_Review_Status__c = 'Complete';
            boolean error = false;
            for(PGQA_Sample__c sample : sample_list){
                system.debug('Rec: '+sample.Ex1_PGQA_Recommendation__c);
                system.debug('Ex1_PGQA_Proposed_Predicted_Grade__c: '+sample.Ex1_PGQA_Proposed_Predicted_Grade__c);
                system.debug('error: '+error);
                if((check_examiner_1 && sample.Ex1_PGQA_Recommendation__c == '') ||
                   (check_examiner_1 && 
                   (sample.Ex1_PGQA_Recommendation__c == 'Predicted Grade should be lower' || sample.Ex1_PGQA_Recommendation__c == 'Predicted Grade should be higher') 
                   && sample.Ex1_PGQA_Proposed_Predicted_Grade__c == '0'))               
                   error = true;
                   else if((check_examiner_2 && sample.Ex2_PGQA_Recommendation__c == '' ) ||
                   (check_examiner_2 && 
                   (sample.Ex2_PGQA_Recommendation__c == 'Predicted Grade should be lower' || sample.Ex2_PGQA_Recommendation__c == 'Predicted Grade should be higher') 
                   && sample.Ex2_PGQA_Proposed_Predicted_Grade__c == '0'))
                    error = true;
            }
            if (check_examiner_1 && (case_record.Examiner_1_PGQA_Overall_Recommendation__c == NULL || case_record.Examiner_1_PGQA_Overall_Recommendation__c == '' ||
               case_record.Ex1_PGQA_Justifcation_for_Recommendation__c ==NULL || case_record.Ex1_PGQA_Justifcation_for_Recommendation__c == ''))
                 error = true;
           else if(check_examiner_2 && (case_record.Examiner_2_PGQA_Overall_Recommendation__c == NULL || case_record.Examiner_2_PGQA_Overall_Recommendation__c == '' ||
               case_record.Ex2_PGQA_Justifcation_for_Recommendation__c ==NULL ||  case_record.Ex2_PGQA_Justifcation_for_Recommendation__c == ''))
                   error = true;
            if(error){
                 ApexPages.Message msg = new ApexPages.Message(ApexPages.severity.ERROR, system.label.My_institute_complete_all_required_fields);
                ApexPages.addMessage(msg);
                return null;
            }
                
            else{
        update sample_list;
        update case_record;
          PageReference pageref = new PageReference('/educator/apex/dashboard');
                pageref.setRedirect(true);
                return pageref;
            }
           }
        
        catch (Exception ex) {
            System.debug('Exception '+ex);
            ApexPages.addMessages(ex);
        }
     return null;
    }
 
}