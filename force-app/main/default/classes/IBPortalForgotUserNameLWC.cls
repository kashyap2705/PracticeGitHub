public without sharing class IBPortalForgotUserNameLWC {
    
     @AuraEnabled(cacheable=true)
    public static String getUserList(string firstName, string lastName, date dateofBirth, string countryName) {
        
        string msg;
        // query username
        try{
            Contact contactUsername = [Select User__r.username,Id,Email,FirstName,LastName,Birthdate,Country_of_Birth__c From Contact	
                                       WHERE FirstName =: firstName and LastName =: lastName and Birthdate =: dateOfBirth and Country_of_Birth__c =: countryName LIMIT 1];
            if(contactUsername != NULL ){
                sendEmail(contactUsername.Id); 
                msg = 'true';
            }
            else{
                msg = 'false';
            }
        }
        catch(exception e){
            msg = 'false';
        }
        return msg; 
        
    } 

   
    @AuraEnabled(cacheable=true)
    public static List<String> getPickListValuesIntoList(){
        List<String> pickListValuesList= new List<String>();
        Schema.DescribeFieldResult fieldResult = Contact.Country_of_Birth__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : ple){
            pickListValuesList.add(pickListVal.getLabel());
        }     
        return pickListValuesList;
    }
    
    //Sending email to respective user via flow
    @AuraEnabled(cacheable=true)
    public static void sendEmail(Id conId) {      

        
        user u = new user();
        u = [select Id from user where contactId = :conId limit 1];
       Map<String,Id> mapa = new Map<String,Id>();
        mapa.put('recordID',u.Id);
        
        Flow.Interview.LWC_Email_Flow flow1 = new Flow.Interview.LWC_Email_Flow(mapa);
        flow1.start();
        
    }

    public static Map<String, String>  customLabelsByLanguage = new Map<String, String>();
   
    //Change the translations of the labels in lWC component
      @AuraEnabled(cacheable=true)
    public static Map<String, String>  getvaluesbyLanguage(String language)
    {
        system.debug('language value: '+ language);
        List<String> customLabelNames = new List<String>{ 'ibPortalForgetUsername','ibPortalForgotUsernameText_Help',
            'ibPortal_ForgetUsername_SuccessMsg','IBENPortal_Registration_FirstName',
            'IBENPortal_Registration_LastName',
            'IBENPortal_MyProfile_DateOfBirth',
            'IBENPortal_Registration_CountryOfBirth',
            'IB_Portal_Forgot_UserName_Page_Button',
            'IB_Portal_UserName_Page_First_Name_Placeholder',
            'IB_Portal_Forgot_UserName_Page_Last_Name',

            'IBENPortal_Registration_DateOfBirth_Format','IB_Portal_Forgot_UserName_Page_CountryBirth_Placeholder',
            'ibPortal_Username_Fill_Fields_Error', 'Date_Format_Forget_Username_Page_Msg', 'IBENPortal_ForgotUserName_Placeholder','IBPortal_ForgotName_Page_DateofBirth'};


                getLabel(customLabelNames,language);

        return customLabelsByLanguage;
        
    }
    //Getting labels
    public static void getLabel(list<String> labels,String lang) {
        PageReference pageRef = Page.Label;
        pageRef.getParameters().put('lang', lang);
        String s ;
        for(String label:labels){
            pageRef.getParameters().put('label', label);
            if(!Test.isRunningTest())
            s = pageRef.getContent().toString();
            else
                s='Test Label Value';
            Integer start_index = s.indexOf(':') ;
            Integer end_index = s.length()-1;
            String result = s.substring(start_index+3, end_index-2);

            customLabelsByLanguage.put(label,result);
        }
    }   


}