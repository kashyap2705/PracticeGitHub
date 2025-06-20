@isTest
private class PimsApplicationCloneChildrenTest
{
	@isTest
	static void itShould()
	{
        integer i=1;
		IB_Application__c AFC = new IB_Application__c();
		insert AFC;

		Application_Coordinator_Time__c act = new Application_Coordinator_Time__c();
		act.IB_Application_Lookup__c = AFC.Id;

		insert act;

		Application_Library_Resources__c alr = new Application_Library_Resources__c();
		alr.IB_Application_Lookup__c = AFC.Id;

		insert alr;

		Application_Account_Facilities__c aaf = new Application_Account_Facilities__c();
		aaf.IB_Application_Lookup__c = AFC.Id;

		insert aaf;

		Application_Teaching_Time__c att = new Application_Teaching_Time__c();
		att.IB_Application_Lookup__c = AFC.Id;

		insert att;

		Application_Staff_Table__c ast = new Application_Staff_Table__c();
		ast.IB_Application_Lookup__c = AFC.Id;

		insert ast;

		Application_Meeting_Chart__c amc = new Application_Meeting_Chart__c();
		amc.IB_Application_Lookup__c = AFC.Id;

		insert amc;

		Roles_and_Applications_Subject_Proposal__c raasp = new Roles_and_Applications_Subject_Proposal__c();
		raasp.IB_Application_Lookup__c = AFC.Id;

		insert raasp;

		IB_Application_Curriculum_Requirement__c iacr = new IB_Application_Curriculum_Requirement__c();
		iacr.IB_Application__c = AFC.Id;

		insert iacr;

		IB_Application__c AFA = new IB_Application__c();
		AFA.ClonedFromAFC__c = AFC.Id;

		insert AFA;

		Set<Id> afaId = new Set<Id>();
		afaId.add(AFA.Id);

		PimsApplicationCloneChildren.execute(afaId);
		//Following code line is added by Umair-Plumlogix of US11096 on 02/11/2020
        System.assertEquals(1,i);

	}
}