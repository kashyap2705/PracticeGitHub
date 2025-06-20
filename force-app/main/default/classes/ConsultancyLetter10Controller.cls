public class ConsultancyLetter10Controller {

	public String coordName {get;set;}
	public String schoolName {get;set;}
	public String programmeName {get;set;}
	public String consultantName {get;set;}
	public String consultantEmail {get;set;}
	public String theYear {get;set;}
	public String signature {get;set;}
	public String theDate {get;set;}
    public String startDate {get;set;}

	public ConsultancyLetter10Controller(){

		coordName = Apexpages.CurrentPage().getParameters().get(SendConLetter10.COORD_NAME);
		schoolName = Apexpages.CurrentPage().getParameters().get(SendConLetter10.SCHOOL_NAME);
		programmeName = Apexpages.CurrentPage().getParameters().get(SendConLetter10.PROG_NAME);
		consultantName = Apexpages.CurrentPage().getParameters().get(SendConLetter10.CON_NAME);
		consultantEmail = Apexpages.CurrentPage().getParameters().get(SendConLetter10.CON_EMAIL);
		theYear = Apexpages.CurrentPage().getParameters().get(SendConLetter10.THE_YEAR);
		theDate = Apexpages.CurrentPage().getParameters().get(SendConLetter10.THE_DATE);
        startDate = Apexpages.CurrentPage().getParameters().get(SendConLetter10.START_DATE);
        signature = ApexPages.CurrentPage().getParameters().get(SendConLetter10.SIGNATURE);
	}
}