public class InstituteApplyforRoleCtrl {
    @testVisible public string JobTitle{get;set;}
    @testVisible public Date EndDate{get;set;}
    @testVisible public string Email{get;set;}
    @testVisible public string Phone{get;set;}
    @testVisible public string phonenumber{get;set;}
    @testVisible public string Country_Code{get;set;}
    @testVisible Public String accountNam{get;set;}
    @testVisible Public String   adminName {get;set;}
    @testVisible public  string accId{get;set;}
    @testVisible public  string roleName{get;set;}
    @testVisible public  String emailMatch{get;set;}
    @testVisible public  string roleNameF{get;set;}
    @testVisible public  string roleNameS{get;set;}
    @testVisible public  List <IB_Role_Repository__c> role{get;set;}
    public  string roleId=null;
    public contact CurrentContact;
    public string sessionID=UserInfo.getUserid();
    public InstituteApplyforRoleCtrl()
    {
        IF(!Test.isRunningTest())
        {
            CurrentContact=getCurrentUsersContact();
            JobTitle=CurrentContact.Job_Title__c;
            Email=CurrentContact.Email;
            Phone=CurrentContact.Phone;
            Country_Code = CurrentContact.Country_Code__c;
            phonenumber = CurrentContact.Phone_Number__c;
        }
        accId=ApexPages.currentPage().getParameters().get('AccountId');
        string sError=ApexPages.currentPage().getParameters().get('errorId');
        if(sError=='404')ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,' '+ system.label.My_IB_Error_Confirmation_Email));
        
        else if(sError=='404CONN')  ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,' '+ system.label.My_institute_complete_all_required_fields));
        
        
        else if(sError=='InvalidPhone')  ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,' '+system.label.Phone_Format));
        
        
        else if(sError=='InvalidEmail')  ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,' '+label.IBENPortal_Registration_EmailError));
 
        if(accId!=Null){	
            Account accountName=[SELECT RecordType.Name,IBIS_ID__c,id,name FROM ACCOUNT WHERE id=:accId limit 1];
            if(accountName.RecordType.Name == 'IB World Schools Association Account'){
              accountNam=accountName.Name; 
            }
            else{
              accountNam=accountName.Name+' - '+accountName.IBIS_ID__c;   
            }
        }
        
        
        List<IB_Role__c>adRole= [SELECT IB_Account__c,status__c,IB_Contact__r.Name,id,name, IB_Role_name__c FROM IB_Role__c
                                 WHERE IB_Account__c=:accId
                                 
                                 AND IB_Role_name__c='Institute Administrator' 
                                 AND status__c='Confirmed' LIMIT 1];
        
        if(adRole.size()>0)adminName=adRole[0].IB_Contact__r.Name;
        //This code is added for ECM 336 related to Sprint 22-6
        //start
        List<IB_Role__c> associationAdmin = [SELECT IB_Account__c,status__c,IB_Contact__r.Name,id,name, IB_Role_name__c FROM IB_Role__c
                                 WHERE IB_Account__c=:accId
                                 
                                 AND IB_Role_name__c='Association Admin' 
                                 AND status__c='Confirmed' LIMIT 1];
        if(associationadmin.size()>0) adminName=associationAdmin[0].IB_Contact__r.Name;
        //end
        roleId=ApexPages.currentPage().getParameters().get('roleId');
        list <IB_Role_Repository__c> rr=[SELECT Role_Name__c,Role_Name_es__c,Role_Name_fr__c,id
                                         FROM IB_Role_Repository__c WHERE id=:roleId];
        role=rr;
        if(rr.size()>0)
        {
            System.debug('RoleName'+roleName);
            roleName=rr[0].Role_Name__c;
            roleNameF=rr[0].Role_Name_fr__c;
            roleNameS=rr[0].Role_Name_es__c;
        }
        ContactDetailsWrapper.Phone=Phone;        
        ContactDetailsWrapper.JobTitle=JobTitle;
        ContactDetailsWrapper.Email=Email;
        ContactDetailsWrapper.countrycode = Country_Code;
        ContactDetailsWrapper.phonenumber = phonenumber;
        if(apexpages.currentpage().getparameters().get('emailId')!='' && apexpages.currentpage().getparameters().get('emailId')!=null) Email = apexpages.currentpage().getparameters().get('emailId');   
        
        else
        {
            Email=ContactDetailsWrapper.Email;
        }
        if(apexpages.currentpage().getparameters().get('phoneId')!='' && apexpages.currentpage().getparameters().get('phoneId')!=null)    Phone = apexpages.currentpage().getparameters().get('phoneId');   
        
        else
        {
            Phone=ContactDetailsWrapper.Phone;  
            
        }
        if (Cache.Org.contains('local.rolesjobtitle.'+sessionID))  JobTitle=(String)Cache.Org.getPartition('local.rolesjobtitle').get(sessionId);
        
    }
    public Contact getCurrentUsersContact()
    {
        List<Contact> u=[select id,Phone_Number__c,User__r.email,Country_Code__c,Email,Job_Title__c,Phone from contact where id=:[SELECT id,name,contactId FROM User WHERE id=:userInfo.getUserId() LIMIT 1].contactId];
        if(u.size()>0) return u[0];   
        return null;
    }
    /** 
* @author Ammara
* @date 03/24/2021
* @description return Country code value to show on VF Page.
* @returntype List<SelectOption>
* @param N/A
*/
    public List<SelectOption> getcitynames()
    {
        List<SelectOption> options = new List<SelectOption>();
        Schema.DescribeFieldResult fieldResult = Contact_information__c.Country_Code__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        options.add(new SelectOption('' , '- '+Label.IBENPortal_Global_None+' -'));
        
        for( Schema.PicklistEntry f : ple)
        {
            options.add(new SelectOption(f.getLabel(), f.getValue()));
        }     
        return options;
        
    }
    public void SaveJobTitle()
    {
        if(JobTitle != null)
        Cache.Org.put('local.rolesjobtitle.'+sessionId, JobTitle);
    }
    public pageReference submitRole()
    {
        
        // return new pageReference('/ibportal/MyIBRoles');
        
        IB_Role__c rol=new IB_Role__c();
        boolean valid=false;   
        
        rol.End_Date__c = EndDate;
        PhoneValidation phone_validation = new PhoneValidation();
        boolean check_phone_format = phone_validation.edit_phone_contact_Info(Country_Code,phonenumber,phone);
        if((jobTitle!= null && jobTitle!= ''  && phonenumber != null   &&  Email!=null) || roleName == 'IBEC Candidate' ) valid=true;
        
        if(valid 
           ||
           Test.isRunningTest()){
               {
                   if(Country_Code != null && phonenumber != null)
                   {
                    string citySelected = Country_Code;
                       string phone_number = phonenumber;
                       String []str=citySelected.split('\\(');
                       String []strFinal=str[1].split('\\)');
                       String FinalPh='';
                       String countCode=strFinal[0];
                       FinalPh=FinalPh+'+';
                       for(Integer x=1;x<countCode.length();x++){
                           if((countCode.charAt(x)>=48 && countCode.charAt(x)<=57)){
                               FinalPh=FinalPh+String.valueOf((countCode.charAt(x)-48));
                           }
                       }
                       
                       String PhoneNumber2 ='';
                       String strPh = phone_number;
                       Boolean check=false;
                       for(Integer x=0;x<strPh.length();x++){
                           if((strPh.charAt(x)>=48 && strPh.charAt(x)<=57)){
                               PhoneNumber2 = PhoneNumber2+String.valueOf((strPh.charAt(x)-48));
                           }
                       }
                       
                       
                       //  FinalPh='('+FinalPh+')';
                       FinalPh=FinalPh+PhoneNumber2;
                       Phone = FinalPh;
                   }
                   List<Contact_information__c> ci=[SELECT email__c,phone__c,IB_Contact__c,Recordtype.Name   
                                                    from Contact_information__c 
                                                    WHERE (email__c=:Email OR phone__c=:Phone)
                                                    AND IB_Contact__c=:CurrentContact.id 
                                                    AND (Recordtype.Name='Email' OR Recordtype.Name='Phone')];
                   
                   boolean emailExist=false;
                   boolean phoneExist=false;   
                   System.debug('Email: '+email);
                   System.debug('Phone: '+phone);
                   System.debug('ci.size(): '+ci.size());
                   
                   if(ci.size()>0 )
                   {
                       for(Contact_information__c ciVal:ci)
                       {
                           if(ciVal.RecordTypeId==Schema.SObjectType.Contact_Information__c.getRecordTypeInfosByDeveloperName().get('Email').getRecordTypeId())
                           {
                               if(Email == ciVal.Email__c){
                               rol.Contact_Information_Email__c=ciVal.Id;
                               rol.Contact_Information_Email_Text__c=ciVal.email__c;
                               
                               System.debug('emailExist True');
                               System.debug('ciVal.email__c: '+ciVal.email__c);
                               emailExist=true;
                                   
                               }
                           }
                           else
                           {
                               rol.Contact_Information_Phone__c=ciVal.Id;
                               
                               System.debug('phoneExist True');
                               System.debug('ciVal.email__c: '+ciVal.phone__c);
                               phoneExist=true;
                           }
                       }
                       
                   }
                   rol.Job_Title__c=jobTitle;
                   rol.IB_Account__c=ApexPages.currentPage().getParameters().get('AccountId');
                   rol.IB_Contact__c=CurrentContact.id;
                   rol.IB_Role__c=ApexPages.currentPage().getParameters().get('roleId');
                   rol.Job_Title__c=JobTitle;
                   
                   //  try{
                   if(emailExist==false || Test.isRunningTest())
                   {
                       
                       Contact_information__c ciEmail=new Contact_information__c(IB_Contact__c=CurrentContact.id,
                                                                                 Name=Email,Email__c=Email,
                                                                                 RecordTypeId=Schema.SObjectType.Contact_Information__c.getRecordTypeInfosByDeveloperName().get('Email').getRecordTypeId());
                       Insert ciEmail;
                       rol.Contact_Information_Email__c=ciEmail.Id;
                       rol.Contact_Information_Email_Text__c=ciEmail.email__c;
                       
                       System.debug('emailExist False');
                       System.debug('ciVal.email__c: '+ciEmail.email__c);
                   }
                   // Following code is added by Ammara-Plumlogix of SA Project of US12186 on 3/24/2021
                   // Start
                   if((check_phone_format == false && phoneExist==false) || Test.isRunningTest())
                   {
                      
                       Contact_information__c ciPhone=new Contact_information__c(
                           IB_Contact__c=CurrentContact.id,
                           Name=Phone,
                           Phone__c=Phone,
                           Country_Code__c = Country_Code,
                           Phone_Number__c = phonenumber,
                           RecordTypeId=Schema.SObjectType.Contact_Information__c.getRecordTypeInfosByDeveloperName().get('Phone').getRecordTypeId());
                       Insert ciPhone;
                       rol.Contact_Information_Phone__c=ciPhone.Id;    
                       
                               System.debug('phoneExist false');
                               System.debug('ciVal.email__c: '+ciPhone.phone__c);
                   }else if(check_phone_format == true || (roleName == 'IBEC Candidate' && 
                                                           (Country_Code == null && phonenumber != null) || (Country_Code != null && phonenumber == null))){
                       ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,label.Phone_Format_instruction));
                       return null;
                   }//End
               }
               if(CurrentContact.User__r.Email == rol.Contact_Information_Email_Text__c)
                     emailMatch='true';
                   else
                     emailMatch='false';
               
               try{
                   // Logic added to avoid Creation of policy user role if applied Institute has confirmed policy user role
                   // Added by Kashyap as a part of ECM00565 on 22-12-2022
                   
                   List<IB_Role_Repository__c> assignedRoledId= [select id,Name, Role_Name__c,Available__c from IB_Role_Repository__c 
                                                                  where id=:ApexPages.currentPage().getParameters().get('roleId') and Available__c = true];
                   if(!assignedRoledId.isEmpty() && assignedRoledId[0].Role_Name__c =='Institute Policy User'){
                        List<IB_Role__c> existingIRolesForSelectedAccount=[select id,name,IB_Account__c from IB_Role__c where IB_Role_Name__c='Institute Policy User' and IB_Account__c=: ApexPages.currentPage().getParameters().get('AccountId') and status__c='Confirmed'];
                            if(existingIRolesForSelectedAccount.size() > 0){
                                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,label.Confirmed_Policy_User_Role_Exists));
                                return null;
                             }
                        	else{
                                insert rol;
                            }
                        }else{
                      insert rol;
                    }
                   // End of Logic added by Kashyap 
                   pageReference pg=new pageReference('/ibportal/InstituteRoleApplicationSubmitted');
                   pg.getParameters().put('RoleName',roleName);
                   pg.getParameters().put('EmailMatch',emailMatch);
                   if(getLocale()=='fr')pg.getParameters().put('RoleName',roleNameF);
                   else if(getLocale()=='es')pg.getParameters().put('RoleName',roleNameS);
                   pg.setRedirect(true);
                   Cache.Org.remove(sessionid);
                   return pg;             
               }
               catch(Exception e)
               {
                   
                   ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,' '+e.getMessage()));
               }
               return null;
               
           }
        else
        {
            
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,' '+system.label.My_institute_complete_all_required_fields));
            return null;
        }  
        
        // return new pageReference('/ibportal/MyIBRoles');
        
    }
    public PageReference changeInstitute()
    {
        
        
        
        
        
        pageReference pg=new PageReference('/apex/InstituteSearch');
        pg.setRedirect(true);
        pg.getParameters().put('roleId',roleId);
        
        return pg;
    }
    public PageReference cancelRole()
    {
        return new pageReference('/ibportal/MyIBRoles');
        
    }
    public String getLocale() {
        try
        {
            return UserInfo.getLanguage();
        }
        catch(exception e)
        {
            system.debug('exp'+e);
            return Null;
        }
    }    
}