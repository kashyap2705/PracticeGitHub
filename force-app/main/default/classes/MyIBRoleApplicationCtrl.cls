/*******************************************************************************************
* @Name         MyIBRoleApplicationCtrl 
* @Author       
* @Date         
* @Group        
* @Description  
*******************************************************************************************/
/* MODIFICATION LOG
* Version          Developer          Date               Description
*-------------------------------------------------------------------------------------------
*  1.0            Saurabh Singh      05/18/2023        To show the error on UI.I have changed the INFO into ERROR in the line number 765.
*******************************************************************************************/
public without sharing class MyIBRoleApplicationCtrl {
    
    @testVisible private IB_Role__c role {get;set;} 
    private final Map<String,IB_Role_Repository__c> rolesMap = new Map< String , IB_Role_Repository__c>(); 
    private final User user; 
    private final String INTERNAL_LICENSE = 'Salesforce';
    private Date today = date.today();
    public static IB_Workshop_Details__c titleName{get;set;}
    public String elapsedTime;
    public Boolean edit {get;set;}
    public String referencesCap = String.valueOf(Label.IBENPortal_shared_references).capitalize();
    public List<IB_Subject__c> ibSubjects {get;set;}
    public IB_Workshop_Titles__c titles2 {get;set;}
    private final List <SelectOption> categoriesInfo = new List<SelectOption>();
    private final List <SelectOption> programmsInfo = new List<SelectOption>();
    @testVisible public List<SelectOption> subjectOptsRight {get;set;}
    public List<SelectOption> programmesForSchool {get;set;}
    public List<SelectOption> programmeCoordinatorsForSchool {get;set;}
    Map<String, String> ageGroupListValue = new Map<String, String>();
    @testVisible public list<SelectOption> selectedWorkshopTitles {get;set;}
    @testVisible public list<SelectOption> selectedAgeGroup {get;set;}
    public list<SelectOption> ageAvailableOptions {get;set;}
    public list<SelectOption> WorkshopTitlesOptions {get;set;}
    public Map<String,IB_Programme__c> ibProgrammeMap {get;set;}
    public String programmeCoordinator {get;set;}
    //below piece of code is as part of CR 11987
    //start
    public List<SelectOption> bqcsubject
    {
        get
        {
            List<SelectOption> options = new List<SelectOption>();
            Schema.DescribeFieldResult fieldResult = IB_Role__c.BQC_Subject__c.getDescribe();
            List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
            
            for( Schema.PicklistEntry f : ple){
                system.debug('labels = ' + f.getLabel() + ',' +  f.getValue() );
                options.add(new SelectOption(f.getValue() , f.getLabel()));
            }
            return options;
        }
    }
    //end  
    
    public String getReferencesCap(){
        try
        {
            return referencesCap;
        }
        catch(exception e)
        {
            system.debug('excep'+e);
            return null;
        }
    }
    
    public IB_Role_Repository__c currentRole {get;set;}
    
    public String roleDescription {set; get;}
    
    public Contact con {get;set;}
    
    public String categoryData {set; get;}
    
    public String roleData {set; get;}
    
    public String programmData {set; get;} 
    
    public String subjectGroupString {set; get;} 
    
    public String subjectString {set; get;} 
    public String status;
    
    public String schoolName {get;set;}
    public String ibisCode {get;set;}
    public String schoolAccountId {get;set;}
    public Boolean hasLanguageExperience {get;set;}
    public Boolean hasEducationalDegree {get;set;}
    public Boolean hasCountryOfResidence {get;set;}
    public Boolean hasPhone {get;set;}
    
    public IB_E_Background__c languageExperience {get;set;}
    public IB_E_Background__c educationalDegree {get;set;}
    
    public String languageExpRecType {get;set;}
    public String educationalDegRecType {get;set;}
    public boolean BqcRole {get;set;}
    public String bqcsubjectGroupString {set; get;}
    /***This Part of Code is added as part of US-11741,Staff-Aug Project
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
    public List<Workshops_Details> Workshops_Details_All{get;set;} // All workshops list
    Map<ID,IB_Workshop_Details__c> workshop_to_add{get;set;}//workshop selected and need to added in selected_workshop_details
    //This Part of Code is added as part of US-12160(ECM00218 & ECM00219),Staff-Aug Project on 2/5/2021
    public List<IB_E_Background__c> ib_background {get;set;}//List off IB-E-Background add by educator
    public  IB_E_Background__c background {get;set;}//Record of IB-E-Background
    public ID backgroundRecordTypeId;//Record type id IB School specfic Experience
    public integer row_to_remove{get;set;}//store index value to remove record from ib_background list
    public Boolean year_experience{get; set;}
    /***End***/
    //Function that select programmes
    public string selectedprogramme {
        get
        {
            System.debug('Data: '+programmData);
            if(programmData == 'MYP')
                return Label.IB_Portal_MYP;
            else if(programmData == 'PYP')
                return Label.IB_Portal_PYP;
            else if(programmData == 'CP')
                return Label.IB_Portal_CP;
            else if(programmData == 'DP')
                return Label.IB_Portal_DP;
            else if(programmData == 'DP+CP')
                return Label.IB_Portal_DP_CP;
            else if(programmData == 'IB Ed')
                return Label.IB_Portal_IB_Ed;
            else if(programmData == 'Lead')
                return Label.IB_Portal_Lead;
            else
                return '';
            
        }
    }
    //Function that run to get all workshop titles
    public void get_workshop_titles(){
        List<String> workshop_names = new List<String>();
        locale = getlocale();
        Date enddate = date.today();
        Workshops_Details_List = new List<Workshops_Details>();
        Previous_Workshops_Details = new List<Workshops_Details>(); 
        selected_Workshops_Details = new List<Workshops_Details>(); 
        workshop_to_add = new Map<ID,IB_Workshop_Details__c>();
        System.debug('Programme Data: '+programmData);
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
        Workshops_Details_All = Workshops_Details_List;
        System.debug('Workshop Records are '+Workshops_Details_List);
    }
    //Function return All programmes list
    public List<SelectOption> getProgramme() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('','--'+Label.select+'--'));
        options.add(new SelectOption('PYP',Label.IB_Portal_PYP));
        options.add(new SelectOption('MYP',Label.IB_Portal_MYP));
        options.add(new SelectOption('DP',Label.IB_Portal_DP));
        options.add(new SelectOption('CP',Label.IB_Portal_CP));
        options.add(new SelectOption('DP+CP',Label.IB_Portal_DP_CP));
        options.add(new SelectOption('IB Ed',Label.IB_Portal_IB_Ed));
        options.add(new SelectOption('Lead',Label.IB_Portal_Lead));
        return options;
    }
    //Function to add all the selected workshops from workshop_to_add in selected_workshop_details
    public void  selected_workshops(){
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
    //Function to add selected workshops to workshop_to_add and making sure no duplicates added
    public void  select_workshops(){
        if(Workshops_Details_List != null){
            System.debug('Select Workshop: '+Workshops_Details_List.size());
            for(Workshops_Details wrd : Workshops_Details_List){                
                if(wrd.isSelected == true && workshop_to_add != null && !workshop_to_add.containsKey(wrd.workshop_title.id)){ 
                    System.debug('Select Workshop 1: '+wrd);
                    workshop_to_add.put(wrd.workshop_title.id,wrd.workshop_title);
                }else if(wrd.isSelected == false && workshop_to_add != null && workshop_to_add.containsKey(wrd.workshop_title.id))
                    workshop_to_add.remove(wrd.workshop_title.id);
                
            }
        }
        if(workshop_to_add != null)
            System.debug('***** '+workshop_to_add.size());
    }
    //Function refresh all the worshops for VF Page according to the user input
    public void all_workshop(){
        selected_workshops();
        List<Workshops_Details> temp_List = new List<Workshops_Details>();
        for(Workshops_Details wd: Workshops_Details_All){//All
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
        Workshops_Details_All = temp_List;
        System.debug('***Test: '+temp_List.size());
    }
    //Function check filters and call functions according to selected filters
    public void filters(){
        all_workshop();
        if((inputText1 != null || inputText1 != '')&& (searchfilter_category != null ||  searchfilter_category != '') )
            get_searchtitle();
        else if((inputText1 != null || inputText1 != '')&& (searchfilter_category == null ||  searchfilter_category == '') )
            get_searchtitle();
        else if((inputText1 == null || inputText1 == '')&& (searchfilter_category != null || searchfilter_category != ''))
            category_filter_workshop();
        else if((inputText1 == null || inputText1 == '')&& (searchfilter_category == null || searchfilter_category == ''))
            selected_workshops();
    }
    //Function to filter workshop on the basis of selected category
    public void category_filter_workshop(){
        try{
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
            System.debug('Category: '+str+' filter '+searchfilter_category+' list '+Workshops_Details_List.size()+'  '+Workshops_Details_List);
            System.debug('Prvious: '+Previous_Workshops_Details.size()+'  '+Previous_Workshops_Details);
        }catch(Exception ex){
            System.debug('Exception: '+ex);
        }
    }
    //Function to filter workshop on the basis of keyword
    public void get_searchtitle() {
        try{
            List<Workshops_Details> Workshops_Details_search = new List<Workshops_Details>();     
            Workshops_Details_List = Workshops_Details_All;
            searchstring = inputText1;    
            if(inputText1 != null && inputText1 != ''){
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
    //Function to assign the processed workshop list to Workshops_Details_List to show it on VF Page
    public void workshop_list(List<Workshops_Details> Workshops_Details_search1){
        Previous_Workshops_Details = Workshops_Details_List;
        Workshops_Details_List = null;
        Workshops_Details_List = new List<Workshops_Details>();
        Workshops_Details_List = Workshops_Details_search1;
        System.debug('Workshop List: '+Workshops_Details_search1);
    }
    /****End****/
    /*** This method will assign the list of roles according o the role user selected to apply. Only for Evaluation Leader and Programme Leader
* @param N/A
* @return List<SelectOption>
***/
    public List<SelectOption> geteducator_background_role(){
        List<String> evaluation_leader_roles = new List<String>{'Director','Head of School','Principal','Headmaster','IB coordinator','Head of academics','Curriculum Director','Assistant principal','Department head','Year level leader','Other'};
            List<String> programme_leader_roles = new List<String>{'Teacher','Section leader','Department leader','Middle leadership','Senior leadership' };
                List<SelectOption> educator_background_role= new List<SelectOption>();
        if(currentrole.Role_Name__c == 'Evaluation Leader'){
            Schema.DescribeFieldResult fieldResult = Schema.IB_E_Background__c.IB_Role__c.getDescribe();
            List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
            for( Schema.PicklistEntry f : ple){
                system.debug('labels = ' + f.getLabel() + ',' +  f.getValue() );
                if(evaluation_leader_roles.contains(f.getValue()))
                    educator_background_role.add(new SelectOption(f.getValue() , f.getLabel()));
            }}else if(currentrole.Role_Name__c == 'Programme Leader'){
                Schema.DescribeFieldResult fieldResult = Schema.IB_E_Background__c.IB_Role__c.getDescribe();
                List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
                for( Schema.PicklistEntry f : ple){
                    system.debug('labels = ' + f.getLabel() + ',' +  f.getValue() );
                    if(programme_leader_roles.contains(f.getValue()))
                        educator_background_role.add(new SelectOption(f.getValue() , f.getLabel()));
                }
            }
        return educator_background_role;
    }
    /* This method will assign the list of programme. Only for Evaluation Leader and Programme Leader
* @param N/A
* @return List<SelectOption>
***/
    public List<SelectOption> geteducator_programme(){
        List<SelectOption> educator_background_programme= new List<SelectOption>();
        List<String> programme = new List<String>{'MYP','PYP','CP','DP'};        
            Schema.DescribeFieldResult fieldResult = Schema.IB_E_Background__c.IB_Programme__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry f : ple){
            system.debug('labels = ' + f.getLabel() + ',' +  f.getValue() );
            if(programme.contains(f.getValue()))
                educator_background_programme.add(new SelectOption(f.getValue() , f.getLabel()));
        }
        return educator_background_programme;
        
    }
    /* This method will add another row in ib_background for employment history record
* @param N/A
* @return N/A
***/
    public void addAnother(){
        System.debug('Test: '+background);
        background = new IB_E_Background__c();
        background.RecordTypeId = backgroundRecordTypeId;
        ib_background.add(background);
        System.debug('Test: '+ib_background.size());
    }
    /* This method will add remove row from ib_background for employment history record
* @param N/A
* @return N/A
***/
    public void remove(){
        System.debug('Row: '+row_to_remove);
        ib_background.remove(row_to_remove);
        List<IB_E_Background__c> ib_background_temp = new List<IB_E_Background__c>();
        ib_background_temp = ib_background;
        ib_background = new List<IB_E_Background__c>();
        for(IB_E_Background__c ib_background_record :ib_background_temp){
            ib_background.add(ib_background_record);
        }
    }
    /***End***/
    public String getStatus(){
        try
        {
            return this.role.Status__c;
        }
        catch(exception e)
        {
            system.debug('exp'+e);
            return Null;
        }
    }
    public List<SelectOption> getCountryInfo() {
        try
        {
            List <SelectOption> countryInfoList = new List <SelectOption> ();
            countryInfoList.add(new SelectOption ('', ''));
            try { 
                for (IB_Country_Segmentation__c country : IBCountrySegmentationDAO.INSTANCE.getAll()) {
                    if (getLocale() == 'es' && country.Country_es__c != null) {
                        countryInfoList.add(new SelectOption(country.id, country.Country_es__c));
                    }
                    else if (getLocale() == 'fr' && country.Country_fr__c != null) {
                        countryInfoList.add(new SelectOption(country.id, country.Country_fr__c));
                    }
                    else {
                        countryInfoList.add(new SelectOption(country.id, country.name));
                    }
                }
                
            } catch (Exception e) {
                system.debug('*** Error in Constructor method *** ' + e.getMessage());
                ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, '2.)' + e.getMessage()));
            } 
            
            return countryInfoList;
        }
        catch(exception e)
        {
            system.debug('exp'+e);
            return Null;
        }
    }
    
    public List<SelectOption> contactOptions {get;set;}
    
    public MyIBRoleApplicationCtrl (ApexPages.StandardController stdController) {
        
        
        try
        {
            Map<String, String> ageGroupListValue = new Map<String, String>();
            system.debug('MyIBRoleApplicationCtrl Start');
            edit=true;
            subjectOptsRight = new List<SelectOption>();
            ageAvailableOptions=new List<SelectOption>();
            user = UserService.getUser();
            ibProgrammeMap = new Map<String,IB_Programme__c>();
            IBEBackgroundDAO ibeDao = IBEBackgroundDAO.INSTANCE;
            hasLanguageExperience = false;
            hasEducationalDegree = false;
            hasCountryOfResidence = false;
            hasPhone = false;
            
            selectedWorkshopTitles = new List<SelectOption>();
            selectedAgeGroup= new List<SelectOption>();
            programmesForSchool = new List<SelectOption>();
            
            this.role = (IB_Role__c) stdController.getRecord();
            
            RoleRepositoryService.roleId = ApexPages.currentPage().getParameters().get('roleId');
            currentRole = RoleRepositoryService.getRoleById();
            
            if(currentRole.MyIB_Use_My_School_Subjects__c){
                ibSubjects = [SELECT IB_Programme__c,toLabel(Subject_Group__c),Subject_Group_Value__c,Subject_Name__c,Subject_Name_FR__c, Subject_Name_SP__c FROM IB_Subject__c WHERE Available_in_MySchool__c = true];
            } else {
                ibSubjects =  [SELECT IB_Programme__c,toLabel(Subject_Group__c),Subject_Group_Value__c,Subject_Name__c,Subject_Name_FR__c, Subject_Name_SP__c 
                               FROM IB_Subject__c 
                               WHERE Available_in_IBEN__c = true];
                
                List<IB_Subject__c> subjects2 = [SELECT IB_Programme__c,toLabel(Subject_Group__c),Subject_Group_Value__c,Subject_Name__c,Subject_Name_FR__c, Subject_Name_SP__c 
                                                 FROM IB_Subject__c 
                                                 WHERE ID in (SELECT IB_Subject__c FROM IB_Subjects_Available_for_Roles__c WHERE IB_Role__c = :currentRole.Id)];
                
                ibSubjects.addAll(subjects2);                                               
            }
            
            final IB_Role_Repository__c value = currentRole;
            programmData = this.role.Programme_Selection__c;
            subjectGroupString = this.role.Subject_Groups__c;
            //below piece of code is added as part of CR 11987
            //start
            if(currentrole.Role_Name__c == 'Building Quality Curriculum Reviewer' || currentrole.Role_Name__c == 'Building Quality Curriculum School Reviewer'
               || currentrole.Role_Name__c == 'Building Quality Curriculum Senior Reviewer'  )
            {
                string programme = 'MYP';
                if(getLocale() == 'en_US'){
                    programmsInfo.add(new SelectOption('-Please Select-','-Please Select-'));
                    programmsInfo.add(new SelectOption('MYP','MYP'));
                }
                else if(getLocale()  == 'es'){
                    programmsInfo.add(new SelectOption('-Please Select-','-Seleccione-'));
                    programmsInfo.add(new SelectOption('MYP','PAI'));
                }
                else{
                    programmsInfo.add(new SelectOption('-Please Select-','-Veuillez sélectionner-'));
                    programmsInfo.add(new SelectOption('MYP','PEI'));
                }
                bqcrole = false; 
            }
            //end
            else
            {
                this.programmsInfo.addAll (getProgramsByRoleId(currentRole.Id));
                bqcrole = true;    
            }
            
            List<IB_E_Background__c> eBackgrounds = ibeDao.getRequiredIBEBackgroundsForRole(user.ContactId);
            for(IB_E_Background__c e:eBackgrounds){
                if(e.RecordType.Name == 'Educational Degrees')
                    hasEducationalDegree = true;
                if(e.RecordType.Name == 'Language Experience')
                    hasLanguageExperience= true;
            }
            
            ContactService.setContactId(user.ContactId);
            con = ContactService.getContact();
            if(con.Country__c != null)
                hasCountryOfResidence = true;
            if(con.Phone != null && con.Phone != '')
                hasPhone = true;
            
            
            RecordTypeDAO rtDao = RecordTypeDAO.instance;
            
            if(!hasEducationalDegree && currentRole.Require_Educational_Degree__c){
                educationalDegree = new IB_E_Background__c();
                educationalDegree.RecordTypeId = rtDao.getRecordTypeByNameAndsObjectType('Educational Degrees', 'IB_E_Background__c').Id;
            }
            if(!hasLanguageExperience && currentRole.Require_Language_Experience__c){
                languageExperience = new IB_E_Background__c();
                languageExperience.RecordTypeId = rtDao.getRecordTypeByNameAndsObjectType('Language Experience', 'IB_E_Background__c').Id;
                
            }
            
            initSubjectGroups();
            getWorkshopTitles();
            //This Part of Code is added as part of US-11741,Staff-Aug Project
            Workshops_Details_List = new List<Workshops_Details>();
            Previous_Workshops_Details = new List<Workshops_Details>(); 
            selected_Workshops_Details = new List<Workshops_Details>(); 
            workshop_to_add = new Map<ID,IB_Workshop_Details__c>();
            /*End*/
            //This Part of Code is added as part of US-12160(ECM00218 & ECM00219),Staff-Aug Project on 2/5/2021
            
            ib_background = new List<IB_E_Background__c>();
            background = new IB_E_Background__c();
            backgroundRecordTypeId = rtDao.getRecordTypeByNameAndsObjectType('IB School Specific Experience', 'IB_E_Background__c').Id;
            background.RecordTypeId = backgroundRecordTypeId;
            ib_background.add(background);
            row_to_remove = 0;
            /***End***/
        }
        
        catch(exception e)
        {
            system.debug('exp'+e);
        }
        
    }
    
    @TestVisible
    private List<SelectOption> getProgramsByRoleId(String roleId) {
        
        try
        {
            
            final IB_Role_Repository__c value = currentRole;
            final List<SelectOption> result =  new List<SelectOption>();
            result.add(new SelectOption('', '-' + Label.MyIB_Please_Select + '-'));
            
            List<IB_Data_Translate__c> translations = [
                SELECT Record_ID__c, Translate_Value_1__c 
                FROM IB_Data_Translate__c 
                WHERE Object_Name__c = 'IB_Role_Repository__c'
                AND Locale__c = :getLocale()
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
            }
            return result;
        }
        catch(exception e)
        {
            system.debug('exp'+e);
            return Null;
        }
    }
    public PageReference SaveInfo_IBEC_Role() {
        
        try {
            Boolean temp = edit_phone();
            system.debug('this.role.Country Code' + this.con.Country_Code__c);
            system.debug('this.role.Phone Number' + this.con.Phone_Number__c);
            system.debug('this.role.Job Title' + this.con.Job_Title__c);
            system.debug('this.role.Email' + this.con.Email);
            Integer charLength = con.Phone_Number__c.length();
            if(charLength<4 || charLength>15 || temp == true)
            {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.Phone_Format_Error));
                return null;
            }
            
            if(!Test.isRunningTest())
                update con;
            
            this.role.IB_Contact__c = user.ContactId;
            this.role.IB_Role__c = currentRole.Id;       
            if(!Test.isRunningTest())
                upsert this.role;
            PageReference view = new PageReference ('/ibportal/MyIBRoles');
            view.setRedirect(true);        
            return view;
            
        } catch (Exception ex) {
            
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, ' ' + ex.getMessage()));
            
            return null;
        }
        
        
    }
    public PageReference SaveInfo() {
        
        try {
            // this code is edited as part of for uS-12186 of staff aug project
            
            if(currentRole.Role_Type__c != 'School Role' && hasphone == false && con.Country_Code__c != Null && con.Phone_Number__c!= Null)
            {
                Boolean temp = edit_phone();
                Integer charLength = con.Phone_Number__c.length();
                
                if(charLength<4 || charLength>15 || temp==true)
                    
                {
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.Phone_Format_Error));
                    
                    return null;
                }
                
            }
            else if(currentRole.Role_Type__c != 'School Role' && hasphone == false && (con.Country_Code__c == Null || con.Phone_Number__c== Null)){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.Phone_Format_instruction));
                
                
                return null;
            }
            //End
            
            
            if(!Test.isRunningTest())
                update con;
            
            this.role.IB_Contact__c = user.ContactId;
            this.role.IB_Role__c = currentRole.Id; 
            this.role.Programme_Selection__c = programmData;
            
            
            
            
            
            //This part is added as part of US-12376 on 10/09/2021  (Show error if CAS_Coordinator already exist)
            ID roleId = ApexPages.currentPage().getParameters().get('roleId');
            IB_Role_Repository__c roleSel = [Select Id, Role_Name__c FROM IB_Role_Repository__c WHERE Id = :roleId LIMIT 1];
            //  //  this code is edited by developer Ali Haider Bajwa-PlumLogix for ecm 465 of cr project
            //  start
            if(roleSel.Role_Name__c == 'Teacher')
            {
                IF(programmData =='PYP')  
                {
                    if(selectedAgeGroup.size()==0)
                    {
                        ApexPages.Message msg = new ApexPages.Message(ApexPages.severity.INFO , 'Error: ' + system.label.IBENPortal_Error_RoleApplicationAgeGroup);
                        ApexPages.addMessage(msg);
                        return null;
                    }
                    
                    String rightAgeGroup='';
                    if(selectedAgeGroup != null){
                        for(SelectOption so:selectedAgeGroup){
                            rightAgeGroup = rightAgeGroup + ';' + ageGroupListValue.get(so.getValue());
                        }
                    }
                    this.role.Age_Groups__c=rightAgeGroup;
                }
                IF(programmData =='PYP')
                {
                    if(subjectGroupString!='Additional language teacher' && subjectGroupString!='Generalist teacher' && subjectOptsRight.size()==0 )
                    {
                        
                        ApexPages.Message msg = new ApexPages.Message(ApexPages.severity.INFO , system.label.IBENPortal_Error_RoleApplicationSubject);
                        ApexPages.addMessage(msg);
                        getSubjects();
                        return null;
                    }
                }
            }
            //end
            List<IB_Role__c> Existing_CAS_Coordinator = new List<IB_Role__c>();
            if(roleSel.Role_Name__c == 'CAS Coordinator')
            {
                role.Programme_Selection__c = 'DP';
            }
            
            
            if(roleSel.Role_Name__c == 'CAS Coordinator')
            {
                Existing_CAS_Coordinator    = [SELECT Id, Account_Id_Formula__c, IB_Contact__r.User_Language__c , IB_Contact__r.Email,IB_Contact__r.Name, IB_Programme_New__c,
                                               Active__c, IB_Contact__r.LastName, IB_Contact__r.FirstName, IB_Contact__c, Status__c, IB_Role_Name__c,
                                               Programme_Selection__c, School_Name__c FROM IB_Role__c Where IB_Programme_New__c != NULL and IB_Programme_New__c =: role.IB_Programme_New__c and
                                               Status__c = 'Confirmed' and IB_Role_Name__c = 'CAS Coordinator' Limit 1];
                System.debug('roleSel.Role_Name__c :' + roleSel.Role_Name__c);
                System.debug('Size_Existing 123 :' + Existing_CAS_Coordinator.size());
                if(Existing_CAS_Coordinator.size() > 0){
                    System.debug('Inside_Error');
                    ApexPages.Message msg = new ApexPages.Message(ApexPages.severity.INFO , 'Error: ' + system.label.Confirmed_CAS_Coordinator_already_Exist);
                    ApexPages.addMessage(msg);
                    return null;
                }
            }
            
            
            
            
            if(!bqcrole)
            {
                system.debug('bqcsubjectGroupString' + bqcsubjectGroupString);
                system.debug('currentrole' + currentrole.Role_Name__c);
                this.role.BQC_Subject__c = bqcsubjectGroupString;}
            else
            {this.role.Subject_Groups__c = subjectGroupString;}
            this.role.IB_Account__c = this.role.Account_ID__c;
            if(role.IB_Programme_New__c != null || role.Programme_Coordinator_Email__c != null){
                this.role.Notify_Programme_Coordinator_of_Teacher__c = true;
            }
            system.debug('this.role.IB_Account__c' + this.role.IB_Account__c);
            system.debug('this.role.Programme_Selection__c' + this.role.Programme_Selection__c );
            system.debug('this.role.IB_Role__c' + this.role.IB_Role__c);
            // added IB_Programme_New__r.recordtype.Developername !='Agreement' // added by kashyap ECM00605
            List<IB_Role__c> existingProgrammes = [select id from IB_Role__c where IB_Contact__c =: user.ContactId and 
                                                   IB_Role__c =: role.IB_Role__c and 
                                                   Programme_Selection__c =: role.Programme_Selection__c and 
                                                   IB_Account__c =: this.role.Account_ID__c and 
                                                   Status__c in ('Applicant','Confirmed') and 
                                                   (End_Date__c = null OR End_Date__c > TODAY) 
                                                   and IB_Programme_New__r.recordtype.Developername !='Agreement'
                                                     ];
            system.debug('existingprogrammes: ' + existingprogrammes);
            if(existingProgrammes.size() > 0){
                // this code is edited as part of for uS-193886, to show the error on UI.
                ApexPages.Message msg = new ApexPages.Message(ApexPages.severity.ERROR , 'Error: ' + system.label.IBENPortal_Error_RoleApplicationDuplication);
                ApexPages.addMessage(msg);
                return null;
            }
            
            
            
            if(!Test.isRunningTest())
            {
                
                try{
                    
                    
                    system.debug('Javalog -- Institute_profile_link__c '+ this.role.Institute_profile_link__c);
                    upsert this.role;
                    upsert currentRole;
                }
                catch(DMLException e)
                {
                    return null;
                }
            }
            
            
            List<Role_Application_Subject__c> ras = new List<Role_Application_Subject__c>();
            
            for(SelectOption so: subjectOptsRight){
                Role_Application_Subject__c r = new Role_Application_Subject__c();
                r.IB_Subject__c = so.getValue();
                r.Role_And_Application__c = this.role.Id;
                ras.add(r);
            }
            system.debug('Additional language teacher'+subjectGroupString);
            
            if(subjectGroupString=='Additional language teacher' || subjectGroupString=='Generalist teacher')
            {
                IB_Subject__c sub;
                // Select  name,IB_Subject__r.Subject_Name__c, Role_And_Application__c  from Role_Application_Subject__c where IB_Subject__r.Subject_Group__c='Additional language teacher'
                sub=[Select id,Subject_Name__c  from IB_Subject__c where Subject_Name__c='Additional language teacher' OR Subject_Name__c='Generalist Teacher' limit 1];
                Role_Application_Subject__c r = new Role_Application_Subject__c();
                r.IB_Subject__c= sub.Id;
                r.Role_And_Application__c = this.role.Id;
                ras.add(r);
            }
            
            
            if(ras.size() > 0) {
                if(!Test.isRunningTest())
                    insert ras;
            }
            
            //This Part of Code is added as part of US-11741,Staff-Aug Project
            List<Role_Application_Workshop_Title__c> rawt1 = new List<Role_Application_Workshop_Title__c>();
            for(Workshops_Details so : Workshops_Details_List){
                if(so.isSelected == true){
                    Role_Application_Workshop_Title__c r = new Role_Application_Workshop_Title__c();
                    r.IB_Workshop_Title__c = so.workshop_title.IB_Workshop_Title__r.id;
                    r.Role_And_Application__c = this.role.Id;
                    rawt1.add(r);
                }
            }
            if(rawt1.size() > 0) insert rawt1;
            /***End***/
            List<Role_Application_Workshop_Title__c> rawt = new List<Role_Application_Workshop_Title__c>();
            
            for(SelectOption so : selectedWorkshopTitles){
                Role_Application_Workshop_Title__c r = new Role_Application_Workshop_Title__c();
                r.IB_Workshop_Title__c = so.getValue();
                r.Role_And_Application__c = this.role.Id;
                rawt.add(r);
            }
            if(rawt.size() > 0) insert rawt;
            List<IB_E_Background__c> ibeBackgrounds = new List<IB_E_Background__c>();
            if(educationalDegree != null){
                ibeBackgrounds.add(educationalDegree);
            }
            
            if(languageExperience != null){
                ibeBackgrounds.add(languageExperience);
            }
            //This Part of Code is added  as part of US-12160(ECM00218 & ECM00219),Staff-Aug Project on 2/5/2021
            if(ib_background != null){
                for(IB_E_Background__c ib_background_record:ib_background)
                    ibeBackgrounds.add(ib_background_record);
            }
            /***End**/
            if(ibeBackgrounds.size() > 0)
                insert ibeBackgrounds;
            
            PageReference view = new PageReference ('/ibportal/MyIBRoles');
            view.setRedirect(true);        
            return view;
            
            
            
        } 
        catch (Exception ex) {
            
            
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, ' ' + ex.getMessage()));
            System.debug('Exception : '+ex);
            
            return null;
        }
        
        
    }
    
    public List<SelectOption> getProgrammsInfo() {
        return this.programmsInfo;
    }
    public Boolean getPageHasErrorMessages() {
        return ApexPages.hasMessages(ApexPages.Severity.ERROR);
    }
    public boolean edit_phone(){
        string citySelected = con.Country_Code__c;
        string phone_number = con.Phone_Number__c;
        boolean city = false;
        boolean roleAppUpd = false;
        boolean error = false;
        Integer len = phone_number.length();  
        
        if (citySelected =='--None--' || citySelected =='--Aucun--' || citySelected =='--Ninguno--'){
            city = true;
        } 
        
        
        if( !city && phone_number!=Null  && len<=15 && len>4  && phone_number.isNumeric() ){
            
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
            
            FinalPh=FinalPh+PhoneNumber2;
            con.Phone = FinalPh;
            system.debug('FinalPh : ' + FinalPh);
            
        }
        else{
            return true;
        }
        return false;
    }
    public IB_Role__c getRole() {
        return role;
    }
    
    public List<SelectOption> subjectGroupOpts;
    
    public List<SelectOption> getSubjectGroupOpts(){
        return subjectGroupOpts;
    }
    
    public void setSubjectGroupOpts(List<SelectOption> opts){
        subjectGroupOpts = opts;
    }
    
    @testVisible public List<SelectOption> subjectOptsLeft;
    
    public List<SelectOption> getSubjectOptsLeft(){
        
        try
        {
            if(subjectOptsLeft != null){
                return subjectOptsLeft;
            } else return new List<SelectOption>();
        }
        catch(exception e)
        {
            system.debug('exp'+e);
            return Null;
        }
    }
    
    public void setSubjectOptsLeft(List<SelectOption> opts){
        subjectOptsLeft = opts;
    }           
    
    
    public void getSubjectGroups(){
        try
        {
            system.debug(loggingLevel.ERROR, 'ProgrammData: ' + programmData);
            List<SelectOption> opts = new List<SelectOption>();
            opts.add(new SelectOption('', '-' + Label.MyIB_Please_Select + '-'  ));
            
            Set<String> optsSet = new Set<String>(); 
            if(programmData != null && programmData != ''){
                //Added by Kashyap ECM00605
                if(programmData =='Agreement')
                {
                    programmData='DP';
                }
                //Added by Kashyap ECM00605
                //
                
                for(IB_Subject__c s : ibSubjects){
                    if(s.IB_Programme__c == programmData || (s.IB_Programme__c == 'DP' && programmData =='CP')){
                        
                        if(!optsSet.contains(s.Subject_Group_Value__c + '|' + s.Subject_Group__c)){
                            optsSet.add(s.Subject_Group_Value__c + '|' + s.Subject_Group__c);
                            // this line is added as part ofcr-878 on 20-2-2020
                            // to restrict "Career-related programme Core" as subject group in pyp
                            
                            //  //  this code is edited by developer Ali Haider Bajwa-PlumLogix for ecm 465 of cr project
                            //  start
                            if(programmData == 'PYP'){
                                if( s.Subject_Group_Value__c != 'Career-related programme Core' && s.Subject_Group_Value__c != 'Arts (PYP)' )
                                    //end
                                    opts.add(new SelectOption(s.Subject_Group_Value__c, s.Subject_Group__c));}
                            //end   
                            //below piece of code is added as part of CR 11987 on 10/8/20
                            //start   
                            else if(currentrole.Role_Name__c == 'Building Quality Curriculum Reviewer' 
                                    || currentrole.Role_Name__c == 'Building Quality Curriculum School Reviewer'
                                    || currentrole.Role_Name__c == 'Building Quality Curriculum Senior Reviewer'  )
                            {
                                if(programmData == 'MYP')
                                    if( s.Subject_Group_Value__c != 'Projects (MYP)'  )
                                    opts.add(new SelectOption(s.Subject_Group_Value__c, s.Subject_Group__c));}        
                            else  //end  
                                opts.add(new SelectOption(s.Subject_Group_Value__c, s.Subject_Group__c));
                        }
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
            getWorkshopTitles();
        }
        catch(exception e)
        {
            system.debug('exp'+e);
        }
    }
    //  this code is edited by developer Ali Haider Bajwa-PlumLogix for ecm 465 of cr project
    //  start
    public void getAgeGroups()
    {
        Schema.DescribeFieldResult obj2FieldDescribe = IB_Role__c.Age_Groups__c.getDescribe();
        List<Schema.PicklistEntry> lstMypPickListValues  = obj2FieldDescribe.getPickListValues();
        for (Schema.PicklistEntry ageGroupValue : lstMypPickListValues) {
            ageAvailableOptions.add(new SelectOption(ageGroupValue.getLabel(),ageGroupValue.getLabel()));
            ageGroupListValue.put(ageGroupValue.getLabel(), ageGroupValue.getValue());
        }        
    }
    //end
    public void getSubjects(){
        
        try
        {
            List<SelectOption> opts = new List<SelectOption>();
            Set<String> optsSet = new Set<String>();
            
            Set<String> rightOptsSet = new Set<String>();
            for(IB_Subject__c s : ibSubjects){
                if(!rightOptsSet.contains(s.Id) && (s.IB_Programme__c == programmData || (s.IB_Programme__c == 'DP' && programmData =='CP')) && s.Subject_Group_Value__c == subjectGroupString && (subjectGroupString!='Additional language teacher' && subjectGroupString!='Generalist Teacher') ){                    if((s.IB_Programme__c == programmData || (s.IB_Programme__c == 'DP' && programmData =='CP')) && s.Subject_Group_Value__c == subjectGroupString){
                    if(!optsSet.contains(s.Id)){
                        optsSet.add(s.Id);
                        if(getLocale() == 'fr'){
                            opts.add(new SelectOption(s.Id, s.Subject_Name_FR__c));
                        }else if(getLocale() == 'es'){
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
        }
        catch(exception e)
        {
            system.debug('exp'+e);
        }
        
    }
    
    public void initSubjectGroups(){
        
        try
        {
            List<SelectOption> opts = new List<SelectOption>();
            Set<String> optsSet = new Set<String>();
            for(IB_Subject__c s : ibSubjects){
                if(s.IB_Programme__c == programmData || (s.IB_Programme__c == 'DP' && programmData =='CP')){
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
        catch(exception e)
        {
            system.debug('exp'+e);
        }
    }       
    
    public void initSubjects(){
        
        try
        {
            List<SelectOption> opts = new List<SelectOption>();
            Set<String> optsSet = new Set<String>();
            Set<String> rightOptsSet = new Set<String>();
            
            if(subjectOptsRight != null){
                for(SelectOption so:subjectOptsRight){
                    rightOptsSet.add(so.getValue());
                }
            }
            
            for(IB_Subject__c s : ibSubjects){
                system.debug(loggingLevel.error,'SUBJECT:' + s);
                if(!rightOptsSet.contains(s.Id) && (s.IB_Programme__c == programmData || (s.IB_Programme__c == 'DP' && programmData =='CP')) && s.Subject_Group_Value__c == subjectGroupString){
                    if(!optsSet.contains(s.Id)){
                        optsSet.add(s.Id);
                        if(getLocale() == 'fr' && s.Subject_Name_FR__c != null){
                            opts.add(new SelectOption(s.Id, s.Subject_Name_FR__c));
                        }else if(getLocale() == 'es' && s.Subject_Name_SP__c != null){
                            opts.add(new SelectOption(s.Id, s.Subject_Name_SP__c));
                        }else{
                            opts.add(new SelectOption(s.Id, s.Subject_Name__c));  
                        } 
                    }
                }
            }
            
            SelectOptionSorter.doSort(opts, SelectOptionSorter.FieldToSort.Label);
            system.debug(loggingLevel.ERROR,'OPTS: ' + opts);
            
            setSubjectOptsLeft(opts);
        }
        catch(exception e)
        {
            system.debug('exp'+e);
        }
    }
    
    public void getWorkshopTitles(){
        try
        {
            WorkshopTitlesOptions = new list<SelectOption>();
            string subjectListRight = Apexpages.currentPage().getParameters().get('SubParam');
            Set<String> subjects = new Set<String>();
            if(subjectListRight != null){
                list<string> subjectsFound = subjectListRight.split('&');
                system.debug('#### subjectsFound'+subjectsFound);
                
                for(integer i = 0 ; i < subjectsFound.size() ; i=i+2){
                    subjects.add(subjectsFound[i]);
                }
            }
            
            
            List<IB_Workshop_Titles__c> workshoptitles;
            workshoptitles = [SELECT Id, Workshop_Title_FR__c, Workshop_Title_SP__c, Workshop_Title_ENG__c, Subject_Group__c, 
                              (SELECT id, IB_Subject__c, Subject_Group__c from IB_Workshop_Title_Subjects__r) 
                              FROM IB_Workshop_Titles__c WHERE Programme__c =: programmData];
            
            for(IB_Workshop_Titles__c r : workshoptitles){
                if(r.IB_Workshop_Title_Subjects__r.size() == 0){
                    if(getLocale() == 'fr' && r.Workshop_Title_FR__c != null){
                        WorkshopTitlesOptions.add(new SelectOption(r.Id,r.Workshop_Title_FR__c));
                    } else if (getLocale() == 'es' && r.Workshop_Title_SP__c != null){
                        WorkshopTitlesOptions.add(new SelectOption(r.Id,r.Workshop_Title_SP__c));
                    } else {
                        WorkshopTitlesOptions.add(new SelectOption(r.Id,r.Workshop_Title_ENG__c));
                    }
                } else {
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
            
            system.debug('workshop title options: ' + WorkshopTitlesOptions.size());
        }
        catch(exception e)
        {
            system.debug('exp'+e);
        }
    }
    
    public PageReference isLoggedIn() {
        try
        {
            if (UserInfo.getUserType() == 'Guest') {
                return new PageReference('/ibportal/IBPortalLogin');
            } else {
                return null;
            }  
        }
        catch(exception e)
        {
            system.debug('exp'+e);
            return Null;
        }
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
    
    @RemoteAction
    public static List<string> lookupSchoolAccount(String searchTerm, id roleId) {
        try
        {
            system.debug('#### searchTerm : '+searchTerm);
            RecordType RecType = [SELECT Id, Name FROM RecordType WHERE SobjectType = 'Account' AND DeveloperName = 'School_Account'];
            List<Account> accountList = new List<Account>();
            // This part is updated as part of US-12376 09/09/2021 (DP Authorized School Programme Coordinator )
            // //Start
            IB_Role_Repository__c roleSel = [Select Id, Role_Name__c,Related_Programmes__c FROM IB_Role_Repository__c WHERE Id = :roleId LIMIT 1];
            system.debug('#### searchTerm : ' + searchTerm);
            system.debug('#### Role_Name_Repository : ' + roleSel.Role_Name__c);
            
            
            // This part is updated on 09/12/2021 (DP,CP Authorized School)
            // This code is edited for us-12479 of staff aug prject
            if(roleSel.Role_Name__c == 'University and Career Counselor')
                accountList = Database.query('SELECT Id, IBIS_ID__c, Name FROM Account WHERE Number_of_Programmes__c > 0 AND (DP_Programme_Status__c = \'Authorized\' OR IBCC_Programme_Status__c = \'Authorized\' OR IBCC_Programme_Status__c = \'Candidate\' OR DP_Programme_Status__c = \'Candidate\') AND RecordTypeId = \'' + RecType.Id + '\'  AND Name LIKE \'%' + String.escapeSingleQuotes(searchTerm) + '%\'');
            
            else if(roleSel.Role_Name__c != 'CAS Coordinator'){
                
                accountList = Database.query('SELECT Id, IBIS_ID__c, Name FROM Account WHERE Number_of_Programmes__c > 0 AND RecordTypeId = \'' + RecType.Id + '\'  AND Name LIKE \'%' + String.escapeSingleQuotes(searchTerm) + '%\'');
                
            }
            else
            {
                
                accountList = Database.query('SELECT Id, IBIS_ID__c, Name, DP_Programme_Status__c  FROM Account WHERE Number_of_Programmes__c > 0 AND (DP_Programme_Status__c = \'Authorized\' OR DP_Programme_Status__c = \'Candidate\' ) AND RecordTypeId = \'' + RecType.Id + '\'  AND Name LIKE \'%' + String.escapeSingleQuotes(searchTerm) + '%\'');
            }
            //End            
            
            //Additional filtering for programme status added as part of INC0203497 // ECM00425 - Kevin Fugate 8/5/2024
            List<String> accounts = new List<String>();
            List<IB_Programme__c> programmesList = [SELECT Id, Status__c, Account__c FROM IB_Programme__c WHERE Account__c in :accountList AND (Status__c = 'Interested' OR Status__c = 'Candidate' OR Status__c = 'Authorized')];
            for (Account x : accountList) {
                boolean validProgramme = false;
                for (IB_Programme__c programme : programmesList){
                    if(programme.Account__c == x.id){
                        validProgramme = true;
                    }
                }
                if(validProgramme == true){
                accounts.add(x.Name+':'+x.IBIS_ID__c);
            }
            }
            return accounts;
        }
        catch(exception e)
        {
            system.debug('exp'+e);
            return Null;
        }
        
    }
    @RemoteAction
    public static List<String> lookupSchoolAccountByNameMulti(String searchTerm, id roleid) {
        
        try
        {
            system.debug('#### searchTerm : '+searchTerm);
            string accName = searchTerm.split(':')[0];
            string ibis = searchTerm.split(':')[1];
            List<Account> accountList = new List<Account>();
            RecordType RecType = [SELECT Id, Name FROM RecordType WHERE SobjectType = 'Account' AND DeveloperName = 'School_Account'];
            accountList = Database.query('SELECT Id, Name, IBIS_ID__c FROM Account WHERE Number_of_Programmes__c > 0 AND RecordTypeId = \'' + RecType.Id + '\' AND Name = \'' + String.escapeSingleQuotes(accName) + '\' AND IBIS_ID__c = \'' + String.escapeSingleQuotes(ibis) + '\'');
            List<String> accounts = new List<String>();
            for (Account x : accountList) {
                accounts.add(x.Id);
            }
            return accounts;
        }
        catch(exception e)
        {
            system.debug('exp'+e);
            return Null;
        }
    }
    public void getProgrammesForSchool(){
        System.debug('getProgrammesForSchoolStart');
        try
        {
            ProgrammeService.accountId = role.Account_ID__c;
            
            List<IB_Programme__c> programmes = ProgrammeService.getProgrammesByAccount();
            programmesForSchool = new List<SelectOption>();
            programmesForSchool.add(new SelectOption('', '-' + Label.MyIB_Please_Select + '-'));
            
            Boolean added = false;
            List<IB_Data_Translate__c> dt = [
                SELECT Id, Name, Locale__c, Object_Name__c, Record_Id__c, Translate_Value_1__c
                FROM IB_Data_Translate__c
                WHERE Object_Name__c = 'IB_Programme__c'
                AND Locale__c = :getLocale()
            ];
            
            
            for (IB_Programme__c programme : programmes){
                
                if(programme.StageName__c != 'Withdrawal' && programme.StageName__c != 'Termination' && programme.Status__c !='Previously Interested'){
                    string str = currentRole.Related_Programmes__c;
                    if(str.contains(programme.Programme_Selection__c)){
                        added = false;
                        ibProgrammeMap.put(programme.Id,programme);
                        System.debug('Javalog -- '+programme.Programme_Selection__c);
                    }
                    else
                        added = true;     
                    for (IB_Data_Translate__c trans : dt) {
                        if (programme.RecordType.Name == trans.Record_Id__c) {
                            programmesForSchool.add(new SelectOption(programme.Id, trans.Translate_Value_1__c));
                            
                            added = true;
                            break;
                        }
                    }
                    if (!added) {
                        System.debug('xx in added');
                        //Added by kashyap ECm00605
                        if(programme.RecordType.DeveloperName =='Agreement'){
                        programmesForSchool.add(new SelectOption(programme.Id, programme.RecordType.DeveloperName + '-'+ programme.Agreement_Type__c ));
                        }else
                        {
                             programmesForSchool.add(new SelectOption(programme.Id, programme.RecordType.Name  ));
                        }
                    }else{
                        System.debug('xx in not added');
                    }
                }
            }
            System.debug('Javalog -- programmesForSchool '+programmesForSchool);
        }
        catch(exception e)
        {
            system.debug('exp getprogrammesfromschool fail'+e);
        }
    }
    
    public void getProgrammeCoordinatorsForSchool(){
        
        try
        {
            // This part is updated as part of US-12376 09/09/2021 (DP Authorized School Programme Coordinator )
            // //Start
            ID roleId=ApexPages.currentPage().getParameters().get('roleId');
            IB_Role_Repository__c roleSel = [Select Id, Role_Name__c FROM IB_Role_Repository__c WHERE Id = :roleId LIMIT 1];
            
            //End
            
            
            ProgrammeService.accountId = role.Account_ID__c;
            List<IB_Programme__c> programmes = ProgrammeService.getProgrammesByAccount();
            programmeCoordinatorsForSchool = new List<SelectOption>();
            
            for (IB_Programme__c programme : programmes){
                
                if(programme.StageName__c != 'Withdrawal' && programme.StageName__c != 'Termination'&&programme.Status__c!='Previously Interested'){
                    // This part is updated as part of US-12376 09/09/2021 (DP Authorized School Programme Coordinator )
                    // //Start
                    if(roleSel.Role_Name__c == 'Personal Project Coordinator'){
                        if(programme.name.Contains('MYP')){
                        	programmeCoordinatorsForSchool.add(new SelectOption(programme.Programme_Coordinator_Email__c, programme.Programme_Coordinator_Name__c));
                        }
					}
                    else
                    if(roleSel.Role_Name__c != 'CAS Coordinator'){
                        programmeCoordinatorsForSchool.add(new SelectOption(programme.Programme_Coordinator_Email__c, programme.Programme_Coordinator_Name__c));
                    }
                    else
                    {
                        if(programme.Programme_Selection__c == 'DP' &&  ( programme.Status__c == 'Authorized' || programme.Status__c == 'Candidate'))
                        {
                            System.debug('Javalog -- IF_PC_Name ' + programme.Programme_Coordinator_Name__c);
                            
                            programmeCoordinatorsForSchool.add(new SelectOption(programme.Programme_Coordinator_Email__c, programme.Programme_Coordinator_Name__c));
                            role.IB_Programme_New__c = programme.id;
                            role.Programme_Selection__c = 'DP'; 
                        }
                    }
                    //End
                }
            }
            
            programmData='';
            subjectGroupString='';
            
        }
        
        catch(exception e)
        {
            system.debug('exp'+e);
        }
    }  
    
    public void selectProgramme(){
        
        try
        {                             
            ageAvailableOptions.clear();
            if(role.IB_Programme_New__c != null){
                
                
                programmeCoordinator = ibProgrammeMap.get(role.IB_Programme_New__c).Programme_Coordinator_Name__c;
                programmData = ibProgrammeMap.get(role.IB_Programme_New__c).Programme_Selection__c;
            } else {
                programmeCoordinator = '';
                programmData = '';
            }
            if (programmData=='PYP')
            {
                getAgeGroups();
            }
            getSubjectGroups();
        }
        catch(exception e)
        {
            system.debug('exp'+e);
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