public class PimsDashboardController {
    
    //controller
    public Account account { get; set; }
    public List<IB_Address__c> addresses { get; set; }
    public IB_Address__c address {get; set;}
    
    public List<Contact> contacts { get; set; }
    public Contact contact { get; set; }
    public Contact userContact {get; set;}
    
    public List<IB_Role__c> roles { get; set; }
    public IB_Role__c role { get; set; }
    public IB_Role__c primaryContactRole { get; set; }
    public IB_Role__c programmeContactRole { get; set; }
    public IB_Role__c billingContactRole { get; set; }
    public IB_Role__c examContactRole { get; set; }
    public IB_Role__c headOfSchoolContactRole { get; set; }
    
    
    public List<IB_Programme__c> programmes { get; set; }
    public Boolean hasPypProgramme { get; set; }
    public Boolean hasMypProgramme { get; set; }
    public Boolean hasDpProgramme { get; set; }
    public Boolean hasIbccProgramme { get; set; }
    public Boolean hasAgreementProgramme   { get; set; }// added for 635 phase 2 
    
    public Boolean pypHasOpenAFA { get; set; }
    public Boolean mypHasOpenAFA { get; set; }
    public Boolean dpHasOpenAFA { get; set; }
    public Boolean ibccHasOpenAFA { get; set; }
    
    public IB_Programme__c pypProgramme { get; set; }
    public IB_Programme__c mypProgramme { get; set; }
    public IB_Programme__c dpProgramme { get; set; }
    public IB_Programme__c ibccProgramme { get; set; }
    
    //keeps true false for Chatter Button Visibility
    public Boolean pypHasChatterEnabled { get; set; }
    public Boolean mypHasChatterEnabled { get; set; }
    public Boolean dpHasChatterEnabled { get; set; }
    public Boolean ibccHasChatterEnabled { get; set; }
    
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
    public IB_Consultant_Feedback__c pimsConsultationFeedback {get;set;}
    
    public List<IB_Role_Repository__c> allRoles { get; set; }
    
    public DateUtility dateUtil {
        get{
            DateUtility util = new DateUtility();
            return util;
        }
    }
    
    public IB_Programme__c pyp {
        get {
            return profileService.getProgrammeByType(programmes, 'PYP');
        }
    }
    public IB_Programme__c myp {
        get {
            return profileService.getProgrammeByType(programmes, 'MYP');
        }
    }
    public IB_Programme__c dp {
        get {
            return profileService.getProgrammeByType(programmes, 'Diploma_Programme');
        }
    }
    public IB_Programme__c ibcc {
        get {
            return profileService.getProgrammeByType(programmes, 'IBCC');
        }
    }
    
    //getter setter campaign ID for programs
    public ID pypCampID { get; set;}
    public ID mypCampID { get; set;}
    public ID dpCampID { get; set;}
    public ID ibccCampID { get; set;}
    
    //-Page Visibility
    public Boolean showPageDetails {get; set;}
    
    private ProfileService profileService = new ProfileService();
    
    //Addded by kashyap ECM00692
    public List<ProgrammeWrapper> programmeWraperList{ get; set; } 
    private final List<String> constantList = new List<String>{IboUtil.Pims_Programme_Status,IboUtil.Pims_IB_Programme,IboUtil.Pims_IB_staff_contact_information};
    private final List<String> statusList= new List<String>{'Interested', 'Candidate', 'Authorized','Pending'} ;    // added as part of bug fix-agreement phase 2
        
        
    public String programmeStatus {
            get {
                return this.getTranslationsMap().get(IboUtil.Pims_Programme_Status);
            }
            set;
        }
    
    public String ibProgramme {
        get {
            return this.getTranslationsMap().get(IboUtil.Pims_IB_Programme);
        }
        set;
    }
    
    public String contactInformation {
        get {
            return this.getTranslationsMap().get(IboUtil.Pims_IB_staff_contact_information);
        }
        set;
    }
    
    
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
    
    
    //End of Adddition by kashyap ECM00692
    
    public PimsDashboardController() {
        try
        {
            
            PimsCommunityService pimsService = new PimsCommunityService();
            pimsService.initUserData();
            
            account = pimsService.getCurrentAccount();
            profileService.account = account;
            userContact = pimsService.getCurrentContact();
            showPageDetails = pimsService.isMySchoolRole(account.Id,userContact.Id);        
            
            programmes = profileService.getProgrammes();
            addresses = profileService.getAddresses();
            
            //account = profileService.getProfileAccount();
            
            //programmes = profileService.getProgrammes(account.Id);
            hasPypProgramme = profileService.hasProgramme(programmes, 'PYP');
            hasMypProgramme = profileService.hasProgramme(programmes, 'MYP');
            hasDpProgramme = profileService.hasProgramme(programmes, 'Diploma_Programme');
            
            hasAgreementProgramme = profileService.hasProgramme(programmes, 'Agreement');// added for 635 phase 2 
            /** Added by kashyap for ECM00635-phase 2 **/
            if(hasAgreementProgramme == true){
                 IB_Programme__c agreementProgramme = profileService.getProgrammeByType(programmes, 'Agreement'); // added as part of bug fix-agreement phase 2
                if(statusList.contains(agreementProgramme.Status__c) ){ // added as part of bug fix-agreement phase 2
                	hasDpProgramme= true;
                } // added as part of bug fix-agreement phase 2
                
            }
            system.debug('hasDpProgramme:  after agreement' + hasDpProgramme);
            /** Added by kashyap for ECM00635-phase 2 **/
            
            hasIbccProgramme = profileService.hasProgramme(programmes, 'IBCC');
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
            
            //addresses = profileService.getAllAddressesByAccount(account.Id);
            address = new IB_Address__c(IB_Account__c = account.Id);
            
            contacts = profileService.getContactsByAccount(account.Id);
            contact = new Contact(AccountId = account.Id);
            role = new IB_Role__c();
            
            roles = profileService.getRolesByContactList(contacts);
            allRoles = profileService.getAllRolesFromRepository();
            system.debug('account##'+account);
            system.debug('profileService.getRoleByNam##'+profileService.getRoleByName(allRoles, 'School Contact').Id);
            
            
            primaryContactRole = new IB_Role__c(IB_Account__c = account.Id, IB_Role__c = profileService.getRoleByName(allRoles, 'School Contact').Id);
            programmeContactRole = new IB_Role__c(IB_Account__c = account.Id, IB_Role__c = profileService.getRoleByName(allRoles, 'Programme Coordinator').Id);
            // system.debug('programmeContactRole##'+programmeContactRole);
            billingContactRole = new IB_Role__c(IB_Account__c = account.Id, IB_Role__c = profileService.getRoleByName(allRoles, 'Billing Contact').Id);
            examContactRole = new IB_Role__c(IB_Account__c = account.Id, IB_Role__c = profileService.getRoleByName(allRoles, 'Exam Contact').Id);
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
            
            Set<String> afaAccessSet = new Set<String>();
            
            if(programmes != null){
                System.debug(LoggingLevel.ERROR,'programmes.size() : ' + programmes.size());
                afaAccessSet = ProgrammeService.getAfaStatusByRecType(programmes);
            }
            
            System.debug(LoggingLevel.ERROR, 'afaAccessSet.size()' + afaAccessSet.size());
            System.debug(LoggingLevel.ERROR, 'afaAccessSet' + afaAccessSet);
            
            pypHasOpenAFA = afaAccessSet.contains('PYP');
            //for(string recTypeName : afaAccessSet){
            if(afaAccessSet.contains('MYP') || afaAccessSet.contains('MYP Partner')){
                mypHasOpenAFA = true;
            }
            //}
            dpHasOpenAFA = afaAccessSet.contains('Diploma Programme');
            ibccHasOpenAFA = afaAccessSet.contains('CP');
            
            System.debug(LoggingLevel.ERROR, 'pypHasOpenAFA : ' + pypHasOpenAFA);
            System.debug(LoggingLevel.ERROR, 'mypHasOpenAFA : ' + mypHasOpenAFA);
            System.debug(LoggingLevel.ERROR, 'dpHasOpenAFA : ' + dpHasOpenAFA);
            System.debug(LoggingLevel.ERROR, 'ibccHasOpenAFA : ' + ibccHasOpenAFA);
            
            //chatter button enabler
            chatterEnabler();
            
            
            //Addded by kashyap ECM00692 
            if(programmes != null){  
                Map<String, List<IB_Programme__c>> interestedContactProgrammeMap = new Map<String, List<IB_Programme__c>>();
                Map<String, List<IB_Programme__c>> authorizedContactProgrammeMap = new Map<String, List<IB_Programme__c>>();
                Map<String, List<IB_Programme__c>> candidateContactProgrammeMap = new Map<String, List<IB_Programme__c>>();
                
                for (IB_Programme__c programme : programmes) {
                    if (programme.Status__c == 'Interested') {
                        List<IB_Programme__c> programmeListMap= new List<IB_Programme__c>();
                        if(interestedContactProgrammeMap.containsKey(programme.Programme_Decision_Owner__r.email)){
                            interestedContactProgrammeMap.get(programme.Programme_Decision_Owner__r.email).add(programme);
                            
                        }else{
                            programmeListMap.add(programme);
                            interestedContactProgrammeMap.put(programme.Programme_Decision_Owner__r.email,programmeListMap );
                        }
                        
                    }
                    if (programme.Status__c == 'Authorized') {
                        List<IB_Programme__c> programmeListMap= new List<IB_Programme__c>();
                        if(authorizedContactProgrammeMap.containsKey(programme.Account__r.owner.email)){
                            authorizedContactProgrammeMap.get(programme.Account__r.owner.email).add(programme);
                            
                        }else{
                            programmeListMap.add(programme);
                            authorizedContactProgrammeMap.put(programme.Account__r.owner.email,programmeListMap);
                        }
                        
                    }
                    if (programme.Status__c == 'Candidate') {
                        List<IB_Programme__c> programmeListMap= new List<IB_Programme__c>();
                        if(candidateContactProgrammeMap.containsKey(programme.Owner__r.email)){
                            candidateContactProgrammeMap.get(programme.Owner__r.email).add(programme);
                            
                        }else{
                            programmeListMap.add(programme);
                            candidateContactProgrammeMap.put(programme.Owner__r.email,programmeListMap);
                            
                        }
                        
                    }
                }
                
                programmeWraperList= new List<ProgrammeWrapper>();
                for(String s: interestedContactProgrammeMap.keyset())
                {
                    String email = s;
                    List<IB_Programme__c> ibProgrammes= new List<IB_Programme__c>();
                    Set<String> status= new Set<String>();
                    Set<String> programmes = new Set<String>();
                    Set<String> names = new Set<String>();
                    
                    ibProgrammes= interestedContactProgrammeMap.get(s);
                    for(IB_Programme__c ibp: ibProgrammes){
                        status.add(ibp.Status__c);
                        String interestedProgramme= ibp.recordtype.name;
                        if(interestedProgramme=='Diploma Programme'){
                            interestedProgramme= 'DP';
                        }
                        programmes.add(interestedProgramme);
                        names.add(ibp.Programme_Decision_Owner__r.name);
                    }
                    
                    ProgrammeWrapper pw= new ProgrammeWrapper(email,string.join(new List<String>(names),' , '),string.join(new List<String>(status),' , '),string.join(new List<String>(programmes),' , ') );
                    programmeWraperList.add(pw);
                    system.debug('programmeWraperList**'+programmeWraperList);
                }
                for(String s: authorizedContactProgrammeMap.keyset())
                {
                    String email = s;
                    List<IB_Programme__c> ibProgrammes= new List<IB_Programme__c>();
                    Set<String> status= new Set<String>();
                    Set<String> programmes = new Set<String>();
                    Set<String> names = new Set<String>();
                    
                    ibProgrammes= authorizedContactProgrammeMap.get(s);
                    for(IB_Programme__c ibp: ibProgrammes){
                        status.add(ibp.Status__c);
                        String authorizedProgramme= ibp.recordtype.name;
                        if(authorizedProgramme=='Diploma Programme'){
                            authorizedProgramme= 'DP';
                        }
                        programmes.add(authorizedProgramme);
                        
                        if(ibp.Status__c=='Authorized'){
                            names.add(ibp.Account__r.owner.name);
                        }
                    }
                    
                    ProgrammeWrapper pw= new ProgrammeWrapper(email,string.join(new List<String>(names),' , '),string.join(new List<String>(status),' , '),string.join(new List<String>(programmes),' , ') );
                    programmeWraperList.add(pw);
                    system.debug('programmeWraperList**'+programmeWraperList);
                }
                for(String s: candidateContactProgrammeMap.keyset())
                {
                    String email = s;
                    List<IB_Programme__c> ibProgrammes= new List<IB_Programme__c>();
                    Set<String> status= new Set<String>();
                    Set<String> programmes = new Set<String>();
                    Set<String> names = new Set<String>();
                    
                    ibProgrammes= candidateContactProgrammeMap.get(s);
                    for(IB_Programme__c ibp: ibProgrammes){
                        status.add(ibp.Status__c);
                        String candidateProgramme= ibp.recordtype.name;
                        if(candidateProgramme=='Diploma Programme'){
                            candidateProgramme= 'DP';
                        }
                        programmes.add(candidateProgramme);
                        if(ibp.Status__c=='Candidate'){
                            names.add(ibp.Owner__r.name);
                        }
                    }
                    
                    ProgrammeWrapper pw= new ProgrammeWrapper(email,string.join(new List<String>(names),' , '),string.join(new List<String>(status),' , '),string.join(new List<String>(programmes),' , ') );
                    programmeWraperList.add(pw);
                    system.debug('programmeWraperList**'+programmeWraperList);
                }
            }
            // //Addded by kashyap ECM00692 
            
            
            
        }
        Catch(Exception x)
        {
            System.Debug('Exception: '+x);
        }
        
        /* 
@jira RA-43 US-10980 Chatter Functionality
Query campaign record and check conditions on campaign and related record Ib programme.
check size of list.
set boolean true which render on vf and show button.
set fetched campaign record id which is then used in vf to create url 
and send id to myschool.page which then show campaign chatter.

*/
    }
    
    /** Added by kashyap ECM00692 **/
    
    public class ProgrammeWrapper{
        public String email{ get; set;}
        public String name{ get; set;}
        public String status{ get; set;}
        public String ibProgrammes{ get; set;}
        
        public ProgrammeWrapper(String email, String name, String status, String ibProgrammes){
            this.email=email;
            this.name=name;
            this.status=status;
            this.ibProgrammes=ibProgrammes;
            
        }
    }
    
    /** Added by kashyap ECM00692 ****/
    
    public void chatterEnabler() {
        //initalizing default chatter button display false
        pypHasChatterEnabled = false;
        mypHasChatterEnabled = false;
        dpHasChatterEnabled = false;
        ibccHasChatterEnabled = false;
        
        //Chatter button will be visible or not for programs
        
        List<Campaign> pypCampCht = [Select name from campaign where Related_IB_Programme__c =: pyp.Id AND Related_IB_Programme__r.Status__c = 'Candidate' AND status ='Staffed' AND Sub_Type__c ='Candidacy Consultation' Limit 1];
        
        if(pypCampCht.size() >0) {
            //enable chatter for PYP
            pypHasChatterEnabled = true;
            //
            pypCampID = pypCampCht[0].ID;
        }
        
        List<Campaign> mypCampCht = [Select name from campaign where Related_IB_Programme__c =: myp.Id AND Related_IB_Programme__r.Status__c = 'Candidate' AND status ='Staffed' AND Sub_Type__c ='Candidacy Consultation' Limit 1];
        
        if(mypCampCht.size() >0) {
            //enable chatter for MYP
            mypHasChatterEnabled = true;
            mypCampID = mypCampCht[0].ID;
        }
        
        List<Campaign> dpCampCht = [Select name from campaign where Related_IB_Programme__c =: dp.Id AND Related_IB_Programme__r.Status__c = 'Candidate' AND status ='Staffed' AND Sub_Type__c ='Candidacy Consultation' Limit 1];
        
        if(dpCampCht.size() >0) {
            //enable chatter for DP
            dpHasChatterEnabled = true;
            dpCampID = dpCampCht[0].ID;
        }
        
        List<Campaign> ibccCampCht = [Select name from campaign where Related_IB_Programme__c =: ibcc.Id AND Related_IB_Programme__r.Status__c = 'Candidate' AND status ='Staffed' AND Sub_Type__c ='Candidacy Consultation' Limit 1];
        
        
        if(ibccCampCht.size() >0) {
            //enable chatter for IBCC
            ibccHasChatterEnabled = true;
            ibccCampID = ibccCampCht[0].ID;
        }
    }
    //This Part of Code is being added by Ammara-Plumlogix, as part of CR-812
    //begin
    public boolean Check_EP_Programme(){
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
    //end
    
    public Boolean getDisplayIntentPanel() {
        
        Boolean dsp = false;
        //This Part of Code is being added by Ammara-Plumlogix, as part of CR-812
        //begin
        if(Check_EP_Programme() == false){
            dsp = false;
        }
        
        else if (!hasPypProgramme && profileService.getIntentStatus(account.Id, 'PYP')) {//End
            dsp = true;
        }
        else if (!hasMypProgramme && profileService.getIntentStatus(account.Id, 'MYP')) {
            dsp = true;
        }
        else if (!hasDpProgramme && profileService.getIntentStatus(account.Id, 'DP')) {
            dsp = true;
        }
        else if (!hasIbccProgramme && profileService.getIntentStatus(account.Id, 'CP')) {
            dsp = true;
        }
        
        
        return dsp;
        
    }
    
    public boolean getPageHasErrors() {
        return ApexPages.hasMessages();
    }
    
    public String getUserLanguageKey() {
        return UserInfo.getLanguage();
    }
    
    public boolean getShowPypSubDate() {
        Id idx = pyp.Id;
        return getShowSubmissionDate(idx);
    }
    
    public boolean getShowMypSubDate() {
        Id idx = myp.Id;
        return getShowSubmissionDate(idx);
    }
    
    public boolean getShowDpSubDate() {
        Id idx = dp.Id;
        return getShowSubmissionDate(idx);
    }
    
    public boolean getShowCpSubDate() {
        Id idx = ibcc.Id;
        boolean show;
        if(ibcc.IBCC_Implementation_Phase__c == 'Phase 2'){
            show = getShowSubmissionDate(idx);
        }else if(ibcc.StageName__c == 'Consultation process' || ibcc.StageName__c == 'Request for Authorization' || ibcc.StageName__c == 'Verification Visit'){
            show = true;
        }else{
            show = false;
        }
        return show;
    }
    
    public boolean getShowSubmissionDate(id idx) {
        try {
            pimsConsultationFeedback = [SELECT Id, RecordType.Name, IB_Application__c, Status__c
                                        FROM IB_Consultant_Feedback__c
                                        WHERE RecordType.Name = 'Initial Visit' AND IB_Programme_Lookup__c = :idx limit 1];
        }
        catch (Exception e) {
            return false;
        }
        if(pimsConsultationFeedback.Status__c == 'Published'){
            return true;
        }else{
            return false;
        }
    }
    
}