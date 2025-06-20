/*******************************************************************************************
* @Name         ProfileService 
* @Author       
* @Date         
* @Group        
* @Description  
*******************************************************************************************/
/* MODIFICATION LOG
* Version          Developer          Date               Description
*-------------------------------------------------------------------------------------------
*  1.0              Michael Khan      04/24/2023         To reduce the view state we have declared "accountData" and "contactData" as transient and added getter and setter and commented the instantiation code from code
*******************************************************************************************/
public class ProfileService {
    
    public Account account { get; set; }
    
    private transient AccountDAO accountData{
        get{
            if(accountData== null){
                accountData = AccountDAO.getInstance();
            }
            return accountData;
        } 
        set;}
    private UserDAO userData                   = UserDAO.getInstance();
    private transient ContactDAO contactData{ 
        get{
            if(contactData== null){
                contactData = ContactDAO.getInstance();
            }
            return contactData;
        } 
        set;}
    
    private AddressDAO addressData             = AddressDAO.getInstance();
    private SchoolSectionsDAO sectionsData     = SchoolSectionsDAO.getInstance();
    private CountrySegmentationDAO countryData = CountrySegmentationDAO.getInstance();
    private transient RoleDAO roleData {
        get{
            if(roleData== null){
                roleData = RoleDAO.getInstance();
            }
            return roleData;
        } 
        set;}                  
    private ProgrammeDAO programmeData         = ProgrammeDAO.getInstance();
    private transient RoleRepositoryDAO roleRepoData;
    
    private Map<String,Boolean> progStatus = new Map<String,Boolean>();
    private Map<String,Boolean> formStatus = new Map<String,Boolean>();
    
    public static List<IB_Role_Repository__c> roleRepo = null;
    public static List<SchoolSections__c> sectionList = new List<SchoolSections__c>();
    
    public ProfileService() {
        
        try {
            
            formStatus.put('info', false);
            formStatus.put('address', false);
            formStatus.put('section', false);
            formStatus.put('contact', false);
            formStatus.put('intent', false);
            
            progStatus.put('display', false);
            progStatus.put('pyp', false);
            progStatus.put('myp', false);
            progStatus.put('dp', false);
            progStatus.put('ibcc', false);
            
        } Catch(Exception x) {
            System.debug('Exception: '+x);
        }
        
    }
    
    public List<IB_Programme__c> getProgrammes() {
        
        try {
            
            ProgrammeService.setAccountId(account.Id);
            return ProgrammeService.getProgrammesByAccount();
            
        } Catch(Exception x) {
            
            System.debug('Exception: '+x);
            return NULL;
            
        }
        
    }
    
    public List<Ib_Address__c> getAddresses() {
        
        try {
            
            AddressService.setAccountId(account.Id);
            return AddressService.getAddressesByAccount();
            
        } Catch(Exception x) {
            
            System.debug('Exception: '+x);
            return NULL;
            
        }
        
    }
    
    public List<SchoolSections__c> getSchoolSections() {
        
        try {
            
            SchoolSectionsService.setAccountId(account.Id);
            return SchoolSectionsService.getSectionsByAccount();
            
        } Catch(Exception x) {
            
            System.debug('Exception: '+x);
            return NULL;
            
        }
        
    }
    
    public Account getProfileAccount() {
        
        try {
            
            User user = userData.getCurrentUser();
            Contact contact = contactData.getContactByUserId(user.ContactId);
            Account account = accountData.getAccountById(contact.AccountId);
            
            if (account.PIMS_Step_1__c == true) formStatus.put('info', true);
            if (account.PIMS_Step_2__c == true) formStatus.put('address', true);
            if (account.PIMS_Step_3__c == true) formStatus.put('section', true);
            if (account.PIMS_Step_4__c == true) formStatus.put('contact', true);
            if (account.PIMS_Step_5__c == true) formStatus.put('intent', true);
            
            return account;
            
        } catch(exception e) { 
            
            system.debug('exception'+e);
            return Null;
            
        }
        
    }
    
    public List<Ib_Address__c> getAddressesByProgramme(String programme, List<IB_Programme__c> programmes, List<Ib_Address__c> addresses) {
        
        try {
            
            ID recTypeID = Schema.SObjectType.IB_Programme__c.getRecordTypeInfosByDeveloperName().get(programme).getRecordTypeId();
            
            List<Ib_Address__c> addressList = new List<Ib_Address__c>();
            
            for (IB_Programme__c p : programmes) {
                
                if (p.RecordTypeId == recTypeID) {
                    
                    for (Ib_Address__c a : addresses) {
                        
                        if (p.Postal_Address__c == a.Id) addressList.add(a);
                        if (p.Street_Address__c == a.Id) addressList.add(a);
                        if (p.Billing_Address__c == a.Id) addressList.add(a);
                        if (p.Exam_Address__c == a.Id) addressList.add(a);
                        
                    }
                }
            }
            
            return addressList;
            
        } Catch(Exception x) {
            
            System.debug('Exception: '+x);
            return NULL;
            
        }
        
    }
    
    public IB_Address__c getAddressByTypeAndAccount(String type, Id accountId) {
        
        try {
            
            return addressData.getAddressByTypeAndAccount(type, accountId);
            
        } Catch(Exception x) {
            
            System.debug('Exception: '+x);
            return NULL;
            
        }
        
    }
    
    public List<IB_Address__c> getAllAddressesByAccount(Id accountId) {
        
        try {
            
            return addressData.getAllAddressesByAccount(accountId);
            
        } Catch(Exception x) {
            
            System.debug('Exception: '+x);
            return NULL;
            
        }
        
    }
    
    public List<SelectOption> getAddressOptions(Id accountId) {
        
        try {
            
            List<SelectOption> options = new List<SelectOption>();
            List<Ib_Address__c> addresses = addressData.getAllAddressesByAccount(accountId);
            
            for (Ib_Address__c address : addresses) {
                
                String addressOption = address.Name + ' - ' + address.Address_Line_1__c;
                
                if(address.City__c != null)	addressOption = addressOption + ' / ' + address.City__c;
                if(address.Province__c != null) addressOption = addressOption + ' / ' + address.Province__c;
                if(address.Postal_Code__c != null) addressOption = addressOption + ' / ' + address.Postal_Code__c;
                
                options.add(new SelectOption(address.Id, addressOption));
                //address.Name + ' - ' + address.Address_Line_1__c + ' / ' + address.City__c + ' / ' + address.Province__c + ' / ' + address.Postal_Code__c));
            }
            
            return options;
            
        } Catch(Exception x) {
            
            System.debug('Exception: '+x);
            return NULL;
            
        }
        
    }
    
    public List<SelectOption> getAddressCountries() {
        
        try {
            
            List<SelectOption> options = new List<SelectOption>();
            List<IB_Country_Segmentation__c> countries = countryData.getAllCountries();
            
            for (IB_Country_Segmentation__c country : countries) {
                if (UserInfo.getLanguage() == 'es' && country.Country_es__c != null) options.add(new SelectOption(country.id, country.Country_es__c));
                else if (UserInfo.getLanguage() == 'fr' && country.Country_fr__c != null) options.add(new SelectOption(country.id, country.Country_fr__c));
                else options.add(new SelectOption(country.id, country.name));
            }
            
            return options;
            
        } Catch(Exception x) {
            
            System.debug('Exception: '+x);
            return NULL;
            
        }
        
    }
    
    public boolean validateAddresses(Id accountId) {
        
        try {
            
            List<IB_Address__c> addresses = addressData.getAllAddressesByAccount(accountId);
            Integer cnt = 0;
            
            for (IB_Address__c address : addresses) {
                if ((address.Name == 'Postal') || (address.Name == 'Street')) cnt++;
            }
            
            if (cnt == 2) return true;
            else return false;
            
        } Catch(Exception x) {
            
            System.debug('Exception: '+x);
            return NULL;
            
        }
        
    }
    
    public boolean validateSections(Id accountId) {
        
        try {
            
            List<SchoolSections__c> sections = sectionsData.getSchoolSectionsByAccountId(accountId);
            if (sections.size() > 0) return true;
            else return false;
            
        } Catch(Exception x) {
            
            System.debug('Exception: '+x);
            return NULL;
            
        }
        
    }
    
    public List<Contact> getContactsByAccount(Id accountId) {
        
        try {
            return contactData.getContactsByAccountId(accountId);
            
        } Catch(Exception x) {
            
            System.debug('Exception: '+x);
            return NULL;
            
        }
        
    }
    
    public List<SelectOption> getContactOptions(Id accountId) {
        
        try {
            
            List<SelectOption> options = new List<SelectOption>();
            List<Contact> contacts = contactData.getContactsByAccountId(accountId);
            options.add(new SelectOption('', ''));
            
            for (Contact contact : contacts){
                options.add(new SelectOption(contact.Id, contact.LastName + ', ' + contact.FirstName));
            }
            
            List<Contact> contacts2 = contactData.getContactsByAccountHOSPCNoDirectRelation(accountId);
			if(contacts2!=null){
			for (Contact contact : contacts2){
                options.add(new SelectOption(contact.Id, contact.LastName + ', ' + contact.FirstName));
            }
            }
            return options;
            
        } Catch(Exception x) {
            
            System.debug('Exception: '+x);
            return NULL;
            
        }
        
    }
    
    public List<Contact> getContactsByAccountAndRole(List<Contact> contacts, List<IB_Role__c> roles) {
        
        try {
            
            List<Contact> allContacts = new List<Contact>();
            Set<Id> contactIdSet = new Set<Id>();
            
            for (Contact contact : contacts) {
                contactIdSet.add(contact.Id);
            }
            
            for (IB_Role__c role : roles) {
                contactIdSet.add(role.IB_Contact__c);
            }
            return contactData.getContactsByContactIdList(contactIdSet);
            
        } Catch(Exception x) {
            System.debug('Exception: '+x);
            return NULL;
        }
        
    }
    
    public List<IB_Role__c> getRolesByAccount(Id accountId) {
        
        try {
            
            return roleData.getRolesByAccountId(accountId);
            
        } Catch(Exception x) {
            
            System.debug('Exception: '+x);
            return NULL;
            
        }
        
    }
    
    public List<IB_Role__c> getRolesByContactList(List<Contact> contacts) {
        
        try {
            
            List<Id> contactIds = new List<Id>();
            
            for (Contact con : contacts) {
                contactIds.add(con.Id);
            }
            
            List<IB_Role__c> roles = roleData.getRolesByContacts(contactIds);
            
            return roles;
            
        } Catch(Exception x) {
            System.debug('Exception: '+x);
            return NULL;
        }
        
    }
    
    public List<IB_Role__c> getRolesByContactListAndAccount(List<Contact> contacts, Id accountId) {
        
        try {
            
            List<Id> contactIds = new List<Id>();
            
            for (Contact con : contacts) {
                contactIds.add(con.Id);
            }
            
            List<IB_Role__c> roles = roleData.getRolesByContactAndAccount(contactIds, accountId);
            
            return roles;
            
        } Catch(Exception x) {
            
            System.debug('Exception: '+x);
            return NULL;
            
        }
        
    }
    
    public List<SelectOption> getContactOptions(List<Contact> contacts) {
        
        try {
            
            List<SelectOption> options = new List<SelectOption>();
            options.add(new SelectOption('', ''));
            
            for (Contact contact : contacts){
                options.add(new SelectOption(contact.Id, contact.Name));
            }
            
            return options;
            
        } Catch(Exception x) {
            
            System.debug('Exception: '+x);
            return NULL;
            
        }
        
    }
    
    public IB_Programme__c getProgrammeByType(List<IB_Programme__c> programmes, String programme) {
        
        try {
            
            IB_Programme__c prog = new IB_Programme__c();
            
            ID recTypeID = Schema.SObjectType.IB_Programme__c.getRecordTypeInfosByDeveloperName().get(programme).getRecordTypeId();
            
            for (IB_Programme__c p : programmes) {
                if (p.RecordTypeId == recTypeID) prog = p;
            }
            
            // we want to treat MYP Partner as MYP
            if (prog.Id == null && programme == 'MYP') {
                
                recTypeID = Schema.SObjectType.IB_Programme__c.getRecordTypeInfosByDeveloperName().get('MYP_Partner').getRecordTypeId();
                
                for (IB_Programme__c p : programmes) {
                    if (p.RecordTypeId == recTypeID) prog = p;
                }
                
            }
            
            return prog;
            
        } Catch(Exception x) {
            
            System.debug('Exception: '+x+'line no in class ProfileService**'+x.getLineNUmber()+'cause**'+x.getCause());
            return NULL;
            
        }
        
    }
    
    public Boolean hasProgramme(List<IB_Programme__c> programmes, String programme) {
        
        try {
            
            Boolean has = false;
            
            ID recTypeID = Schema.SObjectType.IB_Programme__c.getRecordTypeInfosByDeveloperName().get(programme).getRecordTypeId();
            
            for (IB_Programme__c p : programmes) {
               if (p.RecordTypeId == recTypeID) has = true;
                //if (p.RecordTypeId == recTypeID && p.Status__c<>null && !p.Status__c.contains('Terminated') && !p.Status__c.contains('Withdrawn')) has = true;
            }
            
            // we want to treat MYP Partner as MYP
            if (!has && programme == 'MYP') {
                
                recTypeID = Schema.SObjectType.IB_Programme__c.getRecordTypeInfosByDeveloperName().get('MYP_Partner').getRecordTypeId();
                
                for (IB_Programme__c p : programmes) {
                    if (p.RecordTypeId == recTypeID) has = true;
                    //if (p.RecordTypeId == recTypeID && p.Status__c<>null && !p.Status__c.contains('Terminated') && !p.Status__c.contains('Withdrawn')) has = true;
                }
                
            }
            
            return has;
            
        } Catch(Exception x) {
            
            System.debug('Exception: '+x);
            return NULL;
            
        }
        
    }
    
    //The following code is updated by Shehryar-plumlogix for US12330 sprint 26 on 09/07/2021
    //The code updated for only "grade from" field
    //start  
    public boolean getIntentStatus(Id accountId, String programme) {
        
        try {
            
            Integer minGrade;
            
            if (sectionList == null || sectionList.isEmpty() || sectionList.size()<=0) {
                
                sectionList = getSchoolSectionsbyAccountforCurrentYear(accountId);
                
            }
            
            for (SchoolSections__c sec : sectionList) {
                
                if (!sec.Grade_From__c.isNumeric()) {
                    
                    minGrade = 0;
                    
                } else {
                    
                    minGrade = Integer.valueOf(sec.Grade_From__c);
                    
                }
                
                if (programme == 'PYP') {
                    
                    if (minGrade <= 5 ) return true;
                    
                } else if (programme == 'MYP') {
                    
                    if (minGrade>=5 && minGrade <= 10 ) return true;
                    
                } else if (programme == 'DP' || programme == 'CP') {
                    
                    if (minGrade>10 && minGrade <= 13) return true;
                    
                }
                
            }
            
            return false;
            
        } Catch(Exception x) {
            
            System.debug('Exception: '+x);
            return NULL;
            
        }
        
    }
    
    public List<SchoolSections__c> getSchoolSectionsbyAccountforCurrentYear(Id accountId){
        
        return sectionsData.getSchoolSectionsByAccountIdForCurrentYear(accountId);
        
    }
    
    public String getActiveTab() {
        
        try {
            
            Cookie activeTabCookie = ApexPages.currentPage().getCookies().get('profile_tab');
            String anchor = ApexPages.currentPage().getAnchor();
            String activeTab = 'info';
            
            if (anchor != null) {
                
                activeTab = anchor;
                activeTabCookie = new Cookie('profile_tab', activeTab, null, -1, false);
                ApexPages.currentPage().setCookies(new Cookie[]{activeTabCookie});
                
            } else {
                
                if (activeTabCookie == null) {
                    
                    activeTabCookie = new Cookie('profile_tab', activeTab, null, -1, false);
                    ApexPages.currentPage().setCookies(new Cookie[]{activeTabCookie});
                    
                } else {
                    
                    activeTab = activeTabCookie.getValue();
                    
                }
                
            }
            
            return activeTab;
            
        } Catch(Exception x) {
            
            System.debug('Exception: '+x);
            return NULL;
            
        }
        
    }
    
    public void setActiveTab(String tab) {
        
        try {
            
            Cookie activeTabCookie = new Cookie('profile_tab', tab, null, -1, false);
            ApexPages.currentPage().setCookies(new Cookie[]{activeTabCookie});
            
        } Catch(Exception x) {
            
            System.debug('Exception: '+x);
            
        }
        
    }
    
    public boolean getProfileFormStatus(String panel) {
        
        try {
            
            return formStatus.get(panel);
            
        } Catch(Exception x) {
            
            System.debug('Exception: '+x);
            return NULL;
            
        }
        
    }
    
    public Integer calculateFormCompletion() {
        
        try {
            
            Decimal total = 0;
            Decimal done = 0;
            
            for (boolean val : formStatus.values()) {
                total++;
                if (val == true) done++;
            }
            
            Decimal calculcated = (done / total) * 100;
            
            return calculcated.intValue();
            
        } Catch(Exception x) {
            
            System.debug('Exception: '+x);
            return NULL;
            
        }
        
    }
    
    public IB_Role__c getContactRoleByProgrammeAndType(Id accountId, List<IB_Role__c> roles, String programme, String roleName) {
        
        try {
            
            if (programme.equalsIgnoreCase('CP')) {
                programme = 'IBCC';
            }
            
            IB_Role__c role;
            
            ID recTypeID = Schema.SObjectType.IB_Programme__c.getRecordTypeInfosByDeveloperName().get(programme).getRecordTypeId();
            
            for (IB_Role__c r : roles) {
                
                if ((r.IB_Role_Name__c == roleName) && (roleName == 'Head of School (Overall)')){
                    
                    role = r;
                    
                } else if ((r.IB_Role_Name__c == roleName) && (r.IB_Programme_New__r.RecordTypeId == recTypeID)) {
                    
                    role = r;
                    
                }
                
            }
            
            if (role == null) {
                
                if (roleRepo == null) {
                    roleRepo = getAllRolesFromRepository();
                }
                
                role = new IB_Role__c( IB_Account__c = accountId );
                
                role.IB_Role__c = getRoleByName(roleRepo, roleName).Id;
            }
            
            role.Active__c = true;
            
            return role;
            
        } Catch(Exception x) {
            
            System.debug('Exception: '+x);
            return NULL;
            
        }
        
    }
    
    public Map<String,List<IB_Role__c>> getContactRoleByProgrammeAndTypeforAdmin(Id accountId, List<IB_Role__c> roles) {
        
        string ROLE_ADMIN = 'Admin Assistant';
        
        ID dpRecTypeID = Schema.SObjectType.IB_Programme__c.getRecordTypeInfosByDeveloperName().get('Diploma_Programme').getRecordTypeId();
        ID mypRecTypeID = Schema.SObjectType.IB_Programme__c.getRecordTypeInfosByDeveloperName().get('MYP').getRecordTypeId();
        ID pypRecTypeID = Schema.SObjectType.IB_Programme__c.getRecordTypeInfosByDeveloperName().get('PYP').getRecordTypeId();
        ID ibccRecTypeID = Schema.SObjectType.IB_Programme__c.getRecordTypeInfosByDeveloperName().get('IBCC').getRecordTypeId();
        ID agreementRecTypeID = Schema.SObjectType.IB_Programme__c.getRecordTypeInfosByDeveloperName().get('Agreement').getRecordTypeId();/** Agreement phase 2 ****/
        
        Map<String,List<IB_Role__c>> programToAdminRolesMap = new Map<String,List<IB_Role__c>>();
        
        for ( IB_Role__c role : roles ) {
            
            if ( (role.IB_Role_Name__c == ROLE_ADMIN) && (role.IB_Programme_New__r.RecordTypeId == mypRecTypeID) && (role.IB_Contact__c != null) ) {
                
                List<IB_Role__c> mypAdminRolesList = new List<IB_Role__c>();
                
                if (programToAdminRolesMap.get('MYP') != null) {
                    
                    mypAdminRolesList.addAll(programToAdminRolesMap.get('MYP'));
                    mypAdminRolesList.add(role);
                    programToAdminRolesMap.put('MYP', mypAdminRolesList);
                    
                } else {
                    
                    mypAdminRolesList.add(role);
                    programToAdminRolesMap.put('MYP', mypAdminRolesList);
                    
                }                
                
            } else if ( (role.IB_Role_Name__c == ROLE_ADMIN) && (role.IB_Programme_New__r.RecordTypeId == pypRecTypeID) && (role.IB_Contact__c != null) ) {
                
                List<IB_Role__c> pypAdminRolesList = new List<IB_Role__c>();
                
                if (programToAdminRolesMap.get('PYP') != null) {
                    
                    pypAdminRolesList.addAll(programToAdminRolesMap.get('PYP'));
                    pypAdminRolesList.add(role);
                    programToAdminRolesMap.put('PYP', pypAdminRolesList);
                    
                } else {
                    
                    pypAdminRolesList.add(role);
                    programToAdminRolesMap.put('PYP', pypAdminRolesList);
                    
                }
                
            } else if ( (role.IB_Role_Name__c == ROLE_ADMIN) && (role.IB_Programme_New__r.RecordTypeId == dpRecTypeID) && (role.IB_Contact__c != null) ) {
                
                List<IB_Role__c> dpAdminRolesList = new List<IB_Role__c>();
                
                if (programToAdminRolesMap.get('DP') != null) {
                    
                    dpAdminRolesList.addAll(programToAdminRolesMap.get('DP'));
                    dpAdminRolesList.add(role);
                    programToAdminRolesMap.put('DP', dpAdminRolesList);
                    
                } else {
                    
                    dpAdminRolesList.add(role);
                    programToAdminRolesMap.put('DP', dpAdminRolesList);
                    
                }
                
            } /** Agreement phase 2 ****/
            else if ( (role.IB_Role_Name__c == ROLE_ADMIN) && (role.IB_Programme_New__r.RecordTypeId == agreementRecTypeID) && (role.IB_Contact__c != null) ) {
                
                List<IB_Role__c> agreementAdminRolesList = new List<IB_Role__c>();
                
                if (programToAdminRolesMap.get('Agreement') != null) {
                    
                    agreementAdminRolesList.addAll(programToAdminRolesMap.get('Agreement'));
                    agreementAdminRolesList.add(role);
                    programToAdminRolesMap.put('Agreement', agreementAdminRolesList);
                    
                } else {
                    
                    agreementAdminRolesList.add(role);
                    programToAdminRolesMap.put('Agreement', agreementAdminRolesList);
                    
                }
                
            }/** End of Agreement phase 2 ****/
            else if ( (role.IB_Role_Name__c == ROLE_ADMIN) && (role.IB_Programme_New__r.RecordTypeId == ibccRecTypeID) && (role.IB_Contact__c != null) ) {
                
                List<IB_Role__c> ibccAdminRolesList = new List<IB_Role__c>();
                
                if (programToAdminRolesMap.get('IBCC') != null) {
                    
                    ibccAdminRolesList.addAll(programToAdminRolesMap.get('IBCC'));
                    ibccAdminRolesList.add(role);
                    programToAdminRolesMap.put('IBCC', ibccAdminRolesList);
                    
                } else {
                    
                    ibccAdminRolesList.add(role);
                    programToAdminRolesMap.put('IBCC', ibccAdminRolesList);
                    
                }
                
            }
            
        }
        
        return programToAdminRolesMap;
        
    }    
    
    public String getCandidacyDate(Account acc) {
        
        try {
            
            Date today = Date.today();
            Date canDate;
            Integer daysBetween;
            
            if (acc.Academic_Start_Month__c == 'August' || acc.Academic_Start_Month__c == 'September') {
                
                daysBetween = today.daysBetween(Date.newInstance(today.year(), 4, 1));
                
                if (daysBetween >= 0) {
                    
                    canDate = Date.newInstance(today.year(), 4, 1);
                    
                } else {
                    
                    canDate = Date.newInstance(today.year()+1, 4, 1);
                    
                }
                
            } else if (acc.Academic_Start_Month__c == 'February' || acc.Academic_Start_Month__c == 'March') {
                
                daysBetween = today.daysBetween(Date.newInstance(today.year(), 4, 1));
                
                if (daysBetween >= 0) {
                    
                    canDate = Date.newInstance(today.year(), 10, 1);
                    
                } else {
                    
                    canDate = Date.newInstance(today.year()+1, 10, 1);
                    
                }
                
            } else {
                
                daysBetween = today.daysBetween(Date.newInstance(today.year(), 4, 1));
                
                if (daysBetween >= 0) {
                    
                    canDate = Date.newInstance(today.year(), 4, 1);
                    
                } else {
                    
                    canDate = Date.newInstance(today.year()+1, 4, 1);
                    
                }
                
            }
            
            return canDate.format();
            
        } Catch(Exception x) {
            
            System.debug('Exception: '+x);
            return NULL;
            
        }
        
    }
    
    public String getAuthorizationDate(Account acc) {
        
        try {
            
            Date today = Date.today();
            Date authDate;
            Integer daysBetween;
            
            if (acc.Academic_Start_Month__c == 'August' || acc.Academic_Start_Month__c == 'September') {
                
                daysBetween = today.daysBetween(Date.newInstance(today.year(), 4, 1));
                
                if (daysBetween >= 0) {
                    
                    authDate = Date.newInstance(today.year(), 4, 1);
                    
                } else {
                    
                    authDate = Date.newInstance(today.year()+1, 4, 1);
                    
                }
                
            } else if (acc.Academic_Start_Month__c == 'February' || acc.Academic_Start_Month__c == 'March') {
                
                daysBetween = today.daysBetween(Date.newInstance(today.year(), 4, 1));
                
                if (daysBetween >= 0) {
                    
                    authDate = Date.newInstance(today.year(), 10, 1);
                    
                } else {
                    
                    authDate = Date.newInstance(today.year()+1, 10, 1);
                    
                }
                
            } else {
                
                daysBetween = today.daysBetween(Date.newInstance(today.year(), 4, 1));
                
                if (daysBetween >= 0) {
                    
                    authDate = Date.newInstance(today.year(), 4, 1);
                    
                } else {
                    
                    authDate = Date.newInstance(today.year()+1, 4, 1);
                    
                }
                
            }
            
            authDate = authDate.addMonths(30);
            return authDate.format();
            
        } Catch(Exception x) {
            
            System.debug('Exception: '+x);
            return NULL;
            
        }
        
    }
    
    public List<IB_Role_Repository__c> getAllRolesFromRepository() {
        
        try {
            if(null == roleRepoData)
                roleRepoData = RoleRepositoryDAO.getInstance();
            return roleRepoData.getAllRoles();
            
        } Catch(Exception x) {
            
            System.debug('Exception: '+x);
            return NULL;
        }
        
    }
    
    public IB_Role_Repository__c getRoleByName(List<IB_Role_Repository__c> roles, String name) {
        
        try {
            
            for (IB_Role_Repository__c role : roles) {
                
                if (role.Role_Name__c == name) return role;
                
            }
            
            return null;
            
        } Catch(Exception x) {
            
            System.debug('Exception: '+x);
            return NULL;
            
        }
        
    }
    
}