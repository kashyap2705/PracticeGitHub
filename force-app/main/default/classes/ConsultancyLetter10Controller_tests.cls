@isTest
public class ConsultancyLetter10Controller_tests {

	public static final String SIGKEY = 'TEST';

	@testSetup
	static void setupData(){
		insert new Flow_Signatures__c(
			Name = SIGKEY,
			Signature__c = 'Test'
		);
	}

	static testmethod void one(){

		PageReference ref = Page.Consultancy_Letter_10_EN;
        ref.getParameters().put(SendConLetter10.COORD_NAME, 'Test');
        ref.getParameters().put(SendConLetter10.SCHOOL_NAME, 'Test');
        ref.getParameters().put(SendConLetter10.PROG_NAME,'Test');
        ref.getParameters().put(SendConLetter10.CON_NAME,'Test');
        ref.getParameters().put(SendConLetter10.CON_EMAIL,'Test');
        ref.getParameters().put(SendConLetter10.THE_YEAR,'Test');
        ref.getParameters().put(SendConLetter10.SIGNATURE, SIGKEY);
        ref.getParameters().put(SendConLetter10.THE_DATE,'Test');
        ref.getParameters().put(SendConLetter10.TO_ADDRESS,'Robert.strunk@coastalcloud.us');
		System.Test.setCurrentPage(ref);

		Boolean isError = false;

		System.Test.startTest();
			try{
				ConsultancyLetter10Controller con = new ConsultancyLetter10Controller();
			}
			catch(SendConLetter10.unsupportedException e){
				isError = true;
			}
		System.Test.stopTest();

		System.assert(!isError);

	}
}