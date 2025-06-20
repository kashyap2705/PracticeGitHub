public  class InstituteSearchEmailComponent {
    public static string email{get;set;}
    public static string ConfirmEmail{get;set;}
    public static string acId;
    public static string rolId;
    public static string phoneId;
   
    private void getPageIds()
    {
        acId = apexpages.currentpage().getparameters().get('AccountId');
        rolId=apexpages.currentpage().getparameters().get('roleId');
        phoneId=apexpages.currentpage().getparameters().get('phoneId');
        
    }
    public pageReference create() {
        getPageIds();
                    pageReference pg;
        //Following code is updated for ECM-00226 for Sprint 22-1 on 07/01/2022
        IB_Role_Repository__c RoleSel = [SELECT Id, Role_Name__c FROM IB_Role_Repository__c WHERE Id =:rolId];
        //below line edited by Prerna on 15-12-2023 and added a new role: IBEC Certificate Holder for User Story ECM00566
        If(RoleSel != NULL && (RoleSel.Role_Name__c == 'IBEC University Administrator' || RoleSel.Role_Name__c == 'IBEC Faculty Member' || RoleSel.Role_Name__c == 'IBEC Candidate'|| RoleSel.Role_Name__c == 'IBEC Certificate Holder'))
        {
             pg= new PageReference ('/ibportal/IBECApplyForRole');

        }
         else
         {
             pg= new PageReference ('/ibportal/InstituteApplyForRole');
         }
            pg.getParameters().put('AccountId',acId);
            pg.getParameters().put('roleId',rolId);
            
            pg.getParameters().put('phoneId',phoneId);  

    if(validateEmail(email) )
    {
        if(email==ConfirmEmail)
        {
            
			pg.getParameters().put('emailId',email);
           
        }
        else
        {
            pg.getParameters().put('errorId','404');
           
        }
    }
    else
        {
            pg.getParameters().put('errorId','InvalidEmail');
            
        }
         pg.setRedirect(true);
         return pg;
    }
    
    public  pageReference Cancel1() {
        getPageIds();
        pageReference pg;
        pg= new PageReference ('/ibportal/InstituteApplyForRole');
        pg.getParameters().put('AccountId',acId);
        pg.getParameters().put('roleId',rolId);
        pg.getParameters().put('phoneId',phoneId);
        
        pg.setRedirect(true);
        return pg;
    }
    private static Boolean validateEmail(String email) {
	Boolean res = true;
		
	
	String emailRegex = '^[a-zA-Z0-9._|\\\\%#~`=?&/$^*!}{+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,4}$'; // source: http://www.regular-expressions.info/email.html
	Pattern MyPattern = Pattern.compile(emailRegex);
	Matcher MyMatcher = MyPattern.matcher(email);

	if (!MyMatcher.matches()) 
	    res = false;
	return res;	
	}
    
}