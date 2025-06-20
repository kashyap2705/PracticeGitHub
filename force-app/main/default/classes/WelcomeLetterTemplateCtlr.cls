public class WelcomeLetterTemplateCtlr {
    
	public String template{ get; set; }
    public WelcomeLetterTemplateCtlr(){
        
        try
        {
        
        //Assigning URL Parameters to variables 
        String ibProgramID = ApexPages.currentPage().getParameters().get('ibProgramID');
        
        EmailTemplate html = [select id, HTMLValue from EmailTemplate where developerName = 'WelcomeLetterTemplate'];
		Messaging.SingleEmailMessage email = Messaging.renderStoredEmailTemplate(html.id, null, ibProgramID); //ib program id a1R0D0000009mIW
		
        //Assigning Merged Template to Visualforce Property 
		template = email.gethtmlBody();
        }
        Catch(Exception x)
        {
            System.debug('Exception: '+x);
        }
        
    }
}