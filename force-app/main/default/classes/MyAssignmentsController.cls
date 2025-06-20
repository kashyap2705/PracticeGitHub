public virtual class MyAssignmentsController {
    
    private static User user = UserDAO.INSTANCE.getUserById(Userinfo.getUserId());
    
        
    public String searchString {get; set;}
    public Boolean searchEligOnly {get; set;}
    public static List<IBActivity> myAssignments {get; set;}
    public static List<IBActivity> myEligAssignments {get; set;}
    public static List<IBActivity> myAssignmentsHistory {get; set;}
    public static List<IBActivity> MyCases {get; set;}
    public static String userId = String.valueOf(user.ContactId);
    public static String EligibilityPdf;
    public static String AssignemntTypesPdf;
    public static String StatusPdf;
    
    public Boolean check =false;
    public static set<Id> setRecentlyViewed = new set<Id>();
   /*  public static List<Viewed_IBEN_Assignment__c> viewedAssignments = [Select Community_User__c , IBEN_Assignment__c , Last_Access__c
                                                                       FROM  Viewed_IBEN_Assignment__c 
                                                                       WHERE  Community_User__c =: user.Id ]; */
    
    /**Modified by TBN**/
   /*  public static set<Id> setRecentlyViewed {get{
        
        set<Id> setRecentlyViewed = new set<Id>();

        for(Viewed_IBEN_Assignment__c objShadow : viewedAssignments)
        {
            setRecentlyViewed.add(objShadow.IBEN_Assignment__c);
        }
                                                 
        return setRecentlyViewed;
    }} */
    /**Modified by TBN**/
    public String selectedRole{get;set;}
    public List<SelectOption> myRoleOptions;
    private transient Map<String,Schema.RecordTypeInfo> campaignRtMapByName;
    public String selectedLanguage{get;set;}
    public List<SelectOption> languageOptions;
    private List<IB_E_Background__c> myLanguageExperiences;
    public String searchStartDate{get;set;}
    public String searchEndDate{get;set;}
    private Date startDate,endDate;
    public List<SelectOption> workshopCategoryOptions;
    public String selectedWorkshopCategory{get;set;}
    public String searchWorkshopTitle{get;set;}
    public String searchWorkshopCity{get;set;}
    public List<SelectOption> workshopCountryOptions;
    public String selectedWorkshopCountry{get;set;}
    public String searchSubject{get;set;}
    
    public List<IB_Workshop_Titles__c> ibWorkshopTitles {get;set;}
    public List<IB_Workshop_Titles__c> ibWorkshopTitles2 {get;set;}

    public DateUtility dateUtil {
        get{
            DateUtility util = new DateUtility();
            return util;
        }
   }
   

    private List<String> myRoles;
    private List<IB_Role__c> myAppliedForRoles;
    private set<String> myLanguages;
    private List<String> searchParams;
    
    
    public MyAssignmentsController(){
        system.debug('DEMEG: constructor');
        List<Viewed_IBEN_Assignment__c> viewedAssignments = [Select Community_User__c , IBEN_Assignment__c , Last_Access__c
                                                                       FROM  Viewed_IBEN_Assignment__c 
                                                                       WHERE  Community_User__c =: user.Id ];
        for(Viewed_IBEN_Assignment__c objShadow : viewedAssignments)
        {
            setRecentlyViewed.add(objShadow.IBEN_Assignment__c);
        }
        initializeSearchValues();
        initializeAndLoad(true, true);
    }
    
    public String getStatusPdf(){
        if (UserInfo.getLanguage() == 'fr'){
            system.debug(loggingLevel.ERROR,'STATUS:' + DocumentDAO.INSTANCE.getDocumentPathByName('Assignment Statuses French'));
            return DocumentDAO.INSTANCE.getDocumentPathByName('Assignment Statuses French');
        } else if (UserInfo.getLanguage() == 'es'){
            system.debug(loggingLevel.ERROR,'STATUS:' + DocumentDAO.INSTANCE.getDocumentPathByName('Assignment Statuses Spanish'));
            return DocumentDAO.INSTANCE.getDocumentPathByName('Assignment Statuses Spanish');
        } else {
            system.debug(loggingLevel.ERROR,'STATUS:' + DocumentDAO.INSTANCE.getDocumentPathByName('Assignment Statuses English'));
            return DocumentDAO.INSTANCE.getDocumentPathByName('Assignment Statuses English');
        }
     }
    
    public String getEligibilityPdf(){
        if (UserInfo.getLanguage() == 'fr'){
            system.debug(loggingLevel.ERROR,'ELIGIBILITY:' + DocumentDAO.INSTANCE.getDocumentPathByName('Assignment Statuses French'));
            return DocumentDAO.INSTANCE.getDocumentPathByName('Eligibility F');
        } else if (UserInfo.getLanguage() == 'es'){
            system.debug(loggingLevel.ERROR,'ELIGIBILITY:' + DocumentDAO.INSTANCE.getDocumentPathByName('Assignment Statuses Spanish'));
            return DocumentDAO.INSTANCE.getDocumentPathByName('Eligibility S');
        } else {
            system.debug(loggingLevel.ERROR,'ELIGIBILITY:' + DocumentDAO.INSTANCE.getDocumentPathByName('Assignment Statuses English'));
            return DocumentDAO.INSTANCE.getDocumentPathByName('Eligibility');
        }
     }
     
    public String getAssignmentTypesPdf(){
        if (UserInfo.getLanguage() == 'fr'){
            system.debug(loggingLevel.ERROR,'ASSIGNMENT:' + DocumentDAO.INSTANCE.getDocumentPathByName('Assignment Types French'));
            return DocumentDAO.INSTANCE.getDocumentPathByName('Assignment Types French');
        } else if (UserInfo.getLanguage() == 'es'){
            system.debug(loggingLevel.ERROR,'ASSIGNMENT:' + DocumentDAO.INSTANCE.getDocumentPathByName('Assignment Types Spanish'));
            return DocumentDAO.INSTANCE.getDocumentPathByName('Assignment Types Spanish');
        } else {
            system.debug(loggingLevel.ERROR,'ASSIGNMENT:' + DocumentDAO.INSTANCE.getDocumentPathByName('Assignment Types English'));
            return DocumentDAO.INSTANCE.getDocumentPathByName('Assignment Types English');
        }
    }
    
    private void initializeSearchValues()
    {
        selectedRole=null;
        selectedLanguage=null;
        searchStartDate=null;
        searchEndDate=null;
        selectedWorkshopCategory=null;
        searchWorkshopTitle=null;
        searchWorkshopCity=null;
        selectedWorkshopCountry=null;
    }

    //Initiatialize variables and load records
    private void initializeAndLoad(Boolean includeMyAssignments, Boolean includeEligAssignments){
        System.debug('DEMEG: intializeAndLoad...');
        myRoles = new List<String>();
    myLanguages = new set<String>();
        myAssignments = new List<IBActivity>();
        myEligAssignments = new List<IBActivity>();
        myAssignmentsHistory = new List<IBActivity>();
        MyCases = new List<IbActivity>();
        myLanguageExperiences = new List<IB_E_Background__c>();
        //added IB_Event__r.Delivery_Mode__c in soql as a part of ECM 00524 by kashyap
        //Added IB_Event__r.Programme_Relationship_Manager__c by Suraj as part of ECM00651
        //Added IB_Event__r.recordtype.name, IB_Event__r.Preliminary_Review_Start_Date__c, IB_Event__r.Preliminary_Review_End_Date__c, for ECM754- phase 3
        String query = 'Select Id,IB_Event__r.recordtype.name, IB_Event__r.Preliminary_Review_Start_Date__c, IB_Event__r.Preliminary_Review_End_Date__c,IB_Event__r.Delivery_Mode__c, Start_Date__c, Staffing_Event__c, Programme_s__c,Programme_From_Event_Role__c, Staffing_Event_Region__c, Staffing_Event_Country__c, Staffing_Event_City__c, ' +
            'toLabel(Staffing_Event__r.IB_Event__r.Workshop_Programme__c),IB_Event_Role__r.IB_Role_Name_fr__c,IB_Event_Role__r.IB_Role_Name_es__c,IB_Event_Role__r.Proposed_Language__c,IB_Event_Role__r.delivery_Mode__c, IB_Event_Role__r.PSP__c,IB_Role_Name__c, End_Date__c, toLabel(Application_Status__c), IB_Contact__c, Staffing_Event__r.Name, IB_Event__r.Programme_Relationship_Manager__c ' +
                                                'From My_Staffing_Event__c ' +
                                                'Where IB_Contact__c = :userId ' +
                                                'and Staffing_Event_Status__c != \'Cancelled\' '+
                                     //   'And Application_Status__c = \'Completed\' ' +
                                       'And ((Application_Status__c = \'Completed\' OR Application_Status__c = \'Confirmed\')and End_Date__c >= LAST_N_DAYS:730) ' + 
//  
                                      //  'And ID in (select ParentID from My_Staffing_Event__History)' +
                                        'Order by Start_Date__c LIMIT 1000';

        myRoles = IBActivity.loadMyRoles(myRoles, null);
    myLanguages = IBActivity.loadMyLanguages();
        myAppliedForRoles = IBActivity.loadMyIBRoles(null, 'Confirmed');

        if(includeMyAssignments){ 
            myAssignments = loadMyAssignments( null, false);
        }
        
        if(includeEligAssignments){
            myEligAssignments = loadEligibleAssignments(myEligAssignments, null);
            system.debug(loggingLevel.ERROR,'myEligAssignments: ' + myEligAssignments);           
        }
        
        myAssignmentsHistory = loadMyAssignments( query, true);
        MyCases =loadMyCases(MyCases);

        
        String languageExpRTId = IB_E_Background__c.SObjectType.getDescribe().getRecordTypeInfosByName().get('Language Experience').getRecordTypeId();
        myLanguageExperiences = IBEBackgroundDAO.INSTANCE.getIBEBackgroundsForContactAndRecordType(languageExpRTId, userId); 
        
        system.debug(loggingLevel.ERROR,'myLanguageExperiences: ' + myLanguageExperiences);
        system.debug(loggingLevel.ERROR,'assignmentHistory1: ' + myAssignmentsHistory);
        myAssignmentsHistory = IBActivity.sortIBActivities(myAssignmentsHistory);
        system.debug(loggingLevel.ERROR,'assignmentHistory2: ' + myAssignmentsHistory);
    }

    
    public PageReference isLoggedIn() {
        if (UserInfo.getUserType() == 'Guest') {
            return new PageReference('/educator/siteHomePage');
        }
        return null;
    }
     
    
    public Boolean getNoAssignments(){
        if(myAssignments==null || myAssignments.isEmpty()){
            return true;
        }
        return false;
    }
    
    
    public Boolean getHasRoles(){
        if(myAppliedForRoles!=null && !myAppliedForRoles.isEmpty()){
            return true;
        }
        return false;
    }

    
    public Boolean getNoEligAssignments(){
        if(myEligAssignments==null || myEligAssignments.isEmpty()){
            return true;
        }
        return false; 
    }
    
    
    public Boolean getNoAssignmentsHistory(){
        if(myAssignmentsHistory==null || myAssignmentsHistory.isEmpty()){
            return true;
        }
        return false; 
    }
    


    public void searchAssignments(){
        try{     
            if(String.isNotBlank(searchStartDate))
            {
                startDate = Date.valueOf(searchStartDate);
            }
            if(String.isNotBlank(searchEndDate))
            {
                endDate = Date.valueOf(searchEndDate);    
            }           
            if(searchEligOnly){
                initializeAndLoad(false, false);         
            }
            else{
                initializeAndLoad(false, false);
                myAssignments = loadSearchMyAssignments();
            }
            
            myEligAssignments = loadSearchEligibleAssignments();
        }
        catch(Exception ex){
            System.debug('ERROR: ' + ex);
        }
       
    }
    
    //Added by saurabh(EPAM) as part of bug 178022.
    public String IbApplicationSelect {
        get {
            return this.getTranslationsMap().get(IboUtil.Ib_Application_Select);
        }
        set;
    }
    private final List<String> constantList = new List<String>{IboUtil.Ib_Application_Select};
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
    
    
    public List<SelectOption> getMyRoleOptions()
    {
        List<SelectOption>roleOptions = new List<SelectOption>();
        roleOptions.add(new SelectOption('',IbApplicationSelect));
        Set<String> roleOps = new Set<String>();
        for(IB_Role__c role: myAppliedForRoles)
        {
            if(!roleOps.contains(role.IB_Role__c)){
                roleOps.add(role.IB_Role__c);
                String roleName = '';
                if (UserInfo.getLanguage() == 'fr')
                {
                    roleName = role.IB_Role__r.Role_Name_fr__c;
                }else if (UserInfo.getLanguage() == 'es')
                {
                    roleName = role.IB_Role__r.Role_Name_es__c;
                }else
                {
                    roleName = role.IB_Role_Name__c;
                }
                roleOptions.add(new SelectOption(role.IB_Role__c, roleName));
            }
        }
        
        return roleOptions;
    }

   

    public List<SelectOption> getLanguageOptions()
    {
        List<SelectOption> languageOptions = new List<SelectOption>();
        languageOptions.add(new SelectOption('',IbApplicationSelect));  
        for(IB_E_Background__c ibb: myLanguageExperiences)
        {
            languageOptions.add(new SelectOption(ibb.Language__c,ibb.Language__c));
        } 
        return languageOptions;
    }
    public List<SelectOption> getWorkshopCategoryOptions()
    {
        List<SelectOption> workshopCategoryOptions = new List<SelectOption>();
        workshopCategoryOptions.add(new SelectOption('',IbApplicationSelect)); 
        List<Schema.PickListEntry> campaignPickListValues = Campaign.Category__c.getDescribe().getPickListValues();
        for(Schema.PicklistEntry pickList : campaignPickListValues)
        {
            workshopCategoryOptions.add(new SelectOption(pickList.getValue(),pickList.getLabel()));
        } 
       
        return workshopCategoryOptions;
    }

    public List<SelectOption> getWorkshopCountryOptions()
    {
        List<SelectOption> workshopCountryOptions = new List<SelectOption>();
        workshopCountryOptions.add(new SelectOption('',IbApplicationSelect)); 

        CountrySegmentationDAO countryData = CountrySegmentationDAO.getInstance();
        List<IB_Country_Segmentation__c> countries = countryData.getAllCountries();

        for (IB_Country_Segmentation__c country : countries){
            if (UserInfo.getLanguage() == 'es' && country.Country_es__c != null) {
                workshopCountryOptions.add(new SelectOption(country.name, country.Country_es__c));
            }
            else if (UserInfo.getLanguage() == 'fr' && country.Country_fr__c != null) {
                workshopCountryOptions.add(new SelectOption(country.name, country.Country_fr__c));
            }
            else {
                workshopCountryOptions.add(new SelectOption(country.name, country.name));
            }
        }

        
        return workshopCountryOptions;
    }

    public void clearSearch(){
        searchEligOnly=true;
        initializeSearchValues();
        initializeAndLoad(true, true);
    }
    
    
    public Boolean getHasSearchString(){
        if(searchString != null && searchString.length() > 0){
            return true;
        }
        return false;
    }

    private List<IBActivity> loadMyAssignments(String query, Boolean historical){
        System.debug('Historical Data: '+historical);
        List<IBActivity> activities = new List<IBActivity>();
        List<IBActivity> activitiesCase = new List<IBActivity>();
        List<My_Staffing_Event__c> assignments = new List<My_Staffing_Event__c>();
        //Sheh
        List<Case> cases= new List<Case>();
        Date cutoffDate = Date.today().addDays(-30);
        try{
                if(query == null){// added IB_Event__r.Delivery_Mode__c in soql as a part of ECM 00524 by kashyap
                    //Added IB_Event__r.Programme_Relationship_Manager__c by Suraj as part of ECM00651
                    //Added IB_Event__r.recordtype.name, IB_Event__r.Preliminary_Review_Start_Date__c, IB_Event__r.Preliminary_Review_End_Date__c, for ECM754- phase 3
                    assignments = [Select Id,IB_Event__r.recordtype.name, IB_Event__r.Preliminary_Review_Start_Date__c, IB_Event__r.Preliminary_Review_End_Date__c, Start_Date__c, Staffing_Event__c, Staffing_Event__r.Id, Staffing_Event_Region__c, Staffing_Event_Country__c, Staffing_Event_City__c, 
                                   toLabel(Staffing_Event__r.IB_Event__r.Workshop_Programme__c),IB_Event_Role__c, IB_Event_Role__r.Proposed_Language__c,Programme_s__c,Programme_From_Event_Role__c, IB_Role_Name__c, End_Date__c, toLabel(Application_Status__c), IB_Contact__c, Staffing_Event__r.Name ,
                                   IB_Event_Role__r.Delivery_Mode__c,IB_Event_Role__r.PSP__c,IB_Event_Role__r.IB_Role_Name__c,IB_Event_Role__r.IB_Role__c,IB_Event__r.IB_Programme__c
                               ,IB_Event_Role__r.IB_Role_Name_fr__c,IB_Event_Role__r.IB_Role_Name_es__c,IB_Event__r.Delivery_Mode__c,IB_Event__r.Programme_Relationship_Manager__c
                                   From My_Staffing_Event__c
                                   Where IB_Contact__c = :user.ContactId
                                   AND IB_Event__r.Bundle__c = false
                                   And End_Date__c > TODAY  And
                                   (Application_Status__c NOT IN ('Not Selected', 'Not Approved', 'Invitation Declined', 'Withdrawn', 'Withdrawn by IB', 'Completed', 'Withdraw Interest')
                                    Or (Date_Declined__c != NULL And Date_Declined__c = LAST_N_DAYS:30)
                                    Or (Date_Withdrawn__c != NULL And Date_Withdrawn__c = LAST_N_DAYS:30))  //only display rejected or withdrawn assignments for 30 days
                                   Order by Start_Date__c, Staffing_Event__r.Name  LIMIT 1000];
                                                       

                     system.debug(loggingLevel.ERROR,' historyassignmentsquery: ' + assignments);
                }
                else{
                    System.debug('query inside private loadMyAssignments==='+query);
                    assignments = Database.query(query);
                }
         
            if(!assignments.isEmpty()){
                    system.debug(loggingLevel.ERROR, 'ACTIVITIES AFTER QUERY: ' + assignments);
                  //assignments=IBActivity.IbenRolesAssignments(assignments);
                    activities = IBActivity.addAssignmentsToActivities(activities, assignments);
                  /**Modified by TBN**/
                
                    for(IBActivity objIB : activities)
                    {
                        System.debug('====Test=='+objIB.ApplicationStatus);
                        if(objIB.ApplicationStatus == 'Invited'){
                        objIB.ListColor = setRecentlyViewed.contains(objIB.EventId) ? 'grey' : 'black';}
                    }
                    /**Modified by TBN**/
                    
                    if(!historical){  //only refine if not historical records
                        activities = IBActivity.refineActivities(activities);           
                    }       
             //   activities=IBActivity.addCasesToActivities(activities,cases);
                    
                }
                system.debug(loggingLevel.ERROR, 'ACTIVITIES AFTER IBACTIVITY: ' + activities);
        }catch(Exception e)
        {
            System.debug('Exception==='+e.getMessage());
        }

        
        return activities;
    }//end private loadMyAssignments()
    
    //Following Function is added by Shehryar-plumlogix to load cases in Sprint 22 on 06/10/2021 
    //Start
    public static List<IbActivity> loadMyCases(List<IBActivity>activities )
    {
        List<Case> cases=new List<Case>();
        try{

//this code is edited by developer ali haider bajwa-plumlogix for ECM00379 of staff aug project
//start
        cases=[Select id,CaseNumber,Examiner_1__c,RecordTypeId,RecordType.Name,Examiner_2__c,Subject,toLabel(Examiner_1_Review_Status__c),toLabel(Examiner_2_Review_Status__c),Examiner_1_Start_Date__c,Examiner_2_Start_Date__c,toLabel(PGQA_Examiner_1_Review_Status__c),toLabel(PGQA_Examiner_2_Review_Status__c),PGQA_Examiner_1_Start_Date__c,PGQA_Examiner_2_Start_Date__c,PGQA_Examiner_1__c,PGQA_Examiner_2__c

                     From Case
                      Where   ((RecordType.name In ('PGQA') And Status = 'Under Review') And (
                       ( PGQA_Examiner_1__c!=null And PGQA_Examiner_1_Review_Status__c = 'In-Progress'  And PGQA_Examiner_1__c =:user.ContactId)
                              Or (PGQA_Examiner_1_Review_Status__c ='Complete' And  PGQA_Examiner_2__c!= null And PGQA_Examiner_2__c = :user.ContactId And PGQA_Examiner_2_Review_Status__c = 'In-Progress')))
               or
               ((RecordType.name In ('SIPGE Request') And Status = 'Under Review') And (
                       ( Examiner_1__c!=null And Examiner_1_Review_Status__c = 'In-Progress'  And Examiner_1__c = :user.ContactId )
                  Or (Examiner_1_Review_Status__c ='Complete' And  Examiner_2__c!= null And Examiner_2__c = :user.ContactId And Examiner_2_Review_Status__c = 'In-Progress' And Examiner_1_Decision__c = 'Flag for Assessment escalation – predicted grade should be lower or higher' )))
                     ];
//end
             System.debug('Case: '+cases.size());

            if(!cases.isEmpty()){
            
                        
                activities=IBActivity.addCasesToActivities(activities,cases);
                    
                }
                system.debug(loggingLevel.ERROR, 'ACTIVITIES AFTER IBACTIVITY: ' + activities);
        }catch(Exception e)
        {
            System.debug('Exception==='+e.getMessage());
        }

        
        return activities;
    }
    //End

    public static List<IBActivity> loadMyAssignments(List<IBActivity> activities, String query, Boolean historical){
        List<My_Staffing_Event__c> assignments = new List<My_Staffing_Event__c>();
        Date cutoffDate = Date.today().addDays(-30);
        try{
                if(query == null){// added IB_Event__r.Delivery_Mode__c in soql as a part of ECM 00524 by kashyap
                    //Added IB_Event__r.Programme_Relationship_Manager__c by Suraj as part of ECM00651
                    //Added IB_Event__r.recordtype.name, IB_Event__r.Preliminary_Review_Start_Date__c, IB_Event__r.Preliminary_Review_End_Date__c, for ECM754- phase 3
                    assignments = [Select Id,IB_Event__r.recordtype.name, IB_Event__r.Preliminary_Review_Start_Date__c, IB_Event__r.Preliminary_Review_End_Date__c, Start_Date__c, Staffing_Event__c, Staffing_Event_Region__c, Staffing_Event_Country__c, Staffing_Event_City__c, 
                                                                toLabel(Staffing_Event__r.IB_Event__r.Workshop_Programme__c), Programme_s__c,Programme_From_Event_Role__c, IB_Role_Name__c, End_Date__c, toLabel(Application_Status__c), IB_Contact__c, Staffing_Event__r.Name ,
                                                                IB_Event_Role__r.Proposed_Language__c ,IB_Event_Role__r.Delivery_Mode__c,IB_Event_Role__r.PSP__c
                               ,IB_Event_Role__r.IB_Role_Name_fr__c,IB_Event_Role__r.IB_Role_Name_es__c,IB_Event__r.Delivery_Mode__c,IB_Event__r.Programme_Relationship_Manager__c 
                                                        From My_Staffing_Event__c
                                                        Where IB_Contact__c = :user.ContactId
                                                        And End_Date__c > TODAY  And
                                                            (Application_Status__c NOT IN ('Not Selected', 'Not Approved', 'Invitation Declined', 'Withdrawn', 'Withdrawn by IB', 'Completed', 'Withdraw Interest')
                                                             Or (Date_Declined__c != NULL And Date_Declined__c = LAST_N_DAYS:30)
                                                             Or (Date_Withdrawn__c != NULL And Date_Withdrawn__c = LAST_N_DAYS:30))  //only display rejected or withdrawn assignments for 30 days
                                                        Order by Start_Date__c, Staffing_Event__r.Name  LIMIT 1000];
                                                       

                     system.debug(loggingLevel.ERROR,'assignmentsquery: ' + assignments);
                }
                else{
                //query to show the completeed and confirmed assignments in assignment history
                //ECM477
                // added IB_Event__r.Delivery_Mode__c in soql as a part of ECM 00524 by kashyap
                //Added IB_Event__r.Programme_Relationship_Manager__c by Suraj as part of ECM00651
                //Added IB_Event__r.recordtype.name, IB_Event__r.Preliminary_Review_Start_Date__c, IB_Event__r.Preliminary_Review_End_Date__c, for ECM754- phase 3
                     assignments = [Select Id,IB_Event__r.recordtype.name, IB_Event__r.Preliminary_Review_Start_Date__c, IB_Event__r.Preliminary_Review_End_Date__c, Start_Date__c, Staffing_Event__c, Staffing_Event__r.Id, Staffing_Event_Region__c, Staffing_Event_Country__c, Staffing_Event_City__c, 
                                   toLabel(Staffing_Event__r.IB_Event__r.Workshop_Programme__c), Programme_s__c,Programme_From_Event_Role__c, IB_Role_Name__c, End_Date__c, toLabel(Application_Status__c), IB_Contact__c, Staffing_Event__r.Name ,
                                   IB_Event_Role__r.Proposed_Language__c,IB_Event_Role__r.Delivery_Mode__c,IB_Event_Role__r.PSP__c
                               ,IB_Event_Role__r.IB_Role_Name_fr__c,IB_Event_Role__r.IB_Role_Name_es__c,IB_Event__r.Delivery_Mode__c,IB_Event__r.Programme_Relationship_Manager__c 
                                   From My_Staffing_Event__c
                                   Where IB_Contact__c = :user.ContactId And End_Date__c > TODAY  And Staffing_Event_Status__c != 'Cancelled'
                                   And (Application_Status__c = 'Completed' Or Application_Status__c = 'Confirmed')   Order by Start_Date__c  LIMIT 1000];
                    
                    System.debug('query inside loadMyAssignments==='+query);
                    assignments = Database.query(query);
                }
                if(!assignments.isEmpty()){
                    system.debug(loggingLevel.ERROR, 'ACTIVITIES AFTER QUERY: ' + assignments);
                    activities = IBActivity.addAssignmentsToActivities(activities, assignments);
                    system.debug('HISTORICAL: ' + historical);
                    if(!historical){  //only refine if not historical records
                        system.debug('Before refine activities');
                        activities = IBActivity.refineActivities(activities);
                        system.debug('After refine activities');
                    }           
                }
                system.debug(loggingLevel.ERROR, 'ACTIVITIES AFTER IBACTIVITY: ' + activities);
        }catch(Exception e)
        {
            System.debug('Exception==='+e.getMessage());
        }

        
        return activities;
    }
    

    
    private List<IBActivity> loadSearchMyAssignments(){
        List<IBActivity> searchResults = new List<IBActivity>();
        String query = '';
        String andFilters = getSearchFilters();
        System.debug('selectedRole==='+selectedRole); 
        System.debug('selectedLanguage==='+selectedLanguage); 
        System.debug('selectedWorkshopCountry==='+selectedWorkshopCountry); 
        System.debug('selectedWorkshopCategory==='+selectedWorkshopCategory); 
        System.debug('searchWorkshopCity==='+searchWorkshopCity); 
       
        //Get subset of Role ID's by keyword
        //Get subset of Role ID's by keyword
        if(String.isNotBlank(selectedRole))
        {
            andFilters+= 'And Staffing_Event__c IN ' 
                            + '(Select Staffing_Event__c ' 
                            + 'From IB_Event_Role__c ' 
                            + 'Where IB_Role__c = :selectedRole) '; 
        }
        /*if(String.isNotBlank(selectedRole))
        {
            String roleSearchQuery = 'SELECT Staffing_Event__c FROM IB_Event_Role__c WHERE IB_Role_Name__c = \''+selectedRole+'\'' ;
            searchRoleIds = IBActivity.loadSearchRoles(searchRoleIds, roleSearchQuery);    
        }
        
        if(!searchRoleIds.isEmpty()){
            String idsForQuery= '(';
            for(String rId : searchRoleIds)
            {
                idsForQuery+= '\''+rId+'\',';
            }
            Integer lastIndex = idsForQuery.lastIndexOf(',');
            idsForQuery = idsForQuery.substring(0,lastIndex);
            idsForQuery += ')';
            andFilters += ' AND Staffing_Event__c In '+idsForQuery;
        }*/
        
        myAppliedForRoles = IBActivity.loadMyIBRoles(null, 'Confirmed');
        //IB_Event_Role__r.Proposed_Language__c, 
        // added IB_Event__r.Delivery_Mode__c in soql as a part of ECM 00524 by kashyap
        //Added IB_Event__r.Programme_Relationship_Manager__c by Suraj as part of ECM00651
        //Added IB_Event__r.recordtype.name, IB_Event__r.Preliminary_Review_Start_Date__c, IB_Event__r.Preliminary_Review_End_Date__c for ECM00754 phase 3
        query = 'Select Id,IB_Event__r.recordtype.name, IB_Event__r.Preliminary_Review_Start_Date__c, IB_Event__r.Preliminary_Review_End_Date__c,IB_Event__r.Delivery_Mode__c , Start_Date__c, IB_Event_Role__r.Proposed_Language__c,IB_Event_Role__r.Delivery_Mode__c,IB_Event_Role__r.PSP__c,Staffing_Event__c, Staffing_Event_Type__c, Staffing_Event_Region__c, Staffing_Event_Country__c, Staffing_Event_City__c, ' +
            'Programme_s__c,Programme_From_Event_Role__c,IB_Event_Role__r.IB_Role_Name_fr__c,IB_Event_Role__r.IB_Role_Name_es__c, IB_Role_Name__c, End_Date__c, Application_Status__c, IB_Contact__c, Staffing_Event__r.Name, IB_Event__r.Programme_Relationship_Manager__c' +
                                            ' From My_Staffing_Event__c ' 
                                            + ' WHERE IB_Contact__c = :userId '
                                            + andFilters
                                            + ' Order by Start_Date__c';
        System.debug('final query===='+query);                                            
        searchResults = loadMyAssignments( query, false);
        return searchResults;
    }
    



    /* Eligible Assignments pagination */
    Integer pageSize = 50;
    Integer pageNumber = 0; 
    Integer totalEligible = 0;
    Boolean isSearch = false;
    
    public integer pgNum{
        get{return pageNumber + 1;}
    }
    
    public Integer totalElResults{
        get{return totalEligible;}
    }
    
    public Integer totalPages{
        get{ 
            Integer tpResult = (totalEligible / pageSize);
            
            // if there are 380 results and page size is 100 there will be 3.8 pages which
            // when returned as a whole number is just 3, so round up one more page...
            if(math.mod(tpResult,pageSize) != 0){
                return tpResult + 1;
            } else {
                return tpResult; // assumes there was no remainder in tpResult (ex: 200 results / page size of 100 = 2 pages even.)
            }
        }
    }
    
    public Boolean hasNext{ 
        get{
            return (pageNumber + 1) < totalPages;
        }
    }
    
    public Boolean hasPrev{
        get{
            return pageNumber > 0;
        }
    }
    
    public void nextEA(){
        pageNumber++;
        if(isSearch){
            searchAssignments();
        } else {
            initializeAndLoad(true, true);
        }
    }
 
    public void prevEA(){
        if (pageNumber > 0) 
            pageNumber--;
        if(isSearch){
            searchAssignments();
        } else {
            initializeAndLoad(true, true);
        }
    }

    
    
    
    private List<IBActivity> loadEligibleAssignments(List<IBActivity> activities, String query){
    
        String userRegion = getUserRegion();
        String userCountry = getUserCountry();
        List<String> roleIds = IBActivity.getRoleIds(myAppliedForRoles);
        List<Staffing_Event__c> assignments = new List<Staffing_Event__c>();
        
        Set<String> roleProgrammeCombo = new Set<String>();
        //Following Line is added by plumlogix For ECM 477
        //Start
        for(IB_Role__c r:myAppliedForRoles){
            if(r.Role_Programme_Psp_Combo__c.Contains('2014 - 2020')){
                roleProgrammeCombo.add(r.IB_Role_Programme_Combo__c+'|2014');
                roleProgrammeCombo.add(r.IB_Role_Programme_Combo__c+'|2020');
            }
            else if(r.Upskilled_in_PSP__c==''|| r.Upskilled_in_PSP__c==null){
                roleProgrammeCombo.add(r.IB_Role_Programme_Combo__c+'|');
            }
            else{
                roleProgrammeCombo.add(r.Role_Programme_Psp_Combo__c);
            }
        }
        //EnD
        
        Integer offSet = pageSize * pageNumber;
        
        system.debug(loggingLevel.ERROR, 'ROLEIDS: ' + roleIds);
        system.debug(loggingLevel.ERROR, 'MYAPPLIEDFORROLES: ' + myAppliedForRoles);
        system.debug(loggingLevel.ERROR, 'ROLEIDS: ' + roleIds);
        system.debug(loggingLevel.ERROR, 'MYAPPLIEDFORROLES: ' + myAppliedForRoles);
        system.debug('userRegion: ' + userRegion);
        system.debug('userId: ' + userId);
        system.debug('selectedRole: ' + selectedRole);
        system.debug('query inside loadEligibleAssignments==='+query);
        
        //query = null;
        
        if(query == null){
            if(myLanguages != null && !myLanguages.isEmpty()){//To filter based on User's language experience
        // For pagination, calculate the total number of results
        if(userRegion == 'IBAEM') {
          AggregateResult[] arList =  [SELECT count(id)
                  FROM Staffing_Event__c //IBEN Assignment
                  WHERE Staffing_Event_Status__c NOT IN ('Pending', 'Staffed', 'Postponed', 'Cancelled', 'Complete', 'Confirmed') 
                    And ( Staffing_Event_Region__c = :userRegion OR Staffing_Event_Country__c = 'PAKISTAN')
                    And Start_Date__c != null and End_Date__c != null
                    And (Start_Date__c >= TODAY OR (Staffing_Event_Type__c IN ('Candidacy Consultation', 'Request for authorization', 'Request for Candidacy', 'Course Outline Reading')))
                    And IB_Event__r.Bundle__c = false 
                    And Id IN
                      (Select Staffing_Event__c
                       From IB_Event_Role__c
                       Where IB_Role__c IN :roleIds
                         AND Role_Programme_Psp_Combo__c IN :roleProgrammeCombo
                         AND Positions_Left__c  > 0 // DEMEG: TESTING CPU TIMEOUT
                         AND (Proposed_Language__c = null OR Proposed_Language__c IN :myLanguages)
                       )
                    And Id NOT IN
                      (Select Staffing_Event__c
                       From My_Staffing_Event__c
                       Where IB_Contact__c = :user.ContactId)];
          totalEligible = Integer.valueOf(arList[0].get('expr0'));
          System.debug('Total eligible: ' + totalEligible);
          
          // Now get the actual results (now limited to the pageSize and the OFFSET)
          // added by kashyap IB_Event__r.delivery_Mode__c,IB_Event__r.Event_Language__c  as a part of ECM 00524 
          // Added IB_Event__r.Programme_Relationship_Manager__c by Suraj as part of ECM00651
          //Added IB_Event__r.recordtype.name, IB_Event__r.Preliminary_Review_Start_Date__c, IB_Event__r.Preliminary_Review_End_Date__c, for ECm00754 phase 3
          assignments = [ SELECT Id,IB_Event__r.recordtype.name, IB_Event__r.Preliminary_Review_Start_Date__c, IB_Event__r.Preliminary_Review_End_Date__c,IB_Event__r.delivery_Mode__c,IB_Event__r.Event_Language__c,IB_Event__r.IB_Docs_ID__c, IB_Event__r.Applicant_Eligibility_Location__c,IB_Event__r.Programme_Relationship_Manager__c,Workshop_Product_Title__c, Start_Date__c, Staffing_Event_Region__c, Staffing_Event_Country__c, Staffing_Event_City__c, Programme_s__c, End_Date__c, Name, Subject__c, Staffing_Event_Type__c, Related_Subject__c,
                                   (Select IB_Role_Name__c, IB_Role__c,IB_Role_Name_fr__c,IB_Role_Name_es__c, IB_Workshop_Product_Title__c, toLabel(IB_Programme__c), Positions_Left__c from IB_Event_Roles__r where Positions_Left__c > 0)
                  FROM Staffing_Event__c //IBEN Assignment
                  WHERE Staffing_Event_Status__c NOT IN ('Pending', 'Staffed', 'Postponed', 'Cancelled', 'Complete', 'Confirmed') 
                    And ( Staffing_Event_Region__c = :userRegion OR Staffing_Event_Country__c = 'PAKISTAN')
                    And Start_Date__c != null and End_Date__c != null
                    And (Start_Date__c >= TODAY OR (Staffing_Event_Type__c IN ('Candidacy Consultation', 'Request for authorization', 'Request for Candidacy', 'Course Outline Reading')))
                    And IB_Event__r.Bundle__c = false 
                    And Id IN
                      (Select Staffing_Event__c
                       From IB_Event_Role__c
                       Where IB_Role__c IN :roleIds
                         AND Role_Programme_Psp_Combo__c IN :roleProgrammeCombo // DEMEG: TESTING CPU TIMEOUT
                         AND Positions_Left__c > 0
                         AND (Proposed_Language__c = null OR Proposed_Language__c IN :myLanguages)
                       )
                    And Id NOT IN
                      (Select Staffing_Event__c
                       From My_Staffing_Event__c
                       Where IB_Contact__c = :user.ContactId)
                  ORDER BY Start_Date__c, Name
                  LIMIT :pageSize  
                  OFFSET :offset];
        }
        else if(userRegion == 'IBAP') {
          AggregateResult[] arList =  [SELECT count(id)
                  FROM Staffing_Event__c //IBEN Assignment
                  WHERE Staffing_Event_Status__c NOT IN ('Pending', 'Staffed', 'Postponed', 'Cancelled', 'Complete', 'Confirmed') 
                    And (Staffing_Event_Region__c = :userRegion OR IB_Event__r.Applicant_Eligibility_Location__c = 'Global')
                    And Staffing_Event_Country__c != 'PAKISTAN'
                    And Start_Date__c != null and End_Date__c != null
                    And (Start_Date__c >= TODAY OR (Staffing_Event_Type__c IN ('Candidacy Consultation', 'Request for authorization', 'Request for Candidacy', 'Course Outline Reading')))
                    And IB_Event__r.Bundle__c = false 
                    And Id IN
                      (Select Staffing_Event__c
                       From IB_Event_Role__c
                       Where IB_Role__c IN :roleIds
                         AND Role_Programme_Psp_Combo__c IN :roleProgrammeCombo
                                               
                         AND Positions_Left__c  > 0 // DEMEG: TESTING CPU TIMEOUT
                         AND (Proposed_Language__c = null OR Proposed_Language__c IN :myLanguages)
                       )
                    And Id NOT IN
                      (Select Staffing_Event__c
                       From My_Staffing_Event__c
                       Where IB_Contact__c = :user.ContactId)];
          totalEligible = Integer.valueOf(arList[0].get('expr0'));
          System.debug('Total eligible: ' + totalEligible);
          
          // Now get the actual results (now limited to the pageSize and the OFFSET)
            // added by kashyap IB_Event__r.delivery_Mode__c,IB_Event__r.Event_Language__c  as a part of ECM 00524
            // Added IB_Event__r.Programme_Relationship_Manager__c by Suraj as part of ECM00651 
            // Added IB_Event__r.recordtype.name, IB_Event__r.Preliminary_Review_Start_Date__c, IB_Event__r.Preliminary_Review_End_Date__c,
          assignments = [ SELECT Id,IB_Event__r.recordtype.name, IB_Event__r.Preliminary_Review_Start_Date__c, IB_Event__r.Preliminary_Review_End_Date__c,Event_Type__c,IB_Event__r.delivery_Mode__c,IB_Event__r.Event_Language__c,IB_Event__r.IB_Docs_ID__c, IB_Event__r.Applicant_Eligibility_Location__c,Workshop_Product_Title__c, Start_Date__c, Staffing_Event_Region__c, Staffing_Event_Country__c, Staffing_Event_City__c, Programme_s__c, End_Date__c, Name, Subject__c,IB_Event__r.Programme_Relationship_Manager__c, Staffing_Event_Type__c, Related_Subject__c,
                                   (Select IB_Role_Name__c, IB_Role__c,IB_Role_Name_fr__c,IB_Role_Name_es__c,IB_Workshop_Product_Title__c, toLabel(IB_Programme__c), Positions_Left__c from IB_Event_Roles__r where Positions_Left__c > 0)
                  FROM Staffing_Event__c //IBEN Assignment
                  WHERE Staffing_Event_Status__c NOT IN ('Pending', 'Staffed', 'Postponed', 'Cancelled', 'Complete', 'Confirmed') 
                    And (Staffing_Event_Region__c = :userRegion)
                    And Staffing_Event_Country__c != 'PAKISTAN'
                    And Start_Date__c != null and End_Date__c != null
                    And (Start_Date__c >= TODAY OR (Staffing_Event_Type__c IN ('Candidacy Consultation', 'Request for authorization', 'Request for Candidacy', 'Course Outline Reading')))
                    And IB_Event__r.Bundle__c = false 
                    And Id IN
                      (Select Staffing_Event__c
                       From IB_Event_Role__c
                       Where IB_Role__c IN :roleIds
                         AND Role_Programme_Psp_Combo__c IN :roleProgrammeCombo // DEMEG: TESTING CPU TIMEOUT
                         AND Positions_Left__c > 0
                         AND (Proposed_Language__c = null OR Proposed_Language__c IN :myLanguages)
                       )
                    And Id NOT IN
                      (Select Staffing_Event__c
                       From My_Staffing_Event__c
                       Where IB_Contact__c = :user.ContactId)
                  ORDER BY Start_Date__c, Name
                  LIMIT :pageSize  
                  OFFSET :offset
                  ];
        }
        else  {
          AggregateResult[] arList =  [SELECT count(id)
                  FROM Staffing_Event__c //IBEN Assignment
                  WHERE Staffing_Event_Status__c NOT IN ('Pending', 'Staffed', 'Postponed', 'Cancelled', 'Complete', 'Confirmed') 
                    And (Staffing_Event_Region__c = :userRegion)
                    And Start_Date__c != null and End_Date__c != null
                    And (Start_Date__c >= TODAY OR (Staffing_Event_Type__c IN ('Candidacy Consultation', 'Request for authorization', 'Request for Candidacy', 'Course Outline Reading')))
                    And IB_Event__r.Bundle__c = false 
                    And Id IN
                      (Select Staffing_Event__c
                       From IB_Event_Role__c
                       Where IB_Role__c IN :roleIds
                         AND Role_Programme_Psp_Combo__c IN :roleProgrammeCombo
                         AND Positions_Left__c  > 0 // DEMEG: TESTING CPU TIMEOUT
                         AND (Proposed_Language__c = null OR Proposed_Language__c IN :myLanguages)
                       )
                    And Id NOT IN
                      (Select Staffing_Event__c
                       From My_Staffing_Event__c
                       Where IB_Contact__c = :user.ContactId)];
          totalEligible = Integer.valueOf(arList[0].get('expr0'));
          System.debug('Total eligible: ' + totalEligible);
          
          // Now get the actual results (now limited to the pageSize and the OFFSET)
          // added by kashyap IB_Event__r.delivery_Mode__c,IB_Event__r.Event_Language__c  as a part of ECM 00524
          // Added IB_Event__r.Programme_Relationship_Manager__c by Suraj as part of ECM00651
          // Added IB_Event__r.recordtype.name, IB_Event__r.Preliminary_Review_Start_Date__c, IB_Event__r.Preliminary_Review_End_Date__c,
          assignments = [ SELECT Id,IB_Event__r.recordtype.name, IB_Event__r.Preliminary_Review_Start_Date__c, IB_Event__r.Preliminary_Review_End_Date__c,IB_Event__r.delivery_Mode__c,IB_Event__r.Event_Language__c,IB_Event__r.IB_Docs_ID__c, IB_Event__r.Applicant_Eligibility_Location__c,Workshop_Product_Title__c, Start_Date__c, Staffing_Event_Region__c, Staffing_Event_Country__c, Staffing_Event_City__c, Programme_s__c, End_Date__c, Name, Subject__c, Staffing_Event_Type__c, Related_Subject__c,IB_Event__r.Programme_Relationship_Manager__c,
                                   (Select IB_Role_Name__c, IB_Role__c,IB_Role_Name_fr__c,IB_Role_Name_es__c, IB_Workshop_Product_Title__c, toLabel(IB_Programme__c), Positions_Left__c from IB_Event_Roles__r where Positions_Left__c > 0)
                  FROM Staffing_Event__c //IBEN Assignment
                  WHERE Staffing_Event_Status__c NOT IN ('Pending', 'Staffed', 'Postponed', 'Cancelled', 'Complete', 'Confirmed') 
                    And (Staffing_Event_Region__c = :userRegion)
                    And Start_Date__c != null and End_Date__c != null
                    And (Start_Date__c >= TODAY OR (Staffing_Event_Type__c IN ('Candidacy Consultation', 'Request for authorization', 'Request for Candidacy', 'Course Outline Reading')))
                    And IB_Event__r.Bundle__c = false 
                    And Id IN
                      (Select Staffing_Event__c
                       From IB_Event_Role__c
                       Where IB_Role__c IN :roleIds
                         AND Role_Programme_Psp_Combo__c IN :roleProgrammeCombo // DEMEG: TESTING CPU TIMEOUT
                         AND Positions_Left__c > 0
                         AND (Proposed_Language__c = null OR Proposed_Language__c IN :myLanguages)
                       )
                    And Id NOT IN
                      (Select Staffing_Event__c
                       From My_Staffing_Event__c
                       Where IB_Contact__c = :user.ContactId)
                  ORDER BY Start_Date__c, Name
                  LIMIT :pageSize  
                  OFFSET :offset
                  ];
        }
      }
      else{
        // For pagination, calculate the total number of results
        if(userRegion == 'IBAEM') {
          AggregateResult[] arList =  [SELECT count(id)
                  FROM Staffing_Event__c //IBEN Assignment
                  WHERE Staffing_Event_Status__c NOT IN ('Pending', 'Staffed', 'Postponed', 'Cancelled', 'Complete', 'Confirmed') 
                    And ( Staffing_Event_Region__c = :userRegion  OR IB_Event__r.Applicant_Eligibility_Location__c = 'Global' OR Staffing_Event_Country__c = 'PAKISTAN')
                    And Start_Date__c != null and End_Date__c != null
                    And (Start_Date__c >= TODAY OR (Staffing_Event_Type__c IN ('Candidacy Consultation', 'Request for authorization', 'Request for Candidacy', 'Course Outline Reading')))
                    And IB_Event__r.Bundle__c = false 
                    And Id IN
                      (Select Staffing_Event__c
                       From IB_Event_Role__c
                       Where IB_Role__c IN :roleIds
                         AND Role_Programme_Psp_Combo__c IN :roleProgrammeCombo
                         AND Positions_Left__c  > 0 // DEMEG: TESTING CPU TIMEOUT
                       )
                    And Id NOT IN
                      (Select Staffing_Event__c
                       From My_Staffing_Event__c
                       Where IB_Contact__c = :user.ContactId)];
          totalEligible = Integer.valueOf(arList[0].get('expr0'));
          System.debug('Total eligible: ' + totalEligible);
          
          // Now get the actual results (now limited to the pageSize and the OFFSET)
          // added by kashyap IB_Event__r.delivery_Mode__c,IB_Event__r.Event_Language__c  as a part of ECM 00524
          // Added IB_Event__r.Programme_Relationship_Manager__c by Suraj as part of ECM00651
          // Added IB_Event__r.recordtype.name, IB_Event__r.Preliminary_Review_Start_Date__c, IB_Event__r.Preliminary_Review_End_Date__c,
          assignments = [ SELECT Id,IB_Event__r.recordtype.name, IB_Event__r.Preliminary_Review_Start_Date__c, IB_Event__r.Preliminary_Review_End_Date__c,IB_Event__r.delivery_Mode__c,IB_Event__r.Event_Language__c, IB_Event__r.IB_Docs_ID__c,IB_Event__r.Applicant_Eligibility_Location__c,Workshop_Product_Title__c, Start_Date__c, Staffing_Event_Region__c, Staffing_Event_Country__c, Staffing_Event_City__c, Programme_s__c, End_Date__c, Name, Subject__c, Staffing_Event_Type__c, Related_Subject__c,IB_Event__r.Programme_Relationship_Manager__c,
                                   (Select IB_Role_Name__c, IB_Role__c,IB_Role_Name_fr__c,IB_Role_Name_es__c, IB_Workshop_Product_Title__c, toLabel(IB_Programme__c), Positions_Left__c from IB_Event_Roles__r where Positions_Left__c > 0)
                  FROM Staffing_Event__c //IBEN Assignment
                  WHERE Staffing_Event_Status__c NOT IN ('Pending', 'Staffed', 'Postponed', 'Cancelled', 'Complete', 'Confirmed') 
                    And ( Staffing_Event_Region__c = :userRegion OR Staffing_Event_Country__c = 'PAKISTAN')
                    And Start_Date__c != null and End_Date__c != null
                    And (Start_Date__c >= TODAY OR (Staffing_Event_Type__c IN ('Candidacy Consultation', 'Request for authorization', 'Request for Candidacy', 'Course Outline Reading')))
                    And IB_Event__r.Bundle__c = false 
                    And Id IN
                      (Select Staffing_Event__c
                       From IB_Event_Role__c
                       Where IB_Role__c IN :roleIds
                         AND Role_Programme_Psp_Combo__c IN :roleProgrammeCombo // DEMEG: TESTING CPU TIMEOUT
                         AND Positions_Left__c > 0
                       )
                    And Id NOT IN
                      (Select Staffing_Event__c
                       From My_Staffing_Event__c
                       Where IB_Contact__c = :user.ContactId)
                  ORDER BY Start_Date__c, Name
                  LIMIT :pageSize  
                  OFFSET :offset];
        }
        else if(userRegion == 'IBAP') {
          AggregateResult[] arList =  [SELECT count(id)
                  FROM Staffing_Event__c //IBEN Assignment
                  WHERE Staffing_Event_Status__c NOT IN ('Pending', 'Staffed', 'Postponed', 'Cancelled', 'Complete', 'Confirmed') 
                    And (Staffing_Event_Region__c = :userRegion)
                    And Staffing_Event_Country__c != 'PAKISTAN'
                    And Start_Date__c != null and End_Date__c != null
                    And (Start_Date__c >= TODAY OR (Staffing_Event_Type__c IN ('Candidacy Consultation', 'Request for authorization', 'Request for Candidacy', 'Course Outline Reading')))
                    And IB_Event__r.Bundle__c = false 
                    And Id IN
                      (Select Staffing_Event__c
                       From IB_Event_Role__c
                       Where IB_Role__c IN :roleIds
                         AND Role_Programme_Psp_Combo__c IN :roleProgrammeCombo
                         AND Positions_Left__c  > 0 // DEMEG: TESTING CPU TIMEOUT
                       )
                    And Id NOT IN
                      (Select Staffing_Event__c
                       From My_Staffing_Event__c
                       Where IB_Contact__c = :user.ContactId)];
          totalEligible = Integer.valueOf(arList[0].get('expr0'));
          System.debug('Total eligible: ' + totalEligible);
          
          // Now get the actual results (now limited to the pageSize and the OFFSET)
            // added by kashyap IB_Event__r.delivery_Mode__c,IB_Event__r.Event_Language__c  as a part of ECM 00524
            // Added IB_Event__r.Programme_Relationship_Manager__c by Suraj as part of ECM00651
            // Added IB_Event__r.recordtype.name, IB_Event__r.Preliminary_Review_Start_Date__c, IB_Event__r.Preliminary_Review_End_Date__c,
          assignments = [ SELECT Id,IB_Event__r.recordtype.name, IB_Event__r.Preliminary_Review_Start_Date__c, IB_Event__r.Preliminary_Review_End_Date__c,IB_Event__r.delivery_Mode__c,IB_Event__r.Event_Language__c,IB_Event__r.IB_Docs_ID__c, IB_Event__r.Applicant_Eligibility_Location__c,Workshop_Product_Title__c, Start_Date__c, Staffing_Event_Region__c, Staffing_Event_Country__c, Staffing_Event_City__c, Programme_s__c, End_Date__c, Name, Subject__c, Staffing_Event_Type__c, Related_Subject__c,IB_Event__r.Programme_Relationship_Manager__c,
                                   (Select IB_Role_Name__c,IB_Role_Name_fr__c,IB_Role_Name_es__c, IB_Role__c, IB_Workshop_Product_Title__c, toLabel(IB_Programme__c), Positions_Left__c from IB_Event_Roles__r where Positions_Left__c > 0)
                  FROM Staffing_Event__c //IBEN Assignment
                  WHERE Staffing_Event_Status__c NOT IN ('Pending', 'Staffed', 'Postponed', 'Cancelled', 'Complete', 'Confirmed') 
                    And (Staffing_Event_Region__c = :userRegion)
                    And Staffing_Event_Country__c != 'PAKISTAN'
                    And Start_Date__c != null and End_Date__c != null
                    And (Start_Date__c >= TODAY OR (Staffing_Event_Type__c IN ('Candidacy Consultation', 'Request for authorization', 'Request for Candidacy', 'Course Outline Reading')))
                    And IB_Event__r.Bundle__c = false 
                    And Id IN
                      (Select Staffing_Event__c
                       From IB_Event_Role__c
                       Where IB_Role__c IN :roleIds
                         AND Role_Programme_Psp_Combo__c IN :roleProgrammeCombo // DEMEG: TESTING CPU TIMEOUT
                         AND Positions_Left__c > 0
                       )
                    And Id NOT IN
                      (Select Staffing_Event__c
                       From My_Staffing_Event__c
                       Where IB_Contact__c = :user.ContactId)
                  ORDER BY Start_Date__c, Name
                  LIMIT :pageSize  
                  OFFSET :offset
                  ];
        }
        else  {
          AggregateResult[] arList =  [SELECT count(id)
                  FROM Staffing_Event__c //IBEN Assignment
                  WHERE Staffing_Event_Status__c NOT IN ('Pending', 'Staffed', 'Postponed', 'Cancelled', 'Complete', 'Confirmed') 
                    And (Staffing_Event_Region__c = :userRegion)
                    And Start_Date__c != null and End_Date__c != null
                    And (Start_Date__c >= TODAY OR (Staffing_Event_Type__c IN ('Candidacy Consultation', 'Request for authorization', 'Request for Candidacy', 'Course Outline Reading')))
                    And IB_Event__r.Bundle__c = false 
                    And Id IN
                      (Select Staffing_Event__c
                       From IB_Event_Role__c
                       Where IB_Role__c IN :roleIds
                         AND Role_Programme_Psp_Combo__c IN :roleProgrammeCombo
                         AND Positions_Left__c  > 0 // DEMEG: TESTING CPU TIMEOUT
                       )
                    And Id NOT IN
                      (Select Staffing_Event__c
                       From My_Staffing_Event__c
                       Where IB_Contact__c = :user.ContactId)];
          totalEligible = Integer.valueOf(arList[0].get('expr0'));
          System.debug('Total eligible: ' + totalEligible);
          
          // Now get the actual results (now limited to the pageSize and the OFFSET)
          // added by kashyap IB_Event__r.delivery_Mode__c,IB_Event__r.Event_Language__c  as a part of ECM 00524
          // Added IB_Event__r.Programme_Relationship_Manager__c by Suraj as part of ECM00651
          // Added IB_Event__r.recordtype.name, IB_Event__r.Preliminary_Review_Start_Date__c, IB_Event__r.Preliminary_Review_End_Date__c,
          assignments = [ SELECT Id,IB_Event__r.recordtype.name, IB_Event__r.Preliminary_Review_Start_Date__c, IB_Event__r.Preliminary_Review_End_Date__c,IB_Event__r.delivery_Mode__c,IB_Event__r.Event_Language__c,IB_Event__r.IB_Docs_ID__c,IB_Event__r.Applicant_Eligibility_Location__c, Workshop_Product_Title__c, Start_Date__c, Staffing_Event_Region__c, Staffing_Event_Country__c, Staffing_Event_City__c, Programme_s__c, End_Date__c, Name, Subject__c, Staffing_Event_Type__c, Related_Subject__c,IB_Event__r.Programme_Relationship_Manager__c,
                                   (Select IB_Role_Name__c,IB_Role_Name_fr__c,IB_Role_Name_es__c, IB_Role__c, IB_Workshop_Product_Title__c, toLabel(IB_Programme__c), Positions_Left__c from IB_Event_Roles__r where Positions_Left__c > 0)
                  FROM Staffing_Event__c //IBEN Assignment
                  WHERE Staffing_Event_Status__c NOT IN ('Pending', 'Staffed', 'Postponed', 'Cancelled', 'Complete', 'Confirmed') 
                    And (Staffing_Event_Region__c = :userRegion)
                    And Start_Date__c != null and End_Date__c != null
                    And (Start_Date__c >= TODAY OR (Staffing_Event_Type__c IN ('Candidacy Consultation', 'Request for authorization', 'Request for Candidacy', 'Course Outline Reading')))
                    And IB_Event__r.Bundle__c = false 
                    And Id IN
                      (Select Staffing_Event__c
                       From IB_Event_Role__c
                       Where IB_Role__c IN :roleIds
                         AND Role_Programme_Psp_Combo__c IN :roleProgrammeCombo // DEMEG: TESTING CPU TIMEOUT
                         AND Positions_Left__c > 0
                       )
                    And Id NOT IN
                      (Select Staffing_Event__c
                       From My_Staffing_Event__c
                       Where IB_Contact__c = :user.ContactId)
                  ORDER BY Start_Date__c, Name
                  LIMIT :pageSize  
                  OFFSET :offset
                  ];
        }
            }
        } else {
            //totalEligible = 0;
            System.debug('query inside loadEligibleAssignments==='+query);
            //query += ' LIMIT ' + pageSize + ' OFFSET ' + offset;
            assignments = Database.query(query);
            totalEligible = assignments.size();
            isSearch=true;
            query= query.split('LIMIT',2).get(0);
            query += ' LIMIT ' + pageSize + ' OFFSET ' + offset; 
            assignments = Database.query(query);
        }
    //Following code line is added by Umair-Plumlogix of US11930 of Staff Augmentation on 06/03/2020
        //Begin
        if(query == null ||(query !=null && check ==true) )
        assignments = covid_workshops(assignments,pagesize,offset,userRegion,userCountry,roleProgrammeCombo,roleIds);
        //End
        system.debug(loggingLevel.ERROR, 'ASSIGNMENTS: ' + assignments);

        if(!assignments.isEmpty()){

            // DEMEG: COMMENTED OUT - TESTING CPU TIMEOUT
            //assignments = IBActivity.refineEligibleAssignments(assignments);

            system.debug(loggingLevel.ERROR, 'After Refind Eligible Assignments: ' + assignments);
            //assignments = IBActivity.filterAssignmentsByProgramme(assignments, myAppliedForRoles);
            //assignments = IBActivity.filterAssignmentsBySubject(assignments,eligibleWorkshopTitles);
            system.debug('assignments: ' + assignments);
            system.debug('myAppliedForRoles: ' + myAppliedForRoles );

            // DEMEG: COMMENTED OUT: TESTING CPU TIMEOUT
            //assignments = IBActivity.filterAssignmentsByProgramme(assignments, myAppliedForRoles);
            
            assignments = IBActivity.filterAssignmentsByProgrammeAndSubject(assignments, myAppliedForRoles);
            system.debug(loggingLevel.ERROR, 'After Filter BY programme and subject: ' + assignments);
              //filter out by programme  
            activities = IBActivity.addEligAssignmentsToActivities(activities, assignments);
            /**Modified by TBN**/
            for(IBActivity objIB : activities)
            {
                system.debug('==2==>>>>' + setRecentlyViewed);
                objIB.ListColor = setRecentlyViewed.contains(objIB.Id) ? 'grey' : 'black'; 
                system.debug('===>objIB.ListColor' + objIB.ListColor + ' Id:' + objIB.Id);
            }
            /**Modified by TBN**/
            system.debug(loggingLevel.ERROR, 'FINAL: ' + activities);
        }



        system.debug(loggingLevel.ERROR, 'ELIGIBLE ASSIGNMENTS: ' + activities);

        return activities;
    }
    //Following code line is added by Umair-Plumlogix of US11930 of Staff Augmentation on 06/03/2020
    //Begin
    public List<Staffing_Event__c> covid_workshops(List<Staffing_Event__c> assignments,Integer pagesize,Integer offset,String userRegion,String userCountry,Set<String>roleProgrammeCombo,List<String> roleIds){
        List<Staffing_Event__c> final_assignments = new List<Staffing_Event__c>();
        List<Staffing_Event__c> global_assignments = new List<Staffing_Event__c>();
        Map<id, Staffing_Event__c> temp_assignments = new Map<id,Staffing_Event__c>();
        
        global_assignments = Global_workshops(assignments,pagesize,offset,roleProgrammeCombo,roleIds);
        
        integer index =0 ;
        assignments.addAll(global_assignments);
        if(assignments != null)
        for(Staffing_Event__c event:assignments ){

                if(event.Staffing_Event_Type__c== 'Cluster Workshop' || event.Staffing_Event_Type__c== 'Regional Workshop' || event.Staffing_Event_Type__c== 'In School Workshop'
                  ||  event.Staffing_Event_Type__c== IBConstants.SCHEDULED_WORKSHOP  ||  event.Staffing_Event_Type__c== IBConstants.REQUESTED_WORKSHOP)
                   {
                    
                  if ((event.IB_Event__r.Applicant_Eligibility_Location__c == 'Venue Region' && event.Staffing_Event_Region__c == userRegion) 
                    || (event.IB_Event__r.Applicant_Eligibility_Location__c == 'Venue Country' && event.Staffing_Event_Country__c==userCountry) 
                      || (event.IB_Event__r.Applicant_Eligibility_Location__c == 'Global'))
                   {
                         temp_assignments.put(event.Id, event);
                   }
                   }
            else
            {
                temp_assignments.put(event.Id, event);
            }
        }  
        final_assignments.addall(temp_assignments.values());
        System.debug('Ass: '+final_assignments.size()+' '+final_assignments);
        return final_assignments;
    }    
    //End
    private List<IBActivity> loadSearchEligibleAssignments(){
            /*Search filters:
            *** Programme
            *** From
            *** To
            *** Country
            *** Event Type
            *** Role
            */ 
        Set<String> roleProgrammeCombo = new Set<String>();
      
        //Following code is added by plumlogix For ECM 477
        //Start
        for(IB_Role__c r:myAppliedForRoles){
            if(r.Upskilled_in_PSP__c=='2014 - 2020'){
                roleProgrammeCombo.add(r.IB_Role_Programme_Combo__c+'|2014');
                roleProgrammeCombo.add(r.IB_Role_Programme_Combo__c+'|2020');
            }
            else if(r.Upskilled_in_PSP__c==''|| r.Upskilled_in_PSP__c==null){
                roleProgrammeCombo.add(r.IB_Role_Programme_Combo__c+'|');
            }
            else{
                roleProgrammeCombo.add(r.Role_Programme_Psp_Combo__c);
            }
        }
        //END
        
        
        System.debug('selectedRole==='+selectedRole); 
       system.debug('roleProgrammeCombo==='+roleProgrammeCombo);
        System.debug('selectedLanguage==='+selectedLanguage); 
        System.debug('selectedWorkshopCountry==='+selectedWorkshopCountry); 
        System.debug('searchWorkshopCity==='+searchWorkshopCity); 
        System.debug('selectedWorkshopCategory==='+selectedWorkshopCategory); 
        
        List<IBActivity> searchResults = new List<IBActivity>();
        String query = '';
        String andFilters = '';


        if(String.isNotBlank(selectedRole) && String.isnotBlank(selectedLanguage)){
             andFilters +=  ' And Id In (Select Staffing_Event__c from IB_Event_Role__c where IB_Role__c = :selectedRole AND Role_Programme_Psp_Combo__c in :roleProgrammeCombo AND toLabel(Proposed_Language__c) = :selectedLanguage) ' ;
        } else if(String.isNotBlank(selectedRole)) {
            //Following code line is added by Umair-Plumlogix of US11930 of Staff Augmentation on 06/03/2020
          //Begin
            check= selectedRole.contains('Workshop Leader');
            //End
            andFilters+= ' And Id IN ' 
                            + '(Select Staffing_Event__c ' 
                            + 'From IB_Event_Role__c ' 
                            + 'Where IB_Role__c = :selectedRole '
                            + 'AND Role_Programme_Psp_Combo__c in :roleProgrammeCombo) '; 
            
        } else if(String.isnotBlank(selectedLanguage)) {
           andFilters +=  ' And Id In (Select Staffing_Event__c from IB_Event_Role__c where Role_Programme_Psp_Combo__c in :roleProgrammeCombo AND toLabel(Proposed_Language__c) = :selectedLanguage)';
        } else {
            andFilters+= ' And Id IN ' 
                            + '(Select Staffing_Event__c ' 
                            + 'From IB_Event_Role__c ' 
                            + 'WHERE Role_Programme_Psp_Combo__c in :roleProgrammeCombo) ';
        }
        
        if(String.isnotBlank(searchStartDate)){
            andFilters += ' AND Start_Date__c>=:startDate';
        }       

        if(String.isnotBlank(searchEndDate)){
            andFilters += ' AND End_Date__c<=:endDate';
        }

        if(String.isnotBlank(selectedWorkshopCategory)){
            andFilters += ' AND Category__c =:selectedWorkshopCategory';
        }
        
        if(String.isnotBlank(searchWorkshopTitle)){
            andFilters += ' AND Staffing_Event_Name__c like \'%'+String.escapeSingleQuotes(searchWorkshopTitle)+'%\'';
        }
        
        if(String.isnotBlank(selectedWorkshopCountry)){
            andFilters += ' AND Staffing_Event_Country__c =:selectedWorkshopCountry';
        }

        if(String.isnotBlank(searchWorkshopCity)){
            andFilters += ' AND Staffing_Event_City__c like \'%'+String.escapeSingleQuotes(searchWorkshopCity)+'%\'';
        }
        if(String.isnotBlank(searchSubject)){
            andFilters += ' AND Subject__c like \'%'+String.escapeSingleQuotes(searchSubject)+'%\'';
        }
        //real
        String userRegion = getuserRegion();
        if(userRegion == 'IBAEM') {// added by kashyap IB_Event__r.delivery_Mode__c,IB_Event__r.Event_Language__c  as a part of ECM 00524
            //Added IB_Event__r.Programme_Relationship_Manager__c by Suraj as part of ECM00651
            //Added IB_Event__r.recordtype.name, IB_Event__r.Preliminary_Review_Start_Date__c, IB_Event__r.Preliminary_Review_End_Date__c,
            query = 'Select Id,IB_Event__r.recordtype.name, IB_Event__r.Preliminary_Review_Start_Date__c, IB_Event__r.Preliminary_Review_End_Date__c,IB_Event__r.delivery_Mode__c,IB_Event__r.Event_Language__c,IB_Event__r.IB_Docs_ID__c,IB_Event__r.Programme_Relationship_Manager__c,Start_Date__c, Staffing_Event_Region__c, Subject__c, Workshop_Product_Title__c,Staffing_Event_Name__c, Staffing_Event_Country__c,Category__c, Staffing_Event_Type__c,Staffing_Event_City__c, Programme_s__c, End_Date__c, Name, ' +
                '(Select IB_Role_Name__c,IB_Role_Name_fr__c,IB_Role_Name_es__c, IB_Role__c, tolabel(IB_Programme__c), Positions_Left__c from IB_Event_Roles__r where Positions_Left__c > 0) ' +
                      'From Staffing_Event__c ' +
                      'Where Staffing_Event_Status__c NOT IN (\'Pending\', \'Staffed\', \'Postponed\', \'Cancelled\', \'Complete\', \'Confirmed\')  '
                                                    + 'And (Start_Date__c >= TODAY OR (Staffing_Event_Type__c IN (\'Candidacy Consultation\', \'Request for authorization\', \'Request for Candidacy\', \'Course Outline Reading\')))'
                          +'And (Staffing_Event_Region__c = :userRegion OR Staffing_Event_Country__c = \'PAKISTAN\' )'
                          + 'And IB_Event__r.Bundle__c = false '
                          + 'And Id NOT IN ' 
                                + '(Select Staffing_Event__c ' 
                                + 'From My_Staffing_Event__c ' 
                                + 'Where IB_Contact__c = :userId) ' 
        //Following code is updated by Shehryar-plumlogix as a part of US-12219 of Sprint 20 of Staff Auf on  05/02/2021
                //start  
                +    'and End_Date__c >= TODAY '
        //End  
                + andFilters
                         + ' Order by Start_Date__c  LIMIT 1000';
        }
        else if(userRegion == 'IBAP') {// added by kashyap IB_Event__r.delivery_Mode__c,IB_Event__r.Event_Language__c  as a part of ECM 00524
            //Added IB_Event__r.Programme_Relationship_Manager__c by Suraj as part of ECM00651
            //Added IB_Event__r.recordtype.name, IB_Event__r.Preliminary_Review_Start_Date__c, IB_Event__r.Preliminary_Review_End_Date__c,
      query = 'Select Id,IB_Event__r.recordtype.name, IB_Event__r.Preliminary_Review_Start_Date__c, IB_Event__r.Preliminary_Review_End_Date__c,IB_Event__r.delivery_Mode__c,IB_Event__r.Event_Language__c,IB_Event__r.IB_Docs_ID__c,IB_Event__r.Programme_Relationship_Manager__c, Start_Date__c, Staffing_Event_Region__c, Subject__c, Workshop_Product_Title__c,Staffing_Event_Name__c, Staffing_Event_Country__c,Category__c, Staffing_Event_Type__c,Staffing_Event_City__c, Programme_s__c, End_Date__c, Name, ' +
                '(Select IB_Role_Name__c,IB_Role_Name_fr__c,IB_Role_Name_es__c, IB_Role__c, tolabel(IB_Programme__c), Positions_Left__c from IB_Event_Roles__r where Positions_Left__c > 0) ' +
                      'From Staffing_Event__c ' +
                      'Where Staffing_Event_Status__c NOT IN (\'Pending\', \'Staffed\', \'Postponed\', \'Cancelled\', \'Complete\', \'Confirmed\')  ' 
                                                    + 'And (Start_Date__c >= TODAY OR (Staffing_Event_Type__c IN (\'Candidacy Consultation\', \'Request for authorization\', \'Request for Candidacy\', \'Course Outline Reading\')))'
                          + 'And Staffing_Event_Region__c = :userRegion '
                          + 'And Staffing_Event_Country__c != \'PAKISTAN\''
                          + 'And IB_Event__r.Bundle__c = false '
                          + 'And Id NOT IN ' 
                                + '(Select Staffing_Event__c ' 
                                + 'From My_Staffing_Event__c ' 
                                + 'Where IB_Contact__c = :userId) '
                //Following code is updated by Shehryar-plumlogix as a part of US-12219 of Sprint 20 of Staff Auf on  05/02/2021
                //start
                                +    'and End_Date__c >= TODAY '
        //End  
                + andFilters
                         + ' Order by Start_Date__c LIMIT 1000';
        }
        else {
            // added by kashyap IB_Event__r.delivery_Mode__c,IB_Event__r.Event_Language__c  as a part of ECM 00524
            //Added IB_Event__r.Programme_Relationship_Manager__c by Suraj as part of ECM00651
     		//Added IB_Event__r.recordtype.name, IB_Event__r.Preliminary_Review_Start_Date__c, IB_Event__r.Preliminary_Review_End_Date__c,
      query = 'Select Id,IB_Event__r.recordtype.name, IB_Event__r.Preliminary_Review_Start_Date__c, IB_Event__r.Preliminary_Review_End_Date__c,IB_Event__r.delivery_Mode__c,IB_Event__r.Event_Language__c,IB_Event__r.IB_Docs_ID__c,IB_Event__r.Programme_Relationship_Manager__c,Start_Date__c, Staffing_Event_Region__c, Subject__c, Workshop_Product_Title__c,Staffing_Event_Name__c, Staffing_Event_Country__c,Category__c, Staffing_Event_Type__c,Staffing_Event_City__c, Programme_s__c, End_Date__c, Name, ' +
                '(Select IB_Role_Name__c,IB_Role_Name_fr__c,IB_Role_Name_es__c, IB_Role__c, tolabel(IB_Programme__c), Positions_Left__c from IB_Event_Roles__r where Positions_Left__c > 0) ' +
                      'From Staffing_Event__c ' +
                      'Where Staffing_Event_Status__c NOT IN (\'Pending\', \'Staffed\', \'Postponed\', \'Cancelled\', \'Complete\', \'Confirmed\')  ' 
                                                    + 'And (Start_Date__c >= TODAY OR (Staffing_Event_Type__c IN (\'Candidacy Consultation\', \'Request for authorization\', \'Request for Candidacy\', \'Course Outline Reading\')))'
                          + 'And Staffing_Event_Region__c = :userRegion '
                          + 'And IB_Event__r.Bundle__c = false '
                          + 'And Id NOT IN ' 
                                + '(Select Staffing_Event__c ' 
                                + 'From My_Staffing_Event__c ' 
                                + 'Where IB_Contact__c = :userId) '
                //Following code is updated by Shehryar-plumlogix as a part of US-12219 of Sprint 20 of Staff Auf on  05/02/2021
                //start
                                +    'and End_Date__c >= TODAY '
        //End  
                + andFilters
                         + ' Order by Start_Date__c LIMIT 1000';
        }
        System.debug('query inside loadSearchEligibleAssignments===='+query);
        searchResults = loadEligibleAssignments(searchResults, query);  
        //}
    System.debug('Test1' + searchResults);
        return searchResults;
    }//end loadSearchEligibleAssignments()

    private String getSearchFilters()
    {
        String andFilters = '';
       
        
        if(String.isnotBlank(selectedLanguage))
        {
         //   andFilters += ' AND toLabel(Staffing_Event__r.IB_Event__r.venue_account__r.Language_Of_Correspondance__c)=:selectedLanguage';
         andFilters +=  ' And Id In (Select Staffing_Event__c from IB_Event_Role__c where Proposed_Language__c = :selectedLanguage)';      
        }

        if(String.isnotBlank(searchStartDate))
        {
            andFilters += ' AND Start_Date__c>=:startDate';
        }

       
        if(String.isnotBlank(searchEndDate))
        {
            andFilters += ' AND End_Date__c<=:endDate';
        }

        if(String.isnotBlank(selectedWorkshopCategory))
        {
            andFilters += ' AND Category__c =:selectedWorkshopCategory';
        }
        
        if(String.isnotBlank(searchWorkshopTitle))
        {
            andFilters += ' AND Staffing_Event__r.Staffing_Event_Name__c like \'%'+String.escapeSingleQuotes(searchWorkshopTitle)+'%\'';
        }
        if(String.isnotBlank(selectedWorkshopCountry))
        {
            andFilters += ' AND Staffing_Event_Country__c =:selectedWorkshopCountry';
        }
        if(String.isnotBlank(searchWorkshopCity))
        {
            andFilters += ' AND Staffing_Event_City__c like \'%'+String.escapeSingleQuotes(searchWorkshopCity)+'%\'';
        }
        if(String.isnotBlank(searchSubject))
        {
            andFilters += ' AND Subject__c like \'%'+String.escapeSingleQuotes(searchSubject)+'%\'';
        }
        
        return andFilters;
    }//end getSearchFilters()

   private String getUserRegion(){
    List<Contact> myContact = [Select IB_Region__c From Contact c Where Id = :user.ContactId LIMIT 1];
    return myContact[0].IB_Region__c;
   }
    //Following code line is added by Umair-Plumlogix of US11930 of Staff Augmentation on 06/03/2020
    //Begin
   private String getUserCountry(){
    List<Contact> myContact = [Select Country__r.Name From Contact c Where Id = :user.ContactId LIMIT 1];
    return myContact[0].Country__r.Name;
   }
    private  List<Staffing_Event__c> Global_workshops(List<Staffing_Event__c> final_assignments,Integer pagesize,Integer offset,Set<String>roleProgrammeCombo,List<String> roleIds){
        List<Staffing_Event__c> global_assignments = new List<Staffing_Event__c>();
       if(myLanguages != null && !myLanguages.isEmpty()){
        global_assignments = [select Id,IB_Event__r.recordtype.name, IB_Event__r.Preliminary_Review_Start_Date__c, IB_Event__r.Preliminary_Review_End_Date__c,IB_Event__r.Applicant_Eligibility_Location__c, Workshop_Product_Title__c, Start_Date__c, Staffing_Event_Region__c, 
                       Staffing_Event_Country__c, Staffing_Event_City__c, Programme_s__c, End_Date__c, Name, Subject__c, Staffing_Event_Type__c, 
                       Related_Subject__c,(Select IB_Role_Name__c, IB_Role__c,IB_Workshop_Product_Title__c, toLabel(IB_Programme__c),Positions_Left__c 
                       from IB_Event_Roles__r where Positions_Left__c > 0) from Staffing_Event__c where 
                       (Staffing_Event_Type__c= 'Cluster Workshop'OR Staffing_Event_Type__c= 'Regional Workshop' OR Staffing_Event_Type__c= 'In School Workshop'
                       OR Staffing_Event_Type__c =: IBConstants.REQUESTED_WORKSHOP OR Staffing_Event_Type__c =: IBConstants.SCHEDULED_WORKSHOP)  And Start_Date__c != null and End_Date__c != null
                    And (IB_Event__r.Applicant_Eligibility_Location__c = 'Global' OR
                                             IB_Event__r.Applicant_Eligibility_Location__c = 'Venue Country' )
                                        And Start_Date__c >= TODAY
                    And IB_Event__r.Bundle__c = false 
                    And Id IN
                      (Select Staffing_Event__c
                       From IB_Event_Role__c
                       Where IB_Role__c IN :roleIds
                         AND Role_Programme_Psp_Combo__c IN :roleProgrammeCombo // DEMEG: TESTING CPU TIMEOUT
                         AND Positions_Left__c > 0
                                                  AND (Proposed_Language__c = null OR Proposed_Language__c IN :myLanguages)
                       )
                    And Id NOT IN
                      (Select Staffing_Event__c
                       From My_Staffing_Event__c
                       Where IB_Contact__c = :user.ContactId)
                                       And Id Not IN:final_assignments
                  ORDER BY Start_Date__c, Name
                  LIMIT :pageSize  
                  OFFSET :offset];
        }
        else {
        global_assignments = [select Id,IB_Event__r.recordtype.name, IB_Event__r.Preliminary_Review_Start_Date__c, IB_Event__r.Preliminary_Review_End_Date__c,IB_Event__r.Applicant_Eligibility_Location__c, Workshop_Product_Title__c, Start_Date__c, Staffing_Event_Region__c, 
                       Staffing_Event_Country__c, Staffing_Event_City__c, Programme_s__c, End_Date__c, Name, Subject__c, Staffing_Event_Type__c, 
                                  Related_Subject__c,(Select IB_Role_Name__c,IB_Role_Name_fr__c,IB_Role_Name_es__c, IB_Role__c,IB_Workshop_Product_Title__c, toLabel(IB_Programme__c),Positions_Left__c 
                       from IB_Event_Roles__r where Positions_Left__c > 0) from Staffing_Event__c where 
                       (Staffing_Event_Type__c= 'Cluster Workshop'OR Staffing_Event_Type__c= 'Regional Workshop' OR Staffing_Event_Type__c= 'In School Workshop'
                       OR Staffing_Event_Type__c =: IBConstants.REQUESTED_WORKSHOP OR Staffing_Event_Type__c =: IBConstants.SCHEDULED_WORKSHOP)  And Start_Date__c != null and End_Date__c != null
                    And (IB_Event__r.Applicant_Eligibility_Location__c = 'Global' OR
                                             IB_Event__r.Applicant_Eligibility_Location__c = 'Venue Country' )
                                        And Start_Date__c >= TODAY
                    And IB_Event__r.Bundle__c = false 
                    And Id IN
                      (Select Staffing_Event__c
                       From IB_Event_Role__c
                       Where IB_Role__c IN :roleIds
                         AND Role_Programme_Psp_Combo__c IN :roleProgrammeCombo // DEMEG: TESTING CPU TIMEOUT
                         AND Positions_Left__c > 0
                       )
                    And Id NOT IN
                      (Select Staffing_Event__c
                       From My_Staffing_Event__c
                       Where IB_Contact__c = :user.ContactId)
                                      And Id Not IN:final_assignments
                  ORDER BY Start_Date__c, Name
                  LIMIT :pageSize  
                  OFFSET :offset];
        }
        return global_assignments;
    }
   //End
}