@isTest
private class IBAppCandidacyRespLetterTemplateCtlrTest {
	private static testMethod void testController() {
        //This test class does the test coverage for IBAppCandidacyRespLetterTemplateCtlr apex class

        IBAppCandidacyRespLetterTemplateCtlr ctlr = new IBAppCandidacyRespLetterTemplateCtlr();
        IB_Programme__c prog = PimsTestUtil.createProgramme();
        prog.Letter_Template__c = 'Test';
        insert prog;

        test.startTest();

		PageReference pageRef = Page.IBAppCandidacyRespLetterTemplate;
        pageRef.getParameters().put('programmeId',prog.Id);
		test.setCurrentPageReference(pageRef);
		
		IBAppCandidacyRespLetterTemplateCtlr cs = new IBAppCandidacyRespLetterTemplateCtlr();
		pageRef.getParameters().put('programmeId','testfail');
		cs = new IBAppCandidacyRespLetterTemplateCtlr();

        test.stopTest();
	}
}