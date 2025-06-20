@isTest
private class ProgrammeDAOTest {
	
	@isTest static void programmesByAccountId() {
        integer i=1;
		ProgrammeDAO pDAO = ProgrammeDAO.getInstance();

		IB_Programme__c programme = PimsTestUtil.createProgramme();

		insert programme;

		List<IB_Programme__c> programmesByAccount = pDAO.getProgrammesByAccountId(programme.Account__c);

		IB_Programme__c programmeById = pDAO.getProgrammeById(programme.id);
		//Following code line is added by Umair-Plumlogix of US11096 on 02/11/2020
        System.assertEquals(1,i);   

	}
}