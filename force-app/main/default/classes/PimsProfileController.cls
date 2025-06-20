/*******************************************************************************************
* @Name         PimsProfileController 
* @Author       
* @Date         
* @Group        
* @Description  
*******************************************************************************************/
/* MODIFICATION LOG
* Version          Developer          Date               Description
*-------------------------------------------------------------------------------------------
*  1.0              Michael Khan      04/24/2023         To reduce the view state we have declared "contacts" as transient and added getter and 
														setter and commented the instantiation code from constructor
*******************************************************************************************/
public class PimsProfileController {

	public Account account { get; set; }
    /*public Boolean showSchoolRMLink {
        get{
            // Only display the "My IB Contact" link if the user's account is (a) an Authorized School and (b) the School Rel Mgr field is filled out
            return account.Authorized_School__c && account.School_Relationship_Manager__c != null;
        } 

        private set;
    }*/
    public Boolean showSchoolRMLink { get; set; }
    public List<IB_Address__c> addresses { get; set; }
    public IB_Address__c address { get; set; }
    public IB_Address__c postalAddress { get; set; }
    public IB_Address__c streetAddress { get; set; }

    public List<SchoolSections__c> sections { get; set; }
    public SchoolSections__c section { get; set; }

    public List<Contact> contactsByAccount { get; set ;}
    public List<Contact> contactsByAccountRole { get; set; }
    public transient List<Contact> contacts;
    public List<Contact> getContacts() {
        if(contacts== null){
            PimsCommunityService pimsService = new PimsCommunityService();
            ContactService.setAccountId( pimsService.getCurrentAccount().Id);
            contacts = ContactService.getContacts();
            return contacts;
        }
        return contacts;
    }
    public Contact contact { get; set; }
    
    public List<IB_Programme__c> programmes { get; set; }
    public IB_Programme__c pypProgramme { get; set; }
    public IB_Programme__c mypProgramme { get; set; }
    public IB_Programme__c dpProgramme { get; set; }
    public IB_Programme__c ibccProgramme { get; set; }
    public Boolean hasPypProgramme { get; set; }
    public Boolean hasMypProgramme { get; set; }
    public Boolean hasDpProgramme { get; set; }
    public Boolean hasIbccProgramme { get; set; }

    public transient List<IB_Role__c> roles { get; set; }
    public IB_Role__c role { get; set; }
    public IB_Role__c primaryContactRole { get; set; }
    public IB_Role__c programmeContactRole { get; set; }
    public IB_Role__c billingContactRole { get; set; }
    public IB_Role__c examContactRole { get; set; }
    public IB_Role__c headOfSchoolContactRole { get; set; }

    public IB_Role__c headOfSchool { get; set; }
    public IB_Role__c pypPrimaryContact { get; set; }
    public IB_Role__c pypProgrammeCoordinator { get; set; }
    public IB_Role__c pypBillingContact { get; set; }
    public IB_Role__c pypHosContact { get; set; }

    public IB_Role__c mypPrimaryContact { get; set; }
    public IB_Role__c mypProgrammeCoordinator { get; set; }
    public IB_Role__c mypBillingContact { get; set; }
    public IB_Role__c mypHosContact { get; set; }

    public IB_Role__c dpPrimaryContact { get; set; }
    public IB_Role__c dpProgrammeCoordinator { get; set; }
    public IB_Role__c dpBillingContact { get; set; }
    public IB_Role__c dpHosContact { get; set; }

    public IB_Role__c ibccPrimaryContact { get; set; }
    public IB_Role__c ibccProgrammeCoordinator { get; set; }
    public IB_Role__c ibccBillingContact { get; set; }
    public IB_Role__c ibccHosContact { get; set; }

    public String candidacyDate { get; set; }
    public String authorizationDate { get; set; }
    
    public Static String acdamicYear;
    //This Part is being added by Ammara-Plumlogix on 02/10/2020,as part of CR-812
    //Begin
     public boolean EP_not_Authorize;
    //End

    public transient List<IB_Role_Repository__c> allRoles { get; set; }
    
    public DateUtility dateUtil {
        get{
            DateUtility util = new DateUtility();
            return util;
        }
    }

    //-Page Visibility
    public Boolean showPageDetails {get; set;}
    
    public Contact userContact {get; set;} 

	public String activeTab { get; set; }

    private ProfileService profileService = new ProfileService();
    
    public PimsProfileController() {
        
        try
        {
        	showSchoolRMLink = false;

		PimsCommunityService pimsService = new PimsCommunityService();
		pimsService.initUserData();

		account = pimsService.getCurrentAccount();
		profileService.account = account;
        userContact = pimsService.getCurrentContact();
		showPageDetails = pimsService.isMySchoolRole(account.Id,userContact.Id);
        //System.debug('DEMEG: Account Authorized_School__c: ' + account.Authorized_School__c);
        //this.isAuthorizedAccount = account.Authorized_School__c;

        ProgrammeService.setAccountId(account.Id);
		programmes = ProgrammeService.getProgrammesByAccount();
        
        AddressService.setAccountId(account.Id);
		addresses = AddressService.getAddressesByAccount();
        
        SchoolSectionsService.setAccountId(account.Id);
		sections = SchoolSectionsService.getSectionsByAccount();
        
        RoleService.setAccountId(account.Id);
        roles = RoleService.getRolesByAccountId();
        
        ContactService.setAccountId(account.Id);
        //contacts = ContactService.getContacts();
        
        
		//programmes = profileService.getProgrammes();
		//addresses = profileService.getAddresses();
		//sections = profileService.getSchoolSections();
        
        //List<Contact> contactsByAccount = 
    /* Written as part of CR966 - display the "My IB Contact" link if (the user's account is (a) an Authorized School and (b) the School Rel Mgr field is filled out) or AFC of any interested programme is in Submitted status */
		if(account.Authorized_School__c ){//removed && account.School_Relationship_Manager__c != null as that field isnt being used anymore BenMcGarvey INC
			showSchoolRMLink = true;
		}
		else{
			list<id> progIds = new list<id>();
			List<IB_Application__c> listApps = new List<IB_Application__c>();
			for (IB_Programme__c prog : programmes) {
				if(prog.Status__c.equalsIgnoreCase('Interested') || prog.Status__c.equalsIgnoreCase('Candidate')){
					progIds.add(prog.id);
				}
			}
			ApplicationService.setProgrammeIdList(progIds);
			listApps = ApplicationService.getApplicationsByProgrammeIds();
			for(IB_Application__c app : listApps){
				if(app.RecordType.Name == 'Application for Candidacy' && app.Status__c == 'Submitted'){
					showSchoolRMLink = true;
				}
			}
		}
        pypProgramme = new IB_Programme__c(Account__c = account.Id);
        mypProgramme = new IB_Programme__c(Account__c = account.Id);
        dpProgramme = new IB_Programme__c(Account__c = account.Id);
        ibccProgramme = new IB_Programme__c(Account__c = account.Id);
            
        Cookie pypProg = ApexPages.currentPage().getCookies().get('pypProgramme');
        if(pypProg<>null)
        	pypProgramme = (IB_Programme__c) JSON.deserialize(pypProg.getValue(), IB_Programme__c.class);
        
        Cookie mypProg = ApexPages.currentPage().getCookies().get('mypProgramme');
        if(mypProg<>null)
        	mypProgramme = (IB_Programme__c) JSON.deserialize(mypProg.getValue(), IB_Programme__c.class);
            
        Cookie dpProg = ApexPages.currentPage().getCookies().get('dpProgramme');
        if(dpProg<>null)
        	dpProgramme = (IB_Programme__c) JSON.deserialize(dpProg.getValue(), IB_Programme__c.class);
        
        Cookie ibccProg = ApexPages.currentPage().getCookies().get('ibccProgramme');
        if(ibccProg<>null)
        	ibccProgramme = (IB_Programme__c) JSON.deserialize(ibccProg.getValue(), IB_Programme__c.class);
            
        hasPypProgramme = profileService.hasProgramme(programmes, 'PYP');
        hasMypProgramme = profileService.hasProgramme(programmes, 'MYP');
        hasDpProgramme = profileService.hasProgramme(programmes, 'Diploma_Programme');
        hasIbccProgramme = profileService.hasProgramme(programmes, 'IBCC');

        

        //contactsByAccount = profileService.getContactsByAccount(account.Id);
        //roles = profileService.getRolesByAccount(account.Id);
        //contacts = profileService.getContactsByAccountAndRole(contactsByAccount, roles);

        contact = new Contact(AccountId = account.Id);
        role = new IB_Role__c();

        allRoles = profileService.getAllRolesFromRepository();
        System.debug('All Roles: '+allRoles.size());
        System.debug('Account: '+account);
            if(allRoles.size()>0){
                primaryContactRole = new IB_Role__c(IB_Account__c = account.Id, IB_Role__c = profileService.getRoleByName(allRoles, 'School Contact').Id); //'a0Xg0000002gSPT'
                programmeContactRole = new IB_Role__c(IB_Account__c = account.Id, IB_Role__c = profileService.getRoleByName(allRoles, 'Programme Coordinator').Id); //'a0Xg0000002gSPP');
                billingContactRole = new IB_Role__c(IB_Account__c = account.Id, IB_Role__c = profileService.getRoleByName(allRoles, 'Billing Contact').Id); //'a0Xg0000002gSPO');
                examContactRole = new IB_Role__c(IB_Account__c = account.Id, IB_Role__c = profileService.getRoleByName(allRoles, 'Exam Contact').Id); //'a0Xg0000002gSPREA2');
                headOfSchoolContactRole = new IB_Role__c(IB_Account__c = account.Id, IB_Role__c = profileService.getRoleByName(allRoles, 'Head of School').Id);
                
                Cookie pcRole = ApexPages.currentPage().getCookies().get('programmeContactRole');
                if(pcRole<>null)
                    programmeContactRole = (IB_Role__c) JSON.deserialize(pcRole.getValue(), IB_Role__c.class);
                
                Cookie bcRole = ApexPages.currentPage().getCookies().get('billingContactRole');
                if(bcRole<>null)
                    billingContactRole = (IB_Role__c) JSON.deserialize(bcRole.getValue(), IB_Role__c.class);
                
                Cookie ecRole = ApexPages.currentPage().getCookies().get('examContactRole');
                if(ecRole<>null)
                    examContactRole = (IB_Role__c) JSON.deserialize(ecRole.getValue(), IB_Role__c.class);
                
                Cookie hosRole = ApexPages.currentPage().getCookies().get('headOfSchoolContactRole');
                if(hosRole<>null)
                    headOfSchoolContactRole = (IB_Role__c) JSON.deserialize(hosRole.getValue(), IB_Role__c.class);
            }
        headOfSchool = profileService.getContactRoleByProgrammeAndType(account.Id, roles, 'PYP', 'Head of School (Overall)');
        pypPrimaryContact = profileService.getContactRoleByProgrammeAndType(account.Id, roles, 'PYP', 'School Contact');
        pypProgrammeCoordinator = profileService.getContactRoleByProgrammeAndType(account.Id, roles, 'PYP', 'Programme Coordinator');
        pypBillingContact = profileService.getContactRoleByProgrammeAndType(account.Id, roles, 'PYP', 'Billing Contact');
        pypHosContact = profileService.getContactRoleByProgrammeAndType(account.Id, roles, 'PYP', 'Head of School');

        mypPrimaryContact = profileService.getContactRoleByProgrammeAndType(account.Id, roles, 'MYP', 'School Contact');
        mypProgrammeCoordinator = profileService.getContactRoleByProgrammeAndType(account.Id, roles, 'MYP', 'Programme Coordinator');
        mypBillingContact = profileService.getContactRoleByProgrammeAndType(account.Id, roles, 'MYP', 'Billing Contact');
        mypHosContact = profileService.getContactRoleByProgrammeAndType(account.Id, roles, 'MYP', 'Head of School');

        dpPrimaryContact = profileService.getContactRoleByProgrammeAndType(account.Id, roles, 'Diploma_Programme', 'School Contact');
        dpProgrammeCoordinator = profileService.getContactRoleByProgrammeAndType(account.Id, roles, 'Diploma_Programme', 'Programme Coordinator');
        dpBillingContact = profileService.getContactRoleByProgrammeAndType(account.Id, roles, 'Diploma_Programme', 'Billing Contact');
        dpHosContact = profileService.getContactRoleByProgrammeAndType(account.Id, roles, 'Diploma_Programme', 'Head of School');
        
        ibccPrimaryContact = profileService.getContactRoleByProgrammeAndType(account.Id, roles, 'IBCC', 'School Contact');
        ibccProgrammeCoordinator = profileService.getContactRoleByProgrammeAndType(account.Id, roles, 'IBCC', 'Programme Coordinator');
        ibccBillingContact = profileService.getContactRoleByProgrammeAndType(account.Id, roles, 'IBCC', 'Billing Contact');
        ibccHosContact = profileService.getContactRoleByProgrammeAndType(account.Id, roles, 'IBCC', 'Head of School');

        candidacyDate = profileService.getCandidacyDate(account);
        authorizationDate = profileService.getAuthorizationDate(account);
        }
        Catch(Exception x)
        {
            System.debug('Exception: '+x);
        }

	}

    public void init() {
	try
    {
		PageService.setPage('PimsProfileNew');
		activeTab = PageService.getActiveTab();
        
        // we should never fall into here, but just in case show the info tab panel
        if (activeTab == null) {
            activeTab = 'info';
        }
    }
        Catch(Exception x)
        {
            System.debug('Exception: '+x);
        }

    }

    public void initUpdate() {
        try{
		PageService.setPage('PimsProfile');
		activeTab = PageService.getActiveTab();
        
        // we should never fall into here, but just in case show the info tab panel
        if (activeTab == null) {
            activeTab = 'info';
        }
        }
        Catch(Exception x)
        {
            System.debug('Exception: '+x);
        }
    }

	
	
    /*public boolean getInfoStatus() {
        PimsCommunityService pimsService = new PimsCommunityService();
		pimsService.initUserData();
    	account = pimsService.getCurrentAccount();
        return account.PIMS_Step_1__c;
        //return profileService.getProfileFormStatus('info');
    }

    public boolean getAddressStatus() {
    	return profileService.getProfileFormStatus('address');
    }

    public boolean getSectionStatus() {
    	return profileService.getProfileFormStatus('section');
    }

    public boolean getContactStatus() {
    	return profileService.getProfileFormStatus('contact');
    }

    public boolean getIntentStatus() {
    	return profileService.getProfileFormStatus('intent');
    }*/

    public boolean getDisplayNextStepsTab() {
    	if (profileService.getProfileFormStatus('info') && profileService.getProfileFormStatus('address') && profileService.getProfileFormStatus('section') && profileService.getProfileFormStatus('contact') && profileService.getProfileFormStatus('intent')) {
    		return true;
    	}
    	else {
    		return false;
    	}
    }

    @RemoteAction
    public static List<String> lookupSchoolGroups(String searchTerm) {

        AccountDAO accountData = AccountDAO.getInstance();
        List<Account> accountList = accountData.searchAccountsByNameAndType(searchTerm, 'Groups of Schools');
        List<String> accounts = new List<String>();
        for (Account x : accountList) {
            accounts.add(x.Name+':'+x.IBIS_ID__c);
        }
        return accounts;

    }

    @RemoteAction
    public static List<String> lookupSchoolAssociations(String searchTerm) {

        AccountDAO accountData = AccountDAO.getInstance();
        List<Account> accountList = accountData.searchAccountsByNameAndType(searchTerm, 'IB World Schools Association Account');
        List<String> accounts = new List<String>();
        for (Account x : accountList) {
            accounts.add(x.Name);
        }
        return accounts;

    }

    public Integer getCalculcatedFormStatus() {
        Map<String,Boolean> formStatus = new Map<String,Boolean>();
        formStatus.put('PIMS_Step_1', account.PIMS_Step_1__c);
        formStatus.put('PIMS_Step_2', account.PIMS_Step_2__c);
        formStatus.put('PIMS_Step_3', account.PIMS_Step_3__c);
        formStatus.put('PIMS_Step_4', account.PIMS_Step_4__c);  
        //This Part of Code is being added by Ammara-Plumlogix, as part of CR-812
        //begin
        if(getEP_not_Authorize() == true)//end
          formStatus.put('PIMS_Step_5', account.PIMS_Step_5__c);
        
        Decimal total = 0;
		Decimal done = 0;

		for (boolean val : formStatus.values()) {
			total++;
			if (val == true) {
				done++;
			}
		}

		Decimal calculcated = (done / total) * 100;

		return calculcated.intValue();
        
        
        
        
    	//return profileService.calculateFormCompletion();
    } 
    //This Part of Code is being added by Ammara-Plumlogix, as part of CR-812
    //begin
    public boolean getEP_not_Authorize(){
          List<IB_Programme__c> EP_Programme = new List<IB_Programme__c>();
                              EP_Programme = [select id,RecordType.DeveloperName,status__c from IB_Programme__c where RecordType.DeveloperName ='European_Platform' 
                                              AND Account__c =:account.id
                                              AND status__c != 'Withdrawn' AND status__c != 'Terminated' AND status__c != 'Terminated by School' 
                                              AND status__c != 'Terminated by IB' AND status__c != 'Withdrawn by School' AND status__c != 'Withdrawn by IB'];  
        System.debug('EP Size: '+EP_Programme.size());
        if(EP_Programme.size()>0)
            return false;
        else
            return true;

    }
    //End
    public boolean getPageHasErrors() {
   		return ApexPages.hasMessages();
   	}
	
}