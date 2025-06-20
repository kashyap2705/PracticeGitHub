public without sharing class IBPortalEditRoleInfoController {

	@TestVisible User user = UserDAO.INSTANCE.getUserById(Userinfo.getUserId());
	public final IB_Role__c roleApp {get;set;}
	public final Contact_Information__c conInfoEmail {get;set;}
	public final Contact_Information__c conInfoPhone {get;set;}
	public list<IB_Role__c> listRoleApps {get;set;}
	public Id roleId {get;set;}
    public static boolean error {set;get;}
    public static boolean error1{set; get;}
	public static string usrLang{set; get;}
	private string conEmail;
	private string conPhone;
	private string jobTitle;
    public string instituteurl;
    public boolean consenttick;
    public String citySelected {set; get;}
    Public String phone {set; get;}
    Public String UCC {set;get;}
    public IBPortalEditRoleInfoController () {
		usrLang = getLocale();
        error = true;
        error1 = true;
        system.debug('error = ' + error);
        system.debug('error1 =' + error1);
		system.debug('usrLang = ' + usrLang);
		roleId = ApexPages.currentPage().getParameters().get('Id');
		system.debug('roleId: ' + roleId);
		roleApp = [SELECT Account_Name__c,Active__c,BQC_Subject__c,Contact_IBEN_Region__c,Continuum__c,Email_Confirmed__c,Email__c,End_Date__c,First_Name__c,
		Contact_Information_Email__c,  Contact_Information_Phone__c, Contact_Information_Email__r.email__c,IB_Role_Name__c,IB_Account__r.Name,IB_Contact__c,
		Contact_Information_Email_Text__c, Contact_Information_Phone__r.phone__c, IB_Role_Category__c,IB_Role_Name_es__c, IB_Role_Name_fr__c,
		General_Instructions__c,IBEN_Preferred_Email_Formula__c,IBEN_Preferred_Email__c,IBIS_ADMIN_EMAIL__c,IB_Programme_New__c,IB_Programme__c,
                   //this code is edited for us-12479 of staff aug project
                   //start
                   IB_Role_Level__c,Job_Title__c,Last_Name__c,Motivation__c,Programme_Selection__c,Programme_Type__c,Referee_1_Email__c,Referee_1_First_Name__c,Institute_profile_link__c,Consent_Flag__c,
                   //end
		Referee_1_Last_Name__c,Referee_2_Email__c,Referee_2_First_Name__c,Referee_2_Last_Name__c,Referee_2_Title__c,School_Name__c,Start_Date__c,Status__c,
		Subject__c,Title__c,Contact_Information_Phone__r.Country_Code__c,Contact_Information_Phone__r.Phone_Number__c FROM IB_Role__c where ID =: roleId];
		system.debug('Contact Info Email: ' + roleApp.Contact_Information_Email__r.email__c);
		system.debug('Contact Info Phone: ' + roleApp.Contact_Information_Phone__r.phone__c);
		jobTitle = roleApp.Job_Title__c;
        //this code is edited for us-12479 of staff aug project
        //start
        instituteurl=roleApp.Institute_profile_link__c;
        consenttick=roleApp.Consent_Flag__c;
        //end
		if(roleApp.Contact_Information_Email__c != null && roleApp.Contact_Information_Email__r.email__c != null){
			conEmail = roleApp.Contact_Information_Email__r.email__c;
			conInfoEmail = new Contact_Information__c(id = roleApp.Contact_Information_Email__c, Email__c = roleApp.Contact_Information_Email__r.email__c);
		}
		if(roleApp.Contact_Information_Phone__c != null && roleApp.Contact_Information_Phone__r.phone__c != null){
			conPhone = roleApp.Contact_Information_Phone__r.phone__c;
			conInfoPhone = new Contact_Information__c(id = roleApp.Contact_Information_Phone__c,Country_Code__c = roleApp.Contact_Information_Phone__r.Country_Code__c,
                                                                                                Phone_Number__c = roleApp.Contact_Information_Phone__r.Phone_Number__c, phone__c = roleApp.Contact_Information_Phone__r.phone__c);
        if(conPhone != NULL || conPhone != '')
        {
            Phone = conPhone;
        }
		}
    }
    
    public String getLocale() {
        return UserInfo.getLanguage();
    }

	public List<String> errorMessages {
		get {
			if(errorMessages == null){
				errorMessages = new List<String>();
			}
			return errorMessages;
		}
		set;
	}

	public Integer errorCount {
		get {
			if(errorCount == null){
				errorCount = 0;
			}
			return errorCount;
		}
		set;
	}
    public PageReference isLoggedIn() {
        if (UserInfo.getUserType() == 'Guest') {
           return new PageReference('/ibportal/IBPortalLogin');
        }
        else {
           return null;
        }
    }
	
        //Function updated for ECM226 as part of Staff-Aug Project
        //Added condition for IBEC Roles
    public PageReference saveProfile() {
        try{
			list<Contact_Information__c> listConInfoUpd = new list<Contact_Information__c>();
			Boolean roleAppUpd = false;
			list<IB_Role__c> listReverifyEmail = new list<IB_Role__c>();
			IB_Role__c ibRole = new IB_Role__c();
            // Following code is added as part of SA Project of US12186 on 3/24/2021
			// Start


            if(roleApp.IB_Role_Name__c != 'University and Career Counselor')
            {
			PhoneValidation phone_validation = new PhoneValidation();



            system.debug('Javalog citySelected: '+citySelected);
            system.debug('Javalog phone: '+phone);
                if((roleApp.IB_Role_Name__c != 'IBEC Candidate' && phone_validation.edit_phone_contact_Info(conInfoPhone,citySelected,phone,roleApp) == true) || (roleApp.IB_Role_Name__c == 'IBEC Candidate' && 
                                                           ((((citySelected == null || citySelected == '') && phone != null) || (citySelected != null && (phone == null || phone == ''))) 
                                                           && phone_validation.edit_phone_contact_Info(conInfoPhone,citySelected,phone,roleApp) == true))){

                 ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,label.Phone_Format_Error));
                 return null;
            }//End
                    

            }
			if(conEmail != null && conInfoEmail != null && conEmail != conInfoEmail.Email__c){
                if(roleApp.Email_Confirmed__c == true && roleApp.Status__c != 'Confirmed'){
                    roleApp.Email_Confirmed__c = false;
                }
				list<Contact_Information__c> listExistingConInfoEmail = [select Name, Email__c, IB_Contact__c from Contact_Information__c where IB_Contact__c =: roleApp.IB_Contact__c AND Email__c =: conInfoEmail.Email__c limit 1];
				if(listExistingConInfoEmail != null && !listExistingConInfoEmail.isEmpty()){
					for(Contact_Information__c conEmail : listExistingConInfoEmail){
						roleApp.Contact_Information_Email__c = conEmail.Id;
						roleApp.Contact_Information_Email_Text__c = conInfoEmail.Email__c;
						roleAppUpd = true;
					}
				}
				else{
					Contact_Information__c newConInfoEmail = new Contact_Information__c(IB_Contact__c = roleApp.IB_Contact__c, Email__c = conInfoEmail.Email__c,
																							Name = conInfoEmail.Email__c, 
																							RecordTypeId=Schema.SObjectType.Contact_Information__c.getRecordTypeInfosByDeveloperName().get('Email').getRecordTypeId());
					insert newConInfoEmail;
					roleApp.Contact_Information_Email__c = newConInfoEmail.Id;
					roleApp.Contact_Information_Email_Text__c = conInfoEmail.Email__c;
					roleAppUpd = true;
				}
			}
            if(conPhone != null && conInfoPhone !=null && conPhone != conInfoPhone.phone__c){
				conInfoPhone.Name = conInfoPhone.phone__c;
				listConInfoUpd.add(conInfoPhone);
			}
           
            if((citySelected == null || citySelected == '') && ( phone == '' || phone == null)){
                roleApp.Contact_Information_Phone__c = null;
                roleAppUpd = true;
            }
			if(!listConInfoUpd.isEmpty()){
				update listConInfoUpd;
			}
			if(!listConInfoUpd.isEmpty() || jobTitle != roleApp.Job_Title__c || roleAppUpd){
				update roleApp;
			}

            system.debug('Javalog instituteURL: '+instituteurl);
            system.debug('Javalog ProfileLink: '+roleApp.Institute_profile_link__c);
            //this code is edited for us-12479 of staff aug prject
            //start
            if(roleApp.IB_Role_Name__c == 'University and Career Counselor')
            {
                if(instituteurl!=roleApp.Institute_profile_link__c || consenttick!=roleApp.Consent_Flag__c)
                {
                    
                    update roleApp;
                    
                }
            }
            //end
            if(conEmail != null && conInfoEmail != null && conEmail != conInfoEmail.Email__c && roleApp.Status__c != 'Confirmed'){

                ibRole = [Select Id, Account_Name__c,Active__c,Contact_name__c,ContactInfo_Emailvalue__c,ContactUserLanguage__c,BQC_Subject__c,
						Contact_IBEN_Region__c,Continuum__c,Email_Confirmed__c,Email__c,End_Date__c,First_Name__c,
                          Contact_Information_Email__c,  Contact_Information_Phone__c, Contact_Information_Email__r.email__c,IB_Role_Name__c,IB_Account__r.Name,
                          Contact_Information_Email_Text__c, Contact_Information_Phone__r.phone__c, IB_Role_Category__c,IB_Role_Name_es__c, IB_Role_Name_fr__c,
                          General_Instructions__c,IBEN_Preferred_Email_Formula__c,IBEN_Preferred_Email__c,IBIS_ADMIN_EMAIL__c,IB_Programme_New__c,IB_Programme__c,
                          IB_Role_Level__c,Job_Title__c,Last_Name__c,Motivation__c,Programme_Selection__c,Programme_Type__c,Referee_1_Email__c,Referee_1_First_Name__c,Referee_1_Last_Name__c,Referee_2_Email__c,Referee_2_First_Name__c,Referee_2_Last_Name__c,Referee_2_Title__c,
						  School_Name__c,Start_Date__c,Status__c,Subject__c,Title__c from IB_Role__c where Id=:roleApp.Id];
				listReverifyEmail.add(ibRole);
            }
            if(!listReverifyEmail.isEmpty()){
                new InstituteMgmRolesHandler().SendEmailConfirmationToRoleApplicant(listReverifyEmail);
            }
			PageReference pg = new PageReference('/ibportal/MyIBRoles?id=' + roleId);
			return pg;
		}
		catch(Exception e){
            system.debug('Error Message: ' + e.getMessage());
          //  ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage());
            //ApexPages.addMessage(myMsg);
            return null;
        }
	}
    public PageReference cancelProfile() {
		PageReference pg = new PageReference('/ibportal/MyIBRoles?id=' + roleId);
		return pg;
	}
}