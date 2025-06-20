/**		
	* <h1>Update Contact Phone Field</h1>		
	* This class is responsible for Updating the phone field on Contact object,US11890.
	* 
	* @author  Abd Ur Rehman		
	* @version 1.0		
	* @since   22-06-2020
	
Modification Log     :                                                                              

*-------------------------------------------------------------------------------------------------- 

* Developer                   Date                   Description          Version                          

* ------------------------------------------------------------------------------------------------- 


*/

public class EditContactComponentController {
     private IBPortalSettingsUtil util;
    public User user {get;private set;}
    public String addStep{get;set;}
    public String citySelected{get; set;}
    Public Contact Conphone{get;set;}
    public boolean error {get; set;}
    public string redirecturl {get;set;}
    public string phone{get;set;}

    /**
   * This constructor get the phone number of contact,US11890.
   * @author: Abd Ur Rehman-Plumlogix 
   * @since 22-06-2020
   * @param No parameter.
   * @return No return Type.
    */  
    
    public EditContactComponentController()
    {
        
        if(!Test.isRunningTest())
        {
        util = IBPortalSettingsUtil.getInstance();
        user = UserDAO.INSTANCE.getUserById(Userinfo.getUserId());
         this.Conphone = MyContactDAO.INSTANCE.getContactbyId(user.ContactId);  
        Conphone.Phone=Null;
        }
    }
    
    
     /**		
	   * This Method is responsible for getting the country codes and names,US11890.
	   * @author: Abd Ur Rehman-Plumlogix 
       * @since 22-06-2020
	   * @param No Parameter.		
	   * @return List of SelectOption.		
	  */
    
    //below code is updated by developer Abd Ur Rehman as part of DE6322 on 6-10-2020
        //start     
  public List<SelectOption> getcitynames()
    {
     
        List<SelectOption> pickListValuesList= new List<SelectOption>();
		Schema.DescribeFieldResult fieldResult = IB_Country_Segmentation__c.Country_Codes__c.getDescribe();
		List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
		for( Schema.PicklistEntry pickListVal : ple){
			pickListValuesList.add(new SelectOption(pickListVal.getLabel(),pickListVal.getLabel()));
		}     
		return pickListValuesList;
    }
    
    
 
    /**		
	   * This Method is responsible for processing the and updating phone field with		
	   * specific format,US11890.
	   * @author: Abd Ur Rehman-Plumlogix 
       * @since 22-06-2020
	   * @param No Parameter.		
	   * @return pageReference.		
	   */
    
    Public pagereference create()
    {
        
        try
        {
       
        error = false;    
        Integer len = Phone.length();
        //below code is added by developer Abd Ur Rehman as part of DE6322 on 6-10-2020
        //start     
        boolean city = false;
        if (citySelected =='--None--' || citySelected =='--Aucun--' || citySelected =='--Ninguno--'  )
        city = true;
        //end    
        if( !city && Phone!=Null  && len<=15 && len>8  && Phone.isNumeric() )
        {
            String []str=citySelected.split('\\(');
            
            String []strFinal=str[1].split('\\)');
            
            
            String FinalPh='';
            String countCode=strFinal[0];
            FinalPh=FinalPh+'+';
            for(Integer x=1;x<countCode.length();x++)
            {
                if((countCode.charAt(x)>=48 && countCode.charAt(x)<=57))
                {
                    
                    FinalPh=FinalPh+String.valueOf((countCode.charAt(x)-48));
                }
            }
            
              String PhoneNumber='';
                
                
                String strPh = Phone;
                Boolean check=false;
                for(Integer x=0;x<strPh.length();x++)
                {
                    if(strPh.charAt(x)!=48)
                    {
                        check=true;
                    }
                    if((strPh.charAt(x)>=48 && strPh.charAt(x)<=57) && check==true )
                    {
                        
                        PhoneNumber=PhoneNumber+String.valueOf((strPh.charAt(x)-48));
                    }
                    
                    
                    
                }
                
                
             
             FinalPh=FinalPh+PhoneNumber;
          
            Conphone.Phone=FinalPh;
            update Conphone;
              
                         
        }
       else
        {ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,label.Phone_format));
         Phone=null;
         error = true;
         addStep = 'X';
         IBPortalEditProfileController.error = false;
         IBPortalEditProfileController.error1 = false;
        }
         
        }
        catch(Exception e)
        {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage()));
        }
        system.debug('message =' + ApexPages.hasMessages() );
       return ApexPages.hasMessages() ? null : new PageReference('/ibportal/IBPortalEditProfile');
    }
}