public without sharing class IBPortalEditProfileController {
    
    private IBPortalSettingsUtil util;
    public User user {get;private set;}
    public Contact con {get;private set;} 
    public String birthDateString {get; set;}
    public List<IB_Role__c> teacherSchoolAffiliations {get;set;}
    public List<IB_Role__c> roleapps {get;set;}
    public String removeRoleId {get;set;}
    public String oldPassword {get;set;}
    public String newPassword {get;set;}
    public String verifyNewPassword {get;set;}
    public Boolean isIben {get;set;}
    private Set<String> allowedFileExt = new Set<String> {'.doc','.docx','.pdf','.rtf','.wpd','.wp','.wp7','.wp6','.wp5','.wp4','.txt','.text','.jpg','.jpeg','.png','.zip'};
        
        public static final Integer MAX_FILE_SIZE_FOR_UPLOAD = 5000000;
    public List<areaOfInterest> areaOfInterestList {get; set;}
    public List<mypAreaOfInterest> mypAreaOfInterestList {get; set;}
    Map<String, String> mypAreaOfInterestListvalue = new Map<String, String>();
    Map<String, String> areaOfInterestListValue = new Map<String, String>();
    public List<String> areaOfInterestListString {get; set;}
    public Boolean hasPYPTeacherRole {get; set;}
    public Boolean hasMYPTeacherRole {get; set;}
    public list<string> selectedPypInterestArea{get;set;}
    public static final String CV_DESCRIPTION = '**CV**';
    public static final String ANNUALRELEASE_DESCRIPTION = '**TERMS&CONDITIONS - Head of School Annual Release **';
    public static final String sampleunitplanner_DESCRIPTION = '**sample unit planner**';
    public static final String curriculumcourseoverview_DESCRIPTION = '**curriculum course overview**';
    public string userLang {set;get;}
    public string testS {set;get;}
    //below line are added by developer Abd Ur Rehamn on 16-8-2020 as part of CR11890
    //start
    public static boolean error {set;get;}
    public static boolean error1{set; get;}
    public String citySelected {get;set;}
    public String phone_number {get;set;}
    public String birthDate_Format{get;set;}
    
    public String pb2Rendered{get;set;} // added by kashyap
    public Boolean isIBENConfirmed{get;set;}// added by kashyap
    //end
    //Following code block is added by Ammara-Plumlogix of SA in US12131,US1232 on 1/7/2021
    //Start
    public List<SelectOption> ContactQualifications{get;set;}
    public List<SelectOption> Salutation{get;set;}
    public List<SelectOption> getQualifications() {
        List<SelectOption> options = new List<SelectOption>();
        Schema.DescribeFieldResult fieldResult = Contact.Qualifications__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        
        for( Schema.PicklistEntry f : ple){
            system.debug('labels = ' + f.getLabel() + ',' +  f.getValue() );
            if(contactObject.Qualifications__c == null){
                if(f.getLabel() != '----------')
                    options.add(new SelectOption(f.getValue() , f.getLabel()));
            }else if(f.getLabel() != '----------' && !contactObject.Qualifications__c.contains(f.getValue()))
                options.add(new SelectOption(f.getValue() , f.getLabel()));
        }
        SelectOptionSorter.doSort(options, SelectOptionSorter.FieldToSort.Label);
        return options;
    }
    //End
    @TestVisible private FileWrapper cvDoc;
    
    public FileWrapper getCvDoc()  { 
        return this.cvDoc;
    }
    
    private FileWrapper annualRelease;
    
   
    public void actionSupportOnCountryChange(){
        pb2Rendered = 'true';
            
    }
    
    public FileWrapper getAnnualReleaseDoc(){
        return this.annualRelease;
    }
    
    
    private FileWrapper sampleunitplannerDoc;
    
    public FileWrapper getsampleunitplannerDoc()  { 
        return this.sampleunitplannerDoc;
    }
    
    private FileWrapper curriculumcourseoverviewDoc;
    
    public FileWrapper getcurriculumcourseoverviewDoc()  { 
        return this.curriculumcourseoverviewDoc;
    }
    
    private final Contact contactObject;
    
    public List<String> errorMessages {
        get {
            if(errorMessages == null){
                errorMessages = new List<String>();
            }
            return errorMessages;
        }
        set;
    }
    
    public Integer errorCount {
        get {
            if(errorCount == null){
                errorCount = 0;
            }
            return errorCount;
        }
        set;
    }
    // public Boolean showFields {set;get;}
    public IBPortalEditProfileController() {
        //  showFields = false;
        
        pb2Rendered = 'false';
        isIBENConfirmed= false;
        error = true;
        error1 = true;
        hasPYPTeacherRole=false;
        hasMYPTeacherRole=false;
        mypAreaOfInterestList= new list<mypAreaOfInterest>();
        Schema.DescribeFieldResult obj2FieldDescribe = Contact.MYP_Interest_Areas__c.getDescribe();
        List<Schema.PicklistEntry> lstMypPickListValues  = obj2FieldDescribe.getPickListValues();
        for (Schema.PicklistEntry mypSubjects : lstMypPickListValues) {
            mypAreaOfInterestList.add(new mypAreaOfInterest(mypSubjects.getLabel(),false));
            mypAreaOfInterestListvalue.put(mypSubjects.getLabel(),mypSubjects.getValue());       
        } 
        areaOfInterestList= new list<areaOfInterest>();
        Schema.DescribeFieldResult objFieldDescribe = Contact.PYP_Interest_Areas__c.getDescribe();
        List<Schema.PicklistEntry> lstPickListValues  = objFieldDescribe.getPickListValues();
        for (Schema.PicklistEntry pypSubject : lstPickListValues) {
            areaOfInterestList.add(new areaOfInterest(pypSubject.getLabel(),false));
            areaOfInterestListValue.put(pypSubject.getLabel(),pypSubject.getValue());
        } 
        system.debug('error = ' + error);
        system.debug('error1 =' + error1);
        util = IBPortalSettingsUtil.getInstance();
        user = UserDAO.INSTANCE.getUserById(Userinfo.getUserId());
        isIben = false;
        teacherSchoolAffiliations = new List<IB_Role__c>();
        ContactService.setContactId(user.ContactId);   
        try {
            con = ContactService.getContact();
            
        } catch (Exception e){
            con = new Contact();
        }
        
        countryInfo.add(new SelectOption('', Label.IB_RoleApp_Subject_None));
        
        for (IB_Country_Segmentation__c country : IBCountrySegmentationDAO.INSTANCE.getAll()) {
            if (UserInfo.getLanguage() == 'fr') {
                if (country.country_fr__c == null) {
                    this.countryInfo.add(new SelectOption(country.id, country.name));
                }else {
                    this.countryInfo.add(new SelectOption(country.id, country.country_fr__c));
                }
            } else if (UserInfo.getLanguage() == 'es') {
                if (country.country_es__c == null) {
                    this.countryInfo.add(new SelectOption(country.id, country.name));
                } else {
                    this.countryInfo.add(new SelectOption(country.id, country.country_es__c));
                }
            } else {
                this.countryInfo.add(new SelectOption(country.id, country.name));
            }
        }
        
        if (null == user.ContactId ) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING , Label.IBENPortal_Error_ContactNotFound));
        } else {
            this.contactObject = MyContactDAO.INSTANCE.getContactbyId(user.ContactId);  
        }
        
        roleapps = getActiveIbRoles(user.ContactId);
        for(IB_Role__c r:roleapps){
            if(r.IB_Account__c != null && r.IB_Role__r.Display_in_MyIB__c == true)
                teacherSchoolAffiliations.add(r);
            if(r.Role_Type__c == 'IBEN Role'){
                isIben = true;
            	isIBENConfirmed = true;
            }
            
        }
        
        if(isIben == false){
            for(IB_Role__c r:getAllApplicantIBRoles(user.ContactId)){
                if(r.Role_Type__c == 'IBEN Role')
                    isIben = true;
            }
            
        }
        //  this code is edited by developer Ali Haider Bajwa-PlumLogix for ecm 465 of cr project
        //  start
        // ecm 465-465fix
      
        try
        {
            list<IB_Role__c> rolList=new list<IB_Role__c>();
            rolList=[Select name,Programme_Selection__c from IB_Role__c where (Programme_Selection__c='PYP' OR Programme_Selection__c='MYP') and IB_Contact__r.Id=: user.ContactId and IB_Role_Name__c='Teacher' and status__c ='Confirmed'];
            if(rolList.size()>0)
            {
                for(IB_Role__c rol : rolList)
                {
                    if(rol.Programme_Selection__c=='PYP')
                    {
                        hasPYPTeacherRole=true;
                    }
                    if(rol.Programme_Selection__c=='MYP')
                    {
                        hasMYPTeacherRole=true;
                    }
                }
            }
            
            List<String> rightoption=new list<String>();
            if(this.contactObject.PYP_Interest_Areas__c!=NULL)
                rightoption = this.contactObject.PYP_Interest_Areas__c.split(';',20);
            selectedPypInterestArea=new List<String>();
            for(areaOfInterest subject : areaOfInterestList)
            {
                for(String selectedSubject : rightoption)
                {
                    if(subject.str == selectedSubject)
                        subject.selected=true;
                }
                
            }
            
            
            
            
            List<String> MYPrightoption=new list<string>();
            if(this.contactObject.MYP_Interest_Areas__c!=NULL)
                MYPrightoption = this.contactObject.MYP_Interest_Areas__c.split(';',20);
            for(mypAreaOfInterest subject : mypAreaOfInterestList)
            {
                for(String selectedSubject : MYPrightoption)
                {
                    if(subject.str == selectedSubject)
                        subject.selected=true;
                }
                
                
                
            }  
        }
        Catch(Exception x)
        {
            System.debug('Exception: '+x);
        }
        //end
        //Following code block is added by Ammara-Plumlogix of SA in US12131,US1232 on 1/7/2021
        //Start
        
        Salutation = new List<SelectOption>();
        Schema.DescribeFieldResult fieldResult = Contact.Salutation.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        Salutation.add(new SelectOption('' , '- '+Label.IBENPortal_Global_None+' -'));
        for( Schema.PicklistEntry f : ple){
            system.debug('labels = ' + f.getLabel() + ',' +  f.getValue() );
            if(f.getLabel() != '-')
                Salutation.add(new SelectOption(f.getValue() , f.getLabel()));
        }
        ContactQualifications = new List<SelectOption>();
        System.debug('****Qualification****');
        if(contactObject.Qualifications__c != null){
            List<String> Qualificationitems = contactObject.Qualifications__c.split(';');
            Schema.DescribeFieldResult fieldResult2 = Contact.Qualifications__c.getDescribe();
            List<Schema.PicklistEntry> ple2 = fieldResult2.getPicklistValues();
            for(Schema.PicklistEntry f : ple2){
                for(String s : Qualificationitems){
                    if(f.getValue() == s && f.getLabel() != '----------')
                        ContactQualifications.add(new SelectOption(f.getValue() , f.getLabel()));
                }
            }
            SelectOptionSorter.doSort(ContactQualifications, SelectOptionSorter.FieldToSort.Label);
        }
        System.debug('****Test: '+ContactQualifications);
        //End
        this.cvDoc = new FileWrapper();
        this.cvDoc.description = CV_DESCRIPTION;
        
        this.sampleunitplannerDoc = new FileWrapper();
        this.sampleunitplannerDoc.description = sampleunitplanner_DESCRIPTION;
        
        this.curriculumcourseoverviewDoc= new FileWrapper();
        this.curriculumcourseoverviewDoc.description = curriculumcourseoverview_DESCRIPTION;
        
        this.annualRelease = new FileWrapper();
        this.annualRelease.description = ANNUALRELEASE_DESCRIPTION;
        
        birthDate_Format = dateFormatting();
        
        
    }
    
    private List <SelectOption> countryInfo = new List<SelectOption>();
    
    public List<SelectOption> getCountryInfo() {
        return this.countryInfo;
    }
    //Following code snippet is added by Plumlogix for ECM-00388 part 2 related to Sprint 22-3
    //Begin
    public String dateFormatting()
    {
        DateTime dt = contactObject.Birthdate ;
        String dateformat;
        if (UserInfo.getLanguage() == 'fr' || UserInfo.getLanguage() == 'es'){
            dateformat = dt.format('MM/dd/yyyy');
        } else {
            dateformat = dt.format('dd/MM/yyyy');
        }
        return dateformat;
    }
    //END
    /*  public void editPhoneBoolean()//====================
{
showFields = true;
//return null;
} */
    
    public String getLocale() {
        return UserInfo.getLanguage();
    }
    
    public PageReference isLoggedIn() {
        if (UserInfo.getUserType() == 'Guest') {
           // return new PageReference('/ibportal/IBPortalLogin');
        	return null;
        }
        else {
            return null;
        }
        
    }
    
    private List<IB_Role__c> getAllApplicantIBRoles(string contactId){
        return [SELECT Id, IB_Account__c, Role_Type__c, IB_Role_Name__c,IB_Role_Name_Es__c, IB_Role_Name_FR__c, Status__c, Account_Name__c, Programme_Selection__c, Programme_Selection_ES__c, Programme_Selection_FR__c, IB_Role__r.Display_in_MyIB__c  
                FROM IB_Role__c 
                WHERE IB_Contact__c = :contactId 
                AND (End_Date__c = null OR End_Date__c > TODAY)
                AND Status__c = 'Applicant'];
    }
    
    private List<IB_Role__c> getActiveIbRoles(string contactId){
        return [SELECT Id, IB_Account__c, Role_Type__c, IB_Role_Name__c, IB_Role_Name_Es__c, IB_Role_Name_FR__c, Status__c, Account_Name__c, Programme_Selection__c, Programme_Selection_ES__c, Programme_Selection_FR__c, IB_Role__r.Display_in_MyIB__c  
                FROM IB_Role__c 
                WHERE IB_Contact__c = :contactId 
                AND (End_Date__c = null OR End_Date__c > TODAY)
                AND Status__c = 'Confirmed'];
    }
    
    public Contact getContactObject() {
        return this.contactObject;
    }
    
    public PageReference changePassword(){
        system.debug('error1 = ' + error1 );
        error1 = true;
        system.debug('error1 = ' + error1);
        return Site.changePassword(newPassword,verifyNewPassword,oldPassword);
    }
    
    public PageReference saveProfile() {
        try{
            //  this code is edited by developer Ali Haider Bajwa-PlumLogix for ecm 465 of cr project
            //  start
            list<String> selectedAreaOfInterest = new List<string>();
            list<String> mypselectedAreaOfInterest = new List<string>();
            String pypInterestArea='';
            if(areaOfInterestList!=Null)
            {
                for(areaOfInterest Obj : areaOfInterestList) {
                    if(Obj.selected == true) {
                        selectedAreaOfInterest.add(Obj.str);
                    }
                }
                for(String so:selectedAreaOfInterest){
                    pypInterestArea = pypInterestArea + ';' + areaOfInterestListValue.get(so);
                }
                this.contactObject.PYP_Interest_Areas__c=pypInterestArea;
                update this.contactObject;
            }
            String mypInterestArea='';
            if(mypAreaOfInterestList!=Null)
            {
                for(mypAreaOfInterest Obj : mypAreaOfInterestList) {
                    if(Obj.selected == true) {
                        mypselectedAreaOfInterest.add(Obj.str);
                    }
                }
                for(String so:mypselectedAreaOfInterest){
                    mypInterestArea = mypInterestArea + ';' + mypAreaOfInterestListvalue.get(so);
                }   
                this.contactObject.MYP_Interest_Areas__c=mypInterestArea;
                update this.contactObject;
            }
            //end
            System.debug(birthdatestring);
            if (birthDateString != null && birthDateString != '') {
                birthDateString = birthDateString.removeEnd('.000Z');
                birthDateString = birthDateString.replace('T', ' ');
                contactObject.Birthdate = Date.valueOf(Datetime.valueOfGMT(birthDateString));
                contactObject.Birthdate = Date.newInstance(contactObject.Birthdate.day(), contactObject.Birthdate.month(), contactObject.Birthdate.year());
            }
            
            //Following code block is added by Ammara-Plumlogix of SA in US12131,US1232 on 1/7/2021
            //Start
            String s='';
            for(SelectOption so : ContactQualifications){
                s = s + so.getValue()+';';
            }
            contactObject.Qualifications__c = s;
            System.debug('****set: '+s);
            //End
            
            // Following code is added by Umair-Plumlogix of SA Project of US12186 on 3/22/2021
            // Start
            if(contactObject.Country_Code__c != Null && contactObject.Phone_Number__c!= Null)
            {                
                PhoneValidation phone_validation = new PhoneValidation();
                Boolean temp = phone_validation.edit_phone(contactObject);
                Integer charLength = contactObject.Phone_Number__c.length();
                if(charLength<4 || charLength>15 || temp==true)
                {
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Info,Label.Phone_Format_Error));
                    // ApexPages.addmessage(Label.Phone_Format);
                    return null;
                }
                else
                {
                    update this.contactObject;
                }
                
            }
            else
            {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Info,Label.Phone_Format_Instruction));
                // ApexPages.addmessage(Label.Phone_Format);
                return null;
            }
            //End
            String firstNameStr;
            if( contactObject.FirstName != null)
            {
                firstNamestr = ContactObject.FirstName.substring(0,1 ) + '%';
                //            firstNameStr.add( contactObject.FirstName.substring(0,1) + '%' );
            }    
            system.debug('This is first initial' + firstNamestr);        
            List<contact>  dupCheck = new List<Contact>(); 
            //Following Query is updated by Umair-Plumlogix of SA of US11866 on 4/15/2020
            //Start
            User u = [SELECT ID,LanguageLocaleKey, Name, Profile.Name,Bypass_Validation_Rules__c, Profile.UserLicense.Name from User where ID = :userinfo.getUserId() LIMIT 1];
            //End
            system.debug('This is gold partner' + u.Profile.UserLicense.Name);
            if( u.Profile.UserLicense.Name != 'Gold Partner')
            {
                dupCheck = [SELECT ID, FirstName from contact where  ID IN (Select contactID from user where  User.Profile.UserLicense.Name != 'Gold Partner'  )  AND ( FirstName  like :firstNamestr AND LastName = : contactObject.LastName) AND ( Email  = :contactObject.Email  OR (  ( Alternative_Email__c =: contactObject.Alternative_Email__c OR Email  = :contactObject.Alternative_Email__c OR Alternative_Email__c = :contactObject.Email  ) AND Alternative_Email__c != NULL )  )    AND ID != :contactObject.ID order by createdDate  asc ];        
                system.debug('This is first Condition' + dupCheck);
                if( dupCheck.isEmpty()   )
                {
                    
                    dupCheck = [SELECT ID, FirstName from contact where ID IN (Select contactID from user where  User.Profile.UserLicense.Name != 'Gold Partner'  )  AND   (Birthdate = :contactObject.Birthdate AND Birth_Locale__c = :contactObject.Birth_Locale__c AND Birthdate != null AND Birth_Locale__c != null) AND  ( Email  = :contactObject.Email OR (  Email  = :contactObject.Alternative_Email__c  AND Alternative_Email__c != NULL ))     AND ID != :contactObject.ID order by createdDate  asc ];        
                    system.debug('This is dupCheck Records 2nd '+ dupCheck);
                }
                // Alternate Email
                
                if( dupCheck.isEmpty()   )
                {
                    
                    dupCheck = [SELECT ID, FirstName from contact where ID IN (Select contactID from user where  User.Profile.UserLicense.Name != 'Gold Partner'  )  AND   (Birthdate = :contactObject.Birthdate AND Birth_Locale__c = :contactObject.Birth_Locale__c AND Birthdate != null AND Birth_Locale__c != null) AND ( (  Alternative_Email__c =:contactObject.Alternative_Email__c OR  Alternative_Email__c = :contactObject.Email)  AND Alternative_Email__c  != NULL)   AND ID != :contactObject.ID order by createdDate  asc ];        
                    system.debug('This is dupCheck Records 3rd '+ dupCheck);
                }
                
                if( dupCheck.isEmpty()  )
                {    
                    
                    // system.debug('The value of Birth Locale ' + BirthdateList==null + ' This is Boolean : ' + BirthLocaleStr.isEmpty());
                    dupCheck = [SELECT ID, FirstName from contact where ID IN (Select contactID from user where  User.Profile.UserLicense.Name != 'Gold Partner'  )  AND  
                                ( ( FirstName  like :firstNamestr AND LastName = : contactObject.LastName AND Birthdate = :contactObject.Birthdate AND Birthdate != null AND Birth_Locale__c  = :  contactObject.Birth_Locale__c AND Birth_Locale__c != null) 
                                 OR ( FirstName  like :firstNamestr AND LastName = : contactObject.LastName AND  Alternative_Email__c!= null AND Alternative_Email__c =:contactObject.Alternative_Email__c ) 
                                 OR ( FirstName  like :firstNamestr AND LastName = : contactObject.LastName AND Alternative_Email__c!= null  AND Alternative_Email__c = :contactObject.Email ) )  AND ID != : contactObject.ID order by createdDate  asc ];
                    //     system.debug('Values are ::'+FirstNameStr+' :' +LastNameStr +' : '+ BirthdateList +' : '+ BirthLocaleStr);
                }
                system.debug('This is curretn obkect ID' + ContactObject.ID);
                system.debug('This is dupCheck Records  '+ dupCheck);
            }    
            if( !dupCheck.isEmpty() )
            {
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Info,Label.MyIB_ExistingDuplicateContact);
                ApexPages.addMessage(myMsg);
                throw new IBPortalValidationUtilException (Label.MyIB_ExistingDuplicateContact);
                //         throw new IBPortalValidationUtilException ('There is existing duplicate contact record found in the system.');
                
            }
            else
            {
                /*
system.debug('This is Country__r.Name' + contactObject.Country__r.Name);
if( contactObject.Country__r.Name == '--None--' )
{           
this.contactObject.Country__c = NULL;
}
*/ 
                //Following code block is added by Umair-Plumlogix of SA in US11866 on 4/21/2020
                //Start
                if(userLang == 'English')
                    userLang = 'en_US';
                else if(userLang == 'Spanish')
                    userLang ='es';
                else if(userLang == 'French')
                    userLang='fr';
                
                u.LanguageLocaleKey = userLang;
                update u;
                update this.contactObject;
                //End
            }
            
            
            
            
            /*
contact tempContact = new contact();
tempContact = [ SELECT User__c, ID from Contact where ID = :contactObject.ID LIMIT 1 ];
User updateUser = new User();
if ( tempContact != NULL )
{
updateUser = [ SELECT firstName, LastName, ID from User where ID= :tempContact.User__c  LIMIT 1];
if( updateUser != NULL)
{
updateUser.FirstName = contactObject.FirstName;
updateUser.LastName = contactObject.LastName;                    
update updateUser;
}
}
*/
            PageReference pg = new PageReference('/ibportal');
            errorCount = errorMessages.size();
            return pg;
        }catch(Exception e){
            //    ApexPages.addMessages(e);
            //          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage()));
            //system.debug('$$$$'+e.getMessage());
            
            errorMessages.clear();
            errorMessages.add(e.getMessage());
            errorMessages.add('This is message' + e.getMessage());
            
            errorCount = errorMessages.size();
            
            return null;  
        }
    }
    public PageReference removeRole (){
        IB_Role__c r = new IB_Role__c();
        r.Id = removeRoleId;
        r.End_Date__c = Date.today();
        r.Status__c = 'Withdrawn';
        update r;
        PageReference pageRef = Page.IBPortalEditProfile;
        pageRef.setRedirect(true);
        return pageRef;
    }
    
    @RemoteAction
    public static List<String> lookupSchoolAccountWithIBIS(String searchTerm) {
        system.debug('#### lookupSchoolAccount called : '+searchTerm);
        RecordType RecType = [SELECT Id, Name FROM RecordType WHERE SobjectType = 'Account' AND DeveloperName = 'School_Account'];
        List<Account> accountList = Database.query('SELECT Id, Name, IBIS_ID__c FROM Account WHERE RecordTypeId = \'' + RecType.Id + '\' AND Name LIKE \'%' + String.escapeSingleQuotes(searchTerm) + '%\'');
        List<String> accounts = new List<String>();
        for (Account x : accountList) {
            accounts.add(x.Name+':'+x.IBIS_ID__c);
        }
        return accounts;
        
    }
    
    @RemoteAction
    public static List<String> lookupSchoolAccountByNameMulti(String searchTerm) {
        system.debug('#### searchTerm : '+searchTerm);
        string accName = searchTerm.split(':')[0];
        string ibis = searchTerm.split(':')[1];
        
        RecordType RecType = [SELECT Id, Name FROM RecordType WHERE SobjectType = 'Account' AND DeveloperName = 'School_Account'];
        //List<Account> accountList = Database.query('SELECT Id, Name, IBIS_ID__c FROM Account WHERE RecordTypeId = \'' + RecType.Id + '\' AND Name = \'' + String.escapeSingleQuotes(searchTerm) + '\'');
        List<Account> accountList = Database.query('SELECT Id, Name, IBIS_ID__c FROM Account WHERE RecordTypeId = \'' + RecType.Id + '\' AND Name = \'' + String.escapeSingleQuotes(accName) + '\' AND IBIS_ID__c = \'' + String.escapeSingleQuotes(ibis) + '\'');
        
        //return accountList[0].IBIS_ID__c;
        List<String> accounts = new List<String>();
        for (Account x : accountList) {
            accounts.add(x.IBIS_ID__c);
        }
        return accounts;
    }    
    
    public class FileWrapper {
        public transient Blob body { get; set; }
        public transient String name { get; set; }
        public transient Integer size { get; set; }
        public transient String contentType { get; set; }
        public String description { get; set; }
        public String base64 {get; set;}
    }
    
    private void addAttachmentToObject (FileWrapper file, String objectId) {
        
        if ( null != file && null != file.body) {
            
            if (file.size > MAX_FILE_SIZE_FOR_UPLOAD) {
                throw new ControllerException(Label.IBENPortal_Error_FileSizeLimit + ' ' + file.Name );
            }
            Boolean badFile = true;
            for( String ext : allowedFileExt) {
                if( file.name.endsWith(ext) ) {
                    badFile = false;
                    break;
                }
            }
            if( badFile ) {
                throw new ControllerException(Label.Profile_File_Upload_Error + ' ' + file.Name );
            }
            
            for (Attachment attach : attachments) {
                
                if(attach.Description != null){
                    if (attach.Description.equals(file.description)) {
                        delete attach;
                        break;
                    }
                } 
            }
            insert new Attachment ( body= file.body , Name=file.name, ContentType = file.ContentType, parentId = objectId, description = file.description );
        }
    }
    public List<Attachment> attachments {
        
        get {
            
            if (null == attachments) {
                attachments = AttachmentsDAO.INSTANCE.getAttachmentsbyParentId(contactObject.Id);
            }
            
            return attachments;
        }
        private set; 
    }
    
    public void removeAttachment() {
        try {
            
            delete AttachmentsDAO.INSTANCE.getAttachmentsbyId(remAttachId);
            attachments = null;
            
        } catch (Exception ex) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, Label.IBENPortal_Error_AttachmentDeleted + ex.getMessage()));
        }  
    }
    
    public String remAttachId { 
        
        get;set;
        
    }
    
    public PageReference uploadAttachments() {
        error = true; 
        PageReference page = ApexPages.currentPage();
        
        try {
            addAttachmentToObject (cvDoc, contactObject.Id);
            addAttachmentToObject (sampleunitplannerDoc, contactObject.Id);
            addAttachmentToObject (curriculumcourseoverviewDoc, contactObject.Id);
            addAttachmentToObject (annualRelease, contactObject.Id);     
            
            attachments = null;
            ApexPages.getMessages().clear();
            
            page.setRedirect(true);
            
        } catch (System.DmlException e) {
            for (Integer i = 0; i < e.getNumDml(); i++) {
                ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Info,e.getDmlMessage(i))); 
                system.debug(loggingLevel.ERROR,e.getDmlMessage(i));
                page.setRedirect(false);
            }
            
        }  catch (Exception ex) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info,  + Label.IBENPortal_Error_ProfileUpdateReason + ex.getMessage()));
            system.debug(loggingLevel.ERROR,Label.IBENPortal_Error_ProfileUpdateReason + ex.getMessage());
            page.setRedirect(false);
        }
        
        return null;
        
    }
    
    public Id getIbTeachingExperienceRecordId() {
        RecordType rt = RecordTypeService.getRecordTypeByTypeAndName('IB_E_Background__c','IB_Teaching_Experience');
        return rt.Id;
    }
    
    public Id getIbTrainingsAttendedRecordId() {
        RecordType rt = RecordTypeService.getRecordTypeByTypeAndName('IB_E_Background__c','IB_Trainings_Attended');
        return rt.Id;
    }
    
    public Id getConferenceExperienceRecordId() {
        RecordType rt = RecordTypeService.getRecordTypeByTypeAndName('IB_E_Background__c','IB_Conference_Experience');
        return rt.Id;
    }
    
    public Id getNationalEducationKnowledgeRecordId() {
        RecordType rt = RecordTypeService.getRecordTypeByTypeAndName('IB_E_Background__c','National_Education_Working_Knowledge');
        return rt.Id;
    }
    
    public Id getGeneralTeachingExperianceRecordId() {
        RecordType rt = RecordTypeService.getRecordTypeByTypeAndName('IB_E_Background__c','General_Teaching_Experience');
        return rt.Id;
    }
    
    public Id getEducationalDegreesRecordId() {
        RecordType rt = RecordTypeService.getRecordTypeByTypeAndName('IB_E_Background__c','Educational_Degrees');
        return rt.Id;
    }
    
    public Id getLanguageExperienceRecordId() {
        RecordType rt = RecordTypeService.getRecordTypeByTypeAndName('IB_E_Background__c','Language_Experience');
        return rt.Id;
    }
    
    public Id getAccreditationKnoweledgeRecordId() {
        RecordType rt = RecordTypeService.getRecordTypeByTypeAndName('IB_E_Background__c','Accreditation_Knowledge');
        return rt.Id;
    }
    
    public Id getPublicationsRecordId() {
        RecordType rt = RecordTypeService.getRecordTypeByTypeAndName('IB_E_Background__c','Publications');
        return rt.Id;
    }
    
    public String getPageUrl() {
        return ApexPages.currentPage().getUrl();     
    }
    
    public class IBPortalValidationUtilException extends Exception {}
    public class IBPortalValidationUtilPossibleAccountException extends Exception {}
    public class IBPortalValidationUtilDuplicateSchoolEmailException extends Exception {}
    //Following code block is added by Umair-Plumlogix of SA in US11866 on 4/21/2020
    //Start
    public List<SelectOption> getLanguageInfo(){
        List<SelectOption> options = new List<SelectOption>();
        
        User testUser = [select LanguageLocaleKey from user where id=:userinfo.getuserid()];
        testS = testUser.LanguageLocaleKey;
        if (testS == 'en_US')
        {
            options.add(new SelectOption('English','English'));
            options.add(new SelectOption('Spanish','Spanish'));
            options.add(new SelectOption('French','French'));
        }
        else if (testS == 'es')
        {
            options.add(new SelectOption('Spanish','Spanish'));
            options.add(new SelectOption('English','English'));
            options.add(new SelectOption('French','French'));
        }
        else if (testS == 'fr')
        {
            options.add(new SelectOption('French','French'));
            options.add(new SelectOption('Spanish','Spanish'));
            options.add(new SelectOption('English','English'));
        }
        
        
        return options;
    }
    //  this code is edited by developer Ali Haider Bajwa-PlumLogix for ecm 465 of cr project
    //  start -->
    public class areaOfInterest {
        public String Str {get; set;}
        public Boolean selected {get; set;}
        
        public areaOfInterest(String a, Boolean bool) {
            Str = a;
            selected = bool;
        }
        public areaOfInterest() {
            
        }
    }
    public class mypAreaOfInterest {
        public String Str {get; set;}
        public Boolean selected {get; set;}
        
        public mypAreaOfInterest(String a, Boolean bool) {
            Str = a;
            selected = bool;
        }
        public mypAreaOfInterest() {
            
        }
    }
    //End
    //End
}