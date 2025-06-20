public without sharing class RoleEditCtrl {
    
    private IB_Role__c role; 
    //public IB_Event_Role__c eventRole;
    public List<Training_Event__c> training;
    private final Map<String,IB_Role_Repository__c> rolesMap = new Map< String , IB_Role_Repository__c>(); 
    private final User user; 
    private final String  INTERNAL_LICENSE = 'Salesforce';
    private Date today = date.today();
    public String elapsedTime;
    public Boolean edit;
    public IB_Role_Repository__c roleRepo {get; set;}
    public String referencesCap = String.valueOf(Label.IBENPortal_shared_references).capitalize();
    public static List<IB_Subject__c> ibSubjects = [SELECT IB_Programme__c,toLabel(Subject_Group__c),Subject_Group_Value__c,Subject_Name__c,Subject_Name_FR__c, Subject_Name_SP__c FROM IB_Subject__c WHERE Available_in_IBEN__c = true];
    
    private final List <SelectOption> categoriesInfo = new List<SelectOption>();
    private final List <SelectOption> rolesInfo = new List<SelectOption>();
    private final List <SelectOption> programmsInfo = new List<SelectOption>();
    public List<SelectOption> subjectOptsRight {get;set;}
    public String selectedSubjects {get;set;}
    
    public List<SelectOption> selectedWorkshopTitles {get;set;}
    public list<SelectOption> WorkshopTitlesOptions {get;set;}
    
    set<string> restrictedSubjectSet;
    public String getReferencesCap(){
    	return referencesCap;
    }
    
    public String roleDescription {
        set; get;
    }
    
    public Boolean getEdit(){
        /*if(this.role.Status__c == 'Declined' || this.role.Status__c == 'Confirmed'){
            return false;
        }
        else{
            return true;
        }*/
        return isEditMode;
    }

    public String getUserLanguageKey() {
        return UserInfo.getLanguage();
    }
    
    public List<Training_Event__c> getTraining(){
        return [SELECT id, IB_Event_Name__c, IB_Programme__c, Training_Event_Country__c, Training_Event_Region__c, Start_Date__c, End_Date__c, IB_Role_2__r.id, IB_Role_3__r.id, IB_Role__r.id
                FROM Training_Event__c
                WHERE End_Date__c > TODAY];
    }
    
    /*
    public IB_Event_Role__c getEventRole(){
        IB_Event_Role__c preReq;
        if(this.roleData != null){
            preReq = [SELECT Proposed_Language__c, Proposed_Spoken_Proficiency__c, Proposed_Written_Proficiency__c FROM IB_Event_Role__c WHERE IB_Role__r.id = :this.roleData LIMIT 1];
        }
        else{
           preReq = [SELECT Proposed_Language__c, Proposed_Spoken_Proficiency__c, Proposed_Written_Proficiency__c FROM IB_Event_Role__c LIMIT 1];
        }
        return preReq;
    }*/

    public String getElapsedTime(){
        String elapsedTimeString = '';
        if(getUserLanguageKey() == 'fr'){
            elapsedTimeString = 'Dernier enregistrement effectué il y a ' + elapsedTime + ' jours.';
        } else if (getUserLanguageKey() == 'es') {
            elapsedTimeString = 'Guardado por última vez hace ' + elapsedTime + ' días'; 
        } else {
            elapsedTimeString = 'Last Saved ' + elapsedTime + ' Days Ago';
        }

        return elapsedTimeString;
    }
    
    public String categoryData {
        set; get;
    }
    public String roleData {
        set; get;
    }
    public String programmData {
        set; get;
    } 

    public String subjectGroupString {
        set; get;
    } 

    public String subjectString {
        set; get;
    }
    
    public String status;
    
    public String getStatus(){
        return this.role.Status__c;
    }
    
    
    private boolean isEditMode = false;
    private boolean isInternal = UserDAO.INSTANCE.isInternalUserForProfileId();
    
    public RoleEditCtrl (ApexPages.StandardController stdController) {
        selectedWorkshopTitles = new List<SelectOption>();
           
        subjectOptsRight = new List<SelectOption>();
        selectedSubjects = '';

        this.role = (IB_Role__c) stdController.getRecord();
           
        System.debug('#### Role Id : '+this.role.Id);
           
        //check if this edit page
        if (null != this.role && null != this.role.id) {
               
            this.isEditMode = true;
            this.role = IBRoleDAO.INSTANCE.getRoleById(this.role.id);
               
            Long dif = dateTime.now().getTime() - this.role.LastModifiedDate.getTime(); 
            Long seconds = dif / 1000;
            Long minutes = seconds / 60;
            Long hours = minutes / 60;
            Long days = hours / 24;
        
            this.elapsedTime = String.valueOf(days);
                 
        } else {
               
            //check if this is create page with predefined role. If we have "roleId" as parameter in URL  
            final String roleId = ApexPages.currentPage().getParameters().get('roleId');
               
            if ( null != roleId) {
                this.isEditMode = false;  
                this.role.IB_Role__c = roleId;
            }
               
        }
        System.debug('#### isEditMode : '+isEditMode);
           
        this.user = UserDAO.INSTANCE.getUserById(Userinfo.getUserId());
           
        final List <IB_Role_Repository__c> result = IBRoleRepositoryDAO.INSTANCE.getAvailableRoles();
           
        Map<String, String> categories = new Map<String,String>();
           
        for (IB_Role_Repository__c role : result) {
            if (UserInfo.getLanguage() == 'es') {
                categories.put(role.Category__c, role.Category_es__c);
            } else if (UserInfo.getLanguage() == 'fr') {
                categories.put(role.Category__c, role.Category_fr__c);
            } else {
                categories.put(role.Category__c, role.Category__c);
            }
            rolesMap.put(role.id, role);
            if(role.id == ApexPages.currentPage().getParameters().get('roleId')){
                roleRepo = role;
            }
        }
           
        for (String key : categories.keySet()) {
            this.categoriesInfo.add(new SelectOption(key, categories.get(key)));
        }
           
           
        String initCategory = this.categoriesInfo.get(0).getValue();
        String initRole;
           
        
        //System.debug('**** isEditMode');
        
        final IB_Role_Repository__c value = rolesMap.get(this.role.IB_Role__c);
        
        if (null != value) {
            categoryData = initCategory = value.Category__c;
            roleData = initRole = value.Id;
            System.debug(roleData);
            System.debug(value.Id);
            /*try{
eventRole = [SELECT Proposed_Language__c, Proposed_Spoken_Proficiency__c, Proposed_Written_Proficiency__c FROM IB_Event_Role__c WHERE IB_Role__r.id = :this.roleData LIMIT 1];
} catch(Exception e){}*/
            programmData = this.role.Programme_Selection__c;
            subjectGroupString = this.role.Subject_Groups__c;
            if (UserInfo.getLanguage() == 'es') {
                roleDescription = value.Role_Description_es__c;
            } else if (UserInfo.getLanguage() == 'fr') {
                roleDescription = value.Role_Description_fr__c;
            } else {
                roleDescription = value.Role_Description__c;
            }
            
            List<Role_Application_Subject__c> ras = [SELECT IB_Subject__c,IB_Subject__r.Subject_Name__c,IB_Subject__r.Subject_Name_SP__c,IB_Subject__r.Subject_Name_FR__c FROM Role_Application_Subject__c WHERE Role_And_Application__c = :this.role.id];
            
            for(Role_Application_Subject__c r:ras){
                if(getUserLanguageKey() == 'fr'){
                    subjectOptsRight.add(new SelectOption(r.IB_Subject__c,r.IB_Subject__r.Subject_Name_FR__c));
                    //selectedSubjects = selectedSubjects + r.IB_Subject__r.Subject_Name_FR__c + ',';
                } else if (getUserLanguageKey() == 'es'){
                    subjectOptsRight.add(new SelectOption(r.IB_Subject__c,r.IB_Subject__r.Subject_Name_SP__c));
                    //selectedSubjects = selectedSubjects + r.IB_Subject__r.Subject_Name_SP__c + ',';
                } else {
                    subjectOptsRight.add(new SelectOption(r.IB_Subject__c,r.IB_Subject__r.Subject_Name__c));
                    //selectedSubjects = selectedSubjects + r.IB_Subject__r.Subject_Name__c + ',';
                }
            }
            
            //selectedSubjects = selectedSubjects.removeEnd(',');
            
            List<Role_Application_Workshop_Title__c> rawt = [SELECT ID, IB_Workshop_Title__c, IB_Workshop_Title__r.Workshop_Title_FR__c, IB_Workshop_Title__r.Workshop_Title_SP__c, IB_Workshop_Title__r.Workshop_Title_ENG__c FROM Role_Application_Workshop_Title__c WHERE Role_And_Application__c =: this.role.id];
            for(Role_Application_Workshop_Title__c r : rawt){
                if(getUserLanguageKey() == 'fr'){
                    selectedWorkshopTitles.add(new SelectOption(r.IB_Workshop_Title__c,r.IB_Workshop_Title__r.Workshop_Title_FR__c));
                } else if (getUserLanguageKey() == 'es'){
                    selectedWorkshopTitles.add(new SelectOption(r.IB_Workshop_Title__c,r.IB_Workshop_Title__r.Workshop_Title_SP__c));
                } else {
                    selectedWorkshopTitles.add(new SelectOption(r.IB_Workshop_Title__c,r.IB_Workshop_Title__r.Workshop_Title_ENG__c));
                }
            }
            
            //roleDescription = value.Role_Description__c;
        }
            
        if ( !this.categoriesInfo.isEmpty()) {
            this.rolesInfo.addAll  ( getRolesByCategory(initCategory) );
        }
           
        if (!this.rolesInfo.isEmpty() && null == initRole) {
            initRole = this.rolesInfo.get(0).getValue();
        }
           
        if (!this.rolesInfo.isEmpty() && null != initRole) {
            this.programmsInfo.addAll ( getProgramsByRoleId(initRole) );
        }
        try{
            if(programmData == '' || programmData == null){
                programmData = programmsInfo[0].getValue();
            }
        } catch(Exception e){}
        
        system.debug('#### role.Restricted_Subjects__c : '+role.Restricted_Subjects__c);
        list<string> restrictedSubjects = new list<string>();
        if(role.Restricted_Subjects__c != null && role.Restricted_Subjects__c != ''){
            restrictedSubjects = role.Restricted_Subjects__c.split(',');
        }
        restrictedSubjectSet = new set<string>();
        restrictedSubjectSet.addAll(restrictedSubjects);
        
        initSubjectGroups();
        getWorkshopTitles();
    }
       
    private List<SelectOption> getRolesByCategory(String catName) {
        
        final List<SelectOption> result =  new List<SelectOption>();
                     
        for (IB_Role_Repository__c value : rolesMap.values()) {
            
            if (catName.equals(value.Category__c)) {
                  
                if (UserInfo.getLanguage() == 'es') {
                    result.add(new SelectOption(value.id, value.Role_Name_es__c));
                } else if (UserInfo.getLanguage() == 'fr') {
                    result.add(new SelectOption(value.id, value.Role_Name_fr__c));
                } else {
                    result.add(new SelectOption(value.id, value.Role_Name__c));
                }
            }
        }
        return result;
    } 
       
       
    @TestVisible
    private List<SelectOption> getProgramsByRoleId(String roleId) {
             
        final IB_Role_Repository__c value = rolesMap.get(roleId);
        final List<SelectOption> result =  new List<SelectOption>();

        List<IB_Data_Translate__c> translations = [
            SELECT Record_ID__c, Translate_Value_1__c 
            FROM IB_Data_Translate__c 
            WHERE Object_Name__c = 'IB_Role_Repository__c'
            AND Locale__c = :UserInfo.getLanguage()
        ];

        Map<String,String> programTranslation = new Map<String,String>();
        for(IB_Data_Translate__c t : translations){
            programTranslation.put(t.Record_ID__c.remove(' '), t.Translate_Value_1__c);
        }
          
        if (null != value) {
            for (String program : value.Related_Programmes__c.split(';' ,0) ) {  
                if(programTranslation.get(program.remove(' ')) == null){
                    result.add( new SelectOption(program, program));
                } else {
                    result.add( new SelectOption(program, programTranslation.get(program.remove(' '))));
                }
            }
            if (UserInfo.getLanguage() == 'es') {
                this.roleDescription = value.Role_Description_es__c;
            } else if (UserInfo.getLanguage() == 'fr') {
                this.roleDescription = value.Role_Description_fr__c;
            } else {
                this.roleDescription = value.Role_Description__c;
            }
        }
        return result;
    }
          
    public List<SelectOption> getCategoriesInfo () {
        return this.categoriesInfo;
    }
       
    public List<SelectOption> getRolesInfo() {
        return this.rolesInfo;
    }
       
    public List<SelectOption> getProgrammsInfo() {
        return this.programmsInfo;
    }
   
    public PageReference SaveInfo() {

        system.debug(loggingLevel.ERROR, 'SAVE INFO::: ' + subjectOptsRight);
        system.debug('#### selectedWorkshopTitles : ' + selectedWorkshopTitles);
        try {
            if (!isInternal) {
                this.role.IB_Contact__c = user.ContactId;
                //this.role.IB_Role__c = roleData; 
                //this.role.Programme_Selection__c = programmData;
                this.role.Subject_Groups__c = subjectGroupString;
            }
            upsert this.role;
                
            List<Role_Application_Subject__c> ras = [SELECT ID, Not_Restricted__c FROM Role_Application_Subject__c WHERE Role_And_Application__c =: this.role.id];
            for(Role_Application_Subject__c r : ras){
                r.Not_Restricted__c = true;
            }
            update ras;
            delete ras;

            ras = new List<Role_Application_Subject__c>();

            for(SelectOption so : subjectOptsRight){
                Role_Application_Subject__c r = new Role_Application_Subject__c();
                r.IB_Subject__c = so.getValue();
                r.Role_And_Application__c = this.role.Id;
                ras.add(r);
            }

            insert ras;
        
            system.debug('#### role.IB_Role__c : '+this.role.IB_Role__c);
            
            List<Role_Application_Workshop_Title__c> rawt = [SELECT ID FROM Role_Application_Workshop_Title__c WHERE Role_And_Application__c =: this.role.id];
            delete rawt;
            
            
            rawt = new List<Role_Application_Workshop_Title__c>();

            for(SelectOption so : selectedWorkshopTitles){
                Role_Application_Workshop_Title__c r = new Role_Application_Workshop_Title__c();
                r.IB_Workshop_Title__c = so.getValue();
                r.Role_And_Application__c = this.role.Id;
                rawt.add(r);
            }
            insert rawt;
            
            PageReference view = new PageReference ('/educator/roles?id=' + this.role.IB_Role__c);
            view.setRedirect(true);        
            return view;
                
        } catch (System.DmlException e) {
            for (Integer i = 0; i < e.getNumDml(); i++) {
               
                //Check for apply for the same role/programme combination ,
                // better to do this in IBRoleDAO.INSTANCE.getRoleById but to prevent of doing complicating check we will do this here
           
                if (e.getDmlMessage(i).contains('Unique_Application__c')) {
                    ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, Label.IBENPortal_Error_RoleApplicationDuplication));
                } else { 
                    ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR,e.getDmlMessage(i))); 
                }
            }
             
           return null;
             
        } catch (Exception ex) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, ' ' + ex.getMessage()));
            return null;
        }
    }
       
    /*public void withdraw(){
        this.role.status__c = 'Withdrawn';
        saveInfo();
    }*/
       
    public PageReference cancel() {
        String url = '/roles';
        if (this.isEditMode && ApexPages.currentPage().getParameters().get('id') != ''){ 
            url = '/' + ApexPages.currentPage().getParameters().get('id');
        }
           
        PageReference view = new PageReference (url);
        view.setRedirect(true);        
        return view;
    }
       
    public void searchRole() {
        this.rolesInfo.clear();
        this.rolesInfo.addAll(getRolesByCategory(categoryData));
           
        if (!this.rolesInfo.isEmpty()) {
            this.programmsInfo.clear();
            this.programmsInfo.addAll (getProgramsByRoleId(this.rolesInfo.get(0).getValue()) );
            if (UserInfo.getLanguage() == 'es') {
                this.roleDescription = this.rolesMap.get(this.rolesInfo.get(0).getValue()).Role_Description_es__c;
            } else if (UserInfo.getLanguage() == 'fr') {
                this.roleDescription = this.rolesMap.get(this.rolesInfo.get(0).getValue()).Role_Description_fr__c;
            } else {
                this.roleDescription = this.rolesMap.get(this.rolesInfo.get(0).getValue()).Role_Description__c;
            }
            //this.roleDescription = this.rolesMap.get(this.rolesInfo.get(0).getValue()).Role_Description__c;
        }  
    }
       
    public void searchPrograme() {
        this.programmsInfo.clear();
        this.programmsInfo.addAll (getProgramsByRoleId(roleData) );
    } 
       
    public IB_Role__c getRole() {
        return role;
    }
       
    public boolean getIsInternal() {
        return this.isInternal;
    }

    public List<SelectOption> subjectGroupOpts;
       
    public List<SelectOption> getSubjectGroupOpts(){
        return subjectGroupOpts;
    }

    public void setSubjectGroupOpts(List<SelectOption> opts){
        subjectGroupOpts = opts;
    }

    public List<SelectOption> subjectOptsLeft;

    public List<SelectOption> getSubjectOptsLeft(){
        if(subjectOptsLeft != null){
            return subjectOptsLeft;
        } else return new List<SelectOption>();
    }

    public void setSubjectOptsLeft(List<SelectOption> opts){
        subjectOptsLeft = opts;
    }

    /*public List<SelectOption> getSubjectOptsRight(){
        return subjectOptsRight;
    }
    public void setSubjectOptsRight(List<SelectOption> opts){
        subjectOptsRight = opts;
    }
    */      

    public void getSubjectGroups(){
        system.debug(loggingLevel.ERROR, 'ProgrammData: ' + programmData);
        List<SelectOption> opts = new List<SelectOption>();
        Set<String> optsSet = new Set<String>();
        for(IB_Subject__c s : ibSubjects){
            if(s.IB_Programme__c == programmData){
                if(!optsSet.contains(s.Subject_Group_Value__c + '|' + s.Subject_Group__c)){
                    optsSet.add(s.Subject_Group_Value__c + '|' + s.Subject_Group__c);
                    opts.add(new SelectOption(s.Subject_Group_Value__c, s.Subject_Group__c));
                }
            }
        }

        SelectOptionSorter.doSort(opts, SelectOptionSorter.FieldToSort.Label);
        system.debug(loggingLevel.ERROR,'OPTS: ' + opts);
        setSubjectGroupOpts(opts);
        try{
            subjectGroupString = opts[0].getValue();
        } catch (Exception e){}
        getSubjects();
    }

    public void getSubjects(){
          
        List<SelectOption> opts = new List<SelectOption>();
        Set<String> optsSet = new Set<String>();

        Set<String> rightOptsSet = new Set<String>();

        /*if(subjectOptsRight != null){
            for(SelectOption so:subjectOptsRight){
                rightOptsSet.add(so.getValue());
            }
        }*/
        if(selectedSubjects != null){
            for(string subId : selectedSubjects.split(',')){
                rightOptsSet.add(subId);
            }
        }

        for(IB_Subject__c s : ibSubjects){
            if(!restrictedSubjectSet.contains(s.Id) && !rightOptsSet.contains(s.Id) && s.IB_Programme__c == programmData && s.Subject_Group_Value__c == subjectGroupString){
                if(s.IB_Programme__c == programmData && s.Subject_Group_Value__c == subjectGroupString){
                    if(!optsSet.contains(s.Id)){
                        optsSet.add(s.Id);
                        if(getUserLanguageKey() == 'fr'){
                            opts.add(new SelectOption(s.Id, s.Subject_Name_FR__c));
                        }else if(getUserLanguageKey() == 'es'){
                            opts.add(new SelectOption(s.Id, s.Subject_Name_SP__c));
                        }else{
                            opts.add(new SelectOption(s.Id, s.Subject_Name__c));  
                        } 
                    }
                }
            }
        }

        SelectOptionSorter.doSort(opts, SelectOptionSorter.FieldToSort.Label);
        system.debug(loggingLevel.ERROR,'OPTS: ' + opts);
        setSubjectOptsLeft(opts);
        subjectOptsRight = new List<SelectOption>();
    }

    public void initSubjectGroups(){
          system.debug(loggingLevel.ERROR, 'ProgrammData: ' + programmData);
          List<SelectOption> opts = new List<SelectOption>();
          Set<String> optsSet = new Set<String>();
          for(IB_Subject__c s : ibSubjects){
            if(s.IB_Programme__c == programmData){
              if(!optsSet.contains(s.Subject_Group_Value__c + '|' + s.Subject_Group__c)){
                optsSet.add(s.Subject_Group_Value__c + '|' + s.Subject_Group__c);
                opts.add(new SelectOption(s.Subject_Group_Value__c, s.Subject_Group__c));
              }
            }
          }

          SelectOptionSorter.doSort(opts, SelectOptionSorter.FieldToSort.Label);
          system.debug(loggingLevel.ERROR,'OPTS: ' + opts);
          setSubjectGroupOpts(opts);
          if(subjectGroupString == '' || subjectGroupString == null){
            try{
              subjectGroupString = opts[0].getValue();
            } catch (Exception e){}
          }
          initSubjects();
       }       

    public void initSubjects(){
          
        List<SelectOption> opts = new List<SelectOption>();
        Set<String> optsSet = new Set<String>();
        Set<String> rightOptsSet = new Set<String>();
        selectedSubjects = '';
        if(subjectOptsRight != null){
            for(SelectOption so:subjectOptsRight){
                rightOptsSet.add(so.getValue());
                selectedSubjects += so.getValue()+',';
            }
        }
        selectedSubjects = selectedSubjects.removeEnd(',');
        
        for(IB_Subject__c s : ibSubjects){
            if(!restrictedSubjectSet.contains(s.Id) && !rightOptsSet.contains(s.Id) && s.IB_Programme__c == programmData && s.Subject_Group_Value__c == subjectGroupString){
                if(!optsSet.contains(s.Id)){
                    optsSet.add(s.Id);
                    if(getUserLanguageKey() == 'fr' && s.Subject_Name_FR__c != null){
                        opts.add(new SelectOption(s.Id, s.Subject_Name_FR__c));
                    }else if(getUserLanguageKey() == 'es' && s.Subject_Name_SP__c != null){
                        opts.add(new SelectOption(s.Id, s.Subject_Name_SP__c));
                    }else{
                        opts.add(new SelectOption(s.Id, s.Subject_Name__c));  
                    } 
                }
            }
        }

        SelectOptionSorter.doSort(opts, SelectOptionSorter.FieldToSort.Label);
        system.debug(loggingLevel.ERROR,'OPTS: ' + opts);
        /*if(subjectGroupString == '' || subjectGroupString == null){
            subjectGroupString = opts[0].getValue();
        }*/
        setSubjectOptsLeft(opts);
    }

    public void getWorkshopTitles(){
        string subjectListRight = Apexpages.currentPage().getParameters().get('SubParam');
        system.debug('#### SubParam : '+subjectListRight);
        system.debug('#### selectedSubjects : '+selectedSubjects);
        Set<String> subjects = new Set<String>();
        
        if(subjectListRight != null){
            if(subjectListRight != ''){
                list<string> subjectsFound = subjectListRight.split('&');
                selectedSubjects = '';
                for(integer i = 0 ; i < subjectsFound.size() ; i=i+2){
                    subjects.add(subjectsFound[i]);
                    selectedSubjects += subjectsFound[i]+',';
                }
                selectedSubjects = selectedSubjects.removeEnd(',');
            }
        }else if(selectedSubjects != null && selectedSubjects != ''){
            list<string> subjectsFound = selectedSubjects.split(',');
            for(integer i = 0 ; i < subjectsFound.size() ; i++){
                subjects.add(subjectsFound[i]);
            }
        }
        system.debug('#### subjects : '+subjects.size());
        WorkshopTitlesOptions = new list<SelectOption>();
        String programmData2;
        if(programmData == 'IBCC') programmData2 = 'CP';
        else programmData2 = programmData;
        
        List<IB_Workshop_Titles__c> workshoptitles;
        workshoptitles = [SELECT Id, Workshop_Title_FR__c, Workshop_Title_SP__c, Workshop_Title_ENG__c, Subject_Group__c, 
                          (SELECT id, IB_Subject__c, Subject_Group__c from IB_Workshop_Title_Subjects__r) 
                          FROM IB_Workshop_Titles__c WHERE Programme__c =: programmData2];
        
        system.debug('#### workshoptitles : '+workshoptitles.size());
        
        Set<String> rightOptsSet = new Set<String>();
        if(selectedWorkshopTitles != null){
            for(SelectOption so:selectedWorkshopTitles){
                rightOptsSet.add(so.getValue());
            }
        }
        
        for(IB_Workshop_Titles__c r : workshoptitles){
            if(!rightOptsSet.contains(r.Id)){
                system.debug('#### r.IB_Workshop_Title_Subjects__r.size() : '+r.IB_Workshop_Title_Subjects__r.size());
                if(r.IB_Workshop_Title_Subjects__r.size() == 0){
                    if(getUserLanguageKey() == 'fr' && r.Workshop_Title_FR__c != null){
                        WorkshopTitlesOptions.add(new SelectOption(r.Id,r.Workshop_Title_FR__c));
                    } else if (getUserLanguageKey() == 'es' && r.Workshop_Title_SP__c != null){
                        WorkshopTitlesOptions.add(new SelectOption(r.Id,r.Workshop_Title_SP__c));
                    } else {
                        WorkshopTitlesOptions.add(new SelectOption(r.Id,r.Workshop_Title_ENG__c));
                    }
                }
                else{
                    boolean subjectMatched = false;
                    for(IB_Workshop_Title_Subject__c sub : r.IB_Workshop_Title_Subjects__r){
                        if(subjects.contains(sub.IB_Subject__c)){
                            subjectMatched = true;
                            break;
                        }
                    }
                    if(subjectMatched){
                        if(getUserLanguageKey() == 'fr' && r.Workshop_Title_FR__c != null){
                            WorkshopTitlesOptions.add(new SelectOption(r.Id,r.Workshop_Title_FR__c));
                        } else if (getUserLanguageKey() == 'es' && r.Workshop_Title_SP__c != null){
                            WorkshopTitlesOptions.add(new SelectOption(r.Id,r.Workshop_Title_SP__c));
                        } else {
                            WorkshopTitlesOptions.add(new SelectOption(r.Id,r.Workshop_Title_ENG__c));
                        }
                    }
                }
            }
        }
        system.debug('#### '+WorkshopTitlesOptions.size());
    }
    
}