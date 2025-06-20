/*******************************************************************************************
* @Name     IBPortalRegistrationCtrl 
* @Author       
* @Date         
* @Group        
* @Description  This Class is used to handle IBPortal Registration process
*******************************************************************************************/
/* MODIFICATION LOG
* Version          Developer          Date               Description
*-------------------------------------------------------------------------------------------
*  1.1               Saurabh Singh            06/31/2023        I have added two lines 74 and 75 for capturing the alternative email. 
*  1.2          Ranjith Kondabathini     07th June, 2023		Commented setProgrammeDefaultRoles method as it will be handled in the trigger directly
*******************************************************************************************/
public without sharing class IBPortalRegistrationCtrl {
    
    public Contact contactObject {get; set;}
    public String captchaPrivateKey {get; set;}
    public String captchaPublicKey {get; set;}
    public String communityNickname {get; set { communityNickname = value == null ? value : value.trim(); } }
    public String birthDateString {get; set;}
    public Boolean showCheckboxForPossibleDuplicate {get; set;}
    public String gCaptchaKey {get{return '6LcXSRMTAAAAABBpzAM3IAKAXBxadnVDiJxFshbx';} private set;}
    public String invitationID {get;set;}
    public Contact invitationContact {get; set;}
    public List<IB_Role__c> inviteRolesList {get;set;}
    public List<IB_Role__c> roles {get;set;}
    public String userLang {get; set;}
    public Boolean captchaEnabled {get; set;}
    public Boolean checkforSandbox {get; set;}
    private String emailBody;
    private String emailSubject;
    private String[] toAddress;
    private String[] ccAddress;
    
    @TestVisible private String CUSTOM_SETTING_USERINFO_CONFIG_NAME = 'IbenPublicPortal';
    @TestVisible private String selectedCountry; 
    @TestVisible private String userName;
    @TestVisible private IBPortalSettingsUtil util;
    
    public IBPortalRegistrationCtrl () {
        try {
            checkforSandbox = runningInASandbox();
            captchaEnabled = isReCaptchaEnabled();
            if(!checkforSandbox) { 
                captchaEnabled = true;
            }
        } catch (Exception exp) {
            Logger.get().add(exp, LogSeverity.ERROR).publish(); 
        }

        contactObject = new Contact ();
        util = IBPortalSettingsUtil.getInstance();
        showCheckboxForPossibleDuplicate = false;
        
        captchaPublicKey = util.getCaptchaPublicKey('IB Portal'.toLowerCase());
        captchaPrivateKey = util.getCaptchaPrivateKey('IB Portal'.toLowerCase());
        
        invitationID =  apexpages.currentpage().getparameters().get('inviteid');
        if(invitationID != null && invitationID != ''){
            invitationContact = MyContactDAO.INSTANCE.getContactbyInvitationID(invitationID);
            if(invitationContact != null){// added by kashyap for null check
                RoleService.setAccountId(invitationContact.accountId);
                roles = RoleService.getRolesByAccountId();
                inviteRolesList = new List<IB_Role__c>();
                for (IB_Role__c r : roles) {
                    if(r.IB_Contact__c == invitationContact.id){
                        inviteRolesList.add(r);
                    }
                }
            }
            
            
        } //added by kashyap as part of ECM00503
        
        if(invitationContact != null){
            if(invitationContact.Salutation != null){
                contactObject.Salutation = invitationContact.Salutation;
            }
            contactObject.FirstName = invitationContact.FirstName;
            contactObject.LastName = invitationContact.LastName;
            contactObject.Email = invitationContact.Email;
            if(invitationContact.Birthdate != null){
                contactObject.Birthdate = invitationContact.Birthdate;
                birthDateString = contactObject.Birthdate.format();
            }
            if(invitationContact.Alternative_Email__c != null){
                contactObject.Alternative_Email__c = invitationContact.Alternative_Email__c;
            }
            if(invitationContact.Country_of_Birth__c != null){
                contactObject.Country_of_Birth__c = invitationContact.Country_of_Birth__c;
            }
            if(invitationContact.Birth_Locale__c != null){
                contactObject.Birth_Locale__c = invitationContact.Birth_Locale__c;
            }
        }
        system.debug('contactObject **'+contactObject );
    }

    public static Boolean isReCaptchaEnabled() {
        IB_Captcha_Enablement__c settings = IB_Captcha_Enablement__c.getInstance();
        if (settings != null) {
            return settings.Is_reCaptcha_Enabled__c;
        } else {
            return true;
        }
    }

    public static Boolean runningInASandbox() {
        return [SELECT IsSandbox FROM Organization LIMIT 1].IsSandbox;
    }
    
    public List<SelectOption> getLanguageInfo(){
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('English','English'));
        options.add(new SelectOption('Spanish','Spanish'));
        options.add(new SelectOption('French','French'));
        return options;
        
    }
    
    public String getLocale() {
        LocaleSwitcherExtension lse = new LocaleSwitcherExtension();
        userLang=lse.getLocale(); 
        system.debug('userLang**'+userLang);
        return userLang;
    }
    
    public String getCurrentYear() {
        Date today = Date.today();
        return String.valueOf(today.year());
    }
    
    
    public PageReference registerUser() {
        if (!verifyCaptcha(ApexPages.currentPage().getParameters().get('g-recaptcha-response'))) {
            if(!captchaEnabled && checkforSandbox) {

            } else {  
                ApexPages.addMessage (new ApexPages.Message (ApexPages.Severity.ERROR, 'Nice try BOT!'));
                System.debug('Captcha failed');
                return null;
            }
        }
        Savepoint sp = Database.setSavepoint();
        User newCommunityUser= new User();
        Contact existingContact;
        Contact existingCont_ActiveUser;
        set<Id> roleAccountIds= new Set<Id>();// added by kashyap
        set<Id> roleIBProgrammes = new Set<Id>();// added by kashyap
        Boolean duplicateCheck ;
        Map<String, String> invitationRoleMap= new Map<String,String>();
        
        try {
            
            PortalUserInfo__c conf = PortalUserInfo__c.getInstance(CUSTOM_SETTING_USERINFO_CONFIG_NAME);
            if (null == conf) {
                throw new ControllerException(Label.IBENPortal_Error_NoCustomSetting  + ' ' +  CUSTOM_SETTING_USERINFO_CONFIG_NAME + '.');
            } 
            
            String profileId = conf.ProfileId__c; 
            String accountId = Process_Builder_Settings__c.getInstance().Account_New_User__c;
            String userName = contactObject.Email;
            contactObject.AccountId = accountId;
            birthDateString = birthDateString.removeEnd('.000Z');
            birthDateString = birthDateString.replace('T', ' ');
            contactObject.Birthdate = Date.valueOf(Datetime.valueOfGMT(birthDateString));
            contactObject.Birthdate = Date.newInstance(contactObject.Birthdate.year(), contactObject.Birthdate.month(), contactObject.Birthdate.day());
            
            system.debug('CONTACT INFO: ' + contactObject);
            IBPortalValidationUtil.checkExistingActiveUserRecord(userLang, contactObject.Email);
            IBPortalValidationUtil.checkContactWithActiveUser (userLang, contactObject.FirstName, contactObject.LastName,contactObject.Email, contactObject.Alternative_Email__c, contactObject.Birthdate, contactObject.Birth_Locale__c );
            /**Added by kashyap as a part of ECM 00476***/
            IBPortalValidationUtil.checkContactEmailForExistingUser (userLang,contactObject.Email); // Same functionality is taken care in checkExistingActiveUserRecord ,Seems like not required removed as a part of ECM 197641
            IBPortalValidationUtil.checkContactForDuplicateRegistration(userLang,contactObject.FirstName, contactObject.LastName, contactObject.Birthdate, contactObject.Country_of_Birth__c, contactObject.Birth_locale__c);
            duplicateCheck = IBPortalValidationUtil.markContactDuplicateBasedOnBirth(contactObject.LastName, contactObject.Birthdate, contactObject.Country_of_Birth__c, contactObject.Birth_locale__c);
            /**End of Addition by kashyap as a part of ECM 00476***/
            
            ID ActivateExistingUserID = IBPortalValidationUtil.findContactWithInActiveUser(contactObject.FirstName, contactObject.LastName,contactObject.Email, contactObject.Alternative_Email__c, contactObject.Birthdate, contactObject.Birth_Locale__c); 
            String userId = null;
            /** If contact withInactive User is found **/
            if(!String.isBlank(ActivateExistingUserID)){
                userId = ActivateExistingUserID;
            }else{
                /** Check if we have any Orphan Contact ***/
                existingContact = IBPortalValidationUtil.findOrphanContact(contactObject.FirstName, contactObject.LastName, contactObject.Email, contactObject.Alternative_Email__c, contactObject.Birthdate, contactObject.Birth_Locale__c);
                /** If we find an orphan Contact**/
                
                /** If the registration is via invite link which is sent ***/
                if(invitationID != null && invitationID != ''){
                    existingContact= invitationContact;//MyContactDAO.INSTANCE.getContactbyInvitationID(invitationID);
                }
                
                if(existingContact.ID != null) {
                    List<User> getUserByContactID = [SELECT ID from user where contactID = :existingContact.ID];
                    if(getUserByContactID.isEmpty()){
                        newCommunityUser.Username = contactObject.Email;
                        newCommunityUser.LastName = contactObject.LastName;
                        newCommunityUser.Email = contactObject.Email;
                        newCommunityUser.ProfileId = profileId;
                        newCommunityUser.FirstName = contactObject.FirstName;
                        newCommunityUser.LanguageLocaleKey = userLang; 
                        newCommunityUser.CommunityNickname = contactObject.FirstName + contactObject.LastName + '_' + Datetime.now().millisecond();
                        newCommunityUser.CommunityNickname = newCommunityUser.CommunityNickname.length() > 40 ? newCommunityUser.CommunityNickname.substring(40) : newCommunityUser.CommunityNickname;
                        newCommunityUser.ContactId = existingContact.Id;
                        newCommunityUser.alias = contactObject.FirstName.substring(1,1) + contactObject.LastName.abbreviate(6);
                        newCommunityUser.timezonesidkey = 'America/Los_Angeles';
                        newCommunityUser.emailencodingkey = 'UTF-8';
                        newCommunityUser.localesidkey = 'en_US';
                        /** New User Registration Happens Here and binding to existing contact - linking orphan contact *****/
                        system.debug('user inserted via invitation Id or orphan contact found**');
                        insert newCommunityUser;
                        
                        Ib_Role__c[] adasRoleList = [Select id, IB_Role_Name__c ,IB_Role_Name_es__c,IB_Role_Name_fr__c,IB_Contact__r.Invitation_ID__c,IB_Contact__r.AccountId,IB_Programme_New__c, Status__c from IB_Role__c where IB_Contact__c =: existingContact.id  ];//Limit 1
                        if(adasRoleList.size() >0 ) {
                            for(Ib_Role__c role: adasRoleList){
                                if(role.IB_Contact__r.Invitation_ID__c!=''){
                                    if(userLang == 'es'){
                                        invitationRoleMap.put(role.IB_Contact__r.Invitation_ID__c,role.IB_Role_Name_es__c);
                                    }else if(userLang == 'fr')
                                    {
                                        invitationRoleMap.put(role.IB_Contact__r.Invitation_ID__c,role.IB_Role_Name_fr__c);
                                    }else{
                                        invitationRoleMap.put(role.IB_Contact__r.Invitation_ID__c,role.IB_Role_Name__c);
                                    }
                                }
                                roleAccountIds.add(role.IB_Contact__r.AccountId);
                                roleIBProgrammes.add(role.IB_Programme_New__c);
                                if(role.IB_Role_Name__c == 'Admin Assistant' && role.Status__c == 'Invited'){
                                    changeProfileFutureMethodClass.changeProfileMethodADAS(newCommunityUser.Username); 
                                }
                                else {
                                    changeProfileFutureMethodClass.changeProfileMethod(newCommunityUser.Username);
                                }
                            }
                        }
                        else {
                            changeProfileFutureMethodClass.changeProfileMethod(newCommunityUser.Username); 
                        }
                        userId = newCommunityUser.Id;
                    }
                } else {
                    /** If we don't find an orphan Contact**/
                    if(!Test.isRunningTest()){
                        newCommunityUser.Username = contactObject.Email;
                        newCommunityUser.LastName = contactObject.LastName;
                        newCommunityUser.Email = contactObject.Email;
                        newCommunityUser.ProfileId = profileId;
                        newCommunityUser.FirstName = contactObject.FirstName;
                        newCommunityUser.LanguageLocaleKey = userLang; 
                        newCommunityUser.CommunityNickname = contactObject.FirstName + contactObject.LastName + '_' + Datetime.now().millisecond();
                        newCommunityUser.CommunityNickname = newCommunityUser.CommunityNickname.length() > 40 ? newCommunityUser.CommunityNickname.substring(40) : newCommunityUser.CommunityNickname;
                        /** New User Registration Happens Here Directly *****/
                        userId = Site.createPortalUser(newCommunityUser, accountId, null);
                        system.debug('userId***'+userId);
                    }
                    else 
                        userId = createPortalUserForTest('tportaluser@ibtest.org',ContactObject,'en_US','SCU + Advanced');
                }
                
                if (userId == null) {
                    throw new ControllerException(Label.IBENPortal_Error_UserNotCreated);
                }
            }
            
            
            User newUser = UserDAO.INSTANCE.getUserById(userId);
            /**Respond to Invite mail functionality goes here as a part of ECM00503 this sprint by kashyap **/
            
            if(invitationID == ''){
                invitationID = existingContact.Invitation_ID__c;
            }
            String programCoordinatorEmail ;
            List<IB_Role__c>  confirmedProgrammCoordinator;
            EmailTemplate template;
            if(invitationID != null && invitationID != ''){
                confirmedProgrammCoordinator=[select id,IB_Contact__r.AccountId,IB_Contact__c,IB_Programme_New__c,
                                              IB_Contact__r.Name,IB_Role_Name__c ,IB_Account__c,Email__c,IB_Account__r.Name from IB_Role__c 
                                              where 
                                              IB_Account__c in : roleAccountIds
                                              and 
                                              IB_Programme_New__c in :roleIBProgrammes 
                                              and
                                              IB_Role_Name__c ='Programme Coordinator'and Status__c= 'Confirmed' ];
                
                
                if(userLang == 'fr'){
                    template= [SELECT id, name, HtmlValue, Subject, Body FROM EmailTemplate WHERE developername ='Invited_Role_Accepted_fr'];
                }else if (userLang == 'es'){
                    template= [SELECT id, name, HtmlValue, Subject, Body FROM EmailTemplate WHERE developername ='Invited_Role_Accepted_es'];
                }else{
                    template= [SELECT id, name, HtmlValue, Subject, Body FROM EmailTemplate WHERE developername ='Invited_Role_Accepted'];
                }
                
                if(!confirmedProgrammCoordinator.isEmpty()  && template!= null){
                    ccAddress 		= new string[] {confirmedProgrammCoordinator[0].Email__c};   
                        toAddress 		= new string[] {contactObject.Email};
                            emailBody 		=  template.HtmlValue;
                    emailBody 		= emailBody.replace('[Role Name]', invitationRoleMap.get(invitationID));   
                    emailBody 		= emailBody.replace('[Name of School]', confirmedProgrammCoordinator[0].IB_Account__r.Name); 
                    emailBody 		=  emailBody.replace('[Last Name]', contactObject.LastName);
                    emailBody 		= emailBody.replace(']]>', '');  
                    emailSubject	= template.Subject;
                    emailSubject	= emailSubject.replace('[Role Name]', invitationRoleMap.get(invitationID));
                    emailSubject	= emailSubject.replace('[Name of School]', confirmedProgrammCoordinator[0].IB_Account__r.Name);
                    
                }
                
            }
            /**Respond to Invite mail functionality goes here as a part of ECM00503 this sprint **/
            
            if(!test.isRunningTest())
                IBPortalValidationUtil.updatePortalContact(userLang, duplicateCheck, newUser.ContactId ,invitationID , contactObject.Salutation, contactObject.Title, contactObject.FirstName, contactObject.LastName, contactObject.Email, contactObject.Alternative_Email__c, contactObject.Birthdate, contactObject.Country_of_Birth__c, contactObject.Birth_Locale__c);
            
            
            if(inviteRolesList != null && !inviteRolesList.isEmpty()){
                for (IB_Role__c invitationRole : inviteRolesList) {
                    invitationRole.RecordTypeId =  Schema.SObjectType.IB_Role__c.getRecordTypeInfosByName().get('Confirmed').getRecordTypeId();
                    if(invitationRole.IB_Role_Name__c != 'Admin Assistant' && invitationRole.IB_Role_Name__c != 'Chief Invigilator'){// added for DAS
                        invitationRole.Status__c = 'Confirmed';
                    }
                    invitationRole.Expiry_Date__c = null;
                    invitationRole.End_Date__c = null;
                    
                }
                update inviteRolesList;
                //IB_RoleAfterInsertTriggerHandler.setProgrammeDefaultRoles(inviteRolesList); 
            }
            
            /** 
*  Respond to Invite mail functionality goes here as a part of ECM00503  **/
            
            if(invitationID != null && invitationID != '' && !confirmedProgrammCoordinator.isEmpty() && template!= null){
                sendEmail(emailBody,emailSubject,toAddress,ccAddress);
            } 
            
            
            if (userId != null) { 
                PageReference page = System.Page.IBPortalSelfRegConfirm;
                page.getParameters().put ('name', contactObject.FirstName + ' ' + contactObject.LastName);
                //page.getParameters().put ('lang', getLocale()); 
                page.getParameters().put ('lang', userLang);// can use variable directly enhanced the above by Kashyap as a part of ECM 197641
                page.setRedirect(true);
                return page;
            } else {
                Database.rollback(sp);
                contactObject.Id = null;
                ApexPages.addMessage (new ApexPages.Message (ApexPages.Severity.ERROR, Label.IBENPortal_Error_UserNotCreated));
                return null;
            }
            
        } catch (Exception e) {
            ApexPages.addMessages (e);
            system.debug('error here**'+e.getCause()+'**'+e.getLineNumber()+'msg**'+e.getMessage()+'**'+e.getStackTraceString());
            Database.rollback(sp);
            contactObject.Id = null;
            
            if (e.getTypeName() == IBPortalValidationUtil.IBPortalValidationUtilPossibleAccountException.class.getName()) {
                showCheckboxForPossibleDuplicate = true;
            } else {
                ApexPages.addMessages(e);
                
                toAddress = new string[] {Label.Exception_Email_Alias};
                    String emailBody='Error Occured in IBPortalRegistrationCtrl Class and Cause is '+e.getCause() + ' at Line no '+e.getLineNumber() +
                    ' Error Message is '+ e.getMessage() +' and Stack Track Is'+e.getStackTraceString() + '<br/>';
                emailBody+=' Contact Details Provided are as below **'+ '<br/>' ;
                emailBody+=' <b> contact Email ** </b>'+contactObject.Email+ '<br/>';
                emailBody+=' <b> contact LastName ** </b>'+contactObject.LastName+ '<br/>';
                emailBody+=' <b> contact FirstName ** </b>'+contactObject.FirstName+ '<br/>';
                emailBody+=' <b> contact DOB ** </b>'+contactObject.Birthdate+ '<br/>';
                emailBody+=' <b> contact Country/Territory of birth ** </b>'+contactObject.Country_of_Birth__c+ '<br/>';
                emailBody+=' <b> Place of Birth ** </b>'+contactObject.Birth_Locale__c+ '<br/>';
                
                if(invitationID != null && invitationID != '' &&  existingContact != null){
                    emailBody+=' <b> For invitation Id ** </b>'+invitationID+ '<br/>';
                    emailBody+=' <b> For contact Id ** </b>'+ existingContact.Id + '<br/>';
                }
                emailSubject='Exception Occured when trying to register for a user';
                sendEmail(emailBody,emailSubject,toAddress,null);
            }                    
            
            return null;
        }
    }
    /* Private helper methods */
    
    
    private void sendEmail(String body,String subject,string[] toAddress,string[] ccAddress )
    {
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();// added by kashyap
        if(ccAddress != null){
            email.setCCAddresses(ccAddress);
        }
        email.setToAddresses(toAddress);
        email.setSubject(subject);
        email.setHtmlBody(body);
        system.debug('email exception***'+email);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { email });
        
    }
    private Boolean verifyCaptcha (String response) {
        String recaptcha_secret = captchaPrivateKey;
        
        Http h = new Http ();
        HttpRequest req = new HttpRequest ();
        String body = 'secret=' + recaptcha_secret + '&response=' + response + '&remoteip=' + remoteHost;
        req.setEndpoint('https://www.google.com/recaptcha/api/siteverify'); 
        req.setMethod ('POST');
        req.setBody(body);
        Boolean success;
        if(!Test.isRunningTest()){
            HttpResponse resp = h.send(req);
            Map <String, Object> jsonMap = (Map <String, Object>) JSON.deserializeUntyped(resp.getBody());
            
            System.debug(resp.getBody());
            success = (Boolean) jsonMap.get('success');
        } else {
            success = true;
        }
        
        return success;
    }
    
    private String remoteHost {
        
        get { 
            
            String ret = '127.0.0.1';
            Map<String, String> hdrs = ApexPages.currentPage().getHeaders();
            
            if (hdrs.get('x-original-remote-addr')!= null) {
                ret =  hdrs.get('x-original-remote-addr');
            } else if (hdrs.get('X-Salesforce-SIP')!= null){
                ret =  hdrs.get('X-Salesforce-SIP');
            }
            
            return ret;
        }
    }
    
    private static String createPortalUserForTest(String testemail, Contact c, String locale, String profile){
        Profile p =  [select Id from profile where name=:profile limit 1];
        User pu = new User(profileId = p.id, username = testemail, email = testemail,
                           emailencodingkey = 'UTF-8', localesidkey = locale,
                           languagelocalekey = locale, timezonesidkey = 'America/Los_Angeles',
                           alias='cspu', lastname='lastname', contactId = c.id);
        insert pu;
        return pu.Id;
    }
    
    
    
}