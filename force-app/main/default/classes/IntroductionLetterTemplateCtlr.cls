public class IntroductionLetterTemplateCtlr {
	public string templateBody{ get; set; }
    public IntroductionLetterTemplateCtlr(){
        try{
        String myStaffingEventID = ApexPages.currentPage().getParameters().get('myStaffingEventID');
        
        EmailTemplate html = [select id, HTMLValue from EmailTemplate where developerName = 'Introduction_Letter_pdf'];
		Messaging.SingleEmailMessage email = Messaging.renderStoredEmailTemplate(html.id, null, myStaffingEventID);//a1N0D0000004g7Q
		//system.debug('email body-------------------------'+email.gethtmlBody());
        
         
		templateBody = email.gethtmlBody();   
        } catch(Exception e) {
            system.debug('exception---------------------'+e);
        }
    }
}