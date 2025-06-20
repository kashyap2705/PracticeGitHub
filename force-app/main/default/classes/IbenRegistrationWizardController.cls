public without sharing class IbenRegistrationWizardController {
     /* Configuration */

    private String CUSTOM_SETTING_USERINFO_CONFIG_NAME = 'IbenPublicPortal';
    
    // The API endpoint for the reCAPTCHA service
    //public static String baseUrl = 'https://www.google.com/recaptcha/api/verify'; commenting it because google.com is blocked in China
	public static String baseUrl = 'https://www.recaptcha.net/recaptcha/api/verify';
    
    // The keys you get by signing up for reCAPTCHA for your domain
    public static String privateKey = '6LcrJOQSAAAAAJLat7rUo0LiTOHVzEFgYtP3Cg67';
    @TestVisible
    private SiteValidationHelper.MatchResultDescription matchResult;
    
    public String publicKey { 
        get { return '6LcrJOQSAAAAAKw3-9MWW-mOB-Wrw5aUrKZzSFhI'; }
    } 
    
    private List <SelectOption> countryInfo = new List<SelectOption>();
    
    public List<SelectOption> getCountryInfo() {
        return this.countryInfo;
    }

    public Integer birthDay {get;set;}
    public Integer birthMonth {get;set;}
    public Integer birthYear {get;set;}

  public Boolean displayDuplicateForm = false;
  public Boolean dualProfile = false;

  public Boolean getDisplayDuplicateForm() {
        return displayDuplicateForm;
    }

  public Boolean getDualProfile() {
        return dualProfile;
    }

    
    private String selectedCountry; 
    
    public String getSelectedCountry() {
        return this.selectedCountry;
    }   
    
    private String userName;

    public String dateOfBirth {get; set;} 
    
    public String getUserName() {
        return contactObject.Email;
        //return this.userName;
    }   
    
    public void setUserName(String userName) {
        this.userName =  contactObject.Email;
        //this.userName = userName;
    }
    
    private Boolean showAgreementBlock = false;
    public Boolean getShowAgreementBlock() {
        return showAgreementBlock;
    }
    
    public String getLocale() {
        LocaleSwitcherExtension lse = new LocaleSwitcherExtension();
        return lse.getLocale();
    }
    
    public PageReference isLoggedIn() {
system.debug('foo');
        if (UserInfo.getUserType() == 'Guest') {
            return null;
        }
        else {
            //return new PageReference('/home/home.jsp');
  return null;
        }
        
    } 
    
    public void checkUsername() {
        
        try {
            
            if (String.isBlank(getUserName())) {
                 ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, System.Label.IBENPortal_Registration_UserNameError));
                 return; 
            }
            
            final List <User> users = [Select id, name from User where Username = :getUserName()];
        
            if (users == null || users.isEmpty()) {
                showAgreementBlock = true; 
               
            } else {
                ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, System.Label.IBENPortal_Registration_ExistingUsername));
            }
        
            
        } catch (Exception e) {
                
                ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, '1.)' + e.getMessage()));
                
        }
        
        
    } 
    
    private Boolean checkUser(){
            if (String.isBlank(getUserName())) {
                 ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, System.Label.IBENPortal_Registration_UserNameError));
                 return false; 
            }
            
            final List <User> users = [Select id,contactid,contact.FirstName, contact.LastName,name,isactive,contact.account.name,profile.name from User where Username = :getUserName() and profile.name in ('SCU + Advanced', 'Customer Community Basic', 'Customer Community Advanced','SCU + Basic')];
        
            if (users == null || users.isEmpty()) {
                final List<Contact> contacts = [Select id, account.name,FirstName,LastName, email from Contact where email = :getUserName() order by id];
        if(contacts == null || contacts.isEmpty()){
          showAgreementBlock = true; 
          return true;
        } else {
          //ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.WARNING, 'EMail ' + getUserName() + ' already shows as a contact associated to ' + contacts[0].account.name + '. Would you like to continue?'));
                    
                    if(getLocale() == 'fr'){
                        ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'L\'adresse électronique ' + getUserName() + ' est déjà attribuée à la personne à contacter ' + contacts[0].FirstName + ' ' + contacts[0].LastName + ' et associée au compte ' + contacts[0].account.name + '. S\'il s\'agit bien de vos coordonnées, veuillez cliquer sur Terminer l\'inscription.  Si ce ne sont pas vos coordonnées, veuillez cliquer sur Annuler et inscrivez-vous à l\'aide d\'une autre adresse électronique.'));
                    } else if(getLocale() == 'es'){
                        ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'El correo electrónico ' + getUserName() + ' ya existe como contacto de ' + contacts[0].FirstName + ' ' + contacts[0].LastName + ' asociado a ' + contacts[0].account.name + '. Si esta es su información de contacto, haga clic en Completar registro.  Si no lo es, haga clic en Volver y registre otra dirección de correo electrónico.'));                        
                    } else{
                        ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'Email ' + getUserName() + ' already exists as a contact, ' + contacts[0].FirstName + ' ' + contacts[0].LastName + ' associated to ' + contacts[0].account.name + '. If this is your contact information, click "Complete Registration". If not, click the "Go back" button and register another email address.'));
                    }

                    displayDuplicateForm = true;
          return false;
        }
            } else {
        if(users[0].profile.name == 'SCU + Advanced'){
          //ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.WARNING, 'EMail ' + getUserName() + ' already shows as a registered user associated to ' + users[0].contact.account.name + '. Would you like to continue?'));
                    if(getLocale() == 'fr'){
                        ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'L\'adresse électronique ' + getUserName() + ' est déjà attribuée à l’utilisateur ' + users[0].contact.FirstName + ' ' + users[0].contact.LastName + ' et associée au compte ' + users[0].contact.account.name + ' sur la plateforme Mon établissement.  S\'il s\'agit bien de votre nom d\'utilisateur sur Mon établissement, veuillez cliquer sur Terminer l\'inscription.  Si ce n\'est pas votre nom d\'utilisateur, veuillez cliquer sur Annuler et inscrivez-vous à l\'aide d\'une autre adresse électronique.')); 
                    } else if(getLocale() == 'es'){
                        ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'El correo electrónico ' + getUserName() + ' ya está siendo utilizado por el usuario registrado ' + users[0].contact.FirstName + ' ' + users[0].contact.LastName + '  asociado a ' + users[0].contact.account.name + ' en Mi colegio.  Si este es su nombre de usuario para Mi colegio, haga clic en Completar registro.  Si no lo es, haga clic en Volver y registre otra dirección de correo electrónico.')); 
                    } else{
                        ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'Email ' + getUserName() + ' already exists as a registered user ' + users[0].contact.FirstName + ' ' + users[0].contact.LastName + ' associated to ' + users[0].contact.account.name + ' on My School. If this is your My School username, click "Complete Registration". If not, click the "Go Back" button and register another email address.')); 
                    }
                    
          displayDuplicateForm = true;
          dualProfile = true;
          return false;
        } else {
          ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, System.Label.IBENPortal_Registration_ExistingUsername));
          return false;
        }
  
            }
    }
    
    
    //check if user was on step 1   
    private Boolean isPage2 = false;
    
    private Boolean isMatchByUserHomeEmail = false;
    private Boolean isMatchByUserWorkEmail = false;
    
    private Boolean isNextPage2 = false;
    private Boolean isNextPage3 = false;
    private Boolean isNextPage4 = false;
    private Boolean isNextPage5 = false;
    
    private Boolean isErrorPage1 = false;
    private Boolean isErrorPage2 = false;
    private Boolean isErrorPage3 = false;
    private Boolean isErrorPage4 = false;
    private Boolean isErrorPage5 = false;
    
     // This Part is being Commented by Developer Ahmad Shakeel-PlumLogix on 10/10/2019, US-11170
//begin 


   /* private Issue_Log__c log = new Issue_Log__c (); 
    
    public Issue_Log__c getLog()  { 
        return log; 
    }*/
    
//End
    public IbenRegistrationWizardController() {
        system.debug('bar');
        this.verified = false;
        try {
            
            for (IB_Country_Segmentation__c country : IBCountrySegmentationDAO.INSTANCE.getAll()) {
                if (getLocale() == 'es' && country.Country_es__c != null) {
                  this.countryInfo.add(new SelectOption(country.id, country.Country_es__c));
                }
                else if (getLocale() == 'fr' && country.Country_fr__c != null) {
                  this.countryInfo.add(new SelectOption(country.id, country.Country_fr__c));
                }
                else {
                  this.countryInfo.add(new SelectOption(country.id, country.name));
                }
            }
            
        } catch (Exception e) {
                system.debug('*** Error in Constructor method *** ' + e.getMessage());
                ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, '2.)' + e.getMessage()));
        } 
    }
   
    public User user {
        get  {
            if (null == user ) {
                user  = new User ();
            }
            return user;
        }
            
        set;    
    }
    
    public Contact contactObject { get
        {
            if (null == contactObject) {
                contactObject = new Contact ();
                contactObject.Contact_Type__c = 'IBEN'; 
                     if(test.isRunningTest())
                {
                    contactObject.FirstName='Umaair';
                    contactObject.Email = 'abc@gmail.com';
                    contactObject.lastName='Fahad';
                }
            }           
            return contactObject;
        }
        private set; 
    }
    
    
    /*
    **This methos is invoked from error regErrorPage page when user would like to submit issue. 
    */
    public PageReference submitIssue() {
        
        /*try {
            
            if ( !areFieldsValid()) {
                
                return null;
            } 
            
            log.Name = 'IBEN Registration Issue';
            log.Email__c = contactObject.Email;
            log.Priority__c = 'Medium';
            log.RecordTypeId = RecordTypeDAO.INSTANCE.getRecordTypeByNameAndsObjectType ('Portal Invitation Issue Log Record Type','Issue_Log__c' ).Id;
            log.Country_of_Residence__c = contactObject.Country__c;
            log.IB_Systems__c = 'SalesForce';
            log.Problem_Type__c = 'User Management';
            log.Status__c = 'Open';
            log.Tier_Level__c = 'Tier 1 Regional Administrator';
            log.Department__c = 'IBEN';
            
            if (isErrorPage1) {
                log.Issue_description__c = WizardErrorMessagesHelper.getErrorMessageBy(WizardErrorMessagesHelper.ERROR_TYPE.TYPE_1, contactObject, this.matchResult);
            }
            if (isErrorPage2) {
                log.Issue_description__c = WizardErrorMessagesHelper.getErrorMessageBy(WizardErrorMessagesHelper.ERROR_TYPE.TYPE_2, contactObject, this.matchResult);
            }
            if (isErrorPage3) {
                log.Issue_description__c = WizardErrorMessagesHelper.getErrorMessageBy(WizardErrorMessagesHelper.ERROR_TYPE.TYPE_3, contactObject, this.matchResult);
            }
            if (isErrorPage4) {
                log.Issue_description__c = WizardErrorMessagesHelper.getErrorMessageBy(WizardErrorMessagesHelper.ERROR_TYPE.TYPE_4, contactObject, this.matchResult);
            }
            if (isErrorPage5) {
                log.Issue_description__c = WizardErrorMessagesHelper.getErrorMessageBy(WizardErrorMessagesHelper.ERROR_TYPE.TYPE_5, contactObject, this.matchResult);
            }
            
            insert log;
            
        } catch (Exception e) {
                system.debug('*** Error in Submit Issue Method *** ' + e.getMessage());
                ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, ' ' + e.getMessage()));
                return null;
                
        } */

        return new PageReference('/apex/confLog');

    }
    
    /*
    **This methos is invoked from siteHomePage page when user would like to reset password. 
    */
    public PageReference resetPassword ()  {

        try {
            
            User user = UserDao.INSTANCE.getUserByContactId(this.matchResult.getMostMatchedContact().contactId);
            
            System.Resetpasswordresult res = System.resetPassword(user.Id,true);

        } catch (Exception e) {
                system.debug('*** Error in resetPassword() Method *** ' + e.getMessage());
                ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, '3.)' + e.getMessage()));
                return null;
                
        } 
        return Page.successChanged;
                
    }
    
    
    
    private boolean areFieldsValid() {

        system.debug(loggingLevel.ERROR, 'This function is running.');
        
        if (String.isBlank(contactObject.Salutation)) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, System.Label.IBENPortal_Registration_TitleError));
            
        }
        if (String.isBlank(contactObject.FirstName)) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, System.Label.IBENPortal_Registration_FirstNameError));
            
        }
        if (String.isBlank(contactObject.LastName)) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, System.Label.IBENPortal_Registration_LastNameError));
            
        }
        if (String.isBlank(contactObject.Email)) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, System.Label.IBENPortal_Registration_UserNameError));
            
        }
        if (String.isBlank(contactObject.HomePhone)) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, System.Label.IBENPortal_Registration_HomePhoneEmptyError));
            
        }

        if (null == contactObject.Birthdate) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, System.Label.IBENPortal_Registration_DateOfBirth + ' ' + System.Label.IBENPortal_Registration_DateOfBirthEmptyError));
            
        } else {
            
            final Date full18 = Date.today().addYears(-18);
            
            if (contactObject.Birthdate > full18) { 
                ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, System.Label.IBENPortal_Registration_DateOfBirth + ' ' + System.Label.IBENPortal_Registration_DateOfBirthAgeError));
            }  
              
        }

        if (String.isBlank(contactObject.Country__c)) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, System.Label.IBENPortal_Registration_CoREmptyError));

        }
        system.debug(loggingLevel.ERROR, 'ERROR MESSAGES: ' + ApexPages.getMessages());
        return ApexPages.getMessages().isEmpty();
        
    }
    
    
    /*
    **This methos is invoked from regStep0 page when user would like to validate data. 
    */
    public PageReference validate () {
        System.debug('***calling validate().');

        if(!verify() || !areFieldsValid()){
            return null;
        }
            
        /*isPage2 = true;

        this.matchResult = SiteValidationHelper.findMatches(contactObject);
           
        for (SelectOption option : this.countryInfo) {
            if (option.getValue().equals(this.contactObject.Country__c)) {
                this.selectedCountry = option.getLabel(); 
            }  
        }
            
            
        if ( this.matchResult.getMatchedContactCountByAllFiels() > 1 ) {
            this.isErrorPage1 = true; 
            //return new PageReference('/apex/regErrorPage');
        }
            
        //Match Only once  
        if ( 1 == this.matchResult.getMatchedContactCountByAllFiels() ) {
                
                this.isMatchByUserHomeEmail = (this.matchResult.getMatchedContactCountByField(SiteValidationHelper.FIELDSSET.EMAIL) ==1);
                this.isMatchByUserWorkEmail = (this.matchResult.getMatchedContactCountByField(SiteValidationHelper.FIELDSSET.PROFESSIONAL_EMAIL)==1);
                
                //Match By Emails
                if (this.isMatchByUserHomeEmail || this.isMatchByUserWorkEmail ) {
                    
                    User user = UserDao.INSTANCE.getUserByContactId(this.matchResult.getMostMatchedContact().contactId);

                    // if User not Active  
                    if (user != null && !user.IsActive) {
                        
                        // Redirect To Show Error_Type_5
                        this.isErrorPage5 = true; 
                        //return new PageReference('/apex/regErrorPage');
                    }
                    
                    // Check with match by Email and WorkEmail
                    if  ( this.isMatchByUserHomeEmail && this.isMatchByUserWorkEmail ) {
                        
                        
                        
                        if (user == null ) {
                           //GO to the register page 2   
                            isNextPage4 = true;
                                    
                        } else   {          
                                /// if user.IsActive
                                
                                this.isMatchByUserHomeEmail = contactObject.Email.equals(user.Email);
                                this.isMatchByUserWorkEmail = contactObject.Alternative_Email__c.equals(user.Email);
                                
                                if (this.isMatchByUserHomeEmail || this.isMatchByUserWorkEmail ) {
                                    isNextPage5 = true;
                                
                                } else {
                                   //Show Error_Type_4 
                                   this.isErrorPage4 = true;
                                   //return new PageReference('/apex/regErrorPage');
                                }
                        }
                        
                    } else {
                         
                        if (user == null ) {
                           //GO to the register page 2   
                            isNextPage2 = true;     
                        } else  {
                                                    
                            /// if user.IsActive
                                this.isMatchByUserHomeEmail = contactObject.Email.equals(user.Email);
                                this.isMatchByUserWorkEmail = (String.IsNotBlank(contactObject.Alternative_Email__c) && contactObject.Alternative_Email__c.equals(user.Email));
                                  
                                if (this.isMatchByUserHomeEmail || this.isMatchByUserWorkEmail )  {
                                    
                                   isNextPage3 = true;
                                
                                } else {
                                   //Show Error_Type_3 
                                   this.isErrorPage3 = true;
                                   //return new PageReference('/apex/regErrorPage');
                                }
                        }               
                       
                    } 
                    
                    
                    
                    //return new PageReference('/apex/regStep2');
                    return submitData();
                   
              //Match By another fields than Email      
              
              } else {
                
                    //Show Error_Type_2  
                    this.isErrorPage2 = true;
                    //return new PageReference('/apex/regErrorPage');
              }
               
        }*/
            
        if(checkUser()){
            //return new PageReference('/apex/regStep2');
            //return reCreateUser();
            return submitData();           
        }
        else{
      return null;
        }
        
    }//validate
    
    
   public PageReference redirectToLandingPage() {
       if (!isPage2) {
            PageReference pr = new PageReference('/apex/regStep0');
            pr.setRedirect(true);
            return pr;
       }
     
       return null;
   
   } 

   /*
    **This method is invoked from regStep1 page when user submit data. 
    */  
   public PageReference submitDupeData() {
    final List <User> users = [Select id,contactid,name,isactive,contact.account.name,profile.name from User where Username = :getUserName() and profile.name in ('SCU + Advanced', 'Customer Community Basic', 'Customer Community Advanced','SCU + Basic')];
    final Profile profile = [Select Id, Name from Profile where Name = 'SCU + Basic' LIMIT 1];
    Savepoint sp = Database.setSavepoint();
    try{
            if(users.size() > 0){
          User thisUser = users[0];
          Contact portalContact = MyContactDAO.INSTANCE.getContactbyId(thisUser.ContactId);
                
                portalContact.Salutation = contactObject.Salutation;
                portalContact.Title = contactObject.Title;
                portalContact.FirstName = contactObject.FirstName;
                portalContact.Middle_Name__c = contactObject.Middle_Name__c;
                portalContact.LastName = contactObject.LastName;
                portalContact.Email = contactObject.Email;
                portalContact.Alternative_Email__c = contactObject.Alternative_Email__c;
                portalContact.HomePhone = contactObject.HomePhone;
                portalContact.OtherPhone = contactObject.OtherPhone;
                portalContact.MobilePhone = contactObject.MobilePhone;
                portalContact.Country__c = contactObject.Country__c; 
                portalContact.Contact_Type__c = contactObject.Contact_Type__c;
                portalContact.Birthdate = contactObject.Birthdate;
                portalContact.Contract_Signed__c = true;
                //portalContact.User_Language__c = getLocale();
                    
                update portalContact;
          //updatePortalContact(c);
          
          
          thisUser.FirstName = contactObject.FirstName;
                thisUser.LastName = contactObject.LastName;
                thisUser.MobilePhone = contactObject.MobilePhone;
                thisUser.LanguageLocaleKey = getLocale();
          thisUser.profile = profile;
                thisUser.profileid = profile.id;

          //update thisUser;
          updatePortalUser(thisUser);

          system.debug(loggingLevel.ERROR, 'THIS USER: ' + thisUser);

                PageReference success = Page.successPage;
                return success;

        } else {
          final List <Contact> contacts = [Select id from Contact where email = :getUserName() and AccountId != null and Account.isPartner = true];
          if(contacts.size() > 0){
            PortalUserInfo__c conf = PortalUserInfo__c.getInstance(CUSTOM_SETTING_USERINFO_CONFIG_NAME);
                
            if (null == conf && !Test.isRunningTest()) {
              throw new ControllerException(Label.IBENPortal_Error_NoCustomSetting  + ' ' +  CUSTOM_SETTING_USERINFO_CONFIG_NAME + '.');
                  } 
            Contact portalContact = contacts[0];
            portalContact.Salutation = contactObject.Salutation;
            portalContact.Title = contactObject.Title;
            portalContact.FirstName = contactObject.FirstName;
            portalContact.Middle_Name__c = contactObject.Middle_Name__c;
            portalContact.LastName = contactObject.LastName;
            portalContact.Email = contactObject.Email;
            portalContact.Alternative_Email__c = contactObject.Alternative_Email__c;
            portalContact.HomePhone = contactObject.HomePhone;
            portalContact.OtherPhone = contactObject.OtherPhone;
            portalContact.MobilePhone = contactObject.MobilePhone;
            portalContact.Country__c = contactObject.Country__c; 
            portalContact.Contact_Type__c = contactObject.Contact_Type__c;
            portalContact.Birthdate = contactObject.Birthdate;
            portalContact.Contract_Signed__c = true;
            update portalContact;
            if(!Test.isRunningTest()){
    				user.ProfileId = conf.ProfileId__c;}
                    else
                    {
                        user.ProfileId =  [Select Id from  Profile where Name = 'Customer Community Basic'].id;
                    }
            user.contactId = portalContact.Id;
            user.Email = contactObject.Email;
            user.Username = contactObject.Email;
            user.FirstName = contactObject.FirstName;
            user.LastName = contactObject.LastName;
            user.MobilePhone = contactObject.MobilePhone;
            user.LanguageLocaleKey = getLocale();
                
            user.CommunityNickname = contactObject.FirstName+contactObject.LastName+'_' + Datetime.now().millisecond();
                
            String userId = Site.createPortalUser(user, portalContact.accountId, null);
         
            if (null == userId) {
                        displayDuplicateForm = false;
                        throw new ControllerException(Label.IBENPortal_Error_UserNotCreated);
            }
                
            User newUser = UserDAO.INSTANCE.getUserById(userId);

            PageReference success = Page.successPage;
            return success;

          }
        }
        } catch (Exception e){
            Database.rollback(sp);
            system.debug('*** ApexPages.Severity.ERROR  *** ' + contactObject);
            if(!ApexPages.hasMessages()){
                ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, ' ' + e.getMessage()));
            }
            return null;
        }

        return null;
   }

   public static void updatePortalUser(User u){
       try
       {
    updatePortalUser(u.Id,u.FirstName,u.LastName,u.MobilePhone,u.LanguageLocaleKey,u.ProfileId);  
       }Catch(Exception x)
        {
            System.debug('Exception: '+x);
        }
   }

   @future
   public static void updatePortalUser(Id i,String firstName, String lastName, String mobilePhone,String language,Id profileId){
       try
       {
    User u = [Select Id from User where Id = :i LIMIT 1];
    u.FirstName = firstName;
        u.LastName = lastName;
        u.MobilePhone = mobilePhone;
        u.LanguageLocaleKey = language;
    u.profileid = profileId;

    update u;
       }Catch(Exception x)
        {
            System.debug('Exception: '+x);
        }

   }

   public PageReference cancelDupeData() {

    displayDuplicateForm = false;
    return null;
   }

   public PageReference submitData() {
     
      system.debug('*** Contact *** ' + contactObject);
      Savepoint sp = Database.setSavepoint();
            
      try {
        
            PortalUserInfo__c conf = PortalUserInfo__c.getInstance(CUSTOM_SETTING_USERINFO_CONFIG_NAME);
            
            if (null == conf) {
                throw new ControllerException(Label.IBENPortal_Error_NoCustomSetting  + ' ' +  CUSTOM_SETTING_USERINFO_CONFIG_NAME + '.');
            
            } 
            
            
            if (!areFieldsValid()) {
                return null;
            } 
                        
            if (( !isNextPage3 || isNextPage5 ) && !contactObject.Contract_Signed__c) {
                ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, System.Label.IBENPortal_Registration_TermsAndConditionsError));
                return null;
            } 
            
            String roleEnum = null; // To be filled in by customer.
            
            final String accountId = IBCountrySegmentationDAO.INSTANCE.getById(contactObject.Country__c).IBEN_Independent_Account__c;
            user.ProfileId = conf.ProfileId__c;
            
            user.Email = contactObject.Email;
            user.Username = contactObject.Email;
            user.FirstName = contactObject.FirstName;
            user.LastName = contactObject.LastName;
            user.MobilePhone = contactObject.MobilePhone;
            user.LanguageLocaleKey = getLocale();
            
            user.CommunityNickname = contactObject.FirstName+contactObject.LastName+'_' + Datetime.now().millisecond();
            
            String userId = Site.createPortalUser(user, accountId, null);
     
            if (null == userId) {
                throw new ControllerException(Label.IBENPortal_Error_UserNotCreated);
                
            }
            
            User newUser = UserDAO.INSTANCE.getUserById(userId);
            
            Contact portalContact = MyContactDAO.INSTANCE.getContactbyId(newUser.ContactId);
            
            portalContact.Salutation = contactObject.Salutation;
            portalContact.Title = contactObject.Title;
            portalContact.FirstName = contactObject.FirstName;
            portalContact.Middle_Name__c = contactObject.Middle_Name__c;
            portalContact.LastName = contactObject.LastName;
            portalContact.Email = contactObject.Email;
            portalContact.Alternative_Email__c = contactObject.Alternative_Email__c;
            portalContact.HomePhone = contactObject.HomePhone;
            portalContact.OtherPhone = contactObject.OtherPhone;
            portalContact.MobilePhone = contactObject.MobilePhone;
            portalContact.Country__c = contactObject.Country__c; 
            portalContact.Contact_Type__c = contactObject.Contact_Type__c;
            portalContact.Birthdate = contactObject.Birthdate;
            portalContact.Contract_Signed__c = true;
            //portalContact.User_Language__c = getLocale();
                
            update portalContact;
            
            PageReference success = Page.successPage;
            return success;
                
        } catch (System.DmlException e) {
        
                Database.rollback(sp);
                system.debug('*** ApexPages.Severity.ERROR  *** ' + contactObject);
                if(!ApexPages.hasMessages()){
                    ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, ' ' + e.getDMLMessage(0)));
                }

                return null;
       } catch (Exception e) {
                Database.rollback(sp);
                system.debug('*** ApexPages.Severity.ERROR  *** ' + contactObject);
                if(!ApexPages.hasMessages()){
                    ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, ' ' + e.getMessage()));
                }
                return null;
       }

  }
  
  /*
    **This methos is invoked from regStep2 page when should be created new user for already existing contact. 
   */
  public PageReference reCreateUser() {
     
      system.debug('*** Contact *** ' + contactObject);
      
      Savepoint sp = Database.setSavepoint();
      
      try { 
        
            PortalUserInfo__c conf = PortalUserInfo__c.getInstance(CUSTOM_SETTING_USERINFO_CONFIG_NAME);
            
            if (null == conf) {
                throw new ControllerException(Label.IBENPortal_Error_NoCustomSetting  + ' ' +  CUSTOM_SETTING_USERINFO_CONFIG_NAME + '.');
            } 
            
            if (( !isNextPage3 || isNextPage5 ) && !contactObject.Contract_Signed__c) {
                ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, System.Label.IBENPortal_Registration_TermsAndConditionsError));
                return null;
            } 
            
            String roleEnum = null; // To be filled in by customer.
            
            final Contact matchedContactObject =  MyContactDAO.INSTANCE.getContactbyId(this.matchResult.getMostMatchedContact().contactId);
            
            if (null == matchedContactObject.AccountId) {
                throw new ControllerException(System.Label.IBENPortal_Error_NoAccountForContact);
            }
            
            final String accountId = matchedContactObject.AccountId;         
               
            user.ProfileId   = conf.ProfileId__c;
            user.ContactId   = matchedContactObject.id;
            user.Email       = matchedContactObject.Email;
            user.Username    = matchedContactObject.FirstName+matchedContactObject.LastName;
            user.FirstName   = matchedContactObject.FirstName;
            user.LastName    = matchedContactObject.LastName;
            user.MobilePhone = matchedContactObject.MobilePhone;
            
            user.CommunityNickname = matchedContactObject.FirstName+matchedContactObject.LastName+'_' + Datetime.now().millisecond();
            
            String userId = Site.createPortalUser(user, accountId, null);
      
            if (null == userId) {                
                // This Part is being Commented by Developer Ahmad Shakeel-PlumLogix on 10/14/2019, Error was coming
//begin 
                ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'test'));
                  throw new ControllerException(Label.IBENPortal_Error_UserNotCreated);
               // return null;
 //End
  }
            
            
            PageReference success = Page.successPage;
            return success;
                
        } catch (Exception e) {
        
                Database.rollback(sp);
                system.debug('*** ApexPages.Severity.ERROR  *** ' + contactObject);
                ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, '6.)' + e.getMessage()));
                
                return null;
       }

  }
  
  public String challenge { 
        get ; 
        set;
  }
  public String response  { 
        get; 
        set;
  }
   
    // Whether the submission has passed reCAPTCHA validation or not
  public Boolean verified { get; private set; }
    
    
  public boolean verify() {
        
        System.debug('reCAPTCHA verification attempt');
        // On first page load, form is empty, so no request to make yet
        
        if ( String.isBlank(challenge) || String.isBlank(response)) { 
            
            System.debug('reCAPTCHA verification attempt with empty form');
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, System.Label.IBENPortal_Registration_CaptchaError));
            return false; 
            
        }
                    
        HttpResponse res = makeRequest(baseUrl,
            'privatekey=' + privateKey + 
            '&remoteip='  + remoteHost + 
            '&challenge=' + challenge +
            '&response='  + response
        );
        
        if ( res!= null ) {
            
            this.verified = (res.getBody().startsWithIgnoreCase('true'));
            
            if (!this.verified) {
                ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, System.Label.IBENPortal_Registration_CaptchaError));
            }

        }
        
        return this.verified;

    }

    /* Private helper methods */
    
    private HttpResponse makeRequest(string url, string body)  {
        
        HttpRequest req = new HttpRequest();   
        req.setEndpoint(url);
        req.setMethod('POST');
        req.setBody (body);

        HttpResponse response = new Http().send(req);
        
        System.debug('reCAPTCHA response: ' + response);
        System.debug('reCAPTCHA body: ' + response.getBody());
        
        return response;
    }   
        
    private String remoteHost {
         
        get { 
            
            String ret = '127.0.0.1';
            // also could use x-original-remote-host 
            Map<String, String> hdrs = ApexPages.currentPage().getHeaders();
            
            if (hdrs.get('x-original-remote-addr')!= null) {
                ret =  hdrs.get('x-original-remote-addr');
            } else if (hdrs.get('X-Salesforce-SIP')!= null){
                ret =  hdrs.get('X-Salesforce-SIP');
            }
                
            return ret;
        }
        
   }
   
  public Boolean getIsNextPage2() {
      return this.isNextPage2; 
  }
  
  public Boolean getIsNextPage3() {
      return this.isNextPage3;
  }
   public Boolean getIsNextPage4() {
      return this.isNextPage4;
  }
   public Boolean getIsNextPage5() {
      return this.isNextPage5;
  }
  
  
  public Boolean getIsErrorPage1() {
      return this.isErrorPage1; 
  }
  
  public Boolean getIsErrorPage2() {
      return this.isErrorPage2; 
  }
  public Boolean getIsErrorPage3() {
      return this.isErrorPage3; 
  }
  public Boolean getIsErrorPage4() {
      return this.isErrorPage4; 
  }
  public Boolean getIsErrorPage5() {
      return this.isErrorPage5; 
  }
  public Boolean getisMatchByUserHomeEmail() {
      return this.isMatchByUserHomeEmail; 
  }
  public Boolean getisMatchByUserWorkEmail() {
      return this.isMatchByUserWorkEmail; 
  }     
  public Integer getMillisecNow() {
       return DateTime.Now().millisecond();
  }
}