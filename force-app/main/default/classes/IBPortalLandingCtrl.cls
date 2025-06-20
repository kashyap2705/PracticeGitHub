public with sharing class IBPortalLandingCtrl {
    
    private IBPortalSettingsUtil util;
    public Boolean isFirstSession {get;private set;}
    public Boolean hasNoRoles {get;private set;}
    public Boolean requiredFields {get;private set;}
    public Boolean profileComplete {get; private set;}
    public User user {get;private set;}
    public boolean norolestext{get; set;}
    public Contact con {get;private set;} 
    public String birthDateString {get; set;}
    public List<IB_Role__c> roleapps {get;set;}
    public Boolean profileCompleteForLogin{get;set;}
    public Map<String,AppMenuItem> appMap = new Map<String,AppMenuItem>();
    public Map<String,AppMenuItem> appMapTemp = new Map<String,AppMenuItem>();
    public String showAlert {get;set;}
    public String communityLabel {get;set;}
    @testVisible public String pageRedirectLink {get;set;}
    //variables added by Shahrukh Anwar for ECM00538 on 04/11/2022 -- START --
    public static Boolean hasIben {get;set;}
    public static Boolean hasPdDigitalRole {get;set;}
    //variables added by Shahrukh Anwar for ECM00538 on 04/11/2022 -- END --
    
    private final Contact contactObject;
    
    Public User userTemp = UserDAO.INSTANCE.getUserById(Userinfo.getUserId());
    public String userName {get;set;}
    public List<PermissionSetAssignment> userPermissions = [SELECT Id, PermissionSetId, PermissionSet.Name, PermissionSet.ProfileId, PermissionSet.Profile.Name, AssigneeId, Assignee.Name FROM PermissionSetAssignment WHERE Assignee.id = :userTemp.id];
    
    public List<IB_Role__c> myRoles {get;set;}
    
    public Integer roleCount {get;set;}
   // public static List<IB_Role__c> rolesByContact = null;

    
    /**
* This method is used to update user community activity,US11136      
* @author: Ahmad Shakeel-Plumlogix 
* @since 10-11-2019
* @param No Parameter.       
* @return PageReference.     
*/
    
    
    
    
    public PageReference saveCommunityActivity()
    { 
        
        PageReference p=new PageReference(pageRedirectLink);
        try
        {
            List<String> months=new List<String>{'January','February','March','April','May','June','July','August','September','October','November','December'};
                
            String communityName,userName,lastCommunityVisit;
            Id userId;
            User uName;
            DateTime lastLoginTime;
            Integer noOfVisit=0;
            
            communityName = communityLabel;
            userId = UserInfo.getUserId();
            uName=[SELECT username FROM user WHERE id=:userId];
            userName=uName.Username;
         
            lastLoginTime=dateTime.now();
            String currentMonth= months.get(lastLoginTime.month()-1);
            Integer currentYear=lastLoginTime.year();
            
            List<Community_Visit__c> cVisit=[SELECT Number_of_visits__c,Last_Community_Visit__c,Last_Login__c FROM Community_Visit__c WHERE User_Name__c=:userName AND  Community_Name__c=:communityName AND Login_Year__C=:currentYear AND Login_Month__C=:currentMonth];
            if(cVisit.size()==0)
            {
                noOfVisit++;
                lastCommunityVisit=communityName;
                
                Community_Visit__c insertData=new Community_Visit__c(Community_Name__c=communityName,User_Name__c=userName,Number_of_visits__c=noOfVisit,Last_Login__c=lastLoginTime,Last_Community_Visit__c=lastCommunityVisit,Login_Year__C=currentYear,Login_Month__C=currentMonth);
                insert insertData;
            }
            else
            {
                            
                                                 
                noOfVisit=cVisit[0].Number_of_visits__c.intValue();
                lastCommunityVisit=cVisit[0].Last_Community_Visit__c;
                
                if(lastCommunityVisit!=communityName)
                {
                    noOfVisit++;
                    lastCommunityVisit=communityName;
                    Community_Visit__c updateData=new Community_Visit__c(id=cVisit[0].Id,Community_Name__c=communityName,Number_of_visits__c=noOfVisit,Last_Login__c=lastLoginTime,Last_Community_Visit__c=lastCommunityVisit);
                    update updateData;
                }
                else if(lastCommunityVisit==communityName && lastLoginTime>cVisit[0].Last_Login__c.addMinutes(5) )
                {
                    noOfVisit++;
                    lastCommunityVisit=communityName;
                    Community_Visit__c updateData=new Community_Visit__c(id=cVisit[0].Id,Community_Name__c=communityName,Number_of_visits__c=noOfVisit,Last_Login__c=lastLoginTime,Last_Community_Visit__c=lastCommunityVisit);
                    update updateData;
                    
                }
                
            }
            
         
        
            List<Community_Visit__c> lastName=[SELECT Last_Community_Visit__c from Community_Visit__c Where User_Name__c=:userName];
            
            for(Community_Visit__c c :lastName)
            {
                c.Last_Community_Visit__c=communityName;
            }
            
            update lastName;  
            
        }
        
                          
        
      
     
     
        catch (System.DmlException e) {
            
            
            System.debug('Exception'+e);
        }
        return p;                   
    }                               
    public IBPortalLandingCtrl() {
        
        System.debug('INIT LANDING CTRL!');
        showAlert = System.currentPageReference().getParameters().get('merUs');
        
        util = IBPortalSettingsUtil.getInstance();
        user = UserDAO.INSTANCE.getUserById(Userinfo.getUserId()); 
        //Following code is added by Developer Umair-Plumlogix of SA Project of US-12079 on 11/20/2020
        //Start
       
        String value;
        value =  UserInfo.getFirstName();
       
        if (value!=null)
        {
  
            userName = value;
           
        }
        else
        {
            userName = Label.MyIB_Welcome_v2;
        }
        //End
        ContactService.setContactId(user.ContactId);
        try {
            con = ContactService.getContact();
        } catch (Exception e){
            con = new Contact();           
        }
        
        
        if(con.Birthdate == null || con.Country__c == null || 
           con.Birth_Locale__c == null || con.Birth_Locale__c == '' || con.Country_Of_Birth__c == null || con.Country_Of_Birth__c == ''){
               requiredFields = false;
               
           } else {
               requiredFields = true;
           }
        
        if(con.Birthdate == null || con.Country__c == null || 
           con.Birth_Locale__c == null || con.Birth_Locale__c == '' || con.Country_Of_Birth__c == null || 
           con.Country_Of_Birth__c == '' || con.FirstName == null || con.FirstName == '' || con.LastName == null || 
           con.LastName == '' || con.Email == null || con.Email == '' || con.HomePhone == null || con.HomePhone == '' || 
           con.Birth_Locale__c == null || con.Birth_Locale__c == '' || con.Country__c == null){
               profileComplete = false;
               
           } else {
               profileComplete = true;
           }
        
        if(con.Birthdate == null || con.Birth_Locale__c == null || con.Birth_Locale__c == '' ||
           con.Country_Of_Birth__c == null || con.Country_Of_Birth__c == '' ||
           con.FirstName == null || con.FirstName == '' ||
           con.LastName == null || con.LastName == '' ||
           con.Email == null || con.Email == ''){
               profileCompleteForLogin = false;
               
           } else {
               profileCompleteForLogin = true;
           }
        
        if (null == user.ContactId ) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING , Label.IBENPortal_Error_ContactNotFound));
        } else {
            this.contactObject = MyContactDAO.INSTANCE.getContactbyId(user.ContactId);  
        }
        
        roleapps = getActiveIbRoles(user.ContactId);
        System.debug('roleapps-Size: '+roleapps.size()+' Id IS '+user.ContactId);
        for(IB_Role__c r: roleapps)
        {
           // system.debug('roleapps '+r.IB_Role_Name__c);
            //system.debug('roleapps:IB_Suject '+r.Role_Application_Subjects__r);
        }
        norolestext = text_for_no_roles();
        System.debug('Text: '+norolestext);
    }
   
    public String getLocale() {
        return UserInfo.getLanguage();
    }
    public PageReference isLoggedIn() {
        if (UserInfo.getUserType() == 'Guest') {
            return new PageReference('/ibportal/IBPortalLogin');
        } else if(!profileCompleteForLogin){
            return new PageReference('/ibportal/IBPortalLoginFlow');
        }
        else {
            System.debug('testing----->'+contactObject);
            if (!contactObject.Contract_Signed_New__c){
                PageReference tandc = Page.MyIBTandC;
                tandc.getParameters().put('id', contactObject.Id);
                return tandc;
            }
            stampFirstLogin();
            checkForRoles();
            return null;
        }
        
    }
    
    public List <Tiles> getAppMenuItems1 () {
        
        // Get all available Connected Apps
        for(AppMenuItem app : [SELECT ApplicationId, Label, LogoUrl,  Name, StartUrl FROM AppMenuItem WHERE Name != 'AppLauncher' AND Type = 'ConnectedApplication']){
            //below if condition modified by Prerna Sobti for enewsletters on 15-06-2023
            if(app.Name != 'IB_Roles' && app.Name != 'eNewsletters_Signup')
            {
            appMap.put(app.Name,app);
                System.debug('App Name'+app.Name);
            }
            
            
        }
        
        //  System.debug('Appmappp' +appmap);
        System.debug('SizeOFMap'+appMap.size());

        List<AppMenuItem> availableApps = getAppsForUser(user, roleapps, appMap);
        System.debug('***AvailableApps '+availableApps);
        Network nw = [SELECT id, name FROM Network WHERE Name = 'ibportal' LIMIT 1];
        String baseUrl = Network.getLoginUrl(nw.id);
        baseUrl = baseUrl.removeEnd('/ibportal/IBPortalLogin');
        baseUrl = baseUrl.replace('https','http');
        List<Tiles> appTiles = new List<Tiles>();
        
        for(AppMenuItem a:availableApps){
            Tiles t = new Tiles();
            t.Name = a.Name;
            system.debug('tileName'+a.Name);
            system.debug('StrtUrl'+a.StartUrl);
            system.debug('baseUrl'+baseUrl);
            if(a.StartUrl!=Null)
            {
                if(a.StartUrl.startsWith('http://internationalbaccalaureate.force.com'))
                    t.StartUrl = a.StartUrl.replace('http://internationalbaccalaureate.force.com', baseUrl);
                else if(a.StartUrl.startsWith('https://internationalbaccalaureate.force.com'))
                    t.StartUrl = a.StartUrl.replace('https://internationalbaccalaureate.force.com', baseUrl);
                else
                    t.StartUrl = a.StartUrl;
                appTiles.add(t);
            }
        }  
        return appTiles;      
    }
    
    public List <Tiles> getAppMenuItems2 () {
        
        // Get all available Connected Apps
        Map<String,AppMenuItem> appMap1 = new Map<String,AppMenuItem>();
        for(AppMenuItem app : [SELECT ApplicationId, Label, LogoUrl,  Name, StartUrl FROM AppMenuItem WHERE Name != 'AppLauncher' AND Type = 'ConnectedApplication' AND Name NOT IN: appMap.keySet()]){
            if(app.Name != 'IB_Roles')
            {
            appMap1.put(app.Name,app);
        }
        
        }
        List<AppMenuItem> availableApps = getAppsForUser(user, roleapps, appMap1);
        Network nw = [SELECT id, name FROM Network WHERE Name = 'ibportal' LIMIT 1];
        String baseUrl = Network.getLoginUrl(nw.id);
        baseUrl = baseUrl.removeEnd('/ibportal/IBPortalLogin');
        baseUrl = baseUrl.replace('https','http');
        
        List<Tiles> appTiles = new List<Tiles>();
        
        for(AppMenuItem a:availableApps){
            Tiles t = new Tiles();
            t.Name = a.Name;
            if(a.StartUrl!=Null)
            {
                if(a.StartUrl.startsWith('http://internationalbaccalaureate.force.com'))
                    t.StartUrl = a.StartUrl.replace('http://internationalbaccalaureate.force.com', baseUrl);
                else if(a.StartUrl.startsWith('https://internationalbaccalaureate.force.com'))
                    t.StartUrl = a.StartUrl.replace('https://internationalbaccalaureate.force.com', baseUrl);
                else
                    t.StartUrl = a.StartUrl;
                appTiles.add(t);
            }
        }  
        return appTiles;      
    }
    //Following code is added by Developer Umair-Plumlogix of SA Project of US-12079 on 11/20/2020
    //Start
    public boolean text_for_no_roles(){
        System.debug('No Roles Text');
         Map<String,AppMenuItem> appMap2 = new Map<String,AppMenuItem>();
         for(AppMenuItem app : [SELECT ApplicationId, Label, LogoUrl,  Name, StartUrl FROM AppMenuItem WHERE Name != 'AppLauncher' AND Type = 'ConnectedApplication']){
            appMap2.put(app.Name,app);
        }
         
        List<AppMenuItem> availableApps = getAppsForUser(user, roleapps,  appMap2);
        System.debug('Availble Apps: '+availableApps.size());
        List<String> tileNames = new List<String>();
        for(AppMenuItem a:availableApps){
            tileNames.add(a.Name);
            System.debug('Availble Apps: '+a.Name);
        }
        if(tileNames.size()==2){
        tileNames.contains('IB_Answers');
            return true;
        } else if (tileNames.size() ==1)
               return true;            
        else
            return false;
    }
    public List <Tiles> getAppMenuItems11 () {
        
        // Get all available Connected Apps
        for(AppMenuItem app : [SELECT ApplicationId, Label, LogoUrl,  Name, StartUrl FROM AppMenuItem WHERE Name != 'AppLauncher' AND Type = 'ConnectedApplication']){
            if(app.Name == 'IB_Roles')
            {
            appMapTemp.put(app.Name,app);
            }

        }
         
        List<AppMenuItem> availableApps = getAppsForUser(user, roleapps, appMapTemp);
        Network nw = [SELECT id, name FROM Network WHERE Name = 'ibportal' LIMIT 1];
        String baseUrl = Network.getLoginUrl(nw.id);
        baseUrl = baseUrl.removeEnd('/ibportal/IBPortalLogin');
        baseUrl = baseUrl.replace('https','http');
        
        List<Tiles> appTiles = new List<Tiles>();
        
        for(AppMenuItem a:availableApps){
            Tiles t = new Tiles();
            t.Name = a.Name;
            if(a.StartUrl!=Null)
            {
            if(a.StartUrl.startsWith('http://internationalbaccalaureate.force.com'))
                t.StartUrl = a.StartUrl.replace('http://internationalbaccalaureate.force.com', baseUrl);
            else if(a.StartUrl.startsWith('https://internationalbaccalaureate.force.com'))
                t.StartUrl = a.StartUrl.replace('https://internationalbaccalaureate.force.com', baseUrl);
            else
                t.StartUrl = a.StartUrl;
            
            appTiles.add(t);
            }
        }  

        return appTiles;      
    }
    
  //End
    
    //getAppsForUser method refactored by Shahrukh Anwar for ECM00538 -- Tech Debt
    private List<AppMenuItem> getAppsForUser(User u, List<IB_Role__c> ibRoles, Map<String,AppMenuItem> allApps){
        //ibRoleMap modified to accept List<IB_Role__c> by Shahrukh Anwar for ECM00538 (BUG-184646) on 17/11/2022
        Map<String,List<IB_Role__c>> ibRoleMap = new Map<String,List<IB_Role__c>>();
        Map<String,IB_Role__c> ibRoleConfirmedMap = new Map<String,IB_Role__c>();
        Map<String,IBPortalCommunityAccessSubjects__mdt> subjectsMap = new Map<String,IBPortalCommunityAccessSubjects__mdt>();
        Id usId = UserInfo.getUserId();
        Boolean containsPYPAgeGroup = false;
        hasIben = false;
        hasPdDigitalRole=false;
        Boolean hasDPPYPPC = false;
		Boolean hasNonDPPYPPC = false;//Benjamin McGarvey 1/21/2025, INC0218470 added to prevent PC without DP/PYP from seeing ib exchange/pddigital
        Boolean hasNonPCDigitalChannel=false;
        Boolean viewIBInsights = false;//added by Atticus F For ECM00502/ECM00576 on 18-01-2023 
        Set<String> progCordinatorExceptPYP = new Set<String>{'DP','MYP','CP','European Platform','EP'}; //added by Atticus F For ECM00502/ECM00576 on 18-01-2023 //added EP Programme as a part of ECM00623 by Suraj Parihar

        if(con.Account.recordtypeid==Schema.Sobjecttype.Account.getRecordTypeInfosByDeveloperName().get('IB_Institute').getRecordTypeId() || Test.isRunningTest()) {
            allapps.remove('Heads_Engage');
            //Commented the below - as we should remove IBEN_Central when the IB Contact is tagged to IB Institute
            //allapps.remove('IBEN_Central');
            allapps.remove('Programmes');
            allapps.remove('IB_Insights');
        }
        //SOQL formatting done by Shahrukh Anwar on 07/11/2022 -- Tech Debt
        for(IBPortalCommunityAccessSubjects__mdt subject: [SELECT id,
                                                                DeveloperName,
                                                                Subject__c,
                                                                IB_Role__c 
                                                            FROM IBPortalCommunityAccessSubjects__mdt]){
            subjectsMap.put(subject.IB_Role__c+'-'+subject.Subject__c,subject);
            System.debug('subject ' + subject.IB_Role__c+'-'+subject.Subject__c);
        }
        
        //variable 'r' replaced with 'ibRole' by Shahrukh Anwar for ECM00538 on 17/11/2022 -- Tech Debt
        for(IB_Role__c ibRole : ibRoles){
            System.debug('ibRoleMap ' + ibRole.IB_Role_Name__c);
            // [start] added logic by Atticus F For ECM00502/ECM00576 on 18-01-2023 
            // IB Insight should be visible for DP,MYP and CP -->Programme Cordinators Or Head of School
            if(ibRole.IB_Role_Name__c != null ){
                    if(ibRole.IB_Role_Name__c=='Head of School (Overall)'||(ibRole.IB_Role_Name__c =='Programme Coordinator' || ibRole.IB_Role_Name__c =='Head of School') && 
                        (progCordinatorExceptPYP.contains(ibRole.Programme_Selection__c))){
                            viewIBInsights = true;
                            //break; // Fix for INC0176562
                    }
            }
            // [end]
            //Benjamin McGarvey  INC0218470 
            if(ibRole.IB_Role_Name__c != null ){
                if(ibRole.IB_Role_Name__c =='Programme Coordinator' ){
                    if(ibRole.Programme_Selection__c=='DP'||ibRole.Programme_Selection__c=='PYP'){
                        hasDPPYPPC = true;
                    }else{
                        hasNonDPPYPPC=true;
                    }
                }else if (ibRole.IB_Role_Name__c =='CAS Coordinator'||ibRole.IB_Role_Name__c =='Digital Channel User'||ibRole.IB_Role_Name__c =='Head of School (Overall)'||ibRole.IB_Role_Name__c =='Head of School'){
                    hasNonPCDigitalChannel=true;
                } else if (ibRole.IB_Role_Name__c =='Teacher'&&ibRole.Programme_Selection__c=='PYP' && ibRole.Status__c == 'Confirmed'){
                    hasNonPCDigitalChannel=true;
                } else if (ibRole.IB_Role_Name__c =='Teacher'&&ibRole.Programme_Selection__c=='DP'){
                    for(Role_Application_Subject__c sub: ibRole.Role_Application_Subjects__r){
                        IBPortalCommunityAccessSubjects__mdt IBPortalCommunityAccessSubject =  subjectsMap.get(ibRole.IB_Role_Name__c+'-'+sub.Subject_Name__c);
                        if(IBPortalCommunityAccessSubject != null){
                            hasNonPCDigitalChannel=true;
                        }
                    }
                }
                
            }
             
            //Code added by Shahrukh Anwar to accomodate List<IB_Role__c> for ECM00538 (BUG-184646) on 17/11/2022 -- START --
            if(ibRoleMap.containsKey(ibRole.IB_Role_Name__c)) {
                ibRoleMap.get(ibRole.IB_Role_Name__c).add(ibRole);
            } else {
                ibRoleMap.put(ibRole.IB_Role_Name__c, new List<IB_Role__c> {ibRole});
            }
            //Code added by Shahrukh Anwar to accomodate List<IB_Role__c> for ECM00538 (BUG-184646) on 17/11/2022 -- END --

            //curly braces added by Shahrukh Anwar on 07/11/2022 -- Tech Debt
            for(Role_Application_Subject__c sub: ibRole.Role_Application_Subjects__r) {
                ibRoleConfirmedMap.put(ibRole.IB_Role_Name__c+''+sub.Subject_Name__c,ibRole);
            }
        }
        
        
        //SOQL formatting done by Shahrukh Anwar on 07/11/2022 -- Tech Debt
        Set<String> setAgeGroups = getPYPAgeGroups();
        for(IBPortalCommunityAccess__mdt appCfg : [SELECT DeveloperName,
                                                        Associate_Subjects__c, 
                                                        Community_Name__c,
                                                        IB_Role__c, 
                                                        Role_Confirmed__c 
                                                    FROM IBPortalCommunityAccess__mdt 
                                                    WHERE Community_Name__c = 'IBEN_Central'
                                                    OR Community_Name__c = 'myInstitute' 
                                                    OR Community_Name__c = 'PD_Digital_Channel']) {
            //This code is updated as part of ECM416(giving Teacher role access to PD Digital Channel w.r.t subject) on 1/22/2022
            //Start
            System.debug('Inside the Loop '+appCfg.IB_Role__c);
            // Does this user have an IB Role with access to this App?
            if(ibRoleMap.containsKey(appCfg.IB_Role__c)) {      //added by Shahrukh Anwar for ECM00538 on 07/11/2022 -- Tech Debt
                //for loop added by Shahrukh Anwar to iterate over multiple IB Roles for ECM00538 (BUG-184646) on 17/11/2022
                for(IB_Role__c ibRole : ibRoleMap.get(appCfg.IB_Role__c)) {
                    //if(ibRole != null){           //commented by Shahrukh Anwar for ECM00538 on 07/11/2022 -- Tech Debt
                    System.debug('User belongs to ' + ibRole.IB_Role_Name__c + ' which IS defined in the app security config for ' + appCfg.DeveloperName+ ' Associate Subject '+appCfg.Associate_Subjects__c);

                    //Code written by Shahrukh Anwar for ECM00538 on 04/11/2022 -- START --

                    //for(String ageGroup : setAgeGroups) {
                    //    if(ibRole.Age_Groups__c != null) {
                    //        if(ibRole.Age_Groups__c.contains(ageGroup)) {
                                containsPYPAgeGroup = true;
                    //            break;
                    //        }
                    //    }
                    //}
                    //Null check by Atticus for INC0173429 -- on 8-12-2022
                    if( ibRole.Programme_Selection__c != null && ibRole.Programme_Selection__c.contains('PYP') && 
                        ibRole.Status__c == 'Confirmed' && 
                        //ibRole.Age_Groups__c != null && 
                        ibRole.IB_role_name__c=='Teacher'&&
                        containsPYPAgeGroup == true) {

                            findAndAddCommunityToApprovedApps(allApps, appCfg);

                    }
                    //Code written by Shahrukh Anwar for ECM00538 on 04/11/2022 -- END --

                    //1a. Does the security config require the user to be CONFIRMED for this Role?
                    else if(((appCfg.Role_Confirmed__c && ibRole.Status__c == 'Confirmed') || appCfg.Role_Confirmed__c == false) && appCfg.Associate_Subjects__c == false){
                        
                        System.debug('Associate Subjects is false and User has access to this Community: ' + appCfg.Community_Name__c + ' [IB Role: ' + ibRole.IB_Role_Name__c + ' (status: ' + ibRole.Status__c + ')]'); 
                        
                        //Code written by Shahrukh Anwar for ECM00538 on 04/11/2022 -- Tech Debt -- START --
                        findAndAddCommunityToApprovedApps(allApps, appCfg);
                        //Code written by Shahrukh Anwar for ECM00538 on 04/11/2022 -- Tech Debt -- END --
                    
                    } else if(((appCfg.Role_Confirmed__c && ibRole.Status__c == 'Confirmed') || appCfg.Role_Confirmed__c == false) && appCfg.Associate_Subjects__c == true){
                        for (String key : ibRoleConfirmedMap.keySet()) {
                            IB_Role__c role = ibRoleConfirmedMap.get(key);
                            System.debug('Associate Subjects is true and User has access to this Community: ' + appCfg.Community_Name__c + ' [IB Role: ' + ibRole.IB_Role_Name__c + ' (status: ' + ibRole.Status__c + ')]'); 
                                        
                            for(Role_Application_Subject__c sub: role.Role_Application_Subjects__r){
                            
                                System.debug('Associate Subjects: ' + role.IB_Role_Name__c+'-'+sub.Subject_Name__c);
                                IBPortalCommunityAccessSubjects__mdt IBPortalCommunityAccessSubject =  subjectsMap.get(role.IB_Role_Name__c+'-'+sub.Subject_Name__c);

                                if(IBPortalCommunityAccessSubject != null){
                                    System.debug('User has access to this Community: ' + appCfg.Community_Name__c + ' [IB Role: ' + role.IB_Role_Name__c + ' (status: ' + ibRole.Status__c + ')]'); 
                                
                                    //Code written by Shahrukh Anwar for ECM00538 on 04/11/2022 -- Tech Debt -- START --
                                    findAndAddCommunityToApprovedApps(allApps, appCfg);
                                    //Code written by Shahrukh Anwar for ECM00538 on 04/11/2022 -- Tech Debt -- END --
                                }
                            }
                        }
                    }   
                    else {
                        System.debug('User does NOT have access to ' + appCfg.Community_Name__c + ' [IB Role status: ' + ibRole.Status__c + ']');
                    }
                }
            }
            else {
                System.debug('User does not belong to role (' + appCfg.IB_Role__c + '). Skipping. ibRoleMap has no key for ' + appCfg.IB_Role__c);                
            }
        }
       
        if(!hasAccessToMySchool(u,con)){
            allApps.remove('My_School');
        }
        if(hasIben == false){
            allApps.remove('IBEN_Central');
        }
        if(hasPdDigitalRole == false){                  //curly braces added by Shahrukh Anwar on 07/11/2022 -- Tech Debt
            allApps.remove('PD_Digital_Channel');
        }
        if(hasNonDPPYPPC&& !hasDPPYPPC&&!hasNonPCDigitalChannel){//Ben McGarvey INC0218470, added to prevent programme coordinators from non DP/PYP from seeing pddigital/ib exchange
            allApps.remove('PD_Digital_Channel');
        }
        //viewIBInsights will be false only if the confirmed role is only Program Cordinator for PYP
        //viewIBInsights will be true if it Program Cordinator of MYP, CP,DP apart from PYP
        //added by Atticus F For ECM00502/ECM00576 on 18-01-2023 
        System.debug('# viewIBInsights '+viewIBInsights);
        System.debug('# allapps '+allapps);
        if(!viewIBInsights && !allapps.isEmpty() && allapps.containsKey('IB_Insights')){ 
             allapps.remove('IB_Insights');
        }
       //End        
        return allApps.values();
    }

    //method created by Shahrukh Anwar for ECM00538 on 07/11/2022 -- START --
    private static void findAndAddCommunityToApprovedApps(Map<String,AppMenuItem> allApps, IBPortalCommunityAccess__mdt appCfg) {
        if(allApps.containsKey(appCfg.Community_Name__c)) {
            //redundant code added to this method by Shahrukh Anwar for ECM00538 on 04/11/2022 -- Tech Debt -- START --
            //Find the app that matches the Community name
            AppMenuItem app = allApps.get(appCfg.Community_Name__c);

            // add the app to the list of approved apps
            if(app != null && appCfg.Community_Name__c != 'PD_Digital_Channel'){
                hasIben = true;
            }
            else if(app != null && appCfg.Community_Name__c == 'PD_Digital_Channel'){
                hasPdDigitalRole = true;
            }
            else {
                System.debug('ERROR: ' + appCfg.Community_Name__c + ' NOT FOUND in allApps map. Check that the Community_Name__c field in the Custom Meta Data settings for IBPortalCommunityAccess matches the name defined for the community in Connected Apps. allApps: ' + allApps);
            }
            //redundant code added to this method by Shahrukh Anwar for ECM00538 on 04/11/2022 -- Tech Debt -- END --
        }
    }
    //method created by Shahrukh Anwar for ECM00538 on 04/11/2022 -- END --
    
    private Boolean hasAccessToMySchool(User u, Contact c)
    {
        Boolean access = false;
         if(u.Profile.Name == 'SCU + Basic' || u.Profile.Name == 'SCU + Advanced'){ 
            System.debug('hasAccessToMySchool: User has passed profile check..');
            /* if (con != null && 
                con.Account.Name != 'IBAEM Inactive Contacts' && 
                con.Account.Name != 'IBA Inactive Contacts' && 
                con.Account.Name != 'IBAP Inactive Contacts' &&
                con.Account.Name != 'IBAEM IBEN Independent' && 
                con.Account.Name != 'IBA IBEN Independent' && 
                con.Account.Name != 'IBAP IBEN Independent'
                && con.Account.recordtypeid!=Schema.Sobjecttype.Account.getRecordTypeInfosByDeveloperName().get('IB_Institute').getRecordTypeId()
               ) { */
                   
                   System.debug('hasAccessToMySchool: User does not belong to restricted account.');
                   if (hasMySchoolPermissions() == true){
                       System.debug('hasAccessToMySchool: User is a head of school or programme coordinator.');
                   access = true;
               } 
            //    } 
        } 
        
        return access;  
    } 

    private List<IB_Role__c> getActiveIbRoles(string contactId){
        //Age_Groups__c field added & SOQL formatted by Shahrukh Anwar for ECM00538 on 04/11/2022 -- Tech Debt
        return [SELECT Id, 
                    IB_Account__c, 
                    Role_Type__c, 
                    IB_Role_Name__c, 
                    Status__c, 
                    Account_Name__c, 
                    Age_Groups__c, 
                    Programme_Selection__c,
                    (SELECT Subject_Name__c 
                    FROM Role_Application_Subjects__r), 
                    Programme_Selection_ES__c, 
                    Programme_Selection_FR__c, 
                    IB_Role__r.Display_in_MyIB__c  
                FROM IB_Role__c 
                WHERE IB_Contact__c = :contactId 
                AND (End_Date__c = null OR End_Date__c > TODAY)
                AND Status__c = 'Confirmed'];
    }

    public Contact getContactObject() {
        return this.contactObject;
    }
    public void stampFirstLogin(){
        try{
            User currentUser = [
                SELECT Id, HasLoggedIn__c
                FROM User
                WHERE Id =: UserInfo.getUserId()
                AND HasLoggedIn__c = false
            ]; 
            
            isFirstSession = true;
            
            currentUser.HasLoggedIn__c = true;
            update currentUser; 
        }
        catch(QueryException e){
            System.debug('Not their first login');
        }
        catch(DMLException e){
            System.debug(e);
        }
    }
    //this line is updated by developer Abd Ur Rehman-Plumlogix as part of cr- us11727 on 21-2-2020
    //change the role name from "Global PD Contractor" to "Professional Services Contractor"
    //begin    
    public Set<String> roles = new Set<String>{
        'Consultant',
            'Programme Field Representative',
            'Reader',
            'School Visit Team Member',
            'Workshop Leader',
            'Professional Services Contractor',
            'Session Observer'
            }; //end
                
                public Set<String> statuses = new Set<String>{
                    'Confirmed',
                        'Applicant'
                        };        
                            public void checkForRoles(){
                                
                                List<AggregateResult> tmp = [
                                    SELECT count(Id) 
                                    FROM IB_Role__c 
                                    WHERE IB_Contact__c = :contactObject.Id 
                                    AND IB_Role_Name__c IN:roles 
                                    AND Status__c IN:statuses 
                                ];
                                
                                if(Integer.valueOf(tmp[0].get('expr0')) >= 1){
                                    hasNoRoles = false;
                                    return;
                                }
                                
                                hasNoRoles = true;
                            }
    
    public String getCurrentYear() {
        Date today = Date.today();
        return String.valueOf(today.year());
    }
    
    public class Tiles{
        public String Name {get;set;}
        public String StartUrl {get;set;}
    }

    //Added 06/10/2022 by Mariappan Perumal. This method queries user permission sets and returns true if school permission (Head of School/ Head of School (overall), Program Co-ordinator)
    private Boolean hasMySchoolPermissions(){
        Boolean isMySchool = false;
        if(userPermissions != null){
            for(PermissionSetAssignment psa : userPermissions){
                if(psa.PermissionSet.Name == 'Programme_Coordinator' || psa.PermissionSet.Name == 'Head_of_School' || psa.PermissionSet.Name == 'Head_of_School_Overall'){
                    isMySchool = true;
                }
            }
        }
        return isMySchool;
    }
    
    //Code written by Shahrukh Anwar for ECM00538 on 02/12/2022 -- START --
    private Set<String> getPYPAgeGroups(){
        String ageGroupStr = Label.PYP_Age_Groups;
        Set<String> returnAgeGroups = new Set<String>();
        if(String.isNotBlank(ageGroupStr)){
            List<String> lstAgeGroup = ageGroupStr.split(';');
            if(!lstAgeGroup.isEmpty()){
                returnAgeGroups.addAll(lstAgeGroup);
            }
        }
        return returnAgeGroups;
    }
    //Code written by Shahrukh Anwar for ECM00538 on 02/12/2022 -- END --
}