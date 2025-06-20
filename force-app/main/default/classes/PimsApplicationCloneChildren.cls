public with sharing class PimsApplicationCloneChildren {
	
	@future
	public static void execute(Set<Id> appIds) {

		List<IB_Application__c> applications = [SELECT Id, ClonedFromAFC__c FROM IB_Application__c WHERE Id in :appIds]; 

		Map<Id,Id> AFCtoAFA = new Map<Id,Id>();

		for(IB_Application__c app:applications){
			AFCtoAFA.put(app.ClonedFromAFC__c,app.Id);
		}

		List<sObject> sOBj = new List<sObject>();
		
		for(Application_Coordinator_Time__c act:getAllFieldsApplicationCoordinatorTime(AFCtoAFA.keySet())){
			Application_Coordinator_Time__c a = act.clone(false, true, false, false);
			a.IB_Application_Lookup__c = AFCtoAFA.get(act.IB_Application_Lookup__c);
			sOBj.add(a);
		}

		for(Application_Library_Resources__c act:getAllFieldsApplicationLibraryResources(AFCtoAFA.keySet())){
			Application_Library_Resources__c a = act.clone(false, true, false, false);
			a.IB_Application_Lookup__c = AFCtoAFA.get(act.IB_Application_Lookup__c);
			sOBj.add(a);
		}

		for(Application_Account_Facilities__c act:getAllFieldsApplicationAccountFacilities(AFCtoAFA.keySet())){
			Application_Account_Facilities__c a = act.clone(false, true, false, false);
			a.IB_Application_Lookup__c = AFCtoAFA.get(act.IB_Application_Lookup__c);
			sOBj.add(a);
		}

		for(Application_Teaching_Time__c act:getAllFieldsApplicationTeachingTime(AFCtoAFA.keySet())){
			Application_Teaching_Time__c a = act.clone(false, true, false, false);
			a.IB_Application_Lookup__c = AFCtoAFA.get(act.IB_Application_Lookup__c);
			sOBj.add(a);
		}

		for(Application_Staff_Table__c act:getAllFieldsApplicationStaffTable(AFCtoAFA.keySet())){
			Application_Staff_Table__c a = act.clone(false, true, false, false);
			a.IB_Application_Lookup__c = AFCtoAFA.get(act.IB_Application_Lookup__c);
			sOBj.add(a);
		}

		for(Application_Meeting_Chart__c act:getAllFieldsApplicationMeetingChart(AFCtoAFA.keySet())){
			Application_Meeting_Chart__c a = act.clone(false, true, false, false);
			a.IB_Application_Lookup__c = AFCtoAFA.get(act.IB_Application_Lookup__c);
			sOBj.add(a);
		}

		for(Roles_and_Applications_Subject_Proposal__c act:getAllFieldsSubjectProposal(AFCtoAFA.keySet())){
			Roles_and_Applications_Subject_Proposal__c a = act.clone(false, true, false, false);
			a.IB_Application_Lookup__c = AFCtoAFA.get(act.IB_Application_Lookup__c);
			sOBj.add(a);
		}

		for(IB_Application_Curriculum_Requirement__c act:getAllFieldsCurriculumRequirement(AFCtoAFA.keySet())){
			IB_Application_Curriculum_Requirement__c a = act.clone(false, true, false, false);
			a.IB_Application__c = AFCtoAFA.get(act.IB_Application__c);
			sOBj.add(a);
		}

		if(sOBj.size() > 0) insert sOBj;

    }
		
		
    public static List<Application_Coordinator_Time__c> getAllFieldsApplicationCoordinatorTime(Set<Id> afcIds) {
        DescribeSObjectResult describeResult = Application_Coordinator_Time__c.getSObjectType().getDescribe();
        List<String> fieldNames = new List<String>(describeResult.fields.getMap().keySet());
        String qryString = 'SELECT ' + String.join(fieldNames, ',') + ' FROM ' + describeResult.getName();
        qryString = qryString + ' WHERE IB_Application_Lookup__c in :afcIds';
        return Database.query(qryString);
    }

    public static List<Application_Library_Resources__c> getAllFieldsApplicationLibraryResources(Set<Id> afcIds) {
        DescribeSObjectResult describeResult = Application_Library_Resources__c.getSObjectType().getDescribe();
        List<String> fieldNames = new List<String>(describeResult.fields.getMap().keySet());
        String qryString = 'SELECT ' + String.join(fieldNames, ',') + ' FROM ' + describeResult.getName();
        qryString = qryString + ' WHERE IB_Application_Lookup__c in :afcIds';
        return Database.query(qryString);
    }

    public static List<Application_Account_Facilities__c> getAllFieldsApplicationAccountFacilities(Set<Id> afcIds) {
        DescribeSObjectResult describeResult = Application_Account_Facilities__c.getSObjectType().getDescribe();
        List<String> fieldNames = new List<String>(describeResult.fields.getMap().keySet());
        String qryString = 'SELECT ' + String.join(fieldNames, ',') + ' FROM ' + describeResult.getName();
        qryString = qryString + ' WHERE IB_Application_Lookup__c in :afcIds';
        return Database.query(qryString);
    }

    public static List<Application_Teaching_Time__c> getAllFieldsApplicationTeachingTime(Set<Id> afcIds) {
        DescribeSObjectResult describeResult = Application_Teaching_Time__c.getSObjectType().getDescribe();
        List<String> fieldNames = new List<String>(describeResult.fields.getMap().keySet());
        String qryString = 'SELECT ' + String.join(fieldNames, ',') + ' FROM ' + describeResult.getName();
        qryString = qryString + ' WHERE IB_Application_Lookup__c in :afcIds';
        return Database.query(qryString);
    }

    public static List<Application_Staff_Table__c> getAllFieldsApplicationStaffTable(Set<Id> afcIds) {
        DescribeSObjectResult describeResult = Application_Staff_Table__c.getSObjectType().getDescribe();
        List<String> fieldNames = new List<String>(describeResult.fields.getMap().keySet());
        String qryString = 'SELECT ' + String.join(fieldNames, ',') + ' FROM ' + describeResult.getName();
        qryString = qryString + ' WHERE IB_Application_Lookup__c in :afcIds';
        return Database.query(qryString);
    }

    public static List<Application_Meeting_Chart__c> getAllFieldsApplicationMeetingChart(Set<Id> afcIds) {
        DescribeSObjectResult describeResult = Application_Meeting_Chart__c.getSObjectType().getDescribe();
        List<String> fieldNames = new List<String>(describeResult.fields.getMap().keySet());
        String qryString = 'SELECT ' + String.join(fieldNames, ',') + ' FROM ' + describeResult.getName();
        qryString = qryString + ' WHERE IB_Application_Lookup__c in :afcIds';
        return Database.query(qryString);
    }

    public static List<Roles_and_Applications_Subject_Proposal__c> getAllFieldsSubjectProposal(Set<Id> afcIds) {
        DescribeSObjectResult describeResult = Roles_and_Applications_Subject_Proposal__c.getSObjectType().getDescribe();
        List<String> fieldNames = new List<String>(describeResult.fields.getMap().keySet());
        String qryString = 'SELECT ' + String.join(fieldNames, ',') + ' FROM ' + describeResult.getName();
        qryString = qryString + ' WHERE IB_Application_Lookup__c in :afcIds';
        return Database.query(qryString);
    }

    public static List<IB_Application_Curriculum_Requirement__c> getAllFieldsCurriculumRequirement(Set<Id> afcIds) {
        DescribeSObjectResult describeResult = IB_Application_Curriculum_Requirement__c.getSObjectType().getDescribe();
        List<String> fieldNames = new List<String>(describeResult.fields.getMap().keySet());
        String qryString = 'SELECT ' + String.join(fieldNames, ',') + ' FROM ' + describeResult.getName();
        qryString = qryString + ' WHERE IB_Application__c in :afcIds';
        return Database.query(qryString);
    }    


}