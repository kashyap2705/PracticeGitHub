public without sharing class MyIBRoleApplicationSubjectsCtrl {
    public List<Role_Application_Subject__c> ras {get;set;}
    public IB_Role__c role {get;set;}
    public Integer listCount {get;set;}
    public IB_Role_Repository__c currentRole {get;set;}
    public Id roleId {get;set;}
    public Boolean edit {get;set;}
    public Id deleteId { get; set; }
    public String subjectGroup { get; set; }
    public String addSubject { get; set; }
    public String selectedSubjects {get;set;}
    public List<SelectOption> WorkshopTitlesOptions {get;set;}
    public Set<String> restrictedSubjectSet {get;set;}
    public List<SelectOption> selectedWorkshopTitles {get;set;}
    public List<IB_Subject__c> ibSubjects {get;set;}
    public list<SelectOption> ageAvailableOptions {get;set;}
    @testVisible public list<SelectOption> selectedAgeGroup {get;set;}
    
    /***This Part of Code is added by Ammara-Plumlogix as part of US-11741,Staff-Aug Project*/
    /***Begin***/
    public string workshop_id {get; set;}
    public List<string> searchfilter_list = new List<String>();
    public string searchfilter_category {get; set;}
    public string searchstring{get; set;}
    public String inputText1{get;set;}
    public static string locale;
    public List<Workshops_Details> Workshops_Details_List { get; set; }//list to disply workshops on VF Page
    public List<Workshops_Details> selected_Workshops_Details{get;set;}   //Selected Workshops List
    public List<Workshops_Details> Previous_Workshops_Details{get;set;}  //Previously filtered List
    public List<Workshops_Details> Workshops_Details{get;set;} // All workshops list
    Map<ID,IB_Workshop_Details__c> workshop_to_add{get;set;}//workshop selected and need to added in selected_workshop_details
    public List<Workshops_Details> search_Workshops_Details{get;set;} //List to store search workshops
    //Function that select programmes
    @testvisible public string selectedprogramme {
        get
        {
            String programmData = role.Programme_Selection__c;
            System.debug('Data: '+programmData);
            if(programmData == 'MYP')
                return Label.IB_Portal_MYP;
            else if(programmData == 'PYP')
                return Label.IB_Portal_PYP;
            else if(programmData == 'CP')
                return Label.IB_Portal_CP;
            else if(programmData == 'DP')
                return Label.IB_Portal_DP;
            else if(programmData == 'DP + CP')
                return Label.IB_Portal_DP_CP;
            else if(programmData == 'IB Ed')
                return Label.IB_Portal_IB_Ed;
            else if(programmData == 'Lead')
                return Label.IB_Portal_Lead;
            else
                return '';
            
        }
    }
    //Function to filter workshop on the basis of keyword
    public void get_searchtitle()
    {
        try{
            String programmData = role.Programme_Selection__c;
            List<Workshops_Details> Workshops_Details_search = new List<Workshops_Details>();     
            Workshops_Details_List = Workshops_Details;
            searchstring = inputText1;    
            System.debug('Search Text: '+inputText1+' Locale: '+getlocale());
            if(inputText1 != null && inputText1 != ''){
                /*if(programmData == 'IB Ed' || programmData == 'Lead'){
searchfilter_category = 'Category 3';
category_filter_workshop();
}*/
                inputText1 = inputText1.toLowerCase();
                if(getlocale() == 'en_US'){
                    for(Workshops_Details s:Workshops_Details_List){
                        if(s.workshop_title.IB_Workshop_Title__r.Workshop_Title_ENG__c != null && s.workshop_title.IB_Workshop_Title__r.Workshop_Title_ENG__c != ''){
                            String str = (s.workshop_title.IB_Workshop_Title__r.Workshop_Title_ENG__c+s.workshop_title.IB_Category__c).toLowerCase();
                            if(str.contains(inputText1))
                                Workshops_Details_search.add(new Workshops_Details(s.workshop_title,s.isSelected));
                        }
                    }
                }
                else if(getlocale() == 'es'){
                    for(Workshops_Details s:Workshops_Details_List){
                        if(s.workshop_title.IB_Workshop_Title__r.Workshop_Title_SP__c != null && s.workshop_title.IB_Workshop_Title__r.Workshop_Title_SP__c != ''){
                            String str = (s.workshop_title.IB_Workshop_Title__r.Workshop_Title_SP__c+s.workshop_title.IB_Category__c).toLowerCase();
                            if( str.contains(inputText1))
                                Workshops_Details_search.add(new Workshops_Details(s.workshop_title,s.isSelected));
                        }
                    }
                }
                else if(getlocale() == 'fr'){
                    for(Workshops_Details s:Workshops_Details_List){
                        if(s.workshop_title.IB_Workshop_Title__r.Workshop_Title_FR__c != null && s.workshop_title.IB_Workshop_Title__r.Workshop_Title_FR__c != ''){
                            String str = (s.workshop_title.IB_Workshop_Title__r.Workshop_Title_FR__c+s.workshop_title.IB_Category__c).toLowerCase();
                            if(str.contains(inputText1))
                                Workshops_Details_search.add(new Workshops_Details(s.workshop_title,s.isSelected));
                        }
                    }
                }
                If(Workshops_Details_search.size()>0){
                    workshop_list(Workshops_Details_search);
                }
                else{
                    Workshops_Details_List = new List<Workshops_Details>();
                    Previous_Workshops_Details = new List<Workshops_Details>();
                }
            }
            if(searchfilter_category != null && searchfilter_category != '' &&  programmData != 'IB Ed' && programmData != 'Lead')
                category_filter_workshop();
            system.debug('**************************** Search Keyword: '+inputText1+' '+searchstring);
            system.debug('searched title '+Workshops_Details_List.size()+' ' +Workshops_Details_List);
            system.debug('previous: '+Previous_Workshops_Details.size()+' ' +Previous_Workshops_Details);
        }
        catch(Exception ex){
            System.debug('******Exception: '+ex);
        }
    }
    //Function to get the selected workshops for the applied role
    public void selected_workshops(){
        Set<ID> workshop_titles_ids = new Set<ID>();
        List<ID> workshop_ids = new List<ID>();
        List<ID> workshop_ids_all = new List<ID>();  
        RoleApplicationWorkshopTitleService.roleId = role.Id;
        List<Role_Application_Workshop_Title__c> roleAppTitleList = RoleApplicationWorkshopTitleService.getWorkshopTitlesByRoleId();
        if(roleAppTitleList != null){
            for(Role_Application_Workshop_Title__c roleAppTitle : roleAppTitleList){
                workshop_titles_ids.add(roleAppTitle.IB_Workshop_Title__c);
            }
            selected_Workshops_Details = new List<Workshops_Details>();
            System.debug('Selected Workshop Ids: '+workshop_titles_ids);
            for(IB_Workshop_Details__c wd:[select id,IB_Category_French__c, IB_Category_Spanish__c, IB_Programme_Spanish__c, IB_Programme_French__c,IB_Workshop_Title__r.Workshop_Title_ENG__c,IB_Workshop_Title__r.Workshop_Title_FR__c,IB_Workshop_Title__r.Workshop_Title_SP__c,IB_Programme__c,IB_Category__c,IB_Workshop_Title__r.Name from IB_Workshop_Details__c where IB_Programme__c!= Null AND IB_Workshop_Title__c!=NUll AND IB_Workshop_Title__r.id IN:workshop_titles_ids order by IB_Workshop_Title__r.Workshop_Title_ENG__c] ){
                selected_Workshops_Details.add(new Workshops_Details(wd,true));
                workshop_ids_all.add(wd.id);
                Workshops_Details_List = selected_Workshops_Details;
            }
        }
        System.debug('Selected Workshop: '+Workshops_Details_List.size()+'  '+Workshops_Details_List);
    }
    //Function to add all the selected workshops from workshop_to_add in selected_workshop_details
    public void  selected_workshops2(){
        select_workshops();
        List<IB_Workshop_Details__c> wds = new List<IB_Workshop_Details__c>(); 
        selected_Workshops_Details = new List<Workshops_Details>();
        if(workshop_to_add != null && workshop_to_add.size()>0){
            wds = workshop_to_add.values();
            for(IB_Workshop_Details__c w:wds){
                selected_Workshops_Details.add(new Workshops_Details(w,true));
            }
        }
        workshop_list(selected_Workshops_Details);
    }
    //Function to assign the processed workshop list to Workshops_Details_List to show it on VF Page
    public void workshop_list(List<Workshops_Details> Workshops_Details_search1){
        Previous_Workshops_Details = Workshops_Details_List;
        Workshops_Details_List = null;
        Workshops_Details_List = new List<Workshops_Details>();
        Workshops_Details_List = Workshops_Details_search1;
    }
    //Function to add selected workshops to workshop_to_add and making sure no duplicates added
    public void  select_workshops(){
        if(Workshops_Details_List != null){
            System.debug('Select Workshop: '+Workshops_Details_List.size());
            for(Workshops_Details wrd : Workshops_Details_List){                if(wrd.isSelected == true){ 
                System.debug('Select Workshop 1: '+wrd);
                workshop_to_add.put(wrd.workshop_title.id,wrd.workshop_title);
            }else if(wrd.isSelected == false && workshop_to_add != null && workshop_to_add.containsKey(wrd.workshop_title.id))
                workshop_to_add.remove(wrd.workshop_title.id);
                                                                
                                                               }
        }
    }
    //Function that run to get all workshop titles
    public void get_workshop_titles(){
        String programmData = role.Programme_Selection__c;
        List<String> workshop_names = new List<String>();
        Date enddate = date.today();
        locale = getlocale();
        Workshops_Details_List =new list<Workshops_Details>();
        System.debug('Programme Data: '+programmData+' '+locale);
        selected_Workshops_Details = new List<Workshops_Details>();    
        if(locale == 'en_US'){
            for(IB_Workshop_Details__c w_d:[select id,IB_Category_French__c, IB_Category_Spanish__c, IB_Programme_Spanish__c, IB_Programme_French__c,IB_Workshop_Title__r.Workshop_Title_ENG__c,IB_Workshop_Title__r.Workshop_Title_FR__c,IB_Workshop_Title__r.Workshop_Title_SP__c,IB_Programme__c,IB_Category__c,IB_Workshop_Title__r.Name from IB_Workshop_Details__c where IB_Programme__c!= Null AND IB_Programme__c =:programmData AND IB_Category__c != NULL AND (IB_Workshop_Title__r.Available_To__c = null or IB_Workshop_Title__r.Available_To__c >= :enddate) AND IB_Workshop_Title__c!=NUll  order by IB_Workshop_Title__r.Workshop_Title_ENG__c]){
                if(!workshop_names.contains(w_d.IB_Workshop_Title__r.Workshop_Title_ENG__c+w_d.IB_Category__c ) ){
                    Workshops_Details_List.add(new Workshops_Details(w_d)); 
                    workshop_names.add(w_d.IB_Workshop_Title__r.Workshop_Title_ENG__c+w_d.IB_Category__c);
                }
            }      
        }
        else if(locale == 'fr'){
            for(IB_Workshop_Details__c w_d:[select id,IB_Category_French__c, IB_Category_Spanish__c, IB_Programme_Spanish__c, IB_Programme_French__c,IB_Workshop_Title__r.Workshop_Title_ENG__c,IB_Workshop_Title__r.Workshop_Title_FR__c,IB_Workshop_Title__r.Workshop_Title_SP__c,IB_Programme__c,IB_Category__c,IB_Workshop_Title__r.Name from IB_Workshop_Details__c where IB_Programme__c!= Null AND IB_Programme__c =:programmData AND IB_Category__c != NULL AND (IB_Workshop_Title__r.Available_To__c = null or IB_Workshop_Title__r.Available_To__c >= :enddate) AND IB_Workshop_Title__c!=NUll order by IB_Workshop_Title__r.Workshop_Title_FR__c]){
                if(!workshop_names.contains(w_d.IB_Workshop_Title__r.Workshop_Title_FR__c+w_d.IB_Category__c)){
                    Workshops_Details_List.add(new Workshops_Details(w_d)); 
                    workshop_names.add(w_d.IB_Workshop_Title__r.Workshop_Title_FR__c+w_d.IB_Category__c);
                }        
            }  
        }
        else if(locale == 'es'){
            for(IB_Workshop_Details__c w_d:[select id,IB_Category_French__c, IB_Category_Spanish__c, IB_Programme_Spanish__c, IB_Programme_French__c,IB_Workshop_Title__r.Workshop_Title_ENG__c,IB_Workshop_Title__r.Workshop_Title_FR__c,IB_Workshop_Title__r.Workshop_Title_SP__c,IB_Programme__c,IB_Category__c,IB_Workshop_Title__r.Name from IB_Workshop_Details__c where IB_Programme__c!= Null AND IB_Programme__c =:programmData AND IB_Category__c != NULL AND (IB_Workshop_Title__r.Available_To__c = null or IB_Workshop_Title__r.Available_To__c >= :enddate) AND IB_Workshop_Title__c!=NUll order by IB_Workshop_Title__r.Workshop_Title_SP__c]){
                if(!workshop_names.contains(w_d.IB_Workshop_Title__r.Workshop_Title_SP__c+w_d.IB_Category__c)){
                    Workshops_Details_List.add(new Workshops_Details(w_d)); 
                    workshop_names.add(w_d.IB_Workshop_Title__r.Workshop_Title_SP__c+w_d.IB_Category__c);
                }           
            }  
        }
        Workshops_Details = Workshops_Details_List;
        System.debug('Workshop Records are '+Workshops_Details_List);
    }
    //Function refresh all the worshops for VF Page according to the user input
    public void all_workshop(){
        selected_workshops2();
        List<Workshops_Details> temp_List = new List<Workshops_Details>();
        for(Workshops_Details wd: Workshops_Details){//All
            boolean check = false;
            for(Workshops_Details wd1:  Workshops_Details_List){//Selected
                if(wd.workshop_title.id == wd1.workshop_title.id){
                    temp_List.add(new Workshops_Details(wd.workshop_title,true));
                    System.debug('***Test True: '+wd1.workshop_title);
                    check = true;
                }
            }
            if(check == false){
                temp_List.add(new Workshops_Details(wd.workshop_title,false));
            }
        }
        Workshops_Details_List= temp_List;
        Workshops_Details = temp_List;
        System.debug('***Test: '+temp_List.size());
    }
    //Function check filters and call functions according to selected filters
    public void category_filter(){
        all_workshop();
        System.debug(inputText1 + ' Category Filter '+searchfilter_category);
        if((inputText1 != null && inputText1 != '')&& (searchfilter_category != null &&  searchfilter_category != '') )
            get_searchtitle();
        else if((inputText1 != null && inputText1 != '')&& (searchfilter_category == null ||  searchfilter_category == '') )
            get_searchtitle();
        else if((inputText1 == null || inputText1 == '')&& (searchfilter_category != null && searchfilter_category != '')){
            Workshops_Details_List = Workshops_Details;
            category_filter_workshop();
        }
        else if((inputText1 == null || inputText1 == '')&& (searchfilter_category == null || searchfilter_category == ''))
            Workshops_Details_List = Workshops_Details;
    }
    //Function to filter workshop on the basis of selected category
    public void category_filter_workshop(){
        try{
            System.debug('********Category Filter******');
            String str = '--'+Label.select+'--';
            List<Workshops_Details> Workshops_Details_search = new List<Workshops_Details>();  
            if(searchfilter_category != null && searchfilter_category != '' ){
                List<Workshops_Details> Workshops = new List<Workshops_Details>();
                for(Workshops_Details detail_list:Workshops_Details_List){
                    IB_Workshop_Details__c workshopdetail_record =  detail_list.workshop_title;
                    if(workshopdetail_record.IB_Category__c == searchfilter_category){
                        Workshops_Details_search.add(new Workshops_Details(detail_list.workshop_title,detail_list.isselected));
                    }
                }
                if(Workshops_Details_search.size()>0)
                    workshop_list(Workshops_Details_search);
                else
                    Workshops_Details_List = new List<Workshops_Details>();
            }
            /*else
Workshops_Details_List = Previous_Workshops_Details;*/
            System.debug('Category: '+str+' filter '+searchfilter_category+' list '+Workshops_Details_List.size()+'  '+Workshops_Details_List);
            System.debug('Prvious: '+Previous_Workshops_Details.size()+'  '+Previous_Workshops_Details);
        }catch(Exception ex){
            System.debug('Exception: '+ex);
        }
    }
    /***End***/
    public MyIBRoleApplicationSubjectsCtrl() {
        try
        {
            //  this code is edited by developer Ali Haider Bajwa-PlumLogix for ecm 465 of cr project
            //  start
            edit=true;
            ageAvailableOptions=new List<SelectOption>();
            Schema.DescribeFieldResult obj2FieldDescribe = IB_Role__c.Age_Groups__c.getDescribe();
            List<Schema.PicklistEntry> lstMypPickListValues  = obj2FieldDescribe.getPickListValues();
            for (Schema.PicklistEntry ageGroupValue : lstMypPickListValues) {
                ageAvailableOptions.add(new SelectOption(ageGroupValue.getValue(),ageGroupValue.getLabel()));
            }
            //end
            roleId = ApexPages.currentPage().getParameters().get('Id');
            selectedWorkshopTitles = new List<SelectOption>();
            
            RoleApplicationSubjectService.roleId = roleId;
            ras = RoleApplicationSubjectService.getSubjectsByRoleId();
            listCount = ras.size();
            RoleService.roleId = roleId;
            role = RoleService.getRole();
            //  this code is edited by developer Ali Haider Bajwa-PlumLogix for ecm 465 of cr project
            //  start
            //  //  465-fix
            //  start
            selectedAgeGroup=new List<SelectOption>();
            //end
            if(role.Age_Groups__c!=NULL)
            {
                List<String> rightoption=new list<string>();
                rightoption = role.Age_Groups__c.split(';',5);
                for(integer i=0;i<ageAvailableOptions.Size();i++)
                {
                    for(integer j=0;j<rightoption.Size();j++)
                    {
                        if(ageAvailableOptions[i].getValue() == rightoption[j]) {// changed by Atticus F.
                        //replace getLabel with getValue() -- Bug Fix Bug 184947: Selection of age group not showing on front end for French and Spanish
                            selectedAgeGroup.add(new SelectOption(ageAvailableOptions[i].getValue(),ageAvailableOptions[i].getLabel()));
                            ageAvailableOptions.remove(i);
                        }
                    }
                }
            }
            //end
            List<String> restrictedSubjects = new List<String>();
            
            if(role.Restricted_Subjects__c != null && role.Restricted_Subjects__c != ''){
                restrictedSubjects = role.Restricted_Subjects__c.split(',');
            }
            
            restrictedSubjectSet = new set<string>();
            restrictedSubjectSet.addAll(restrictedSubjects);
            
            RoleRepositoryService.roleId = role.IB_Role__c;
            currentRole = RoleRepositoryService.getRoleById();
            
            if(currentRole.MyIB_Use_My_School_Subjects__c){
                if(role.Programme_Selection__c == 'CP')
                    ibSubjects = [SELECT IB_Programme__c,toLabel(Subject_Group__c),Subject_Group_Value__c,Subject_Name__c,Subject_Name_FR__c, Subject_Name_SP__c FROM IB_Subject__c WHERE IB_Programme__c in ('DP','CP') AND Available_in_MySchool__c = true];  
                else
                    ibSubjects = [SELECT IB_Programme__c,toLabel(Subject_Group__c),Subject_Group_Value__c,Subject_Name__c,Subject_Name_FR__c, Subject_Name_SP__c FROM IB_Subject__c WHERE IB_Programme__c = :role.Programme_Selection__c AND Available_in_MySchool__c = true];
            } else {
                if(role.Programme_Selection__c == 'CP'){
                    ibSubjects = [SELECT IB_Programme__c,toLabel(Subject_Group__c),Subject_Group_Value__c,Subject_Name__c,Subject_Name_FR__c, Subject_Name_SP__c FROM IB_Subject__c WHERE IB_Programme__c in ('CP','DP') AND Available_in_IBEN__c = true];
                    List<IB_Subject__c> subjects2 = [SELECT IB_Programme__c,toLabel(Subject_Group__c),Subject_Group_Value__c,Subject_Name__c,Subject_Name_FR__c, Subject_Name_SP__c 
                                                     FROM IB_Subject__c 
                                                     WHERE IB_Programme__c in ('CP','DP')
                                                     AND ID in (SELECT IB_Subject__c FROM IB_Subjects_Available_for_Roles__c WHERE IB_Role__c = :currentRole.Id)];
                    
                    ibSubjects.addAll(subjects2);
                } else{
                    ibSubjects = [SELECT IB_Programme__c,toLabel(Subject_Group__c),Subject_Group_Value__c,Subject_Name__c,Subject_Name_FR__c, Subject_Name_SP__c FROM IB_Subject__c WHERE IB_Programme__c = :role.Programme_Selection__c AND Available_in_IBEN__c = true];
                    List<IB_Subject__c> subjects2 = [SELECT IB_Programme__c,toLabel(Subject_Group__c),Subject_Group_Value__c,Subject_Name__c,Subject_Name_FR__c, Subject_Name_SP__c 
                                                     FROM IB_Subject__c 
                                                     WHERE IB_Programme__c = :role.Programme_Selection__c
                                                     AND ID in (SELECT IB_Subject__c FROM IB_Subjects_Available_for_Roles__c WHERE IB_Role__c = :currentRole.Id)];
                    
                    ibSubjects.addAll(subjects2);
                }             
            }
            /***This Part of Code is added by Ammara-Plumlogix as part of US-11741,Staff-Aug Project*/
            /***Begin***/
            Workshops_Details_List = new List<Workshops_Details>();
            Previous_Workshops_Details = new List<Workshops_Details>(); 
            selected_Workshops_Details = new List<Workshops_Details>(); 
            workshop_to_add = new Map<ID,IB_Workshop_Details__c>();
            locale = getlocale();
            get_workshop_titles();
            selected_workshops();
            System.debug('Workshop Records are '+Workshops_Details_List);
            /***End***/
            
            getWorkshopTitles();
            getSelectedWorkshopTitles();
            
        }
        Catch(Exception x)
        {
            System.debug('Exception: '+x);
        }
    }
    
    public String getLocale() {
        return UserInfo.getLanguage();
    }
    
    public List<SelectOption> getSubjectGroups() {
        try
        {
            List<SelectOption> options = new List<SelectOption>();
            Boolean added = false;
            
            Set<String> subjectNames = new Set<String>();
            
            options.add(new SelectOption('',''));
            for(IB_Subject__c subject : ibSubjects){
                if(!subjectNames.contains(subject.Subject_Group_Value__c)){
                    subjectNames.add(subject.Subject_Group_Value__c);
                    // this line is added by developor abd-ur-rehman as part ofcr-878 on 20-2-2020
                    // to restrict "Career-related programme Core" as subject group in pyp
                    // begin
                    if(subject.IB_Programme__c == 'PYP'){
                        //  this code is edited by developer Ali Haider Bajwa-PlumLogix for ecm 465 of cr project
                        //  start
                        if( subject.Subject_Group_Value__c != 'Career-related Programme Core' && subject.Subject_Group_Value__c != 'Arts (PYP)' )
                            
                            options.add(new SelectOption(subject.Subject_Group_Value__c,subject.Subject_Group__c)); 
                    }
                    else  //end   
                        options.add(new SelectOption(subject.Subject_Group_Value__c,subject.Subject_Group__c));               
                }
            }
            System.debug('## Reached here'+SelectOptionSorter.FieldToSort.Label);
            SelectOptionSorter.doSort(options, SelectOptionSorter.FieldToSort.Label);
            return options;
        }Catch(Exception x)
        {
            System.debug('Exception: '+x);
            return NULL;
        }
        
    }
    
    public List<SelectOption> getSubjectNames() {
        try
        {
            List<SelectOption> options = new List<SelectOption>();
            
            for (IB_Subject__c subject : ibSubjects) {
                if(subject.Subject_Group_Value__c == subjectGroup){
                    if(!restrictedSubjectSet.contains(subject.Id)){
                        if(getLocale() == 'fr'){
                            options.add(new SelectOption(subject.Id, subject.Subject_Name_FR__c));     
                        } else if(getLocale() == 'es'){
                            options.add(new SelectOption(subject.Id, subject.Subject_Name_SP__c));  
                        } else {
                            options.add(new SelectOption(subject.Id, subject.Subject_Name__c));
                        }
                    }
                }
            }
            SelectOptionSorter.doSort(options, SelectOptionSorter.FieldToSort.Label);
            return options;
        }
        Catch(Exception x)
        {
            System.debug('Exception: '+x);
            return NULL;
        }
    }
    
    public PageReference removeSubject() {
        
        PageReference pageRef = ApexPages.currentPage();
        
        try {
            
            Role_Application_Subject__c subjectToDelete = new Role_Application_Subject__c();
            subjectToDelete.Id = deleteId;
            subjectToDelete.Not_Restricted__c = true;
            update subjectToDelete;
            delete subjectToDelete;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, Label.Role_removed));
            
            RoleApplicationSubjectService.setRoleId(roleId);
            RoleApplicationSubjectService.isSubjectsCached = false;
            ras = RoleApplicationSubjectService.getSubjectsByRoleId();
            pageRef.setRedirect(true);
        }
        catch (Exception ex) {
            ApexPages.addMessages(ex);
        }
        pageRef.getparameters().put('id',roleId);
        return pageRef;
    }
    
    public PageReference createSubject() {
        
        PageReference pageRef = ApexPages.currentPage();
        
        try {
            
            if (addSubject == null || addSubject == '') {
                throw new CustomValidationException('You must enter a subject.');
            }
            
            Role_Application_Subject__c roleSubject = new Role_Application_Subject__c();
            
            roleSubject.Role_And_Application__c = roleId;
            roleSubject.IB_Subject__c = addSubject;
            
            insert roleSubject;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, Label.Subject_Added));
            
            RoleApplicationSubjectService.setRoleId(roleId);
            RoleApplicationSubjectService.isSubjectsCached = false;
            ras = RoleApplicationSubjectService.getSubjectsByRoleId();
            pageRef.getParameters().put('id',roleId);
            pageRef.setRedirect(true);
        }
        catch (Exception ex) {
            ApexPages.addMessages(ex);
        }
        pageRef.getparameters().put('id',roleId);
        return pageRef;
    }
    //  this code is edited by developer Ali Haider Bajwa-PlumLogix for ecm 465 of cr project
    //  start
    public PageReference addAgeGroup()
    {
        try
        {
            PageReference pageRef = new Pagereference('/ibportal/MyIBRoles');
            String rightAgeGroup='';
            if(selectedAgeGroup != null){
                for(SelectOption so:selectedAgeGroup){
                    rightAgeGroup = rightAgeGroup + ';' + so.getValue();
                }
            }
            this.role.Age_Groups__c=rightAgeGroup;
            upsert this.role;
            pageRef.setRedirect(true);
            return pageRef;
        }
        Catch(Exception x)
        {
            System.debug('Exception: '+x);
        }
        return NULL;
    }
    //end
    public void getWorkshopTitles(){
        try
        {
            WorkshopTitlesOptions = new list<SelectOption>();
            Set<String> subjects = new Set<String>();
            
            for(Role_Application_Subject__c r:ras){
                subjects.add(r.IB_Subject__c);
            }
            RoleApplicationWorkshopTitleService.roleId = role.Id;
            List<Role_Application_Workshop_Title__c> listRawt = RoleApplicationWorkshopTitleService.getWorkshopTitlesByRoleId();
            System.debug('Size of listRawt: ' +listRawt.size());
            Set<Id> setRawt = new Set<Id>();
            for(Role_Application_Workshop_Title__c r : listRawt){
                if(r.IB_Workshop_Title__c != null)
                {
                    setRawt.add(r.IB_Workshop_Title__c);
                    system.debug(r.IB_Workshop_Title__c);                    
                }
            }
            System.debug('Size of setRawt: ' +setRawt.size());
            List<IB_Workshop_Titles__c> workshoptitles;
            workshoptitles = [SELECT Id, Workshop_Title_FR__c, Workshop_Title_SP__c, Workshop_Title_ENG__c, Subject_Group__c, 
                              (SELECT id, IB_Subject__c, Subject_Group__c from IB_Workshop_Title_Subjects__r) 
                              FROM IB_Workshop_Titles__c WHERE Programme__c = :role.Programme_Selection__c AND Id NOT IN :setRawt];
            
            for(IB_Workshop_Titles__c r : workshoptitles){
                if(r.IB_Workshop_Title_Subjects__r.size() == 0){
                    if(getLocale() == 'fr' && r.Workshop_Title_FR__c != null){
                        WorkshopTitlesOptions.add(new SelectOption(r.Id,r.Workshop_Title_FR__c));
                    } else if (getLocale() == 'es' && r.Workshop_Title_SP__c != null){
                        WorkshopTitlesOptions.add(new SelectOption(r.Id,r.Workshop_Title_SP__c));
                    } else {
                        WorkshopTitlesOptions.add(new SelectOption(r.Id,r.Workshop_Title_ENG__c));
                    }
                }
                else{
                    if(subjects.size() > 0){
                        boolean subjectMatched = false;
                        for(IB_Workshop_Title_Subject__c sub : r.IB_Workshop_Title_Subjects__r){
                            if(subjects.contains(sub.IB_Subject__c)){
                                subjectMatched = true;
                                break;
                            }
                        }
                        if(subjectMatched){
                            if(getLocale() == 'fr' && r.Workshop_Title_FR__c != null){
                                WorkshopTitlesOptions.add(new SelectOption(r.Id,r.Workshop_Title_FR__c));
                            } else if (getLocale() == 'es' && r.Workshop_Title_SP__c != null){
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
        Catch(Exception x)
        {
            System.debug('Exception: '+x);
        }
        
    }
    
    public void getSelectedWorkshopTitles(){
        try
        {
            RoleApplicationWorkshopTitleService.roleId = role.Id;
            List<Role_Application_Workshop_Title__c> rawt = RoleApplicationWorkshopTitleService.getWorkshopTitlesByRoleId();
            for(Role_Application_Workshop_Title__c r : rawt){
                if(r.IB_Workshop_Title__c != null){
                    system.debug(r.IB_Workshop_Title__c);
                    if(getLocale() == 'fr'){
                        selectedWorkshopTitles.add(new SelectOption(r.IB_Workshop_Title__c,r.IB_Workshop_Title__r.Workshop_Title_FR__c));
                    } else if (getLocale() == 'es'){
                        selectedWorkshopTitles.add(new SelectOption(r.IB_Workshop_Title__c,r.IB_Workshop_Title__r.Workshop_Title_SP__c));
                    } else {
                        selectedWorkshopTitles.add(new SelectOption(r.IB_Workshop_Title__c,r.IB_Workshop_Title__r.Workshop_Title_ENG__c));
                    }
                }
            }
        }
        catch(exception e)
        {
            system.debug('excep'+e);
        }
    }
    
    public PageReference saveWorkshopTitles(){
        try
        {
            PageReference pageRef = ApexPages.currentPage();
            RoleApplicationWorkshopTitleService.roleId = role.Id;
            set<string> setWorkshopTitles = new set<string>();
            map<id, id> mapWTIdToRAWTId = new map<id, id>();
            List<Role_Application_Workshop_Title__c> rawtToAdd = new List<Role_Application_Workshop_Title__c>();
            List<Role_Application_Workshop_Title__c> rawtToRemove = new List<Role_Application_Workshop_Title__c>();
            for(Role_Application_Workshop_Title__c roleAppTitle : RoleApplicationWorkshopTitleService.getWorkshopTitlesByRoleId()){
                setWorkshopTitles.add(roleAppTitle.IB_Workshop_Title__c);
                mapWTIdToRAWTId.put(roleAppTitle.IB_Workshop_Title__c, roleAppTitle.id);
            }
            system.debug('setWorkshopTitles: ' + setWorkshopTitles);
            system.debug('selectedWorkshopTitles: ' + selectedWorkshopTitles);
            for(SelectOption so : selectedWorkshopTitles){
                Role_Application_Workshop_Title__c r = new Role_Application_Workshop_Title__c();
                system.debug('so.getValue(): ' + so.getValue());
                if(!setWorkshopTitles.contains(so.getValue())){
                    r.IB_Workshop_Title__c = so.getValue();
                    r.Role_And_Application__c = role.Id;
                    rawtToAdd.add(r);//Insert newly selected wokshop title
                }
                else{
                    setWorkshopTitles.remove(so.getValue());
                }
            }
            system.debug('rawtToAdd: ' + rawtToAdd);
            system.debug('setWorkshopTitles: ' + setWorkshopTitles);
            if(setWorkshopTitles != null && !setWorkshopTitles.isEmpty()){
                for(id wtId : setWorkshopTitles){
                    rawtToRemove.add(new Role_Application_Workshop_Title__c(id = mapWTIdToRAWTId.get(wtId)));
                }
            }
            if(rawtToAdd != null && !rawtToAdd.isEmpty()){
                insert rawtToAdd;
            }
            if(rawtToRemove != null && !rawtToRemove.isEmpty()){
                delete rawtToRemove;
            }
            pageRef.getparameters().put('id',roleId);
            pageRef.setRedirect(true);
            return pageRef;
        }
        Catch(Exception x)
        {
            System.debug('Exception: '+x);
            return NULL;
        }
    }
    /***This Part of Code is added by Ammara-Plumlogix as part of US-11741,Staff-Aug Project*/
    /***Begin***/
    public PageReference saveWorkshopTitles_Workshop_leader(){
        try
        {
            all_workshop();
            PageReference pageRef = ApexPages.currentPage();
            RoleApplicationWorkshopTitleService.roleId = role.Id;
            Set<string> setWorkshopTitles = new Set<string>();
            List<string> setWorkshopTitles_delete = new List<string>();
            List<ID> workshop_ids_all = new List<ID>();
            List<ID> workshop_ids = new List<ID>();
            map<id, id> mapWTIdToRAWTId = new map<id, id>();
            List<Role_Application_Workshop_Title__c> rawtToAdd = new List<Role_Application_Workshop_Title__c>();
            List<Role_Application_Workshop_Title__c> rawtToRemove = new List<Role_Application_Workshop_Title__c>();
            
            for(Role_Application_Workshop_Title__c roleAppTitle : RoleApplicationWorkshopTitleService.getWorkshopTitlesByRoleId()){
                setWorkshopTitles.add(roleAppTitle.IB_Workshop_Title__r.id);
                mapWTIdToRAWTId.put(roleAppTitle.IB_Workshop_Title__c, roleAppTitle.id);
            }
            system.debug('setWorkshopTitles: ' + setWorkshopTitles);
            system.debug('selectedWorkshopTitles: ' + Workshops_Details_List.size());
            for(Workshops_Details so : Workshops_Details_List){
                if(setWorkshopTitles.size()>0){
                    System.debug(so.isSelected+'');
                    System.debug(so.workshop_title.IB_Workshop_Title__r.id+'');
                    if(so.isSelected == true && !setWorkshopTitles.contains(so.workshop_title.IB_Workshop_Title__r.id )){
                        system.debug('Workshop already not selected');
                        Role_Application_Workshop_Title__c r = new Role_Application_Workshop_Title__c();
                        system.debug('so.getValue(): ' + so.workshop_title.IB_Workshop_Title__r.id);
                        
                        r.IB_Workshop_Title__c = so.workshop_title.IB_Workshop_Title__r.id;
                        r.Role_And_Application__c = role.Id;
                        system.debug('Inserted');
                        rawtToAdd.add(r);//Insert newly selected wokshop title
                    }
                    else if(so.isSelected != true && setWorkshopTitles.contains(so.workshop_title.IB_Workshop_Title__r.id )){
                        system.debug('Workshop remove');
                        setWorkshopTitles_delete.add(so.workshop_title.IB_Workshop_Title__r.id);  //remove the already added workshop title
                    }
                }
                else {
                    Role_Application_Workshop_Title__c r = new Role_Application_Workshop_Title__c();
                    system.debug('Workshop added ' + so.workshop_title.IB_Workshop_Title__r.id);
                    
                    r.IB_Workshop_Title__c = so.workshop_title.IB_Workshop_Title__r.id;
                    r.Role_And_Application__c = role.Id;
                    system.debug('Inserted');
                    rawtToAdd.add(r);//Insert newly selected wokshop title
                }
            }
            
            system.debug('rawtToAdd: ' + rawtToAdd);
            system.debug('setWorkshopTitles Delete: ' + setWorkshopTitles_delete);
            if(setWorkshopTitles_delete != null && !setWorkshopTitles_delete.isEmpty()){
                for(id wtId : setWorkshopTitles_delete){
                    rawtToRemove.add(new Role_Application_Workshop_Title__c(id = mapWTIdToRAWTId.get(wtId)));
                }
            }
            if(rawtToAdd != null && !rawtToAdd.isEmpty()){
                insert rawtToAdd;
            }
            if(rawtToRemove != null && !rawtToRemove.isEmpty()){
                delete rawtToRemove;
            }
            pageRef.getparameters().put('id',roleId);
            pageRef.setRedirect(true);
            return pageRef;
        }
        Catch(Exception x)
        {
            System.debug('Exception: '+x);
            return NULL;
        }
    }
    //Class contain the boolean field and and related workshop Detail
    //The purpose of this class is to keep track of the selected items by User on VF Page by boolean
    public class Workshops_Details {    
        public IB_Workshop_Details__c workshop_title {get;set;}
        public boolean isSelected {get;set;}
        
        public Workshops_Details(IB_Workshop_Details__c workshoptitle){     
            workshop_title=workshoptitle;
            isselected=false;
        }
        public Workshops_Details(IB_Workshop_Details__c workshoptitle,Boolean value){     
            workshop_title=workshoptitle;
            isselected=value;
        }
    }    
    /***End***/
}