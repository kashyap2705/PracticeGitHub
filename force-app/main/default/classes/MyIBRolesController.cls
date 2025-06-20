public without sharing class MyIBRolesController {
    public integer cnt{get;set;}
    public string userId = Userinfo.getUserId();
    @TestVisible User user = UserDAO.INSTANCE.getUserById(Userinfo.getUserId());
    
    private static final List<IB_Role_Repository__c> rolesMaster = RoleRepositoryService.getAllMyIBRoles();
    public List<IB_Role_Repository__c> professionalDevelopmentInitialRoles {get;set;}
    public List<IB_Role_Repository__c> schoolServicesInitialRoles {get;set;}
    public List<IB_Role_Repository__c> professionalDevelopmentAdvancedRoles {get;set;}
    public List<IB_Role_Repository__c> schoolServicesAdvancedRoles {get;set;}
    public List<IB_Role_Repository__c> schoolRoles {get;set;}
    public List<IB_Role_Repository__c> instituteRoles{get;set;}
    public List<IB_Role_Repository__c> onlineProviderRoles{get;set;}
    public List<IB_Role_Repository__c> ibecRoles{get;set;}//ibec roles list
    public List<IB_Role_Repository__c> associationRoles{get;set;}//Association roles list
    
    public List<IB_Role__c> myRoles {get;set;}
    public Integer roleCount {get;set;}
    Public Ib_role__c CurrRole{get;set;}  
    Public User userTemp = UserDAO.INSTANCE.getUserById(Userinfo.getUserId());
    
    
    public Map<String, Boolean> applicationAvailable {get;set;}
    public Map<String, IB_Role_Repository__c> allRolesMap {get;set;}
    
    public Boolean isAdvancedSchoolServices {get;set;}
    public Boolean isAdvancedProfessionalDevelopment {get;set;}
    
    public Map<String,List<Role_Application_Subject__c>> roleApplicationSubjectMap {get;set;} 
    public List<Training_Event__c> eligibleTraining {get;set;}
    public List<String> appliedForRoleProgrammeCombos {get;set;}
    public List<Integer> schoolRolesNumber {get;set;}
    public ID ConID {get;set;}
    public static String deleteAppDocId { get; set; }
    public static String adasAcceptDocId { get; set; }
    public static String adasRejectDocId { get; set; }
    public   string redirectUrl{get;set;}
    public ID TempID {get;set;}
  
    public List<Integer> instituteRolesNumber {get;set;}
    public List<Integer> onlineProviderRolesNumber {get;set;}
    public Boolean ibBackground {get;set;}  
    public Boolean conStaff {get;set;}
    public Boolean trainingPL {get;set;}
    public Boolean trainingEL {get;set;}
    public Boolean roleRecordPL {get;set;}
    public Boolean roleRecordEL {get;set;}
    
    public String displayPopup{get;set;} // added by kashyap DAS
    public String displaySuccessPopup{get;set;}// added by kashyap DAS
    
/** Added for DAS **/
    private final List<String> constantList = new List<String>{ IboUtil.PIMS_SUCCESSMSG, IboUtil.PIMS_DONE, IboUtil.PIMS_CANCEL,IboUtil.PIMS_BUTTONVALUE,IboUtil.PIMS_BUTTONRESPONSE,IboUtil.PIMS_REMOVE_ROLE,IboUtil.PIMS_HEADING,IboUtil.PIMS_SUBHEADING};
    
        public String pimsSuccess {
            get {
                return this.getTranslationsMap().get(IboUtil.PIMS_SUCCESSMSG);
            }
            set;
        }
    
        public String pimsButtonResponse {
            get {
                return this.getTranslationsMap().get(IboUtil.PIMS_BUTTONRESPONSE);
            }
            set;
        }
    
    public String pimsRemoveRole {
        get {
            return this.getTranslationsMap().get(IboUtil.PIMS_REMOVE_ROLE);
        }
        set;
    }
    
    public String pimsHeading {
        get {
            return this.getTranslationsMap().get(IboUtil.PIMS_HEADING);
        }
        set;
    }    
    
    
    public String pimsSubHeading {
        get {
            return this.getTranslationsMap().get(IboUtil.PIMS_SUBHEADING);
        }
        set;
    }  
        
    public String pimsDone {
            get {
                return this.getTranslationsMap().get(IboUtil.PIMS_DONE);
            }
            set;
        }
    
    public String pimsCancel {
        get {
            return this.getTranslationsMap().get(IboUtil.PIMS_CANCEL);
        }
        set;
    }
    
    public String pimsButtonValue {
        get {
            return this.getTranslationsMap().get(IboUtil.PIMS_BUTTONVALUE);
        }
        set;
    }
        
        public static final Map<String, String> languageCodeMap {
        get {
            Map<String, String> languageMap = new Map<String, String>();
            languageMap.put('fr', 'French');
            languageMap.put('es', 'Spanish');
            return languageMap;
        }
    }
    
    transient Map<String, String> translationsMap;
    
    public  Map<String, String> getTranslationsMap() {        
        if (null == this.translationsMap) {
            try {
                String userLanguage = null != languageCodeMap.get(UserInfo.getLanguage()) ? languageCodeMap.get(UserInfo.getLanguage()) : 'American English';
                List<Translation__c> translations = [SELECT Id, Language__c, Value__c, CustomLabel__c, CustomLabel__r.Label__c FROM Translation__c
                                                     WHERE CustomLabel__r.Label__c =: constantList
                                                     AND Language__c = :userLanguage];
                
                this.translationsMap = new Map<String, String>();
                
                for (Translation__c translation : translations) {
                    translationsMap.put(translation.CustomLabel__r.Label__c, translation.Value__c);
                } 
            }
            catch (Exception ex) {
                Logger.get().add(ex, LogSeverity.ERROR).publish();             
            }
        }
        
        return this.translationsMap;
    }
        
        /** End of Added for DAS **/
    
    public MyIBRolesController(){ 
        
        displayPopup = 'false';
        Integer teacherCount = 0;
        String teacherId = '';
        professionalDevelopmentInitialRoles = new List<IB_Role_Repository__c>();
        schoolServicesInitialRoles = new List<IB_Role_Repository__c>();
        applicationAvailable = new Map<String,Boolean>();
        allRolesMap = new Map<String, IB_Role_Repository__c>();
       
       ConID = userTemp.ContactId;
        
        myRoles = [
            SELECT Id, Name, Account_Name__c,Role_Has_Subjects__c, End_Date__c, Programme_Selection_Es__c,
            Programme_Selection_FR__c, toLabel(Status__c), Programme_Selection__c, IB_Contact__c, Status_Value__c, 
            IB_Account__c,Type__c, IB_Account__r.Name, First_Name__c, Last_Name__c, IB_Programme_New__c, Programme_Type__c, 
            Programme_Type_ES__c, Programme_Type_FR__c,Role_Type__c, IB_Role__c, IB_Role_Name__c, IB_Role_Name_es__c, IB_Role_Name_fr__c, 
            IB_Programme_New__r.RecordType.Name, IB_Role_Programme_Combo__c,Start_Date__c
            FROM IB_Role__c
            WHERE IB_Contact__c = :ConID
            /*AND (End_Date__c = null OR End_Date__c > TODAY)*/
            AND (Status__c = 'Applicant' OR Status__c = 'Confirmed' OR Status__c = 'Withdrawn' OR Status__c = 'Invited')
            AND (IB_Role__r.Display_in_MyIB__c = true OR IB_Role__r.Display_Confirmed_in_MyIB__c = true)
            ORDER BY Status__c,Start_Date__c
        ];
        
        roleCount = myRoles.size();
        isAdvancedProfessionalDevelopment = false;
        isAdvancedSchoolServices = false;
        roleApplicationSubjectMap = new Map<String,List<Role_Application_Subject__c>>();
        appliedForRoleProgrammeCombos = new List<String>();
        schoolRoles = new List<IB_Role_Repository__c>();
        instituteRoles=new List<IB_Role_Repository__c>();
        onlineProviderRoles=new List<IB_Role_Repository__c>();
        ibecRoles=new List<IB_Role_Repository__c>();
        associationRoles=new List<IB_Role_Repository__c>();
        onlineProviderRolesNumber =new  List<Integer> ();
        schoolRolesNumber = new List<Integer>();
        instituteRolesNumber =new  List<Integer> ();
        
        
        professionalDevelopmentAdvancedRoles = new List<IB_Role_Repository__c>();
        schoolServicesAdvancedRoles = new List<IB_Role_Repository__c>();
        Integer counter = 0;
        Integer insCounter=0;
        Integer opCounter=0;
        
        ConID = userTemp.ContactId;
        
        ibBackground = false;
         List<IB_E_Background__c> recordList = new List< IB_E_Background__c>();
        recordList=[Select RecordType.Name, Spoken_Proficiency__c, Written_Proficiency__c from IB_E_Background__c where IB_Contact__r.id =: ConID AND RecordType.Name = 'Language Experience'];
        for(IB_E_Background__c b: recordList)
        {
            if (b.RecordType.Name == 'Language Experience' && b.Spoken_Proficiency__c == 'C2-Proficient user' && b.Written_Proficiency__c == 'C2-Proficient user')
                ibBackground = true;
        }
        
        conStaff = false;
        Contact[] conRecord = [Select Independent_Educator__c,School_Name__c,Number_of_years_at_school__c,IBEN_Active__c from Contact where id=: ConID];
        if(conRecord.size() > 0)
        {
            if(conRecord[0].IBEN_Active__c == true && conRecord[0].Independent_Educator__c == Label.PIMS_Gloabl_No && conRecord[0].Number_of_years_at_school__c != null)
            {
            conStaff = true;
            }
        }
        trainingPL = false;
        trainingEL = false;
        
        List<Campaign> trainingRecordPLEL = new List<Campaign>();
        trainingRecordPLEL = [Select id, IB_Role_Name_2__c,IB_Role_Name__c,IB_Role_Name_3__c, Status from Campaign where (IB_Role_Name__c ='Programme Leader' OR IB_Role_Name__c='Evaluation Leader' 
                             OR IB_Role_Name_2__c ='Programme Leader' OR IB_Role_Name_2__c='Evaluation Leader' ) 
                             AND Application_Deadline__c >= Today AND Staffing_Event_Published__c = true];
        if(trainingRecordPLEL.size() > 0)
        {
            for(Campaign C: trainingRecordPLEL)
            {
                if(C.IB_Role_Name__c == 'Programme Leader' || 
                   (C.IB_Role_Name_2__c != null && C.IB_Role_Name_2__c == 'Programme Leader'))
                {
                    trainingPL = true;
                }
                 if (C.IB_Role_Name__c == 'Evaluation Leader' || 
                         (C.IB_Role_Name_2__c != null && C.IB_Role_Name_2__c == 'Evaluation Leader'))
                {
                    trainingEL = true;
                }
            }
            
        }
        
        roleRecordPL = false;
        roleRecordEL = false;
        

        Integer pl=0, el=0, OPCounts =0;
        List<IB_Role__c> roleRecord = new List<IB_Role__c>();
        roleRecord = [Select IB_Role_Name__c, Status__c, Start_Date__c, CreatedDate from IB_Role__c where IB_Contact__c =: ConID AND 
                      (IB_Role_Name__c ='Programme Leader' 
                       OR IB_Role_Name__c ='Evaluation Leader') ORDER BY CreatedDate DESC];
        List<IB_Role__c> roleRecordOP = new List<IB_Role__c>();
        roleRecordOP = [Select IB_Role_Name__c, Status__c from IB_Role__c where IB_Contact__c =: ConID AND IB_Role_Name__c ='Teacher' AND Status__c != 'Declined' AND Status__c!= 'Withdrawn'];
        for(Ib_Role__c rol : roleRecordOP)
        {
            OPCounts++;
        }
        System.debug('**OPCounts: '+OPCounts);
        System.debug('**Role Record: '+roleRecord.size());
        for(IB_Role__c b: roleRecord)
        {
            DateTime dt = b.CreatedDate;
            Date CtDate = date.newinstance(dT.year(), dT.month(), dT.day());
            String abc = Label.IBEN_Role_Date;
            Integer xyz = integer.valueOf(abc);
            xyz = 0-xyz;
            Date dueDate = Date.today().addDays(xyz);

            if(b.IB_Role_Name__c == 'Programme Leader')
            {
                roleRecordPL = true;
                if(CtDate>dueDate)
                pl++;
                
            }
            else if (b.IB_Role_Name__c == 'Evaluation Leader')
            {
                roleRecordEL = true;
                if(CtDate>dueDate)
                el++;
            }

        }
        
        //Code added by Prerna on 18-10-2023 for ECM00566 --STARTS--
        //This query fetch the Ib role with name "IBEC Candidate" role
        List<IB_Role__c> ibecRoleRecord = [Select id, Active__c, IB_Role_Name__c from IB_Role__c where IB_Contact__c =: ConID AND IB_Role_Name__c = 'IBEC Candidate'];
        //Code added by Prerna on 18-10-2023 for ECM00566 --ENDS--
        
        for(IB_Role_Repository__c r:rolesMaster){
            // this code is edited for ecm324
            
            if(r.Role_Name__c=='Institute Transcript User' || r.Role_Name__c=='Institute Administrator' || r.Role_Name__c=='Communication User' || r.Role_Name__c=='Institute Policy User') /** For ECM00565  Added on 14-12-2022 (IB_Role_Name__c='Institute Policy User' OR condition) by Kashyap**/
            {
                //end
                instituteRolesNumber.add(insCounter);
                insCounter++;
                
                instituteRoles.add(r);
            }
            //Add IBEC Roles for ECM226 as part of Staff-Aug Project
            if(r.Role_Name__c == 'IBEC University Administrator' || r.Role_Name__c == 'IBEC Faculty Member' || r.Role_Name__c == 'IBEC Candidate'){
                ibecRoles.add(r);
            }
            //Code added by Prerna on 17-10-2023 for ECM00566 --STARTS--
            //This condition will add 'IBEC Certificate Holder' role in the ibecRoles list if the candidate already holds the "IBEC Candidate" role
            if(r.Role_Name__c == 'IBEC Certificate Holder' && ibecRoleRecord.size()>0){
                ibecRoles.add(r);
            }
            //Code added by Prerna on 17-10-2023 for ECM00566 --ENDS--
            
            //Add Association Roles for ECM336 as part of Staff-Aug Project
            if(r.Role_Name__c == 'Association Admin' || r.Role_Name__c == 'Association User'){
                associationRoles.add(r);
            }
            associationRoles.sort();
            ibecRoles.sort();
            instituteRoles.sort();
            if(r.Role_Name__c == 'Teacher'){
                teacherId = r.Id;
                onlineProviderRolesNumber.add(opCounter);
                opCounter++;
                onlineProviderRoles.add(r);
            }
            allRolesMap.put(r.Id,r);
           if(r.Role_Name__c == 'Programme Leader')
               {
                   if(ibBackground == true && conStaff == true && trainingPL == true && roleRecordEL == false && pl<2)
                   {
                           if(r.Application_Available_in_MyIB__c){
                                 applicationAvailable.put(r.Id,true);
                         } else {
                                applicationAvailable.put(r.Id,false);
                            }
                   }
                   else
                   {
                       applicationAvailable.put(r.Id,false);
                   }
               }
            else if(r.Role_Name__c == 'Evaluation Leader')
            {
                System.debug('CheckEL '+ibBackground+' - '+ conStaff + ' - '+ trainingEL +' - ' + roleRecordPL + ' - ' + el);
                if(ibBackground == true && conStaff == true && trainingEL == true && roleRecordPL == false && el<2)
                   {
                       if(r.Application_Available_in_MyIB__c){
                            applicationAvailable.put(r.Id,true);
                     } else {
                            applicationAvailable.put(r.Id,false);
                        }
                   }
                else
                {
                    applicationAvailable.put(r.Id,false);
                }
            }
            else
            { 
                if(r.Application_Available_in_MyIB__c){
                    applicationAvailable.put(r.Id,true);
                } else {
                    applicationAvailable.put(r.Id,false);
                }
            }
            if(r.Role_Type__c == 'School Role'){
                schoolRolesNumber.add(counter);
                counter++;
                schoolRoles.add(r);
            } else if(r.Role_Type__c == 'IBEN Role'){
                if(r.Category__c == 'Professional Development'){
                    if(r.Training_Model__c == 'Advanced Training'){
                        professionalDevelopmentAdvancedRoles.add(r);
                    } else {
                        professionalDevelopmentInitialRoles.add(r);
                    }
                } else if(r.Category__c == 'School Services'){
                    
                    if(r.Training_Model__c == 'Advanced Training'){
                        schoolServicesAdvancedRoles.add(r);
                    } else {
                        schoolServicesInitialRoles.add(r);
                    }
                }
            }
        }
        /** Code added By Kashyap on 21-12-2022 as a part of ECM00565 to make policy Role display at position 3 above communication User **/
            IB_Role_Repository__c policyUserRole;
        	Boolean policyUserExists;
            for(IB_Role_Repository__c ibRole :instituteRoles)
            {
                if(ibRole.Role_Name__c=='Institute Policy User')
                {
                     policyUserRole = ibRole;
                     policyUserExists = true;
                }
            }
            if(policyUserExists == true){
                instituteRoles.remove(instituteRoles.indexOf(policyUserRole));
                instituteRoles.add(2,policyUserRole);
            }
        
        
        /** end of logic to display policy Role at position 3 above communication User**/
        List<Id> rolesList = new List<Id>();
        Map<String,Integer> roleCountMap = new Map<String,Integer>();
        for(IB_Role__c r:myRoles){
            system.debug('Role: ' + r);
            if(r.Status_Value__c == 'Applicant')
                appliedForRoleProgrammeCombos.add(r.IB_Role_Programme_Combo__c);
            rolesList.add(r.Id);
            
            IB_Role_Repository__c curRole = allRolesMap.get(r.IB_Role__c);
            if(curRole != null){
                if(curRole.MyIB_Max_Number_of_this_Role__c != null){
                    Integer i = 0;
                    if(r.IB_Role_Name__c == 'Teacher')
                    {
                         i = OPCounts;
                        roleCountMap.put(curRole.Id, i);
                    }
                    else{
                        i = roleCountMap.get(curRole.Id);
                    System.debug('roleCountMap i= '+i);
                    if(i == null ){
                        roleCountMap.put(curRole.Id,1);
                    } else {
                        roleCountMap.put(curRole.Id, i+1);
                    }
                    }
                }
                system.debug('r.Status_Value__c: ' + r.Status_Value__c);
                system.debug('curRole.Category__c: ' + curRole.Category__c);
                system.debug('curRole.Training_Model__c: ' + curRole.Training_Model__c);
                if(r.Status_Value__c == 'Confirmed'){
                    if(curRole.Category__c == 'School Services'){
                        isAdvancedSchoolServices = true;
                    }
                    
                    if(curRole.Category__c == 'Professional Development'){
                        isAdvancedProfessionalDevelopment = true;
                    }
                }
            }
        }

        for(String r:roleCountMap.keySet()){
            if(roleCountMap.get(r) >= allRolesMap.get(r).MyIB_Max_Number_of_this_Role__c)
                applicationAvailable.put(r,false);
        }
        
        RoleApplicationSubjectService.roleList = rolesList;
        List<Role_Application_Subject__c> ras = RoleApplicationSubjectService.getSubjectsByRoleList();
        
        for(Role_Application_Subject__c r:ras){
            List<Role_Application_Subject__c> rasList = roleApplicationSubjectMap.get(r.Role_And_Application__c);
            if(rasList == null){
                rasList = new List<Role_Application_Subject__c>();
            }
            rasList.add(r);
            
            roleApplicationSubjectMap.put(r.Role_And_Application__c,rasList);
        }
        
        TrainingEventDAO teDao = TrainingEventDAO.INSTANCE;
        eligibleTraining = teDao.getEligibleTrainings(appliedForRoleProgrammeCombos,user.Contact.IB_Region__c,user.ContactId);
        List<Training_Event__c> appliedForTraining = teDao.getAppliedForTrainings(user.ContactId);
        for(Training_Event__c t:appliedForTraining){
            eligibleTraining.add(t);
        }
        
        system.debug('training: ' + eligibleTraining);
        
        
    } 
    
    //Following code is a part of ADASUS10 of Admin Assistant Project on 12/09/2021
    //Start 
    public PageReference adasAcceptRecord(){
        try{
            System.debug('Umair 1 ');
        ConID = userTemp.ContactId;
        Ib_Role__c roleRequired = [Select id, IB_Account__c,IB_Programme_New__c, IB_Role_Name__c, IB_Role_Name_fr__c, IB_Role_Name_es__c, 
                               Email__c, Status__c,IB_Contact__c,Account_Name__c,IB_Contact__r.Email from IB_Role__c Where id=:adasAcceptDocId];
        Contact contactOfRole = [Select id,Name,OwnerId,CreatedById from Contact where id=: roleRequired.IB_Contact__c];
        ID progID = roleRequired.IB_Programme_New__c;
        ID accID = roleRequired.IB_Account__c;
        List<IB_Role__c> ibRolePC = [Select Id, IB_Role_Name__c, Status__c from IB_Role__c where IB_Contact__c=:ConID AND IB_Programme_New__c=:progID  AND Status__c = 'Confirmed' AND IB_Role_Name__c = 'Programme Coordinator'];
        List<IB_Role__c> ibRoleHOS = [Select Id, IB_Role_Name__c, Status__c from IB_Role__c where IB_Contact__c=:ConID AND IB_Account__c =: accID AND Status__c = 'Confirmed' AND IB_Role_Name__c = 'Head of School'];
        List<IB_Role__c> ibRolesList = [Select Id, Status__c, IB_Role_Name__c, IB_Programme_New__c from IB_Role__c  where Status__c = 'Confirmed' AND IB_Role_Name__c = 'Admin Assistant' AND IB_Programme_New__c=:progID];
        User userRecord = [Select id, ProfileId from User Where ContactId =: roleRequired.IB_Contact__c];
        Profile profileRecord =  [select Id from profile where Name='Customer Community Advanced' limit 1];
            //Following code is a part of ADASUS02 of Admin Assistant Project on 12/09/2021
            //Start
            if(ibRolesList.size() >= Integer.valueOf(system.label.ADAS_AdminAssistantMaxLimitInteger)) 
            {
              ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.ADAS_Admin_Assistant_Max_Limit));
              return null;  
            }
            //End
            //Following code is a part of ADASUS03 of Admin Assistant Project on 12/09/2021
            //Start
            /*else if (ibRoleHOS.size()>0) // Removed as part of INC0175659 - Kevin Fugate
            {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, Label.ADAS_HOS_PC_Error));
                return null;
            }*/
            else if (ibRolePC.size()>0)
            {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, Label.ADAS_HOS_PC_Error));
                return null;
            }
            //End
         else 
         {
            if(roleRequired !=null)
            {
                roleRequired.Status__c = 'Confirmed'; 
                update roleRequired;
                AdminAssistantHelper.SendEmailToPCADASAccept(roleRequired,contactOfRole);
                PageReference tempPage = ApexPages.currentPage();            
                tempPage.setRedirect(true);
                callPublicSite(userRecord.Id, profileRecord.id);
                return tempPage;
                }
             return null;
             }
            
            }
    
    catch(Exception exp){
        System.debug('Umair 3 ');
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, Label.Error_Removing));
            return null;
        }
    }
    //This code is added as a part of ADASUS05 of Admin Assistant Project on 11/2/2021
    //Start
    @Future(callout=true)
    public static void callPublicSite(Id userId, Id profileIdToUpdate)
    {
        System.debug('Start callPublicSite');
        Site site = [SELECT Id FROM Site WHERE UrlPathPrefix = 'ibportal' LIMIT 1];
        String communityUrl = [SELECT SecureURL FROM SiteDetail WHERE DurableId =: site.Id].SecureUrl;
        String remoteURL = communityUrl + '/ProfileUpdate?userId=' + userId + '&profileId=' + profileIdToUpdate;
        system.debug('remoteURL=>'+remoteURL);
        HttpRequest httpRequest = new HttpRequest();
        httpRequest.setMethod('GET');
        httpRequest.setEndpoint(remoteURL);
        if(!Test.isRunningTest())
        HttpResponse httpResponse = new Http().send(httpRequest);
        System.debug('End callPublicSite');
        
    }
    //End 
    public PageReference adasRejectRecord(){
     try{
          Pagereference refrence = new Pagereference('/ibportal/roleRejectConfirmADAS');
          Ib_Role__c roleOfContact = [Select id, name, IB_Contact__c from Ib_Role__c where id=:adasRejectDocId Limit 1];
          refrence.getParameters().put('inviteidIBRole', roleOfContact.IB_Contact__c);
          refrence.getParameters().put('inviteidIBRoleID', roleOfContact.Id);
          refrence.setRedirect(true);
          return refrence;

        }
        catch(Exception exp){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, Label.Error_Removing));
            return null;
        }
        
    }
    //End ADASUS10
   
    // DAS 
       public PageReference removeRecord() 
    {
        IB_Role__c roleToRemove = [SELECT Id,IB_Role_Name__c,IB_Account__r.Name,Programme_Selection__c,Email__c,IB_Contact__c,
                                  Programme_Coordinator_First_Name__c,IB_Account__c, IB_Contact__r.User_Language__c, 
                                  IB_Contact__r.Email, Name, Status__c, IB_Programme_New__c, Programme_Coordinator_Email__c
                                  FROM IB_Role__c
                                      WHERE Id =: deleteAppDocId];
        
       List<IB_Role__c> confirmedCIRolesCount =[select id from IB_Role__c where 
                                                     IB_Account__c=: roleToRemove.IB_Account__c and Programme_Selection__c=: roleToRemove.Programme_Selection__c and 
      
                                                IB_Role_Name__c= 'Chief Invigilator' and Status__c='Confirmed' ];
        
        if((roleToRemove!= null && roleToRemove.IB_Role_Name__c != 'Chief Invigilator' ) || (confirmedCIRolesCount.size() > 1 )) {
            try{
                Pagereference ref = new Pagereference('/ibportal/roleRemoveRequest');
                ref.getParameters().put('TempID', deleteAppDocId);
                ref.setRedirect(true);
                return ref;
                
            }
            catch(Exception ex){
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, Label.Error_Removing));
                return null;
            }
        }
        /**else if(confirmedCIRolesCount.size() > 1 ){
            try{
                Pagereference ref = new Pagereference('/ibportal/roleRemoveRequest');
                ref.getParameters().put('TempID', deleteAppDocId);
                ref.setRedirect(true);
                return ref;
                
            }
            catch(Exception ex){
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, Label.Error_Removing));
                return null;
            }
        }**/
        else
        {
            
           displayPopup = 'true';
            system.debug('displayPopup***'+displayPopup);
            system.debug('deleteAppDocId***'+deleteAppDocId);
            return null;
        }
    }

    /** Added for DAS **/
    public void closePopup(){
        displayPopup = 'false';
        displaySuccessPopup ='false';
    }
    /** Added for DAS **/
    
    /** Sends Email to PC Saying he is the only CI Role available and wants to withdraw DAS ****/
     public void sendEmailToProgrammeCoordinator(){
        displayPopup = 'false';
         displaySuccessPopup ='true';
         // String[] toAddresses;
         List<String> toAddresses = new List<String>();
         String confirmedPCEmail;
           system.debug('deleteAppDocId***'+deleteAppDocId);
         system.debug('adasRejectDocId***'+adasRejectDocId);
        
       IB_Role__c loggedInUserRole  = [
            SELECT Id, Name,IB_Role_Name__c,IB_Account__c,Disable_CI_Role__c,Programme_Selection__c, IB_Contact__r.Name,IB_Account__r.Name   FROM IB_Role__c
            WHERE IB_Contact__c = :ConID and IB_Role_Name__c='Chief Invigilator'
            AND Status__c = 'Confirmed' limit 1];
         
         if(loggedInUserRole!= null){
             system.debug('loggedInUserRole before**'+loggedInUserRole.Id);
             system.debug('loggedInUserRole before**'+loggedInUserRole.Disable_CI_Role__c);
         loggedInUserRole.Disable_CI_Role__c= true;
         update loggedInUserRole;
         }
          system.debug('loggedInUserRole after**'+loggedInUserRole.Disable_CI_Role__c);
         system.debug('loggedInUserRole.Programme_Selection__c**'+loggedInUserRole.Programme_Selection__c);
         system.debug('loggedInUserRole.IB_Account__c**'+loggedInUserRole.IB_Account__c);
         
         List<IB_Role__c> confirmedPCRole=[select id,name,IB_Contact__r.name, email__c from IB_Role__c where IB_Role_Name__c= 'Programme Coordinator' 
                                           AND Status__c = 'Confirmed' and Programme_Selection__c =: loggedInUserRole.Programme_Selection__c and 
                                           IB_Account__c=: loggedInUserRole.IB_Account__c limit 1];
         
         if(!confirmedPCRole.isEmpty() ){
             
             for(IB_Role__c role: confirmedPCRole){
                 confirmedPCEmail= role.email__c;
                 //toAddresses = new String[] {confirmedPCEmail};
                       toAddresses.add(role.Email__c);
                     }
         }
          
        String ciName= loggedInUserRole.IB_Contact__r.Name;
        String schoolName= loggedInUserRole.IB_Account__r.Name;
      
        String developerName;
        String userLanguage= UserInfo.getLanguage();
         
            if(!toAddresses.isEmpty()){  
            // Create an email message object
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
         OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = 'myschool-noreply@ibo.org'];
         if (owea.size()>0) {
             mail.setOrgWideEmailAddressId(owea.get(0).Id);
         }
         
         if(userLanguage=='fr'){
             developerName = 'PIMS_CIWithdrawalTo_PC_fr';
             
         }else if(userLanguage=='es'){
             developerName = 'PIMS_CIWithdrawalTo_PC_es';
         }else{
             developerName = 'PIMS_CIWithdrawalTo_PC';
         }
         
         EmailTemplate template;  
         try {
             template = [SELECT id, name, HtmlValue, Subject, Body FROM EmailTemplate WHERE developername =: developerName];
         } catch (Exception e) {
             
         }
         
       
         String plainSubject= template.Subject;
         plainSubject=plainSubject.replace('[roleName]','Chief Invigilator');
         plainSubject=plainSubject.replace('[CI Name]',ciName);
         mail.setToAddresses(toAddresses);
         mail.setSubject(plainSubject);
         String plainBody = template.Body;
         plainBody = plainBody.replace('[School Name]', schoolName);
         if(confirmedPCRole[0].IB_Contact__r.name != null){
             plainBody= plainBody.replace('[Programme Coordinator]', confirmedPCRole[0].IB_Contact__r.name);
         }
          plainBody = plainBody.replace('[CI Name]', ciName);
         plainBody = plainBody.replace('[roleNameShort]','CI');
         
         mail.setPlainTextBody(plainBody);
         
         
         Messaging.SendEmailResult[] results = Messaging.sendEmail(
             new Messaging.SingleEmailMessage[] { mail });
         }
         
         
    }
    
     /** Sends Email to PC Saying he is the only CI Role available and wants to withdraw DAS ****/
    public PageReference isLoggedIn() {
        try
        {
            if (UserInfo.getUserType() == 'Guest') {
                return new PageReference('/ibportal/IBPortalLogin');
            }
            else {
                return null;
            }       
        }Catch(Exception x)
        {
            System.debug('Exception: '+x);
            return NULL;
        }
        
        
        
    }
    
    public void ConfirmEmailForInstUser() {
        try
        {
            CurrRole=[select id,name,Email_Confirmed__c,IB_Role_Name_es__c,IB_Role_Name_fr__c,IB_Role_Name__c from ib_role__c where id=:Apexpages.currentpage().getparameters().get('roleID')]; 
            CurrRole.Email_Confirmed__c=true;
            update CurrRole;


        }
        Catch(Exception x)
        {
            System.debug('Exception: '+x);
        }
        
        
        
    }
    
    public PageReference goBacktoMyIB() 
    {
        try{
            Pagereference ref = new Pagereference('/ibportal/');
          ref.setRedirect(true);
          return ref;

        }
        catch(Exception ex){
            System.debug('Exception: '+ex);
            return null;
        }
        
    }
    
    public String getLocale() {
        return UserInfo.getLanguage();
    }  
     public Id getIbTeachingExperienceRecordId() {
        RecordType rt = [SELECT Id FROM RecordType WHERE SobjectType = 'IB_E_Background__c' AND DeveloperName = 'IB_Teaching_Experience'];
        return rt.Id;
    }
}