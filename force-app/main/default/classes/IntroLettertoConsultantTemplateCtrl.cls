public class IntroLettertoConsultantTemplateCtrl {
	public String template{ get; set; }
    public IntroLettertoConsultantTemplateCtrl(){
        try
        {
        //Assigning URL Parameters to variables 
        String myStaffingEventID = ApexPages.currentPage().getParameters().get('myStaffingEventID');
        
        EmailTemplate html = [select id, HTMLValue from EmailTemplate where developerName = 'Introduction_Letter_to_Consultant'];
		Messaging.SingleEmailMessage email = Messaging.renderStoredEmailTemplate(html.id, null, myStaffingEventID);//myStaffingEventID); //a1N0D0000004g7Q //staffing event it a1R0D0000009mIW
		system.debug('Jarvis Log===========================================Mystaffing event ID'+myStaffingEventID);
        //Assigning Merged Template to Visualforce Property 
		template = email.gethtmlBody();
        }
        Catch(Exception x)
        {
            System.debug('Exception: '+x);
        }
    }
}