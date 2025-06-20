public without sharing class ConsultantFeedbackSectionB1Controller extends PimsApplicationControllerHelper {

    //Commented by Plumlogics US11182
    /*
	public IB_Consultant_Feedback__c visitFeedback {get;set;}
	public IB_Consultant_Feedback__c endOfProcFeedback {get;set;}
	public IB_Application__c application {get;set;}
	public IB_Application_Assessment__c assessment {get;set;}
	public Boolean isEndOfProcess {get;set;}

	public static final RecordType endOfProcRecType = [select Id from RecordType where sObjectType = 'IB_Consultant_Feedback__c' AND DeveloperName = 'End_of_Process'];
	public static final RecordType visitRecType = [select Id from RecordType where sObjectType = 'IB_Consultant_Feedback__c' AND DeveloperName = 'Initial_Visit'];

	public Map<String, Contact> evidenceContacts {get;set;}
	public IB_Programme__c programme {get;set;}
	public Boolean otherLanguage {get;set;}
	public List<Application_Coordinator_Time__c> progCoordinatorTimeList {get;set;}
	public Decimal pcTimeAllocTotal {get;set;}*/

	public ConsultantFeedbackSectionB1Controller(){

		/*isEndOfProcess = false;

		//Each DAO is only being called once so I do not feel it is worth the time to redo and call the services.
		application = ApplicationDAO.getInstance().getApplicationById(ApexPages.currentPage().getParameters().get('id'));
		assessment = ApplicationAssessmentDAO.getInstance().getAppAssessmentByAppId(application.Id);

		Set<String> conIds = new Set<String>();
		conIds.addAll(((String)(application.AC_3_1_Feasability_Leads__c)).split(','));

		for(IB_Consultant_Feedback__c tmp : ConsultantFeedbackDAO.getInstance().getRecordsByAppId(application.Id)){

			// May need to do a status check for one-off scenarios

			if(tmp.RecordTypeId == visitRecType.Id){
				visitFeedback = tmp;
				continue;
			}
			else if(tmp.RecordTypeId == endOfProcRecType.Id){
				endOfProcFeedback = tmp;
				isEndOfProcess = true;
			}

			ApexPages.currentPage().getParameters().put('id', application.Id);
		}

		evidenceContacts = new Map<String, Contact>([
			SELECT Id, FirstName, LastName
			FROM   Contact
			WHERE 	Id IN:conIds
		]);

		programme = ProgrammeDAO.getInstance().getProgrammeById(visitFeedback.IB_Programme_Lookup__c);

        if (programme.Primary_Language_of_Instruction__c == 'English' || programme.Primary_Language_of_Instruction__c == 'Spanish' || programme.Primary_Language_of_Instruction__c == 'French' || programme.Secondary_Language_of_Instruction__c == 'English' || programme.Secondary_Language_of_Instruction__c == 'Spanish' || programme.Secondary_Language_of_Instruction__c == 'French' || programme.PR_5_Third_Language__c == 'English' || programme.PR_5_Third_Language__c == 'Spanish' || programme.PR_5_Third_Language__c == 'French' || programme.PR_5_Fourth_Language__c == 'English' || programme.PR_5_Fourth_Language__c == 'Spanish' || programme.PR_5_Fourth_Language__c == 'French'){
           otherLanguage = false;
        }
        else {
           otherLanguage = true;
        }

		progCoordinatorTimeList = [
           SELECT B2_1a_1_CP_Duty__c, B2_1a_1_CP_Weekly_Time__c, B2_1a_1_DP_Duty__c, B2_1a_1_DP_Weekly_Time__c, B2_1a_1_PYP_Duty__c, B2_1a_1_PYP_Weekly_Time__c,
           B2_1a_1_MYP_Duty__c, B2_1a_1_MYP_Weekly_Time__c, Id, Name, IB_Application_Lookup__c, Roles_Applications__c, Type__c
           FROM Application_Coordinator_Time__c
           WHERE IB_Application_Lookup__c = :application.Id AND Type__c = 'Programme coordinator'
        ];

        pcTimeAllocTotal = 0;
        for (Application_Coordinator_Time__c pct : progCoordinatorTimeList) {
           if (getIsCp() && pct.B2_1a_1_CP_Weekly_Time__c != null) pcTimeAllocTotal += pct.B2_1a_1_CP_Weekly_Time__c;
           if (getIsDp() && pct.B2_1a_1_DP_Weekly_Time__c != null) pcTimeAllocTotal += pct.B2_1a_1_DP_Weekly_Time__c;
           if (getIsPyp() && pct.B2_1a_1_PYP_Weekly_Time__c != null) pcTimeAllocTotal += pct.B2_1a_1_PYP_Weekly_Time__c;
           if (getIsMyp() && pct.B2_1a_1_MYP_Weekly_Time__c != null) pcTimeAllocTotal += pct.B2_1a_1_MYP_Weekly_Time__c;
        }*/

	}

	public PageReference save(){

        return Null;
		/*if(isEndOfProcess){
			update endOfProcFeedback;
		}
		else{
			update visitFeedback;
		}

		return null;*/
	}

}