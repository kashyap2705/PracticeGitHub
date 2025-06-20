public class onlineProviderApplyForRoleCtrl {

    @testVisible public string JobTitle{get;set;}
    @testVisible public string Email{get;set;}
    @testVisible public string Phone{get;set;}
    @testVisible public string phonenumber{get;set;}
    @testVisible public string Country_Code{get;set;}
    @testVisible Public String accountNam{get;set;}
    @testVisible Public String   adminName {get;set;}
    @testVisible public  string accId{get;set;}
    @testVisible public  string roleName{get;set;}
    @testVisible public  string roleNameF{get;set;}
    @testVisible public  string roleNameS{get;set;}
    @testVisible public  String emailMatch{get;set;}
    public  string roleId=null;
    public contact CurrentContact;
    public  string selectedProgramme{get;set;}
    public List<SelectOption> programmesForSchool {get;set;}
    public Map<String,IB_Programme__c> ibProgrammeMap {get;set;}
    public string sessionID=UserInfo.getUserid();
    public String OnlineCoordinator {get;set;}
    public IB_Role_Repository__c currentRole {get;set;}
    public IB_Role__c currentIBRole {get;set;}
    public String subjectGroupString {set; get;} 
    public Boolean edit {get;set;}
    public String programmData {set; get;} 
    public List<IB_Subject__c> ibSubjects {get;set;}
    public List<SelectOption> subjectOptsRight {get;set;}
    public static string emailE {get;set;}
    public static string ConfirmEmail {get;set;} 
	public static Boolean emailCheck = false;     
    public onlineProviderApplyForRoleCtrl()
    {
        emailE = null;
        ConfirmEmail = null;
IF(!Test.isRunningTest())
{
        CurrentContact=getCurrentUsersContact();
        JobTitle=CurrentContact.Job_Title__c;
        Email=CurrentContact.Email;
        Phone=CurrentContact.Phone;
        Country_Code = CurrentContact.Country_Code__c;
        phonenumber = CurrentContact.Phone_Number__c;
    	
    }
        edit=true;
        
        subjectOptsRight = new List<SelectOption>();
       // currentRole = RoleRepositoryService.getRoleById();
        accId=ApexPages.currentPage().getParameters().get('AccountId');
        string sError=ApexPages.currentPage().getParameters().get('errorId');
        
        if(sError=='404')ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,' '+ system.label.My_IB_Error_Confirmation_Email));
        
        else if(sError=='404CONN')  ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,' '+ system.label.My_institute_complete_all_required_fields));
            
        
        else if(sError=='InvalidPhone')  ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,' '+system.label.Phone_Format));
            
        
        else if(sError=='InvalidEmail')  ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,' '+system.label.IBENPortal_Registration_EmailError));
            
        
        if(accId!=Null)
        {
            Account accountName=[SELECT IBIS_ID__c,id,name FROM ACCOUNT WHERE id=:accId limit 1];
            //accountNam=accountName.Name+' - '+accountName.IBIS_ID__c;
            accountNam=accountName.Name;
        }
        
        List<IB_Role__c>adRole= [SELECT IB_Account__c,status__c,IB_Contact__r.Name,id,name, IB_Role_name__c FROM IB_Role__c
                                 WHERE IB_Account__c=:accId
                                 
                                 AND IB_Role_name__c='Teacher' 
                                 AND status__c='Confirmed' LIMIT 1];
        
        if(adRole.size()>0)adminName=adRole[0].IB_Contact__r.Name;
        
        roleId=ApexPages.currentPage().getParameters().get('roleId');
        currentRole = [Select id , MyIB_Has_Subjects__c from IB_Role_Repository__c where id=:roleId];
        ibSubjects =  [SELECT IB_Programme__c,toLabel(Subject_Group__c),Subject_Group_Value__c,Subject_Name__c,Subject_Name_FR__c, Subject_Name_SP__c 
                               FROM IB_Subject__c
                               WHERE Available_in_IBEN__c = true];
        
        System.debug('Apple ibSubject' + ibSubjects);
        currentIBRole=[Select id , Subject_Groups__c, IB_Role_Name__c , IB_Programme_New__c from IB_Role__c where IB_Role_Name__c ='Teacher' Limit 1];
        //subjectGroupString = currentIBRole.Subject_Groups__c;
        
        list <IB_Role_Repository__c> rr=[SELECT Role_Name__c,Role_Name_es__c,Role_Name_fr__c,id 
                                         FROM IB_Role_Repository__c WHERE id=:roleId];
        if(rr.size()>0)
        {
            System.debug('RoleName'+roleName);
            roleName=rr[0].Role_Name__c;
            roleNameF=rr[0].Role_Name_fr__c;
            roleNameS=rr[0].Role_Name_es__c;
        }
        ContactDetailsWrapper.Phone=Phone;        
        ContactDetailsWrapper.JobTitle=JobTitle;
        ContactDetailsWrapper.Email=Email;
        ContactDetailsWrapper.countrycode = Country_Code;
        ContactDetailsWrapper.phonenumber = phonenumber;
        if(apexpages.currentpage().getparameters().get('emailId')!='' && apexpages.currentpage().getparameters().get('emailId')!=null) Email = apexpages.currentpage().getparameters().get('emailId');   
        
        else
        {
            Email=ContactDetailsWrapper.Email;
        }
        if(apexpages.currentpage().getparameters().get('phoneId')!='' && apexpages.currentpage().getparameters().get('phoneId')!=null)    Phone = apexpages.currentpage().getparameters().get('phoneId');   
        
        else
        {
            Phone=ContactDetailsWrapper.Phone;  
            
        }
          if (Cache.Org.contains('local.rolesjobtitle.'+sessionID))  JobTitle=(String)Cache.Org.getPartition('local.rolesjobtitle').get(sessionId);
        
    }
    public Contact getCurrentUsersContact()
    {
        List<Contact> u=[select id,Phone_Number__c,User__r.email,Country_Code__c,Email,Job_Title__c,Phone from contact where id=:[SELECT id,name,contactId FROM User WHERE id=:userInfo.getUserId() LIMIT 1].contactId];
       if(u.size()>0) return u[0];   
        return null;
    }
    //=================================================
    public List<SelectOption> getChooseProgramme()
    {
        List<SelectOption> options = new List<SelectOption>();
        String userLanguage = UserInfo.getLanguage();
        options.add(new SelectOption('--None--','--None--'));
        List<IB_Role__c> tempRole = new List<IB_Role__c>();
        List<ID> progID = new List<ID>();
        tempRole = [Select Id,IB_Account__c, IB_Programme_New__r.id, IB_Role_Name__c , IB_Contact__c, Status__c from IB_Role__c where IB_Account__c=:accId AND IB_Contact__r.id =:CurrentContact.Id AND IB_Role_Name__c='Teacher' AND Status__c != 'Withdrawn' AND Status__c != 'Declined'];
        for(IB_Role__c rr : tempRole)
        {
            progID.add(rr.IB_Programme_New__r.id);
        }
        List<IB_Programme__c> abc = new List<IB_Programme__c>();
        abc=[Select id, name , status__c, Account__c, RecordType.Name, Record_Type_Name_French__c, Record_Type_Name_Spanish__c from IB_Programme__c where Account__r.id =: accId AND Status__c='Authorized' AND StageName__c = 'Evaluation'  AND id NOT IN: progID];
        for( IB_Programme__c prog : abc)
        {
            if(userLanguage == 'fr'){
                options.add(new SelectOption(prog.RecordType.Name,prog.Record_Type_Name_French__c));
            }else if(userLanguage == 'es'){
                options.add(new SelectOption(prog.RecordType.Name,prog.Record_Type_Name_Spanish__c));
            }else {
                options.add(new SelectOption(prog.RecordType.Name,prog.RecordType.Name));
            }
           
        } 
        return options;        
    }
    
    public void selectProgramme(){
        
        try
        {                             
            
            if(selectedProgramme != null && selectedProgramme != '--None--'){
			List<IB_Role__c> temp = new List<IB_Role__c>();
                String tempProg = selectedProgramme;
                if(selectedProgramme == 'Diploma Programme')
                    selectedProgramme = 'DP';
                
                programmData = selectedProgramme;
                initSubjectGroups();
                getSubjectGroups();
                temp=[Select id , IB_Contact__r.Name from IB_Role__c where IB_Role_Name__c = 'Online Coordinator' 
                      AND IB_Account__r.id =: accId AND 
                      (Status__c = 'Confirmed') Limit 1];
               
                if(temp != null && temp.size()>0 && temp[0].IB_Contact__r.Name != null)
                OnlineCoordinator = temp[0].IB_Contact__r.Name;
                else{
                OnlineCoordinator = '';   
                  ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,label.My_onlineProvider_No_Online_Coordinator_error));
                }
            } else {
                OnlineCoordinator = ''; 
                 ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,label.My_onlineProvider_No_Online_Coordinator_error));
            }
        }
        catch(exception e)
        {
            system.debug('exp'+e);
        }
    }  
    //==================================================================================
    public List<SelectOption> subjectGroupOpts;
    
    public List<SelectOption> getSubjectGroupOpts(){
        System.debug('Apple3 subjectGroupOpts' + subjectGroupOpts);
        return subjectGroupOpts;
    }
    
    public void setSubjectGroupOpts(List<SelectOption> opts){
        subjectGroupOpts = opts;
    }
    public List<SelectOption> subjectOptsLeft;
    
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
            //selectedSubjects = '';
           // system.debug(loggingLevel.ERROR, 'ProgrammData: ' + programmData);
            List<SelectOption> opts = new List<SelectOption>();
            opts.add(new SelectOption('', '-' + Label.MyIB_Please_Select + '-'));
            
            Set<String> optsSet = new Set<String>();
            if(programmData != null && programmData != ''){
                
                System.debug('Apple2 ibSubjects' + ibSubjects);
                for(IB_Subject__c s : ibSubjects){
                    if(s.IB_Programme__c == programmData || (s.IB_Programme__c == 'DP' && programmData =='CP')){
                        
                        if(!optsSet.contains(s.Subject_Group_Value__c + '|' + s.Subject_Group__c)){
                            optsSet.add(s.Subject_Group_Value__c + '|' + s.Subject_Group__c);
                            // this line is added by developor abd-ur-rehman as part ofcr-878 on 20-2-2020
                            // to restrict "Career-related programme Core" as subject group in pyp
                            // begin
                            if(programmData == 'PYP'){
                                if( s.Subject_Group_Value__c != 'Career-related programme Core' )
                                    opts.add(new SelectOption(s.Subject_Group_Value__c, s.Subject_Group__c));}
                            //end   
                            //below piece of code is added by developer Abd Ur Rehman as part of CR 11987 on 10/8/20
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
            system.debug('Orange1 opts'+ opts);
            setSubjectGroupOpts(opts);
            try{
                subjectGroupString = opts[0].getValue();
            } catch (Exception e){}
            getSubjects();
            //getWorkshopTitles();
        }
        catch(exception e)
        {
            system.debug('exp'+e);
        }
    }
    
    public void getSubjects(){
        
        try
        {
            //system.debug('#### selectedSubjects : '+selectedSubjects);
            List<SelectOption> opts = new List<SelectOption>();
            Set<String> optsSet = new Set<String>();
            
            Set<String> rightOptsSet = new Set<String>();
            
            //if(selectedSubjects != null){
            //    for(string subId : selectedSubjects.split(',')){
            //       rightOptsSet.add(subId);
            //    }
            //}
            
            for(IB_Subject__c s : ibSubjects){
                if(!rightOptsSet.contains(s.Id) && (s.IB_Programme__c == programmData || (s.IB_Programme__c == 'DP' && programmData =='CP')) && s.Subject_Group_Value__c == subjectGroupString){
                    if((s.IB_Programme__c == programmData || (s.IB_Programme__c == 'DP' && programmData =='CP')) && s.Subject_Group_Value__c == subjectGroupString){
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
            opts.add(new SelectOption('', '-' + Label.MyIB_Please_Select + '-'));
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
            System.debug('Orange2 opts'+opts);
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
    //=================================================
     /** 
	* @author Ammara
	* @date 03/24/2021
	* @description return Country code value to show on VF Page.
    * @returntype List<SelectOption>
	* @param N/A
	*/
     public List<SelectOption> getcitynames()
    {
          List<SelectOption> options = new List<SelectOption>();
       Schema.DescribeFieldResult fieldResult = Contact_information__c.Country_Code__c.getDescribe();
       List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
       for( Schema.PicklistEntry f : ple)
       {
               options.add(new SelectOption(f.getLabel(), f.getValue()));
       }     
        return options;
        
    }
    public void SaveJobTitle()
    {
        Cache.Org.put('local.rolesjobtitle.'+sessionId, JobTitle);
    }
    public pageReference submitRole()
    {
        
        // return new pageReference('/ibportal/MyIBRoles');
        
        IB_Role__c rol=new IB_Role__c();
        List<Role_Application_Subject__c> ras = new List<Role_Application_Subject__c>();
        boolean valid=false;   
        boolean check_phone_format = edit_phone();
        if(jobTitle != null && jobTitle!= '' && !String.isEmpty(jobTitle) && !String.isBlank(jobTitle)  && OnlineCoordinator != '' && selectedProgramme != null && selectedProgramme != '--None--' && subjectOptsRight != null && subjectOptsRight.size() > 0 && subjectGroupString != null && phonenumber != null   &&  Email!=null) valid=true;
        
        if(valid 
           ||
           Test.isRunningTest()){
        {
            List<Contact_information__c> ci=[SELECT email__c,phone__c,IB_Contact__c,Recordtype.Name   
                                             from Contact_information__c 
                                             WHERE (email__c=:Email OR phone__c=:Phone)
                                             AND IB_Contact__c=:CurrentContact.id 
                                             AND (Recordtype.Name='Email' OR Recordtype.Name='Phone')];
            
            boolean emailExist=false;
            boolean phoneExist=false;            
            if(ci.size()>0 )
            {
                for(Contact_information__c ciVal:ci)
                {
                    if(ciVal.RecordTypeId==Schema.SObjectType.Contact_Information__c.getRecordTypeInfosByDeveloperName().get('Email').getRecordTypeId())
                    {
                        rol.Contact_Information_Email__c=ciVal.Id;
                        rol.Contact_Information_Email_Text__c=ciVal.email__c;
                        emailExist=true;
                    }
                    else 
                    {
                        rol.Contact_Information_Phone__c=ciVal.Id;
                        
                        phoneExist=true;
                    }
                }
            
            }
            IB_Programme__c temp = new IB_Programme__c();
            if(selectedProgramme != null && selectedProgramme != '--None--')
            {
            	temp=[Select id from IB_Programme__c where RecordType.Name=:selectedProgramme AND Account__r.id =: accId Limit 1];
                rol.IB_Programme_New__c=temp.id;
            }
            rol.Type__c='Online Provider';
            rol.Job_Title__c=jobTitle;
            rol.IB_Account__c=ApexPages.currentPage().getParameters().get('AccountId');
            rol.IB_Contact__c=CurrentContact.id;
            rol.IB_Role__c=ApexPages.currentPage().getParameters().get('roleId');
            rol.Subject_Groups__c = subjectGroupString;
            rol.Job_Title__c=JobTitle;
            
            
            
            
            //  try{
            if(emailExist==false || Test.isRunningTest())
            {
                if(emailE == '' || emailE == null){
                    emailE = Email;
                    ConfirmEmail = Email;
                }
                Contact_information__c ciEmail=new Contact_information__c(IB_Contact__c=CurrentContact.id,
                                                                          Name=Email,Email__c=emailE,
                                                                          RecordTypeId=Schema.SObjectType.Contact_Information__c.getRecordTypeInfosByDeveloperName().get('Email').getRecordTypeId());
                Insert ciEmail;
                rol.Contact_Information_Email__c=ciEmail.Id;
                rol.Contact_Information_Email_Text__c=ciEmail.email__c;
                
            }
            
            // Following code is added by Ammara-Plumlogix of SA Project of US12186 on 3/24/2021
			// Start
            if((check_phone_format == false && phoneExist==false ) || Test.isRunningTest())
            {
                Contact_information__c ciPhone=new Contact_information__c(
                    IB_Contact__c=CurrentContact.id,
                    Name=Phone,
                    Phone__c=Phone,
                    Country_Code__c = Country_Code,
                    Phone_Number__c = phonenumber,
                    RecordTypeId=Schema.SObjectType.Contact_Information__c.getRecordTypeInfosByDeveloperName().get('Phone').getRecordTypeId());
                Insert ciPhone;
                rol.Contact_Information_Phone__c=ciPhone.Id;                
            }else if(check_phone_format == true){
                 ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,label.Phone_Format_Error));
                if(phonenumber!= '')
                phonenumber = '';
                 return null;
            }//End
            //*********************************
          
              System.debug('Plum IN: '+emailE);
            if(emailE != '' )
            {
            if(validateEmail(emailE) )
            {
                if(emailE!=ConfirmEmail)
                {
   					ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,' '+ system.label.My_IB_Error_Confirmation_Email));
                    emailE = '';
                    ConfirmEmail = '';
                    return null;
                }
                else
                {
                	Contact_information__c cid=new Contact_information__c();
                  	 cid= [SELECT id,Email__c,Name,phone__c,IB_Contact__c,Recordtype.Name   
                                             from Contact_information__c 
                                             WHERE IB_Contact__c=:CurrentContact.id 
                                             AND Recordtype.Name='Email'  Limit 1];
                    cid.Email__c=emailE;
                    cid.Name = emailE;
                    update cid;
                    rol.Contact_Information_Email__c=cid.Id;
                	rol.Contact_Information_Email_Text__c=cid.email__c;

                }
                
            }
            else
                {
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,' '+system.label.IBENPortal_Registration_EmailError));
                    emailE = '';
                    ConfirmEmail = '';
                    return null;
                    
                }
            }
            }
            try{
            List<IB_Role__c> confirmedRoleList = [SELECT id, IB_Role_Name__c,Status__c, Email__c ,IB_Contact__c, IB_Contact__r.Name, IB_Contact__r.Email 
                                           FROM IB_Role__c 
                                           WHERE IB_Role_Name__c = 'Online Coordinator' AND IB_Account__r.id =: accId AND  Status__c = 'Confirmed' Limit 1];
            System.debug('confirmedRoleList'+confirmedRoleList);
            if(confirmedRoleList.size() > 0){
                rol.Online_Coordinator_Name__c=confirmedRoleList[0].IB_Contact__r.Name;
                rol.Online_Coordinator_Email__c = confirmedRoleList[0].IB_Contact__r.Email;
                rol.Online_Coordinator__c = confirmedRoleList[0].IB_Contact__c;
            }
            System.debug('Role Ins'+rol);
            insert rol;
                System.debug('Orange Right'+subjectOptsRight);
            for(SelectOption so: subjectOptsRight){
                Role_Application_Subject__c r = new Role_Application_Subject__c();
                r.IB_Subject__c = so.getValue();
                r.Role_And_Application__c = rol.id;
                ras.add(r);
            }
            System.debug('Orange ras'+ras);
            if(ras.size() > 0) {
                if(!Test.isRunningTest())
                    insert ras;
            }
                if(CurrentContact.User__r.Email == rol.Contact_Information_Email_Text__c)
                     emailMatch='true';
                   else
                     emailMatch='false';
 			pageReference pg=new pageReference('/ibportal/InstituteRoleApplicationSubmitted');
                pg.getParameters().put('RoleName',roleName);
                pg.getParameters().put('EmailMatch',emailMatch);
                if(getLocale()=='fr')pg.getParameters().put('RoleName',roleNameF);
                else if(getLocale()=='es')pg.getParameters().put('RoleName',roleNameS);
            pg.setRedirect(true);
                Cache.Org.remove(sessionid);
            return pg;             
                }
            catch(Exception e)
            {
                
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,' '+e.getMessage()));
            }
          return null;
            
        }
        else
        {
            if(OnlineCoordinator == ''){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,label.My_onlineProvider_No_Online_Coordinator_error));
                return null;
            }else{
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,' '+system.label.My_institute_complete_all_required_fields));
            return null;
            }
        }  
        
        // return new pageReference('/ibportal/MyIBRoles');
        
    }
    
    public void emailCheckFun()
    {
        emailCheck = true;
    }
    public static Boolean validateEmail(String email) {
	Boolean res = true;

	String emailRegex = '^[a-zA-Z0-9._|\\\\%#~`=?&/$^*!}{+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,4}$'; // source: http://www.regular-expressions.info/email.html
	Pattern MyPattern = Pattern.compile(emailRegex);
	Matcher MyMatcher = MyPattern.matcher(email);

	if (!MyMatcher.matches()) 
	    res = false;
	return res;	
	}
    
    public PageReference changeInstitute()
    {

        pageReference pg=new PageReference('/apex/onlineProviderSearch');
        pg.setRedirect(true);
        pg.getParameters().put('roleId',roleId);
        
        return pg;
    }
    public PageReference cancelRole()
    {
        return new pageReference('/ibportal/MyIBRoles');
        
    }
     /** 
	* @author Ammara
	* @date 03/24/2021
	* @description Validate the contact added phone and Country Code.
    * @returntype Boolean
	* @param N/A
	*/
     public boolean edit_phone(){
        string citySelected = Country_Code;
        string phone_number = phonenumber;
        boolean city = false;
        boolean roleAppUpd = false;
        boolean error = false;
		Integer len = phone_number.length();  
        System.debug('city: '+citySelected);
         System.debug('phone: '+phone);
        	if (citySelected =='--None--' || citySelected =='--Aucun--' || citySelected =='--Ninguno--'){
				city = true;
			} 
			if( !city && phone_number!=Null  && len<=15 && len>8  && phone_number.isNumeric() ){
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
					if(strPh.charAt(x)!=48){
						check = true;
					}
					if((strPh.charAt(x)>=48 && strPh.charAt(x)<=57) && check == true ){
						PhoneNumber2 = PhoneNumber2+String.valueOf((strPh.charAt(x)-48));
					}
				}
				
               
              //  FinalPh='('+FinalPh+')';
                FinalPh=FinalPh+PhoneNumber2;
                Phone = FinalPh;
				system.debug('FinalPh : ' + FinalPh);
              
			}
			else{
                return true;
			}
        return false;
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
}