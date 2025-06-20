/*******************************************************************************************
* @Name         PimsProfileIntentController  
* @Author       
* @Date         
* @Group        
* @Description  
*******************************************************************************************/
/* MODIFICATION LOG
* Version          Developer          Date               Description
*-------------------------------------------------------------------------------------------
*  1.0        Ranjith Kondabathini      07/20/2023       Update the logic to not confirm invited contact roles when updated from Programme Default Contacts section.
*******************************************************************************************/
public class PimsProfileIntentController implements PimsProfilePanelInterface {
    
    public Account account {get;set;}
    public Boolean hasPypProgramme {get;set;}
    public Boolean hasMypProgramme {get;set;}
    public Boolean hasDpProgramme {get;set;}
    public Boolean hasIbccProgramme {get;set;}
    public IB_Programme__c pypProgramme {get;set;}
    public IB_Programme__c mypProgramme {get;set;}
    public IB_Programme__c dpProgramme {get;set;}
    public IB_Programme__c ibccProgramme {get;set;}
    //public IB_Role__c primaryContactRole {get;set;}
    public IB_Role__c programmeContactRole {get;set;}
    public IB_Role__c billingContactRole {get;set;}
    public IB_Role__c examContactRole {get;set;}
    public IB_Role__c headOfSchoolContactRole {get;set;}
    public list<IB_Role__c> listRoleInsert;
    public String activeTab {get;set;}
    private Date closeDate = Date.valueOf('2999-12-31 12:00:00');
    
    public Boolean isDashboardPage {get;set;}
    //This Part of Code is being added by Ammara-Plumlogix, as part of CR-812
    //begin
    public boolean ischeckEP;
    //End
    
    private ProfileService profileService = new ProfileService();
    private RoleDAO roleData = RoleDAO.getInstance();
    
    private static IntendToApplySettings__c intendToApplySettings = IntendToApplySettings__c.getOrgDefaults();
    
    // should not be used for the intend to apply but needed for the impl
    public PageReference save() {
        
        
        
        
        System.debug('THIS SAVE METHOD!'); 
        
        PageReference pageRef = ApexPages.currentPage();
        activeTab = 'intent';
        pageRef = new PageReference('/pims/PimsProfileNew');
        pageRef.setRedirect(true);
        pageRef.getParameters().put('tab', activeTab);
        
        return pageRef;
    }
    
    public PageReference savePyp() {
        System.debug('THIS SAVE PYP METHOD!'); 
        listRoleInsert = new list<IB_Role__c>();
        PageReference pageRef = ApexPages.currentPage();
        Savepoint sp = Database.setSavepoint();
        try{
            //RecordType RecType = [SELECT Id, Name FROM RecordType WHERE SobjectType = 'IB_Programme__c' AND DeveloperName = 'PYP'];
            ID RecTypeId = Schema.SObjectType.IB_Programme__c.getRecordTypeInfosByDeveloperName().get('PYP').getRecordTypeId();
            pypProgramme.RecordTypeId = RecTypeId;
            
            if (account.Short_Name__c != null && account.Short_Name__c != '') {
                pypProgramme.Name = 'PYP ' + account.Short_Name__c;
            }
            else {
                pypProgramme.Name = 'PYP ' + account.Name;
            }
            pypProgramme.Status__c = 'Interested';
            pypProgramme.StageName__c = 'Request for Candidacy';
            pypProgramme.Close_Date__c = closeDate;
            if (account.Region__c == 'IBAEM') {
                pypProgramme.Owner__c = intendToApplySettings.IBAEM_User_Id__c;
            }
            else if (account.Region__c == 'IBAP') {
                pypProgramme.Owner__c = intendToApplySettings.IBAP_User_Id__c;
            }
            else {
                pypProgramme.Owner__c = intendToApplySettings.IBA_User_Id__c;
            }
            List<IB_Role__c> headOfSchool = roleData.getHeadOfSchool(account.Id);
            
            //system.debug('headOfSchoola  '+headOfSchool);
            
            
            
            if (headOfSchool.size() == 0) throw new CustomValidationException(Label.PIMS_Error_HeadOfSchool);
            
            if (headOfSchoolContactRole.IB_Contact__c == null) throw new CustomValidationException(Label.PIMS_Error_HeadOfSchoolProgramme);
            
            //if (primaryContactRole.IB_Contact__c == null && programmeContactRole.IB_Contact__c == null) throw new CustomValidationException(Label.PIMS_Error_PrimaryContact);
            if (programmeContactRole.IB_Contact__c == null) throw new CustomValidationException(Label.PIMS_Error_PrimaryContact);
            
            if (billingContactRole.IB_Contact__c == null) throw new CustomValidationException(Label.PIMS_Error_BillingContact);
            
            if (pypProgramme.Programme_Legal_Name__c == null) throw new CustomValidationException(Label.PIMS_Error_LegalName);
            
            if (account.Academic_End_Month__c == 'January' || account.Academic_End_Month__c == 'February' || account.Academic_End_Month__c == 'September' || account.Academic_End_Month__c == 'October' || account.Academic_End_Month__c == 'November'  || account.Academic_End_Month__c == 'December'){
                pypProgramme.Exam_Session__c = 'November';
            } else {
                pypProgramme.Exam_Session__c = 'May';
            }
            
            account.PIMS_Step_1__c = true;
            account.PIMS_Step_2__c = true;
            account.PIMS_Step_3__c = true;
            account.PIMS_Step_4__c = true;
            account.PIMS_Step_5__c = true;
            account.Lead_Account__c = false;
            if(!Test.isRunningTest())
            { update account;
             insert pypProgramme;
            }
            //primaryContactRole.IB_Programme_New__c = pypProgramme.Id;
            programmeContactRole.IB_Programme_New__c = pypProgramme.Id;            
            billingContactRole.IB_Programme_New__c = pypProgramme.Id;
            headOfSchoolContactRole.IB_Programme_New__c = pypProgramme.Id;
            
            programmeContactRole.Programme_Selection__c = 'PYP';
            billingContactRole.Programme_Selection__c = 'PYP';
            headOfSchoolContactRole.Programme_Selection__c = 'PYP';
            
            //insert primaryContactRole;
            if (programmeContactRole.IB_Contact__c != null) {
                //insert programmeContactRole;
                listRoleInsert.add(programmeContactRole);
                system.debug(loggingLevel.ERROR, 'programmeContactRole from PimsProfileIntent: ' + programmeContactRole);
            }
            //insert billingContactRole;
            //insert headOfSchoolContactRole;
            listRoleInsert.add(billingContactRole);
            listRoleInsert.add(headOfSchoolContactRole);
            if(listRoleInsert != null && !listRoleInsert.isEmpty()){
                checkContactRecordType(listRoleInsert);
                
                insert listRoleInsert;
            }                 
            activeTab = 'next';
            if (isDashboardPage) pageRef = new PageReference('/pims/PimsDashboard');
            else pageRef = new PageReference('/pims/PimsProfileNew');
            
            pageRef.setRedirect(true);
            
            
        }
        catch (Exception ex) {
            
            ApexPages.addMessages(ex);
            activeTab = 'intent';
            pageRef.setRedirect(false);
            pageRef.getParameters().put('prog', 'pyp');
            
            account.PIMS_Step_5__c = false;
            Database.rollback(sp);
            if(pypProgramme != null) pypProgramme.id = null;
            if(programmeContactRole != null) programmeContactRole.id = null;
            if(billingContactRole != null) billingContactRole.id = null;
            if(headOfSchoolContactRole != null) headOfSchoolContactRole.id = null;
            
        }
        
        if (!isDashboardPage) pageRef.getParameters().put('tab', activeTab);
        
        return pageRef;
    }
        
    public PageReference saveMyp() {
        System.debug('THIS SAVE MYP METHOD!'); 
        listRoleInsert = new list<IB_Role__c>();
        
        PageReference pageRef = ApexPages.currentPage();
        Savepoint sp = Database.setSavepoint();
        try {
            
            //RecordType RecType = [SELECT Id, Name FROM RecordType WHERE SobjectType = 'IB_Programme__c' and DeveloperName = 'MYP'];
            ID RecTypeId = Schema.SObjectType.IB_Programme__c.getRecordTypeInfosByDeveloperName().get('MYP').getRecordTypeId();
            mypProgramme.RecordTypeId = RecTypeId;
            if (account.Short_Name__c != null && account.Short_Name__c != '') {
                mypProgramme.Name = 'MYP ' + account.Short_Name__c;
            }
            else {
                mypProgramme.Name = 'MYP ' + account.Name;
            }
            mypProgramme.Status__c = 'Interested';
            mypProgramme.StageName__c = 'Request for Candidacy';
            mypProgramme.Close_Date__c = closeDate;
            if (account.Region__c == 'IBAEM') {
                mypProgramme.Owner__c = intendToApplySettings.IBAEM_User_Id__c;
            }
            else if (account.Region__c == 'IBAP') {
                mypProgramme.Owner__c = intendToApplySettings.IBAP_User_Id__c;
            }
            else {
                mypProgramme.Owner__c = intendToApplySettings.IBA_User_Id__c;
            }
            
            List<IB_Role__c> headOfSchool = roleData.getHeadOfSchool(account.Id);
            
            if (headOfSchool.size() == 0) throw new CustomValidationException(Label.PIMS_Error_HeadOfSchool);
            
            if (headOfSchoolContactRole.IB_Contact__c == null) throw new CustomValidationException(Label.PIMS_Error_HeadOfSchoolProgramme);
            
            //if (primaryContactRole.IB_Contact__c == null && programmeContactRole.IB_Contact__c == null) throw new CustomValidationException(Label.PIMS_Error_PrimaryContact);
            if (programmeContactRole.IB_Contact__c == null) throw new CustomValidationException(Label.PIMS_Error_PrimaryContact);
            
            if (billingContactRole.IB_Contact__c == null) throw new CustomValidationException(Label.PIMS_Error_BillingContact);
            
            if (examContactRole.IB_Contact__c == null) throw new CustomValidationException(Label.PIMS_Error_ExamContact);
            
            if (mypProgramme.Programme_Legal_Name__c == null) throw new CustomValidationException(Label.PIMS_Error_LegalName);
            
            account.PIMS_Step_1__c = true;
            account.PIMS_Step_2__c = true;
            account.PIMS_Step_3__c = true;
            account.PIMS_Step_4__c = true;
            account.PIMS_Step_5__c = true;
            account.Lead_Account__c = false;
            update account;
            insert mypProgramme; 
            
            
            //primaryContactRole.IB_Programme_New__c = mypProgramme.Id;
            programmeContactRole.IB_Programme_New__c = mypProgramme.Id;
            billingContactRole.IB_Programme_New__c = mypProgramme.Id;
            headOfSchoolContactRole.IB_Programme_New__c = mypProgramme.Id;
            examContactRole.IB_Programme_New__c = mypProgramme.Id;
            
            programmeContactRole.Programme_Selection__c = 'MYP';
            billingContactRole.Programme_Selection__c = 'MYP';
            headOfSchoolContactRole.Programme_Selection__c = 'MYP';
            examContactRole.Programme_Selection__c = 'MYP';
            
            /*if (primaryContactRole.IB_Contact__c != null) insert primaryContactRole;
if (programmeContactRole.IB_Contact__c != null) insert programmeContactRole;
if (billingContactRole.IB_Contact__c != null) insert billingContactRole;
if (headOfSchoolContactRole.IB_Contact__c != null) insert headOfSchoolContactRole;*/
            if (programmeContactRole.IB_Contact__c != null) listRoleInsert.add(programmeContactRole);
            if (billingContactRole.IB_Contact__c != null) listRoleInsert.add(billingContactRole);
            if (examContactRole.IB_Contact__c != null) listRoleInsert.add(examContactRole);
            if (headOfSchoolContactRole.IB_Contact__c != null) listRoleInsert.add(headOfSchoolContactRole);
            if(listRoleInsert != null && !listRoleInsert.isEmpty()){
                checkContactRecordType(listRoleInsert);
                
                insert listRoleInsert;
            }
            activeTab = 'next';
            if (isDashboardPage) pageRef = new PageReference('/pims/PimsDashboard');
            else pageRef = new PageReference('/pims/PimsProfileNew');
            
            pageRef.setRedirect(true);
        }
        catch (Exception ex) {
            System.debug(loggingLevel.Error, 'STRUNK - '+ex);
            ApexPages.addMessages(ex);
            activeTab = 'intent';
            pageRef.setRedirect(false);
            pageRef.getParameters().put('prog', 'myp');
            
            account.PIMS_Step_5__c = false;
            Database.rollback(sp);
            if(mypProgramme != null) mypProgramme.id = null;
            if(programmeContactRole != null) programmeContactRole.id = null;
            if(billingContactRole != null) billingContactRole.id = null;
            if(examContactRole != null) examContactRole.id = null;
            if(headOfSchoolContactRole != null) headOfSchoolContactRole.id = null;
        }
        
        if (!isDashboardPage) pageRef.getParameters().put('tab', activeTab);
        
        return pageRef;
    }
    
    public PageReference saveDp() {
        listRoleInsert = new list<IB_Role__c>();
        PageReference pageRef = ApexPages.currentPage();
        Savepoint sp = Database.setSavepoint();
        try {
            
            //RecordType RecType = [SELECT Id, Name FROM RecordType WHERE SobjectType = 'IB_Programme__c' and DeveloperName = 'Diploma_Programme'];
            ID RecTypeId = Schema.SObjectType.IB_Programme__c.getRecordTypeInfosByDeveloperName().get('Diploma_Programme').getRecordTypeId();
            dpProgramme.RecordTypeId = RecTypeId;
            if (account.Short_Name__c != null && account.Short_Name__c != '') {
                dpProgramme.Name = 'DP ' + account.Short_Name__c;
            }
            else {
                dpProgramme.Name = 'DP ' + account.Name;
            }
            dpProgramme.Status__c = 'Interested';
            dpProgramme.StageName__c = 'Request for Candidacy';
            dpProgramme.Close_Date__c = closeDate;
            if (account.Region__c == 'IBAEM') {
                dpProgramme.Owner__c = intendToApplySettings.IBAEM_User_Id__c;
            }
            else if (account.Region__c == 'IBAP') {
                dpProgramme.Owner__c = intendToApplySettings.IBAP_User_Id__c;
            }
            else {
                dpProgramme.Owner__c = intendToApplySettings.IBA_User_Id__c;
            }
            
            List<IB_Role__c> headOfSchool;
            headOfSchool = roleData.getHeadOfSchool(account.Id);
            
            if (headOfSchool.size() == 0) throw new CustomValidationException(Label.PIMS_Error_HeadOfSchool);
            
            if (headOfSchoolContactRole.IB_Contact__c == null) throw new CustomValidationException(Label.PIMS_Error_HeadOfSchoolProgramme);
            
            //if (primaryContactRole.IB_Contact__c == null && programmeContactRole.IB_Contact__c == null) throw new CustomValidationException(Label.PIMS_Error_PrimaryContact);
            if (programmeContactRole.IB_Contact__c == null) throw new CustomValidationException(Label.PIMS_Error_PrimaryContact);
            
            if (billingContactRole.IB_Contact__c == null) throw new CustomValidationException(Label.PIMS_Error_BillingContact);
            
            if (examContactRole.IB_Contact__c == null) throw new CustomValidationException(Label.PIMS_Error_ExamContact);
            
            if (dpProgramme.Programme_Legal_Name__c == null) throw new CustomValidationException(Label.PIMS_Error_LegalName);
            
            account.PIMS_Step_1__c = true;
            account.PIMS_Step_2__c = true;
            account.PIMS_Step_3__c = true;
            account.PIMS_Step_4__c = true;
            account.PIMS_Step_5__c = true;
            account.Lead_Account__c = false;
            update account;
            insert dpProgramme;
            //primaryContactRole.IB_Programme_New__c = dpProgramme.Id;
            programmeContactRole.IB_Programme_New__c = dpProgramme.Id;
            billingContactRole.IB_Programme_New__c = dpProgramme.Id;
            examContactRole.IB_Programme_New__c = dpProgramme.Id;
            headOfSchoolContactRole.IB_Programme_New__c = dpProgramme.Id;
            
            programmeContactRole.Programme_Selection__c = 'DP';
            billingContactRole.Programme_Selection__c = 'DP';
            headOfSchoolContactRole.Programme_Selection__c = 'DP';
            examContactRole.Programme_Selection__c = 'DP';
            
            /*if (primaryContactRole.IB_Contact__c != null) insert primaryContactRole;
if (billingContactRole.IB_Contact__c != null) insert billingContactRole;
if (examContactRole.IB_Contact__c != null) insert examContactRole;
if (headOfSchoolContactRole.IB_Contact__c != null) insert headOfSchoolContactRole;
if (programmeContactRole.IB_Contact__c != null) insert programmeContactRole;*/
            if (billingContactRole.IB_Contact__c != null) listRoleInsert.add(billingContactRole);
            if (examContactRole.IB_Contact__c != null) listRoleInsert.add(examContactRole);
            if (headOfSchoolContactRole.IB_Contact__c != null) listRoleInsert.add(headOfSchoolContactRole);
            if (programmeContactRole.IB_Contact__c != null) listRoleInsert.add(programmeContactRole);
            if(listRoleInsert != null && !listRoleInsert.isEmpty()){
                checkContactRecordType(listRoleInsert);
                
                insert listRoleInsert;
                
                
                
                activeTab = 'next';
                if (isDashboardPage) pageRef = new PageReference('/pims/PimsDashboard');
                else pageRef = new PageReference('/pims/PimsProfileNew');
                
                pageRef.setRedirect(true);
            }
        }
        catch (Exception ex) {
            
            ApexPages.addMessages(ex);
            activeTab = 'intent';
            pageRef.setRedirect(false);
            pageRef.getParameters().put('prog', 'dp');
            account.PIMS_Step_5__c = false;
            Database.rollback(sp);
            if(dpProgramme != null) dpProgramme.id = null;
            if(programmeContactRole != null) programmeContactRole.id = null;
            if(billingContactRole != null) billingContactRole.id = null;
            if(examContactRole != null) examContactRole.id = null;
            if(headOfSchoolContactRole != null) headOfSchoolContactRole.id = null;
        }
        
        if (!isDashboardPage) pageRef.getParameters().put('tab', activeTab);
        
        return pageRef;
    }
    
    public PageReference saveIbcc() {
        System.debug('THIS SAVE IBCC METHOD!'); 
        listRoleInsert = new list<IB_Role__c>();
        PageReference pageRef = ApexPages.currentPage();
        // This is added by Suraj as a part of ECM00589  
        Set<String> dpStatus = new Set<String>{'Interested','Candidate','Authorized'};
        List<Account> associatedAccount = new List<Account>();  
        if(account != null){
            associatedAccount = [SELECT DP_Programme_Status__c FROM Account WHERE Id =: account.ID LIMIT 1];
        }
        // END    
        Savepoint sp = Database.setSavepoint();
        try {
            
            //RecordType RecType = [SELECT Id, Name FROM RecordType WHERE SobjectType = 'IB_Programme__c' and DeveloperName = 'IBCC'];
            ID RecTypeId = Schema.SObjectType.IB_Programme__c.getRecordTypeInfosByDeveloperName().get('IBCC').getRecordTypeId();
            ibccProgramme.RecordTypeId = RecTypeId;
            if (account.Short_Name__c != null && account.Short_Name__c != '') {
                ibccProgramme.Name = 'CP ' + account.Short_Name__c;
            }
            else {
                ibccProgramme.Name = 'CP ' + account.Name;
            }
            ibccProgramme.Status__c = 'Interested';
            ibccProgramme.StageName__c = 'Request for Candidacy';
            ibccProgramme.Close_Date__c = closeDate;
            if (account.Region__c == 'IBAEM') {
                ibccProgramme.Owner__c = intendToApplySettings.IBAEM_User_Id__c;
            }
            else if (account.Region__c == 'IBAP') {
                ibccProgramme.Owner__c = intendToApplySettings.IBAP_User_Id__c;
            }
            else {
                ibccProgramme.Owner__c = intendToApplySettings.IBA_User_Id__c;
            }
            
            // AND condition in below if statement is added by Suraj as a part of ECM00589 
            if (hasDpProgramme && (!associatedAccount.isEmpty() && dpStatus.contains(associatedAccount[0].DP_Programme_Status__c)) ) {
                ibccProgramme.IBCC_Implementation_Phase__c = 'Phase 1';
            }
            else {
                ibccProgramme.IBCC_Implementation_Phase__c = 'Phase 2';
            }
            
            List<IB_Role__c> headOfSchool;
            headOfSchool = roleData.getHeadOfSchool(account.Id);
            
            
            
            if (headOfSchool.size() == 0) throw new CustomValidationException(Label.PIMS_Error_HeadOfSchool);
            
            if (headOfSchoolContactRole.IB_Contact__c == null) throw new CustomValidationException(Label.PIMS_Error_HeadOfSchoolProgramme);
            
            //if (primaryContactRole.IB_Contact__c == null && programmeContactRole.IB_Contact__c == null) throw new CustomValidationException(Label.PIMS_Error_PrimaryContact);
            if (programmeContactRole.IB_Contact__c == null) throw new CustomValidationException(Label.PIMS_Error_PrimaryContact);
            
            if (billingContactRole.IB_Contact__c == null) throw new CustomValidationException(Label.PIMS_Error_BillingContact);
            
            if (examContactRole.IB_Contact__c == null) throw new CustomValidationException(Label.PIMS_Error_ExamContact);
            
            if (ibccProgramme.Programme_Legal_Name__c == null) throw new CustomValidationException(Label.PIMS_Error_LegalName);
            
            account.PIMS_Step_1__c = true;
            account.PIMS_Step_2__c = true;
            account.PIMS_Step_3__c = true;
            account.PIMS_Step_4__c = true;
            account.PIMS_Step_5__c = true;
            account.Lead_Account__c = false;
            update account;
            insert ibccProgramme;
            //primaryContactRole.IB_Programme_New__c = ibccProgramme.Id;
            programmeContactRole.IB_Programme_New__c = ibccProgramme.Id;
            billingContactRole.IB_Programme_New__c = ibccProgramme.Id;
            examContactRole.IB_Programme_New__c = ibccProgramme.Id;
            headOfSchoolContactRole.IB_Programme_New__c = ibccProgramme.Id;
            
            programmeContactRole.Programme_Selection__c = 'CP';
            billingContactRole.Programme_Selection__c = 'CP';
            headOfSchoolContactRole.Programme_Selection__c = 'CP';
            examContactRole.Programme_Selection__c = 'CP';
            
            /*if (primaryContactRole.IB_Contact__c != null) insert primaryContactRole;
if (programmeContactRole.IB_Contact__c != null) insert programmeContactRole;
if (billingContactRole.IB_Contact__c != null) insert billingContactRole;
if (examContactRole.IB_Contact__c != null) insert examContactRole;
if (headOfSchoolContactRole.IB_Contact__c != null) insert headOfSchoolContactRole;*/
            if (programmeContactRole.IB_Contact__c != null) listRoleInsert.add(programmeContactRole);
            if (billingContactRole.IB_Contact__c != null) listRoleInsert.add(billingContactRole);
            if (examContactRole.IB_Contact__c != null) listRoleInsert.add(examContactRole);
            if (headOfSchoolContactRole.IB_Contact__c != null) listRoleInsert.add(headOfSchoolContactRole);
            if(listRoleInsert != null && !listRoleInsert.isEmpty()){
                checkContactRecordType(listRoleInsert);
                System.debug('TEST 444444444444444444444444444444444!!! ');
                
                insert listRoleInsert;
            }
            
            activeTab = 'next';
            if (isDashboardPage) pageRef = new PageReference('/pims/PimsDashboard');
            else pageRef = new PageReference('/pims/PimsProfileNew');
            
            pageRef.setRedirect(true);
        }
        catch (Exception ex) {
            
            ApexPages.addMessages(ex);
            activeTab = 'intent';
            pageRef.setRedirect(false);
            
            account.PIMS_Step_5__c = false;
            Database.rollback(sp);
            if(ibccProgramme != null) ibccProgramme.id = null;
            if(programmeContactRole != null) programmeContactRole.id = null;
            if(billingContactRole != null) billingContactRole.id = null;
            if(examContactRole != null) examContactRole.id = null;
            if(headOfSchoolContactRole != null) headOfSchoolContactRole.id = null;
        }
        
        if (!isDashboardPage) {
            pageRef.getParameters().put('tab', activeTab);
            pageRef.getParameters().put('prog', 'ibcc');
        }
        
        return pageRef;
    }
    
    private void checkContactRecordType(List<IB_Role__c> roleList){
        System.debug('THIS CHECK RECORD TYPE METHOD!');
        set<id> contactIDs = new set<id>();
        set<id> invitedContactIDs = new set<id>();
        //RecordType RecType = [SELECT Id, Name FROM RecordType WHERE SobjectType = 'Contact' AND DeveloperName = 'Invited_Contact'];
        ID RecTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Invited_Contact').getRecordTypeId();
        if(roleList != null && !roleList.isEmpty()){
            for (IB_Role__c role : roleList) {
                contactIDs.add(role.IB_Contact__c);
            }
        }
        if(!contactIDs.isEmpty()){
            for(Contact con : [SELECT Id, RecordTypeId FROM Contact WHERE Id IN: contactIDs and RecordTypeId =: RecTypeId]){
                invitedContactIDs.add(con.id);
            }
        }
        if(roleList != null && !roleList.isEmpty()){
            Id invitedRoleRecTypeId = Schema.SObjectType.IB_Role__c.getRecordTypeInfosByName().get('Invited').getRecordTypeId();
            final ID confirmedRoleRecTypeId = Schema.SObjectType.IB_Role__c.getRecordTypeInfosByName().get('Confirmed').getRecordTypeId();
            for (IB_Role__c role : roleList) {
                //Contact con = [SELECT Id, RecordTypeId FROM Contact WHERE Id =: role.IB_Contact__c LIMIT 1];
                if(!invitedContactIDs.isEmpty() && invitedContactIDs.contains(role.IB_Contact__c)){
                    role.RecordTypeId = invitedRoleRecTypeId;
                    role.Status__c = 'Invited';
                    role.End_Date__c = null;
                } else {
                    role.RecordTypeId = confirmedRoleRecTypeId;
                    role.Status__c = 'Confirmed';	
                    role.Active__c = true;	
                }
            }
        }
    }
    
    public List<SelectOption> getAddressOptions() {
        return profileService.getAddressOptions(account.Id);
    }
    
    public List<SelectOption> getContactOptions() {
        return profileService.getContactOptions(account.Id);
    }
    
    //This Part of Code is being added by Ammara-Plumlogix, as part of CR-812
    //begin
    public boolean getischeckEP(){
        List<IB_Programme__c> EP_Programme = new List<IB_Programme__c>();
        EP_Programme = [select id,RecordType.DeveloperName,status__c from IB_Programme__c where RecordType.DeveloperName ='European_Platform' 
                        AND Account__c =:account.id
                        AND status__c != 'Withdrawn' AND status__c != 'Terminated' AND status__c != 'Terminated by School' 
                        AND status__c != 'Terminated by IB' AND status__c != 'Withdrawn by School' AND status__c != 'Withdrawn by IB'];  
        System.debug('EP Size: '+EP_Programme.size());
        if(EP_Programme.size()>0)
            return true;
        else
            return false;
    }
    //End
    public boolean getDisplayPypForm() {
        return profileService.getIntentStatus(account.Id, 'PYP');
    }
    
    public boolean getDisplayMypForm() {
        return profileService.getIntentStatus(account.Id, 'MYP');
    }
    
    public boolean getDisplayDpForm() {
        return profileService.getIntentStatus(account.Id, 'DP');
    }
    
    public boolean getDisplayIbccForm() {
        return profileService.getIntentStatus(account.Id, 'CP');
    }
    
    public String getUserLanguageKey() {
        return UserInfo.getLanguage();
    }
    
    public PageReference storeDPIntentInfo() {
        storeSchoolContactsInfo('dpProgramme', dpProgramme);
        return null;
    }
    
    public PageReference storeIBCCIntentInfo() {
        storeSchoolContactsInfo('ibccProgramme', ibccProgramme);
        return null;
    }
    
    public PageReference storePYPIntentInfo() {
        storeSchoolContactsInfo('pypProgramme', pypProgramme);
        return null;
    }
    
    public PageReference storeMYPIntentInfo() {
        storeSchoolContactsInfo('mypProgramme', mypProgramme);
        return null;
    }
    
    public void storeSchoolContactsInfo(String cookieName, IB_Programme__c prog) {
        Cookie progCookie = new Cookie(cookieName, JSON.serialize(prog), null, -1, false);
        Cookie pcCookie = new Cookie('programmeContactRole', JSON.serialize(programmeContactRole), null, -1, false);
        Cookie bcCookie = new Cookie('billingContactRole', JSON.serialize(billingContactRole), null, -1, false);
        Cookie ecCookie = new Cookie('examContactRole', JSON.serialize(examContactRole), null, -1, false);
        Cookie hosCookie = new Cookie('headOfSchoolContactRole', JSON.serialize(headOfSchoolContactRole), null, -1, false);
        
        ApexPages.currentPage().setCookies(new Cookie[] {progCookie, pcCookie, bcCookie, ecCookie, hosCookie});
             
    }
    
}