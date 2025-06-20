/**
 * If you run into errors and need to clear the data, heres a script to run in anonymous apex:

List<Translation__c> translationsCreatedByMe = ([SELECT Id FROM Translation__c WHERE CreatedDate = TODAY AND CreatedById = :UserInfo.getUserId()]);
delete translationsCreatedByMe;

List<CustomLabel__c> customLabelsCreatedByMe = ([SELECT Id FROM CustomLabel__c WHERE CreatedDate = TODAY AND CreatedById = :UserInfo.getUserId()]);
delete customLabelsCreatedByMe;

List<Custom_Label_Project__c> projectLabelsCreatedByMe = ([SELECT Id FROM Custom_Label_Project__c WHERE CreatedDate = TODAY AND CreatedById = :UserInfo.getUserId()]);
delete projectLabelsCreatedByMe;

List<Lead> leadsCreatedByMe = ([SELECT Id FROM Lead WHERE CreatedDate = TODAY AND CreatedById = :UserInfo.getUserId()]);
delete leadsCreatedByMe;

List<IB_Role__c> rolesAndAppsCreatedByMe = ([SELECT Id FROM IB_Role__c WHERE CreatedDate = TODAY AND CreatedById = :UserInfo.getUserId()]);
delete rolesAndAppsCreatedByMe;

List<IB_Programme__c> programmesCreatedByMe = ([SELECT Id FROM IB_Programme__c WHERE CreatedDate = TODAY AND CreatedById = :UserInfo.getUserId()]);
delete programmesCreatedByMe;

List<Contact> contactsCreatedByMe = ([SELECT Id FROM Contact WHERE CreatedDate = TODAY AND CreatedById = :UserInfo.getUserId()]);
delete contactsCreatedByMe;

List<Account> accountsCreatedByMe = ([SELECT Id FROM Account WHERE CreatedDate = TODAY AND CreatedById = :UserInfo.getUserId()]);
delete accountsCreatedByMe;

List<IB_Application__c> ibApplicationsCreatedByMe = ([SELECT Id FROM IB_Application__c WHERE CreatedDate = TODAY AND CreatedById = :UserInfo.getUserId()]);
delete ibApplicationsCreatedByMe;

List<IB_Role_Repository__c> ibRoleRepositoryCreatedByMe = ([SELECT Id FROM IB_Role_Repository__c WHERE CreatedDate = TODAY AND CreatedById = :UserInfo.getUserId()]);
delete ibRoleRepositoryCreatedByMe;

List<IB_Country_Segmentation__c> countrySegmentationreatedByMe = ([SELECT Id FROM IB_Country_Segmentation__c WHERE CreatedDate = TODAY AND CreatedById = :UserInfo.getUserId()]);
delete countrySegmentationreatedByMe;

List<IB_Address__c> addressCreatedByMe = ([SELECT Id FROM IB_Address__c WHERE CreatedDate = TODAY AND CreatedById = :UserInfo.getUserId()]);
delete addressCreatedByMe;

 */

global with sharing class PostSandboxGeneration implements SandboxPostCopy{
    
    global PostSandboxGeneration(){}
    
    global void runApexClass(SandboxContext context) {
        System.debug('Org ID: ' + context.organizationId());
        System.debug('Sandbox ID: ' + context.sandboxId());
        System.debug('Sandbox Name: ' + context.sandboxName());
        
        // Insert logic here to prepare the sandbox for use.
        mainFunction();
    }
    
    public static void mainFunction()
    {
        List<Custom_Label_Project__c> projectLabels = createCustomLabelProjects();
        insert projectLabels;
        
        List<CustomLabel__c> customLabels = createCustomLabels();
        insert customLabels;
        
        List<Translation__c> translations = createTranslations();
        insert translations;
        
        // Starts the chain of queueables
        System.enqueueJob(new PostSandboxGenerationQueueable1());
    }
    
    // ##### Leads
    
    public static List<Lead> createLeads(Integer numOfLeads, String recordType)
    {
        List<Lead> tempLeads = new List<Lead>();
        
        for(Integer i = 0; i < numOfLeads; i++)
        {
            Lead temp = new Lead();
            tempLeads.add(createLeadInstance(temp, Schema.SObjectType.Lead.getRecordTypeInfosByName().get(recordType).getRecordTypeId()));
        }
        
        return tempLeads;
    }
    
    
    public static Lead createLeadInstance(Lead leadRecord, String recordTypeId) {
        
        String DEFAULT_LEAD_SOURCE = 'Sales Development - Inbound';
        String DEFAULT_COMPANY = 'TestCompany';
        String DEFAULT_COUNTRY = 'United States';
        String DEFAULT_STATE = 'Florida';
        String DEFAULT_REGION = 'IBA';
        String DEFAULT_SUB_REGION = 'NORTHERN AMERICA';
        String DEFAULT_STATUS = 'Open';
        Boolean DEFAULT_PYP_INTEREST = true;
        String DEFAULT_POSITION_WITH_SCHOOL = 'Teacher';
        
        Lead leadInstance = leadRecord;
        
        leadInstance.FirstName = String.isBlank(leadInstance.FirstName) ? generateRandomString(5) : leadRecord.FirstName;
        leadInstance.LastName = String.isBlank(leadInstance.LastName) ? generateRandomString(5) : leadRecord.LastName;
        leadInstance.LeadSource = String.isBlank(leadInstance.LeadSource) ? DEFAULT_LEAD_SOURCE : leadRecord.LeadSource;
        leadInstance.Company = String.isBlank(leadInstance.Company) ? DEFAULT_COMPANY : leadRecord.Company;
        leadInstance.Email = String.isBlank(leadInstance.Email) ? generateRandomEmail(10, null) : leadRecord.Email;
        leadInstance.Status = String.isBlank(leadInstance.Status) ? DEFAULT_STATUS : leadRecord.Status;
        leadInstance.Country = String.isBlank(leadInstance.Country) ? DEFAULT_COUNTRY : leadRecord.Country;
        leadInstance.State = String.isBlank(leadInstance.State) ? DEFAULT_STATE : leadRecord.State;
        leadInstance.Region__c = String.isBlank(leadInstance.Region__c) ? DEFAULT_REGION : leadRecord.Region__c;
        leadInstance.Sub_Region__c = String.isBlank(leadInstance.Sub_Region__c) ? DEFAULT_SUB_REGION : leadRecord.Sub_Region__c;
        leadInstance.Position_with_School__c = String.isBlank(leadInstance.Position_with_School__c) ? DEFAULT_POSITION_WITH_SCHOOL : leadRecord.Position_with_School__c;
        leadInstance.PYP_Interest__c = DEFAULT_PYP_INTEREST;
        
        return leadInstance;
    }
    
    // ##### Accounts
    
    public static List<Account> createAccounts(Integer numOfAccounts, String recordType)
    {
        List<Account> tempAccounts = new List<Account>();
        
        Id recordTypeId = null;
        if(recordType != null && !String.isBlank(recordType))
        {
            recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(recordType).getRecordTypeId();
        }
        
        for(Integer i = 0; i < numOfAccounts; i++)
        {
            Account temp = new Account();
            
            tempAccounts.add(createAccountInstance(temp, recordTypeId));
        }
        
        return tempAccounts;
    }
    
    public static Account createAccountInstance(Account accountRecord, Id recordTypeId) {
        
        String REGION = 'IBAEM';
        String SUBREGION = 'EUROPE';
        String LANGUAGE = 'English';
        String PRIVATE_VAR = 'Private';
        String USD_CURRENCY = 'USD';
        String WEBSITE = 'https://www.test.org';
        String COUNTRY = 'SWEDEN';
        
        Account accountInstance = accountRecord;
        
        if(recordTypeId != null)
        {
            accountInstance.RecordTypeId = recordTypeId;
        }
        
        System.debug(accountInstance.RecordTypeId);
        
        accountInstance.Name = String.isBlank(accountRecord.Name) ? generateRandomString(5) : accountRecord.Name;
        accountInstance.Region__c = String.isBlank(accountRecord.Region__c) ? REGION : accountRecord.Region__c;
        accountInstance.Sub_region__c = String.isBlank(accountRecord.Sub_region__c) ? SUBREGION : accountRecord.Sub_region__c;
        accountInstance.External_PD_Provider__c = true;
        accountInstance.Language_Of_Correspondance__c = String.isBlank(accountRecord.Language_Of_Correspondance__c) ? LANGUAGE : accountRecord.Language_Of_Correspondance__c;
        accountInstance.Legal_Status__c = String.isBlank(accountRecord.Legal_Status__c) ? PRIVATE_VAR : accountRecord.Legal_Status__c;
        accountInstance.Billing_Currency__c = String.isBlank(accountRecord.Billing_Currency__c) ? USD_CURRENCY : accountRecord.Billing_Currency__c;
        accountInstance.Website = String.isBlank(accountRecord.Website) ? WEBSITE : accountRecord.Website;
        accountInstance.Short_Name__c = accountInstance.Name;
        accountInstance.Country__c = String.isBlank(accountRecord.Country__c) ? COUNTRY : accountRecord.Country__c;
        accountInstance.Lead_Account__c = true;
        
        return accountInstance;
    }
    
    // ##### Contacts
    
    public static List<Contact> createContacts(Integer numOfAccounts, String recordType)
    {
        List<Contact> tempContacts = new List<Contact>();
        
        for(Integer i = 0; i < numOfAccounts; i++)
        {
            Contact temp = new Contact();
            tempContacts.add(createContactInstance(temp, Schema.SObjectType.Contact.getRecordTypeInfosByName().get(recordType).getRecordTypeId()));
        }
        
        return tempContacts;
    }
    
    /**
     * @description - Populates fields of an Contact instance
     * @param contactRecord - the record to populate fields
     * @param recordTypeId - the recordtype id to assign record type to new record
     * @return Contact with populated fields
     */
    public static Contact createContactInstance(Contact contactRecord, String recordTypeId) {
        
        String FIRSTNAME = 'TestFirstName';
        Date BIRTHDATE = Date.today().addDays(-10000);
        
        Contact contactInstance = contactRecord;
        
        contactInstance.FirstName = String.isBlank(contactRecord.FirstName) ? FIRSTNAME : contactRecord.FirstName;
        contactInstance.LastName = String.isBlank(contactRecord.LastName) ? generateRandomString(5) : contactRecord.LastName;
        contactInstance.Email = String.isBlank(contactRecord.Email) ? generateRandomEmail(10, null) : contactRecord.Email;
        contactInstance.Birthdate = String.isBlank(String.valueOf(contactRecord.Birthdate)) ? BIRTHDATE : contactRecord.Birthdate;
        
        return contactInstance;
    }
    
    // ##### IB Role Repository
    
    public static List<IB_Role_Repository__c> createRoleRepository()
    {
        List<IB_Role_Repository__c> tempLIBRoleRepositories = new List<IB_Role_Repository__c>();
        
        tempLIBRoleRepositories.add(new IB_Role_Repository__c(
            Account_Association__c = null,
        Address_Source__c = null,
        Application_Available_in_MyIB__c = false,
        Available__c = false,
        Available_From__c = Date.newInstance(2000, 1, 1),
        Available_in_Region__c = 'School Services',
        Available_To__c = null,
        Bypass_Educator_Background_Rule__c = false,
        Category__c = 'School_Roles',
        Context__c = 'Head_of_School',
        Custom_Application__c = '',
        CV__c = false,
        Display_Confirmed_in_MyIB__c = false,
        Display_in_MyIB__c = false,
        Display_In_PIMS_Community__c = false,
        DOB_Mandatory__c = false,
        External_Role_ID__c = null,
        External_Role_Type__c = 'IBEN_Roles',
        IB_Staff_Role__c = false,
        Letter_of_Agreement__c = false,
        Letter_of_Reference__c = false,
        MyIB_Has_Subjects__c = false,
        MyIB_Has_Workshop_Titles__c = false,
        MyIB_Max_Number_of_this_Role__c = null,
        MyIB_Multiple_Programmes__c = false,
        MyIB_Require_My_School_Approval__c = false,
        MyIB_Use_My_School_Subjects__c = false,
        Permission_Set_Name__c = null,
        Programme_Association__c = 'Required',
        Programme_Required__c = false,
        Related_Programmes__c = 'PYP;MYP;DP;CP',
        Require_Educational_Degree__c = false,
        Require_Language_Experience__c = false,
        Role_Description__c = 'The Head of School is the Headmaster or Principal of an IB School, spanning all the programmes offered by the school.',
        Role_Level__c = 'Fully Qualified',
        Role_Name__c = 'Head of School',
        Role_Name_French__c = 'Chef dâ€™Ã©tablissement',
        Role_Name_Spanish__c = 'Director(a) de colegio',
        Role_Retired__c = false,
        Role_Type__c = 'School Role',
        Role_Description_es__c = 'La funciÃ³n de director de un Colegio del Mundo del IB abarca todos los programas que ofrece el colegio.',
        Role_Description_fr__c = 'Le chef dâ€™Ã©tablissement dirige une Ã©cole du monde de lâ€™IB et supervise tous les programmes quâ€™elle propose.Â ',
        Prevent_Duplicates__c = false,
        SF_Role_Application__c = false,
        Sub_Category__c = 'Evaluation & Authorization',
        Training_Model__c = null,
        Unit_Planner__c = false
            ));
        
        tempLIBRoleRepositories.add(new IB_Role_Repository__c(
            Account_Association__c = null,
        Address_Source__c = null,
        Application_Available_in_MyIB__c = false,
        Available__c = false,
        Available_From__c = Date.newInstance(2000, 1, 1),
        Available_in_Region__c = 'School Services',
        Available_To__c = null,
        Bypass_Educator_Background_Rule__c = false,
        Category__c = 'School_Roles',
        Context__c = 'Head_of_School_Overall',
        Custom_Application__c = '',
        CV__c = false,
        Display_Confirmed_in_MyIB__c = false,
        Display_in_MyIB__c = false,
        Display_In_PIMS_Community__c = false,
        DOB_Mandatory__c = false,
        External_Role_ID__c = null,
        External_Role_Type__c = 'IBEN_Roles',
        IB_Staff_Role__c = false,
        Letter_of_Agreement__c = false,
        Letter_of_Reference__c = false,
        MyIB_Has_Subjects__c = false,
        MyIB_Has_Workshop_Titles__c = false,
        MyIB_Max_Number_of_this_Role__c = null,
        MyIB_Multiple_Programmes__c = false,
        MyIB_Require_My_School_Approval__c = false,
        MyIB_Use_My_School_Subjects__c = false,
        Permission_Set_Name__c = null,
        Programme_Association__c = 'Prohibited',
        Programme_Required__c = false,
        Related_Programmes__c = 'N/A',
        Require_Educational_Degree__c = false,
        Require_Language_Experience__c = false,
        Role_Description__c = 'Head of School (Overall)',
        Role_Level__c = 'Fully Qualified',
        Role_Name__c = 'Head of School (Overall)',
        Role_Name_French__c = 'Chef dâ€™Ã©tablissement (global)',
        Role_Name_Spanish__c = 'Director(a) del colegio (general)',
        Role_Retired__c = false,
        Role_Type__c = 'School Role',
        Role_Description_es__c = 'Director de colegio (toda la instituciÃ³n)',
        Role_Description_fr__c = 'Chef dâ€™Ã©tablissement (global)',
        Prevent_Duplicates__c = false,
        SF_Role_Application__c = false,
        Sub_Category__c = 'Evaluation & Authorization',
        Training_Model__c = null,
        Unit_Planner__c = false
            ));
        
        tempLIBRoleRepositories.add(new IB_Role_Repository__c(
            Account_Association__c = null,
        Address_Source__c = null,
        Application_Available_in_MyIB__c = false,
        Available__c = false,
        Available_From__c = Date.newInstance(2000, 1, 1),
        Available_in_Region__c = 'School Services',
        Available_To__c = null,
        Bypass_Educator_Background_Rule__c = false,
        Category__c = 'School_Roles',
        Context__c = 'Programme_Coordinator',
        Custom_Application__c = '',
        CV__c = false,
        Display_Confirmed_in_MyIB__c = false,
        Display_in_MyIB__c = false,
        Display_In_PIMS_Community__c = false,
        DOB_Mandatory__c = false,
        External_Role_ID__c = null,
        External_Role_Type__c = 'IBEN_Roles',
        IB_Staff_Role__c = false,
        Letter_of_Agreement__c = false,
        Letter_of_Reference__c = false,
        MyIB_Has_Subjects__c = false,
        MyIB_Has_Workshop_Titles__c = false,
        MyIB_Max_Number_of_this_Role__c = null,
        MyIB_Multiple_Programmes__c = false,
        MyIB_Require_My_School_Approval__c = false,
        MyIB_Use_My_School_Subjects__c = false,
        Permission_Set_Name__c = null,
        Programme_Association__c = 'Required',
        Programme_Required__c = false,
        Related_Programmes__c = 'PYP;MYP;DP;CP',
        Require_Educational_Degree__c = false,
        Require_Language_Experience__c = false,
        Role_Description__c = 'The person that administrators the running of an IB Programme within a school.',
        Role_Level__c = 'Fully Qualified',
        Role_Name__c = 'Programme Coordinator',
        Role_Name_French__c = 'Coordonnateur du programme',
        Role_Name_Spanish__c = 'Coordinador(a) de programa',
        Role_Retired__c = false,
        Role_Type__c = 'School Role',
        Role_Description_es__c = 'Supervisa la implementaciÃ³n del programa del IB en el colegio.',
        Role_Description_fr__c = 'Il superviseÂ la mise en Å“uvre dâ€™un programme de lâ€™IB au sein dâ€™un Ã©tablissement.',
        Prevent_Duplicates__c = false,
        SF_Role_Application__c = false,
        Sub_Category__c = 'Evaluation & Authorization',
        Training_Model__c = null,
        Unit_Planner__c = false
            ));
        
        return tempLIBRoleRepositories;
    }
    
    // ##### Custom Label Project
    
    public static List<Custom_Label_Project__c> createCustomLabelProjects()
    {
        List<Custom_Label_Project__c> projectLabels = new List<Custom_Label_Project__c>();
        
        List<String> projectNames = new List<String>{'IB Portal Template', 'IBEN', 'IB Action Plan Template', 'My School Profile', 'Ib_Pims_Application_Doc', 'Ib_Application_Feedback', 'IB_Answers_EC'};
        
        for(String temp : projectNames)
        {
            projectLabels.add(new Custom_Label_Project__c(Name = temp));
        }
        
        return projectLabels;
    }
    
    // Query used for static resource: SELECT Group__c, Label__c, Project__r.Name FROM CustomLabel__c . Used Copilot to convert it to JSON and uploaded to the static resource (make sure to minify it)
    public static List<CustomLabel__c> createCustomLabels()
    {
        List<CustomLabel__c> customLabels = new List<CustomLabel__c>();
        
        List<Custom_Label_Project__c> projects = ([SELECT Id, Name FROM Custom_Label_Project__c]);
        
        Map<String, Id> mapOfProjectNamesToIds = new Map<String, Id>();
        
        for(Custom_Label_Project__c tempProject : projects)
        {
            mapOfProjectNamesToIds.put(tempProject.Name, tempProject.Id);
        }
        
        StaticResource sr = [SELECT Body FROM StaticResource WHERE Name = 'PostSandboxRefresh_CustomLabels'];
        String jsonString = sr.Body.toString();
        
        // Deserialize into a Map
        System.debug(jsonString);
        Map<String, Object> rawMap = (Map<String, Object>) JSON.deserializeUntyped(jsonString);
        
        for (String key : rawMap.keySet())
        {
            Map<String, Object> entry = (Map<String, Object>) rawMap.get(key);
            
            CustomLabel__c temp = new CustomLabel__c();
            temp.Group__c = (String) entry.get('Group__c');
            temp.Label__c = (String) entry.get('Label__c');
            temp.Project__c = mapOfProjectNamesToIds.get((String) entry.get('Project__r.Name'));
            
            customLabels.add(temp);
        }
        
        return customLabels;
    }
    
    // Query used for static resource: SELECT Language__c, Value__c, CustomLabel__r.Label__c FROM Translation__c . Used Copilot to convert it to JSON and uploaded to the static resource (make sure to minify it)
    public static List<Translation__c> createTranslations()
    {
        List<Translation__c> translations = new List<Translation__c>();
        
        List<CustomLabel__c> customLabels = ([SELECT Id, Label__c FROM CustomLabel__c]);
        
        Map<String, Id> mapOfCustomLabelsToIds = new Map<String, Id>();
        
        for(CustomLabel__c tempCustomLabel : customLabels)
        {
            mapOfCustomLabelsToIds.put(tempCustomLabel.Label__c, tempCustomLabel.Id);
        }
        
        StaticResource sr = [SELECT Body FROM StaticResource WHERE Name = 'PostSandboxRefresh_Translations'];
        String jsonString = sr.Body.toString();
        
        
        // Deserialize into a List of generic Maps
        List<Object> rawList = (List<Object>) JSON.deserializeUntyped(jsonString);
        
        for (Object obj : rawList)
        {
            Map<String, Object> record = (Map<String, Object>) obj;
            
            Translation__c temp = new Translation__c();
            temp.Language__c = (String) record.get('Language__c');
            temp.Value__c = (String) record.get('Value__c');
            temp.CustomLabel__c = mapOfCustomLabelsToIds.get((String) record.get('CustomLabel__r.Label__c'));
            
            translations.add(temp);
        }
        
        return translations;
    }
    
    // ##### IB Address
    
    /**
     * @description  - Populates fields of IB_Country_Segmentation__c instance
     * @param ibCountrySegmentationRecord - the record to populate fields
     * @return `IB_Country_Segmentation__c`
     */
    public static IB_Country_Segmentation__c createIBCountrySegmentation(String country, String subregion, String segment){
        
        IB_Country_Segmentation__c ibCountrySegmentationInstance = new IB_Country_Segmentation__c();
        ibCountrySegmentationInstance.Country_es__c = country;
        ibCountrySegmentationInstance.Geographical_Sub_Region_Segmentation__c = subregion;
        ibCountrySegmentationInstance.IBEN_Segmentation__c = segment;
        ibCountrySegmentationInstance.Regional_Office_Segmentation__c = segment;
        return ibCountrySegmentationInstance;
    }
    
    // ##### Role(s) & Application(s)
    public static List<IB_Role__c> createIbRoles(IB_Role_Repository__c hosRole, IB_Role_Repository__c hosOverallRole, IB_Role_Repository__c pcRole, List<Contact> contacts, IB_Programme__c programme)
    {
        List<IB_Role__c> roles = new List<IB_Role__c>();
        
        for(Integer i = 0; i < contacts.size()-1; i++)
        {
            if(Math.mod(i, 3) == 0)
            {
                // HoS Overall
                roles.add(createRoleInstance(hosOverallRole.Id, 'Confirmed', true, null, contacts[i], null));
            }
            else if(Math.mod(i, 3) == 1)
            {
                // HoS
                roles.add(createRoleInstance(hosRole.Id, 'Confirmed', true, 'DP', contacts[i], programme));
            }
            else
            {
                // Programme Coordinator
                roles.add(createRoleInstance(pcRole.Id, 'Confirmed', true, 'DP', contacts[i], programme));
            }
        }
        
        return roles;
    }
    
    public static IB_Role__c createRoleInstance(Id role, String status, Boolean active, String programmes, Contact con, IB_Programme__c programme)
    {
        IB_Role__c roleInstance = new IB_Role__c();
        
        roleInstance.IB_Role__c = role;
        roleInstance.IB_Contact__c = con.Id;
        roleInstance.IB_Account__c = con.AccountId;
        roleInstance.Status__c = status;
        roleInstance.Active__c = active;
        roleInstance.Programme_Selection__c = programmes;
        if(programme != null)
        {
            roleInstance.IB_Programme_New__c = programme.Id;
        }
        
        
        return roleInstance;
    }
    
    // ##### IB Address
    
    public static IB_Address__c createIBAddressInstance(String status, String addressLine1, String city, String postalCode, IB_Country_Segmentation__c segmentation, Account account){
        
        IB_Address__c ibAddressInstance = new IB_Address__c();
        
        ibAddressInstance.Name = generateRandomString(5);
        ibAddressInstance.Status__c = status;
        ibAddressInstance.Address_Line_1__c = addressLine1;
        ibAddressInstance.City__c = city;
        ibAddressInstance.Postal_Code__c = postalCode;
        ibAddressInstance.Country__c = segmentation.id;
        ibAddressInstance.IB_Account__c = account.Id;
        
        return ibAddressInstance;
    }
    
    // ##### IB Programme
    
    public static List<IB_Programme__c> createIBProgrammes(String recordTypeName, IB_Address__c ibAddress, Integer nProgrammes) {
        
        List<IB_Programme__c> ibProgrammes = new List<IB_Programme__c>();
        Id recordTypeId  = Schema.SObjectType.IB_Programme__c.getRecordTypeInfosByName().get(recordTypeName).getRecordTypeId();
        
        for (Integer i = 0; i < nProgrammes; i++) {
            IB_Programme__c ibProgramme = createIBProgrammeInstance(recordTypeId, ibAddress);
            ibProgrammes.add(ibProgramme);
        }
        
        return ibProgrammes;
    }
    
    public static IB_Programme__c createIBProgrammeInstance(String recordTypeId, IB_Address__c ibAddress) {
        
        String DEFAULT_EXAM_SESSION = 'May';
        String DEFAULT_STATUS = 'Test';
        String DEFAULT_IBCC_IMPLEMENTATION_PHASE = 'Phase 1';
        String DEFAULT_PRIMARY_LANGUAGE = 'English';
        String DEFAULT_STAGE_NAME = 'Evaluation';
        String DEFAULT_STATUS_AUTHORIZED = 'Authorized';
        Date DEFAULT_DATE_DECISION_ON_CANDIDACY = Date.today().addDays(365);
        Date DEFAULT_DATE_DECISION_ON_AUTHORIZATION = Date.today().addDays(-20);
        
        IB_Programme__c ibProgrammeInstance = new IB_Programme__c();
        
        ibProgrammeInstance.recordTypeId = recordTypeId;
        ibProgrammeInstance.Exam_Session__c = DEFAULT_EXAM_SESSION;
        ibProgrammeInstance.Status__c = DEFAULT_STATUS;
        ibProgrammeInstance.IBCC_Implementation_Phase__c = DEFAULT_IBCC_IMPLEMENTATION_PHASE;
        ibProgrammeInstance.Primary_Language_of_Instruction__c = DEFAULT_PRIMARY_LANGUAGE;
        ibProgrammeInstance.StageName__c = DEFAULT_STAGE_NAME;
        ibProgrammeInstance.Date_Decision_on_Candidacy__c = DEFAULT_DATE_DECISION_ON_CANDIDACY;
        ibProgrammeInstance.Date_Decision_on_Authorization__c = DEFAULT_DATE_DECISION_ON_AUTHORIZATION;
        ibProgrammeInstance.Street_Address__c = ibAddress.id;
        ibProgrammeInstance.Account__c = ibAddress.IB_Account__c;
        
        return ibProgrammeInstance;
    }
    
    // ##### IB Application
    
    public static List<IB_Application__c> createIBApplications(String recordTypeName, IB_Programme__c ibProgramme, Integer numApplications)
    {
        List<IB_Application__c> ibApplications = new List<IB_Application__c>();
        
        
        for (Integer i = 0; i < numApplications; i++) {
            IB_Application__c ibApplication = createIBApplicationInstance(recordTypeName, ibProgramme);
            ibApplications.add(ibApplication);
        }
        
        return ibApplications;
    }
    
    public static IB_Application__c createIBApplicationInstance(String recordTypeName, IB_Programme__c ibProgramme) {
        
        String default_Status = 'Draft';
        
        IB_Application__c ibApplicationInstance = new IB_Application__c();
        
        ibApplicationInstance.Name = ibProgramme.Name + ' ' + recordTypeName;
        ibApplicationInstance.recordTypeId = Schema.SObjectType.IB_Application__c.getRecordTypeInfosByName().get(recordTypeName).getRecordTypeId();
        ibApplicationInstance.Status__c = default_Status;
        ibApplicationInstance.Application_Lookup_to_Programme__c = ibProgramme.Id;
        
        return ibApplicationInstance;
    }
    
    // ##### User
    
    public static User createUser(String profileName, String FirstName, String LastName){
        
        Id profileId = getProfileId(profileName);
        
        User usr = new User();
        
        usr = createUserInstance(profileId, FirstName, LastName);
        
        return usr;
    }
    
    public static String getProfileId(String profileName){
        String profileId = '';
        try{
            if(profileName == 'System Administrator' || profileName == '' || profileName == null) {
                Id userLicenseId = [ select Id from UserLicense where name = 'Salesforce'].id;
                profileId = [select Id from Profile where name='System Administrator' and UserLicenseId=:userLicenseId].id;
            } else {
                profileId = [SELECT Id FROM Profile WHERE Name = :profileName LIMIT 1].Id;
            }
        } catch(Exception e){
            profileId = [SELECT Id FROM Profile LIMIT 1].Id;
        }
        return profileId;
    }
    
    /**
     * @description - Creates or updates a User instance with default or specified values. If a field is blank or null in
     *                the provided user record, it assigns a default value to that field.
     * @param userRecord - The User record to be used as a template. If fields are blank or null, defaults are applied.
     * @param profileId - The Profile ID to assign to the User. If null, the User's Profile ID remains unchanged.
     * @return - The User instance populated with provided or default values.
     */
    public static User createUserInstance(String profileId, String firstName, String lastName){
        
        String DEFAULT_DOMAIN = 'test.com';
        String DEFAULT_FIRSTNAME = 'TestFirstName';
        String DEFAULT_ALIAS = 'tUser';
        Boolean DEFAULT_ACTIVE = true;
        String DEFAULT_TIMEZONE = 'America/Los_Angeles';
        String DEFAULT_LOCALE = 'en_US';
        String DEFAULT_EMAILKEY = 'UTF-8';
        String DEFAULT_LANGUAGEKEY = 'en_US';
        
        User userInstance = new User();
        
        userInstance.FirstName = generateRandomString(5);
        userInstance.LastName = generateRandomString(5);
        
        String email = generateRandomEmail(15, null);
        
        userInstance.ProfileId = profileId;
        userInstance.Email = email;
        userInstance.UserName = email;
        userInstance.IsActive = true;
        userInstance.Alias = generateRandomString(6);
        userInstance.TimeZoneSidKey = DEFAULT_TIMEZONE;
        userInstance.LocaleSidKey = DEFAULT_LOCALE;
        userInstance.EmailEncodingKey = DEFAULT_EMAILKEY;
        userInstance.LanguageLocaleKey = DEFAULT_LANGUAGEKEY;
        
        return userInstance;
    }
    
    // ##### Utility
    
    /**
     * @description This method generates random String values for test classes
     * @param len   length of random string
     * @return      `String`
     */
    public static String generateRandomString(Integer len) {
        final String chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyz';
        String randStr = '';
        while (randStr.length() < len) {
            Integer idx = Math.mod(Math.abs(Crypto.getRandomInteger()), chars.length());
            randStr += chars.substring(idx, idx+1);
        }
        return randStr;
    }
    
    /**
     * @description   This method generates randomemail for test classes
     * @param prefixLength length of string before domain name
     * @param domain   domain name for test email
     * @return             `String`
     */
    public static String generateRandomEmail(Integer prefixLength, String domain)
    {
        if(domain == null)
        {
            domain = 'gmail.com';
        }
        
        if(prefixLength == null)
        {
            prefixLength = 15;
        }
        
        return generateRandomString(prefixLength) + '@' + domain;
    }
}