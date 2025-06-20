/*
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


public without sharing class Sample{


        public PGQA_Sample__c pgqasample{get;set;}
        public boolean Examiner_1_check{get;set;}
        public boolean Examiner_2_check{get;set;}
        public String transcript_file_url{get;set;}
        public String Evidence_1_file_url{get;set;}
    public String Evidence_2_file_url{get;set;}
    public String Evidence_3_file_url{get;set;}
    public String Additional_Evidence_files_url_1{get;set;}
    public String Additional_Evidence_files_url_2{get;set;}
    public String Additional_Evidence_files_url_3{get;set;}
        public List<SelectOption> getgrade() {
        List<SelectOption> options = new List<SelectOption>(); 


                  Schema.DescribeFieldResult fieldResult = PGQA_Sample__c.Ex1_PGQA_Recommendation__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        
        for( Schema.PicklistEntry f : ple){
            system.debug('labels = ' + f.getLabel() + ',' +  f.getValue() );
                options.add(new SelectOption( f.getValue(), f.getLabel() ));
        }


            return options; 
    }
       public List<SelectOption> getProposedGradeList(){
        List<SelectOption> options = new List<SelectOption>();
        Schema.DescribeFieldResult fieldResult = case.PGQA_Proposed_Predicted_Grade__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();

        options.add(new SelectOption('0', Label.IBENPortal_Global_None));

        for(Schema.PicklistEntry p : ple)
        {
            
            options.add(new SelectOption(p.getValue(), p.getValue()));
        }
        return options;
    }
        public Sample(PGQA_Sample__c Sample_record,boolean ex1,boolean ex2){
            pgqasample = Sample_record;
            Examiner_1_check = ex1;
            Examiner_2_check = ex2;
            getRelatedFilesByRecordId(pgqasample.id);
        }
        public void getRelatedFilesByRecordId(ID samplerecordid){
        List<ContentDocumentLink> files = [SELECT ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId = :samplerecordid];
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
               else if(str.contains('evidence 1'))
               Evidence_1_file_url = [SELECT DistributionPublicUrl FROM ContentDistribution where ContentVersionId = :docLink.id  LIMIT 1].DistributionPublicUrl;
               else if(str.contains('evidence 2'))
               Evidence_2_file_url = [SELECT DistributionPublicUrl FROM ContentDistribution where ContentVersionId = :docLink.id  LIMIT 1].DistributionPublicUrl;
               else if(str.contains('evidence 3'))
               Evidence_3_file_url = [SELECT DistributionPublicUrl FROM ContentDistribution where ContentVersionId = :docLink.id  LIMIT 1].DistributionPublicUrl;
               else if(str.contains('Additional Supporting Evidence 1'))
               Additional_Evidence_files_url_1 = [SELECT DistributionPublicUrl FROM ContentDistribution where ContentVersionId = :docLink.id  LIMIT 1].DistributionPublicUrl;             
               else if(str.contains('Additional Supporting Evidence 2'))
               Additional_Evidence_files_url_2 = [SELECT DistributionPublicUrl FROM ContentDistribution where ContentVersionId = :docLink.id  LIMIT 1].DistributionPublicUrl;            
               else if(str.contains('Additional Supporting Evidence 3'))
               Additional_Evidence_files_url_3 = [SELECT DistributionPublicUrl FROM ContentDistribution where ContentVersionId = :docLink.id  LIMIT 1].DistributionPublicUrl;
        }
         System.debug('Trascript File ID: '+transcript_file_url);
         System.debug('Evidence 1 File ID: '+Evidence_1_file_url);
         System.debug('Evidence 2 File ID: '+Evidence_2_file_url);
         System.debug('Evidence 3 File ID: '+Evidence_3_file_url);
         System.debug('Additional Evidence 1 File ID: '+Evidence_1_file_url);
         System.debug('Additional Evidence 2 File ID: '+Evidence_2_file_url);
         System.debug('Additional Evidence 3 File ID: '+Evidence_3_file_url);
    }
        public PGQA_Sample__c checkPreidictedgrade(PGQA_Sample__c sample_to_update){
            if(sample_to_update.Ex1_PGQA_Recommendation__c == 'Predicted Grade is correct')
                sample_to_update.Ex1_PGQA_Proposed_Predicted_Grade__c = '';
             if(sample_to_update.Ex2_PGQA_Recommendation__c == 'Predicted Grade is correct')
                sample_to_update.Ex2_PGQA_Proposed_Predicted_Grade__c = '';
            return sample_to_update;
        }
    
    }