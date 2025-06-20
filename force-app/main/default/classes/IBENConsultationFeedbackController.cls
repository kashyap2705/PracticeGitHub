public without sharing class IBENConsultationFeedbackController {

//controller
    //Using static constants for a tighter reference
    public static final String SECTION_INSTRUCTIONS = 'inst';
    public static final String SECTION_REVIEW = 'rev';
    public static final String SECTION_A = 'a';
    public static final String SECTION_B1 = 'b1';
    public static final String SECTION_B2 = 'b2';
    public static final String SECTION_C1 = 'c1';
    public static final String SECTION_C2 = 'c2';
    public static final String SECTION_C3 = 'c3';
    public static final String SECTION_C4 = 'c4';
    public static final String SECTION_ADVICE = 'adv';

    public static final RecordType endOfProcRecType = [select Id from RecordType where sObjectType = 'IB_Consultant_Feedback__c' AND DeveloperName = 'End_of_Process' ];
    public static final RecordType visitRecType = [select Id from RecordType where sObjectType = 'IB_Consultant_Feedback__c' AND DeveloperName = 'Initial_Visit'  ];

    public transient IB_Application__c application {get;set;}
    public IB_Consultant_Feedback__c visitFeedback {get;set;}
    public IB_Consultant_Feedback__c endOfProcFeedback {get;set;}
    public String activeSection {get;set;}
    public PageReference activeContent {get;set;}
    public String readerFeedbackId {get;set;}
    public Boolean isEndOfProcess {get;set;}
    public String assignmentId {get;set;}
    public String website {get;set;}
    
    //chatter functionality
    public Boolean hasChatterEnabled {get; set; }
    public ID eventID {get; set; }

    public IBENConsultationFeedbackController() {

        System.debug(LoggingLevel.ERROR, 'Entering Feedback Constructor');

        isEndOfProcess = false;

        application = ApplicationDAO.getInstance().getApplicationById(ApexPages.currentPage().getParameters().get('id'));

        for(IB_Consultant_Feedback__c tmp : ConsultantFeedbackDAO.getInstance().getRecordsByAppId(application.Id)){

            // May need to do a status check for one-off scenarios

            if(tmp.RecordTypeId == visitRecType.Id){
                visitFeedback = tmp;
                website = visitFeedback.IB_Programme_Lookup__r.Account__r.Website;
            }
            else if(tmp.RecordTypeId == endOfProcRecType.Id){
                endOfProcFeedback = tmp;
                website = endOfProcFeedback.IB_Programme_Lookup__r.Account__r.Website;
                isEndOfProcess = true;
            }
        }

        try {
            if(website.substring(0, 4) != 'http'){
                website = 'http://' + website;
            }
        }
        catch (Exception ex) {
            website = '';
        }

        //Should only be one but in case of multiple, it will get the last one.
        if(!isEndOfProcess){
            for(IB_Application_Feedback__c tmp : [select Id from IB_Application_Feedback__c where Status__c = 'Submitted' AND FB_Lookup_IB_Application__c =: visitFeedback.IB_Application__c order by createdDate ASC]){
                readerFeedbackId = tmp.Id;
            }
        } else{
            for(IB_Application_Feedback__c tmp : [select Id from IB_Application_Feedback__c where Status__c = 'Submitted' AND FB_Lookup_IB_Application__c =: endOfProcFeedback.IB_Application__c order by createdDate ASC]){
                readerFeedbackId = tmp.Id;
            }
        }

        activeSection = ApexPages.currentPage().getParameters().get('sec');
        system.debug('Active Session 1 '+activeSection );
        //Default section to Profile Review
        if(!sectionMap.containsKey(activeSection)){
            activeSection = SECTION_INSTRUCTIONS;
        }

        activeContent = sectionMap.get(activeSection);
        
        /* @jira RA-44 Chatter functionality
         * getting id of ib programme from ib application object.
         *  getting ib event from ib program.
         *  setting eventID variable which is using in VF for creating url linked to Button. 
         *  setting button visible on VF.
*/         
        hasChatterEnabled = false;        
        try {
            List<IB_Application__c> ibApp = [Select id, name , Application_Lookup_to_Programme__c from IB_Application__c where id =: application.id AND Application_Lookup_to_Programme__r.status__c = 'Candidate'];
            if(ibApp.size() > 0) {
                //IB_Application__c ap = ibApp[0];
                List<Campaign> camp = [Select name from campaign where Related_IB_Programme__c =: ibApp[0].Application_Lookup_to_Programme__c AND status ='Staffed' AND Sub_Type__c ='Candidacy Consultation' Limit 1];
                eventID = camp[0].id;
                hasChatterEnabled = true;
            }   
        } catch(Exception e) { //catching exception of index out of bound when no event will found
            
        }

        System.debug(LoggingLevel.ERROR, 'Leaving Feedback Constructor');
    }

    //Pulls in the page that wraps the section component. This reduces viewstate.
    public static final Map<String, PageReference> sectionMap = new Map<String, PageReference>{
        SECTION_INSTRUCTIONS => Page.ICF_Section_Instructions,
        SECTION_REVIEW => Page.ICF_Section_Review,
        SECTION_A => Page.ICF_Section_A,
        SECTION_B1 => Page.ICF_Section_B1,
        SECTION_B2 => Page.ICF_Section_B2,
        SECTION_C1 => Page.ICF_Section_C1,
        SECTION_C2 => Page.ICF_Section_C2,
        SECTION_C3 => Page.ICF_Section_C3,
        SECTION_C4 => Page.ICF_Section_C4,
        SECTION_ADVICE => Page.ICF_Section_Advice 
    };

    public static String getSECTION_INSTRUCTIONS(){
        return SECTION_INSTRUCTIONS;
    }
    public static String getSECTION_REVIEW(){
        return SECTION_REVIEW;
    }
    public static String getSECTION_A(){
        return SECTION_A;
    }
    public static String getSECTION_B1(){
        return SECTION_B1;
    }
    public static String getSECTION_B2(){
        return SECTION_B2;
    }
    public static String getSECTION_C1(){
        return SECTION_C1;
    }
    public static String getSECTION_C2(){
        return SECTION_C2;
    }
    public static String getSECTION_C3(){
        return SECTION_C3;
    }
    public static String getSECTION_C4(){
        return SECTION_C4;
    }
    public static String getSECTION_ADVICE(){
        return SECTION_ADVICE;
    }
}