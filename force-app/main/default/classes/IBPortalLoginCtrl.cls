/*******************************************************************************************
* @Name         IBPortalLoginCtrl 
* @Author       
* @Date         
* @Group        
* @Description  
*******************************************************************************************/
/* MODIFICATION LOG
* Version          Developer          Date               Description
*-------------------------------------------------------------------------------------------
* 1.0          Ranjith Kondabathini 07th June, 2023		Commented setProgrammeDefaultRoles method as it will be handled in the trigger directly
*******************************************************************************************/
public without sharing class IBPortalLoginCtrl {
    
  @testVisible public String username {get; set;}
  @testVisible public String password {get; set;}    
  @testVisible public String labelWelcom {get;set;}
  
  public Boolean TLS_NewNote_Text {get;set;}
  public static PageReference pageRef;
  public static PageReference loginRef;
  
  @testVisible public static String invitationID {get;set;}
  @testVisible public static String languageParam {get;set;}
  // Below line added by Charan | 25-04-2024
  @testVisible public static String portalStartUrl {get; set;}
  @testVisible public static Contact invitationContact {get; set;}
  @testVisible public static List<IB_Role__c>  rolesList {get;set;}
  @testVisible public static List<IB_Role__c> inviteRolesList {get;set;}
  @testVisible public static Contact userContact{get;set;}
  
  public static List<User> userId {get; set;} 
  
  //show maintenance banner when needed
  public Boolean getshowbanner(){
      for( Maintenance_Banner__mdt maintenanceBanner:[SELECT Banner_Visible__c,DeveloperName FROM Maintenance_Banner__mdt WHERE DeveloperName='Maintenance'])
      {
          return maintenanceBanner.Banner_Visible__c;
      }
      return false;
  }
  
  public IBPortalLoginCtrl(){
      
      invitationID = System.currentPageReference().getParameters().get('inviteid');
      languageParam = System.currentPageReference().getParameters().get('lang');
      // Below line added by Charan | 25-04-2024
      portalStartUrl = System.currentPageReference().getParameters().get('startURL');
      system.debug('InvitPlum'+invitationID);
      
      if(invitationID != null && invitationID !='')
      {
          //Following Custom label is added by Shehryar-plumlogix,as part of US-12224 on 04/27/2021
          //Start
          //   labelWelcom = Label.TLS_Text_v2;
          labelWelcom = Label.TLS_NewNote_Text;
          TLS_NewNote_Text=true;
          // tls_text_v2 =true;
          // tls_text = false;
      } 
      else
      {
          // labelWelcom = Label.TLS_Text;
          labelWelcom = Label.TLS_NewNote_Text;
          TLS_NewNote_Text=true;
          //tls_text_v2 =false;
          //tls_text = true;
          //End
      }
      
  }
  
  public static List<String> errorMessages {
      get {
          if(errorMessages == null){
              errorMessages = new List<String>();
          }
          return errorMessages;
      }
      set;
  }
  
  public static Integer errorCount {
      get {
          if(errorCount == null){
              errorCount = 0;
          }
          return errorCount;
      }
      set;
  }
  
  @auraEnabled
  public Static String login(String username, String password,String language, String invitationID) {
      
      String startUrl = '%2FIBPortalLogin%2F';
      languageParam = language;        
      errorCount = errorMessages.size();
      Map<String, String> invitationRoleMap= new Map<String,String>();
      String invitedRole;
      
      if (invitationID != null && invitationID != '') {
          startUrl = startUrl + '?merUs=true';
      } 
      
      try {
          
           pageRef = Site.login(username, password, startUrl);
          Integer loginCount = 0; 
          List<LoginHistory> LH = new List<LoginHistory>();
          
          userId = [SELECT id , Name, IsActive,email,LanguageLocaleKey FROM User WHERE Username = :username LIMIT 1];
          if (userID.size() > 0) {
              
              Datetime FifteenMinBack = Datetime.now().addMinutes(-15);
              LH = [SELECT status FROM LoginHistory WHERE Userid IN : userId AND LoginTime >= :FifteenMinBack ORDER BY LoginTime DESC LIMIT 5];
              
              for (LoginHistory l : LH) {
                  
                  if (l.status == 'Invalid Password' || l.status == 'Password Lockout') {
                      loginCount++;
                  }
                  
              }
              
              if (pageRef == null) {
                  
                  if (loginCount < 5) {
                      errorMessages.clear();
                      errorMessages.add(getErrorLabel('PIMS_Error_Login',languageParam));
                      loginCount=0;
                  } else {
                      errorMessages.clear();
                      errorMessages.add(getErrorLabel('PIMS_Error_Login_Lock',languageParam));
                      loginCount=0;
                  }
                  
                  if (!userId[0].IsActive) {
                      
                      errorMessages.clear();
                      errorMessages.add(getErrorLabel('PIMS_Error_Login_inActive',languageParam));
                      loginCount = 0;
                      
                      Map<String,Id> mapemail = new Map<String,Id>();
                      mapemail.put('recordID',userId[0].Id);
                      mapemail.put('forgotPassword',userId[0].Id);
                      
                      Flow.Interview.LWC_Email_Flow flowCall = new Flow.Interview.LWC_Email_Flow(mapemail);
                      flowCall.start();
                      
                  }
                  
              } else {
                  
                  if (invitationID != null && invitationID != '') {
                      
                      userContact = MyContactDAO.INSTANCE.getContactbyEmail(username);
                      
                      // Commented out following one line while solving permission sets issue.
                      // changeProfileFutureMethodClass.changeProfileMethod(username);  
                                              
                      invitationContact = [SELECT Id, Invitation_ID__c, RecordType.Id, account.Id, Email, Invite_Accepted__c FROM Contact WHERE Invitation_ID__c = :invitationID]; 
                                              
                      RoleService.setAccountId(invitationContact.accountId);
                      rolesList = RoleService.getRolesByAccountId();
                      
                      inviteRolesList = new List<IB_Role__c>();
                      
                      for (IB_Role__c r : rolesList) {
                          if (r.IB_Contact__c == invitationContact.id) {
                              inviteRolesList.add(r);
                          }
                      }
                      
                  }
              }  
             
          } else {
              errorMessages.add(getErrorLabel('PIMS_Error_Login',languageParam));
          }            
          
          if (userContact != null ) {
              set<Id> roleAccountIds= new Set<Id>();// added by kashyap
          set<Id> roleIBProgrammes = new Set<Id>();// added by kashyap
              
              List<IB_Role__c>invitationRoleList = new List<IB_Role__c>(); 
              userContact.Email = invitationContact.Email;
              
              if (inviteRolesList != null && !inviteRolesList.isEmpty()) {
                  
                  for (IB_Role__c invitationRole : inviteRolesList) {
                      
                      invitationRole.End_Date__c = Date.TODAY();
                      invitationRole.IB_Contact__c = userContact.Id;                                            
                      invitationRole.RecordTypeId =  Schema.SObjectType.IB_Role__c.getRecordTypeInfosByName().get('Confirmed').getRecordTypeId();
                      //Following code line is added by Umair-Plumlogix of ADAS project on 11/01/2021
                      if(invitationRole.IB_Role_Name__c !='Admin Assistant'){
                        invitationRole.Status__c = 'Confirmed';
                      }
                      invitationRole.End_Date__c = null;
                      invitationRoleList.add(invitationRole);
                      
                      roleAccountIds.add(invitationRole.IB_Account__c);
                      roleIBProgrammes.add(invitationRole.IB_Programme_New__c);
                      
                      if(languageParam == 'es'){
                         invitedRole = invitationRole.IB_Role_Name_es__c;
                      }else if(languageParam == 'fr')
                      {	invitedRole = invitationRole.IB_Role_Name_fr__c;
                      }else{
                         invitedRole = invitationRole.IB_Role_Name__c;
                      }
                              
                      
                      
                  }
                  
                  if (invitationRoleList.size()>0) {
                      update invitationRoleList;
                  }
                  userContact.Invitation_ID__c = null;
                  
                  List<IB_Referee_Feedback__c> feedList = new List<IB_Referee_Feedback__c>();
                  feedList = [SELECT Id, IB_Contact__c, IB_Role__c FROM IB_Referee_Feedback__c WHERE IB_Contact__c =: invitationContact.id];
                  
                  for (IB_Referee_Feedback__c feed : feedList) {
                      feed.IB_Contact__c = userContact.Id;
                  }
                  
                  update feedList;
                  
                  //IB_RoleAfterInsertTriggerHandler.setProgrammeDefaultRoles(inviteRolesList);
                  
              }
              
              Id newId = invitationContact.AccountId;
              Id contactid=invitationContact.id;
              // US-0002286 start
              //Calling future method to delete invited contact after role merging                    
              //DeleteNewContactMadeforRole.DeleteContact(contactid);
              if(invitationContact!=null && invitationContact.id!=userContact.id ){
                delete invitationContact;
                }
              //US-0002286 end
              userContact.AccountId = newId;
              
              update userContact;
              
              
              /** Added functionality to notify the ProgrammCoordinator that invite has been responded and merged with existing contact **/
               List<IB_Role__c>  confirmedProgrammCoordinator=[select id,IB_Account__r.Name,IB_Contact__r.AccountId,IB_Contact__c,IB_Programme_New__c,
                                                              IB_Contact__r.Name,IB_Role_Name__c ,IB_Account__c,Email__c from IB_Role__c 
                                                              where 
                                                              IB_Account__c in : roleAccountIds
                                                              and 
                                                              IB_Programme_New__c in :roleIBProgrammes 
                                                              and
                                                              (IB_Role_Name__c ='Programme Coordinator') and Status__c= 'Confirmed' 
                                                              ];
              // US-0002286 added list size check
              if(confirmedProgrammCoordinator.size()>0 && confirmedProgrammCoordinator[0].Email__c != null){
                  EmailTemplate template;
                  if(languageParam == 'fr'){
                      template= [SELECT id, name, HtmlValue, Subject, Body FROM EmailTemplate WHERE developername ='Invited_Role_Accepted_fr'];
                  }else if (languageParam == 'es'){
                      template= [SELECT id, name, HtmlValue, Subject, Body FROM EmailTemplate WHERE developername ='Invited_Role_Accepted_es'];
                  }else{
                     template= [SELECT id, name, HtmlValue, Subject, Body FROM EmailTemplate WHERE developername ='Invited_Role_Accepted'];
                  }
                  
                                      
                  Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                  string[] ccAddress = new string[] {confirmedProgrammCoordinator[0].Email__c};   
                  email.setCCAddresses(ccAddress);
                  string[] toAddress = new string[] {userContact.Email};
                   String emailBody 		=  template.HtmlValue;
                  
                  emailBody 		= emailBody.replace('[Role Name]', invitedRole);   
                  emailBody 		= emailBody.replace('[Name of School]', confirmedProgrammCoordinator[0].IB_Account__r.Name); 
                  emailBody 		= emailBody.replace('[Last Name]', userContact.LastName);
                  emailBody 		= emailBody.replace(']]>', '');
                  
                  
                  email.setToAddresses(toAddress);
                  email.setHtmlBody(emailBody);
                  String emailSubject	= template.Subject;
                  emailSubject	= emailSubject.replace('[Role Name]', invitedRole);
                  emailSubject	= emailSubject.replace('[Name of School]', confirmedProgrammCoordinator[0].IB_Account__r.Name);
                  email.setSubject(emailSubject);
                  Messaging.sendEmail(new Messaging.SingleEmailMessage[] { email });
              }
              /** End of Added functionality to notify the ProgrammCoordinator that invite has been responded and merged with existing contact **/
              
          }                
          
          errorCount = errorMessages.size();
          
          saveCommunityActivity(username);
          
          if (pageRef != null) {
              return pageRef.getUrl();
          }
          
          String loginUrl= '/ibportal/IBPortalLogin';
          return errorMessages[0];            
          
      } catch (Exception e) {
          if (!Test.isRunningTest()) {
              throw new AuraHandledException(e.getMessage());
          }              
          
          return null;
      }
       
  }
 @AuraEnabled
  public Static String ibLogin(String username, String password,String language, String siteUrl) {
      
      errorCount = errorMessages.size();
      Map<String, String> invitationRoleMap= new Map<String,String>();
      String invitedRole;
      try {
          userId = [SELECT id ,FirstName,LastName, Name, IsActive,email,LanguageLocaleKey FROM User WHERE Username = :username LIMIT 1];           
           pageRef = Site.login(username, password, siteUrl);
          Integer loginCount = 0; 
          Boolean checkCommunityAccess = true;
          List<LoginHistory> LH = new List<LoginHistory>();
           if (userID.size() > 0) {
              
              Datetime FifteenMinBack = Datetime.now().addMinutes(-15);
              LH = [SELECT status FROM LoginHistory WHERE Userid IN : userId AND LoginTime >= :FifteenMinBack ORDER BY LoginTime DESC LIMIT 5];
              
              for (LoginHistory l : LH) {
                  
                  if (l.status == 'Invalid Password' || l.status == 'Password Lockout') {
                      loginCount++;
                  }
               }
              }         
         errorCount = errorMessages.size();
         saveCommunityActivity(username);
          
         
          if (pageRef != null) {
              system.debug('getUrl---'+pageRef.getUrl());
                 return 'Success||'+pageRef.getUrl();
          }
          
          String loginUrl= '/ibportal/IBPortalLogin';
          return 'Error||'+errorMessages[0];            
          
      } catch (Exception e) {
          system.debug('e---'+e.getMessage());
          /*if (e.contains('Your login attempt has failed. Make sure the username and password are correct.')) {
              //throw new AuraHandledException(e.getMessage() +'line no'+ e.getLineNumber()+'Cause**'+e.getCause());
          } */
          list<LoginHistory> LH = [
              SELECT status
              FROM LoginHistory
              WHERE Userid IN :userId
              ORDER BY LoginTime DESC
              LIMIT 1
          ];
          //system.debug('Status-->'+LH[0].status);
          if (!LH.isEmpty() && LH[0].status == 'No community access') {
              return 'ErrorNotCommunityUser||' + userId[0].FirstName;
          } else {
              return 'Error||' + e.getMessage();
          }
      }
}

// This method is used to update user community activity,US11136.
// @author: Ahmad shakeel-Plumlogix
// @since 10-11-2019
// @param String of userName.
// @return Void.

public static void saveCommunityActivity(string userName1) {
  try {
    List<String> months = new List<String>{
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    };
    String communityName, userName, lastCommunityVisit;
    String userN;

    DateTime lastLoginTime;
    Integer noOfVisit = 0;

    communityName = 'ibportal';
    userN = userName1;

    List<User> uName = [SELECT username FROM user WHERE username = :userN];

    if (uName.size() > 0) {
      userName = uName[0].Username;

      lastLoginTime = dateTime.now();
      String currentMonth = months.get(lastLoginTime.month() - 1);
      Integer currentYear = lastLoginTime.year();

      List<Community_Visit__c> cVisit = new List<Community_Visit__c>();
      cVisit = [
        SELECT Number_of_visits__c, Last_Community_Visit__c, Last_Login__c
        FROM Community_Visit__c
        WHERE
          User_Name__c = :userName
          AND Community_Name__c = :communityName
          AND Login_Year__C = :currentYear
          AND Login_Month__C = :currentMonth
      ];

      if (cVisit.size() == 0) {
        noOfVisit++;
        lastCommunityVisit = communityName;

        Community_Visit__c insertData = new Community_Visit__c(
          Community_Name__c = communityName,
          User_Name__c = userName,
          Number_of_visits__c = noOfVisit,
          Last_Login__c = lastLoginTime,
          Last_Community_Visit__c = lastCommunityVisit,
          Login_Year__C = currentYear,
          Login_Month__C = currentMonth
        );

        insert insertData;
      } else {
        noOfVisit = cVisit[0].Number_of_visits__c.intValue();
        lastCommunityVisit = cVisit[0].Last_Community_Visit__c;

        if (lastCommunityVisit != communityName) {
          noOfVisit++;
          lastCommunityVisit = communityName;
          Community_Visit__c updateData = new Community_Visit__c(
            id = cVisit[0].Id,
            Community_Name__c = communityName,
            Number_of_visits__c = noOfVisit,
            Last_Login__c = lastLoginTime,
            Last_Community_Visit__c = lastCommunityVisit
          );
          update updateData;
        } else if (
          lastCommunityVisit == communityName &&
          lastLoginTime > cVisit[0].Last_Login__c.addMinutes(5)
        ) {
          noOfVisit++;
          lastCommunityVisit = communityName;
          Community_Visit__c updateData = new Community_Visit__c(
            id = cVisit[0].Id,
            Community_Name__c = communityName,
            Number_of_visits__c = noOfVisit,
            Last_Login__c = lastLoginTime,
            Last_Community_Visit__c = lastCommunityVisit
          );
          update updateData;
        }
      }

      List<Community_Visit__c> lastName = new List<Community_Visit__c>();
      lastName = [
        SELECT Last_Community_Visit__c
        FROM Community_Visit__c
        WHERE User_Name__c = :userName
      ];

      for (Community_Visit__c c : lastName) {
        c.Last_Community_Visit__c = communityName;
      }

      update lastName;
    }
  } catch (System.DmlException e) {
    system.debug('Exp0: ' + e.getMessage());
  }
}

public String getLocale() {
  LocaleSwitcherExtension lse = new LocaleSwitcherExtension();
  return lse.getLocale();
}

public PageReference isLoggedIn() {
  if (UserInfo.getUserType() != 'Guest') {
    // Below condition added by Charan | 25-04-2024
    if(portalStartUrl != null && portalStartUrl == '/ibportal/s/ibportal/IBPortalEditProfile'){
      return new PageReference('/ibportal/IBPortalEditProfile');
    }
    return new PageReference('/ibportal/IBPortalLanding');
  } else {
    return null;
  }
}

public static List<String> translationvalues = new List<String>();
public static Map<String, String> customLabelsByLanguage = new Map<String, String>();

@AuraEnabled(cacheable=true)
public static Map<String, String> getvaluesbyLanguage(String language) {
  List<String> customLabelNames = new List<String>{
    'IBPortal_Navbar_My_IB',
    'COVID_Students',
    'Pims_Login_Login',
    'Pims_Login_Password',
    'Pims_Login_Forgot_Password',
    'Text_alongside_username_field_on_myib',
    'ib_portal_login_H1',
    'PIMS_Error_Login',
    'Provide_a_formatted_email_in_username_on_myib',
    'ib_portal_login_register',
    'IBENPortal_WelcomeEmail_Username',
    'ibPortal_Username_Fill_Fields_Error',
    'ib_portal_login_H2',
    'ib_portal_login_P1',
    'ib_portal_login_H3_help',
    'ib_portal_login_P2_helpText',
    'ib_portal_login_Assessment',
    'ib_portal_login_CreateNewAccount',
    'Forgot_username',
    'Text_alongside_username_field_on_myib',
    'ib_portal_login_register',
    'ibPortal_Spinner_Message',
      'ibPortal_Loading_MyIB_Applications',
      'IBENPortal_Login_Error'
  };
  getLabel(customLabelNames, language);
  return customLabelsByLanguage;
}

public static string getErrorLabel(String label, String lang) {
  PageReference pageRef = Page.Label;
  pageRef.getParameters().put('lang', lang);

  String labelValue;
  pageRef.getParameters().put('label', label);

  if (!Test.isRunningTest()) {
    labelValue = pageRef.getContent().toString();
  } else {
    labelValue = 'Test Label Value';
  }

  Integer start_index = labelValue.indexOf(':');
  Integer end_index = labelValue.length() - 1;
  String result = labelValue.substring(start_index + 3, end_index - 2);

  return result;
}

public static void getLabel(list<String> labels, String lang) {
  PageReference pageRef = Page.Label;
  pageRef.getParameters().put('lang', lang);
  String labelValue;

  for (String label : labels) {
    pageRef.getParameters().put('label', label);

    if (!Test.isRunningTest()) {
      labelValue = pageRef.getContent().toString();
    } else {
      labelValue = 'Test Label Value';
    }

    Integer start_index = labelValue.indexOf(':');
    Integer end_index = labelValue.length() - 1;
    String result = labelValue.substring(start_index + 3, end_index - 2);
    customLabelsByLanguage.put(label, result);
  }
}
//END
}