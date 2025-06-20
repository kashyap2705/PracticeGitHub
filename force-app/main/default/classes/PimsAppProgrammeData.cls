public class PimsAppProgrammeData extends PimsApplicationControllerHelper {

    public String appId {get;set;}
	public String acntName {get;set;}
    public String activeTab {get;set;}
    public String redirectUrl {get;set;}
    public String pdCompletionStatus {get;set;}

    public String Addr {get;set;}
    public String Addr1 {get;set;}
    public String Addr2 {get;set;}
    public String Addr3 {get;set;}
    public String Addr4 {get;set;}
    public String deletePSId {get;set;}

    public IB_Application__c application {get;set;}
    public IB_Programme__c programme {get;set;}
    public List<IB_Address__c> addresses {get;set;}

    public IB_Programme_Structure__c programmeStructure {get;set;}
    public List<IB_Programme_Structure__c> programmeStructureList {get;set;}

    public Decimal mypStudentTotal {get;set;}
    public Decimal pypStudentTotal {get;set;}

    public PimsAppProgrammeData() {

        appId = ApexPages.currentPage().getParameters().get('id');

        if (appId == null) throw new CustomValidationException('The application ID is invalid.');

        PageService.setPage(getApplicationPageName());
        if (!Test.isRunningTest()) activeTab = PageService.getActiveTab();
        if (Test.isRunningTest()) activeTab = 'prog';
        if (activeTab == 'prog') {

            if (!Test.isRunningTest()) ApplicationService.setApplicationId(appId);
            application = ApplicationService.getApplication();

            if (!Test.isRunningTest()) ProgrammeService.setProgrammeId(application.Application_Lookup_to_Programme__r.Id);
            programme = ProgrammeService.getProgramme();

            AddressService.setAccountId(programme.Account__c);
            addresses = AddressService.getAddressesByAccount();

            programmeStructureList = [
                SELECT Id,Name,PR_2_MYP_Age_From__c,PR_2_MYP_Age_To__c,PR_2_MYP_Grade_Year_From__c,PR_2_MYP_Grade_Year_To__c,PR_2_MYP_School_Lookup__c,
                PR_2_MYP_Student_Total_Year__c,PR_2_MYP_Year__c,PR_2_PYP_MYP_Section__c,PR_2_PYP_Number_of_Classes__c,PR_2_PYP_Number_of_Grades__c,
                PR_2_PYP_Student_Age__c,PR_2_PYP_Total_Students_Year__c
                FROM IB_Programme_Structure__c
                WHERE IB_Programme_Lookup__c = :programme.id
            ];

            mypStudentTotal = 0;
            pypStudentTotal = 0;
            for (IB_Programme_Structure__c rec : programmeStructureList) {
                if (getIsMyp() && rec.PR_2_MYP_Student_Total_Year__c != null) mypStudentTotal += rec.PR_2_MYP_Student_Total_Year__c;
                if (getIsPyp() && rec.PR_2_PYP_Total_Students_Year__c != null) pypStudentTotal += rec.PR_2_PYP_Total_Students_Year__c;
            }
			//programmeStructure = new IB_Programme_Structure__c();
            programmeStructure = new IB_Programme_Structure__c(PR_2_MYP_School_Lookup__c = programme.Account__c);
			if(programme.Account_IBIS_Code__c != null){
				acntName = programme.Account__r.Name + ' - ' + programme.Account_IBIS_Code__c;
			}
			else{
				acntName = programme.Account__r.Name;
			}
        }

    }

    public PageReference save() {

        system.debug('pdCompletionStatus =====> '+pdCompletionStatus);

        try {
            application.AFC_Programme_Information_Status__c = pdCompletionStatus;
            update application;


            programme.Street_Address__c = Addr;
            // Update the additional campus address locations with their selected value
            programme.Additional_Address_1__c = Addr1;
            programme.Additional_Address_2__c = Addr2;
            programme.Additional_Address_3__c = Addr3;
            programme.Additional_Address_4__c = Addr4;
            if (getIsMyp()) programme.Number_of_Students__c = mypStudentTotal;
            if (getIsPyp()) programme.Number_of_Students__c = pypStudentTotal;
            update programme;

            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, Label.Programme_information_saved));
            if (getIsPyp()) {
                redirectUrl = '/pims/'+getApplicationPageName()+'?id=' + application.Id + '&tab=sectiona';
            }
            else {
                redirectUrl = '/pims/'+getApplicationPageName()+'?id=' + application.Id + '&tab=subject';
            }
        }
        catch (Exception ex) {
            ApexPages.addMessages(ex);
        }

        return null;
    }

    public List<SelectOption> getAddressOptions() {

        appId = ApexPages.currentPage().getParameters().get('id');

        if (appId == null) {
            throw new CustomValidationException('The application ID is invalid.');
        }

        ApplicationService.setApplicationId(appId);
        application = ApplicationService.getApplication();

        AddressService.setAccountId(application.Account__c);
        addresses = AddressService.getAddressesByAccount();

        return AddressService.getAddressOptions();
    }

    public List<SelectOption> getAddressOptionsWithBlank() {

        appId = ApexPages.currentPage().getParameters().get('id');

        if (appId == null) {
            throw new CustomValidationException('The application ID is invalid.');
        }

        ApplicationService.setApplicationId(appId);
        application = ApplicationService.getApplication();

        AddressService.setAccountId(application.Account__c);
        addresses = AddressService.getAddressesByAccount();

        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('', '--None--'));
        options.addAll(AddressService.getAddressOptions());

        return options;
    }


    // Used to maintain page state while inserting data in the Programme Structure table
    public PageReference saveProgrammeStructure() {

        programmeStructure.IB_Programme_Lookup__c = programme.id;

        try {
            insert programmeStructure;
            // Create a new object variable for the next row of data
			//programmeStructure = new IB_Programme_Structure__c();
            programmeStructure = new IB_Programme_Structure__c(PR_2_MYP_School_Lookup__c = programme.Account__c);

            // Must query data for the table again to ensure deleted rows no longer appear on the page
            programmeStructureList = [
                SELECT Id,Name,PR_2_MYP_Age_From__c,PR_2_MYP_Age_To__c,PR_2_MYP_Grade_Year_From__c,PR_2_MYP_Grade_Year_To__c,PR_2_MYP_School_Lookup__c,
                PR_2_MYP_Student_Total_Year__c,PR_2_MYP_Year__c,PR_2_PYP_MYP_Section__c,PR_2_PYP_Number_of_Classes__c,PR_2_PYP_Number_of_Grades__c,
                PR_2_PYP_Student_Age__c,PR_2_PYP_Total_Students_Year__c
                FROM IB_Programme_Structure__c
                WHERE IB_Programme_Lookup__c = :programme.id
            ];
            mypStudentTotal = 0;
            pypStudentTotal = 0;
            for (IB_Programme_Structure__c rec : programmeStructureList) {
                if (getIsMyp() && rec.PR_2_MYP_Student_Total_Year__c != null) mypStudentTotal += rec.PR_2_MYP_Student_Total_Year__c;
                if (getIsPyp() && rec.PR_2_PYP_Total_Students_Year__c != null) pypStudentTotal += rec.PR_2_PYP_Total_Students_Year__c;
            }

            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Programme Structure was saved successfully.'));
            redirectUrl = '/pims/'+getApplicationPageName()+'?id=' + appId + '&tab=prog';
        }
        catch (Exception ex) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error saving Programme Structure '+ex));
            return null;
        }
        return null;
    }

    // Used to maintain page state while updating data in the Programme Structure table
    public PageReference updateProgrammeStructure() {

        redirectUrl = '/pims/'+getApplicationPageName()+'?id=' + application.Id + '&tab=prog';
        try {
            update programmeStructureList;

            mypStudentTotal = 0;
            pypStudentTotal = 0;
            for (IB_Programme_Structure__c rec : programmeStructureList) {
                if (getIsMyp() && rec.PR_2_MYP_Student_Total_Year__c != null) mypStudentTotal += rec.PR_2_MYP_Student_Total_Year__c;
                if (getIsPyp() && rec.PR_2_PYP_Total_Students_Year__c != null) pypStudentTotal += rec.PR_2_PYP_Total_Students_Year__c;
            }

            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'The programme structure was updated successfully.'));
        }
        catch (Exception ex) {
            ApexPages.addMessages(ex);
        }
        return null;
    }


    // Used to maintain page state while deleting data from the Programme Structure table
    public PageReference removeProgrammeStructure() {

        PageReference pageRef = ApexPages.currentPage();
        //system.debug('In removeProgrammeStructure =====>'+deletePSId);
        try {

            IB_Programme_Structure__c psToDelete = new IB_Programme_Structure__c();
            psToDelete.Id = deletePSId;

            delete psToDelete;

            // Must query data for the table again to ensure deleted rows no longer appear on the page
            programmeStructureList = [
                SELECT Id,Name,PR_2_MYP_Age_From__c,PR_2_MYP_Age_To__c,PR_2_MYP_Grade_Year_From__c,PR_2_MYP_Grade_Year_To__c,PR_2_MYP_School_Lookup__c,
                PR_2_MYP_Student_Total_Year__c,PR_2_MYP_Year__c,PR_2_PYP_MYP_Section__c,PR_2_PYP_Number_of_Classes__c,PR_2_PYP_Number_of_Grades__c,
                PR_2_PYP_Student_Age__c,PR_2_PYP_Total_Students_Year__c
                FROM IB_Programme_Structure__c
                WHERE IB_Programme_Lookup__c = :programme.id
            ];
            mypStudentTotal = 0;
            pypStudentTotal = 0;
            for (IB_Programme_Structure__c rec : programmeStructureList) {
                if (getIsMyp() && rec.PR_2_MYP_Student_Total_Year__c != null) mypStudentTotal += rec.PR_2_MYP_Student_Total_Year__c;
                if (getIsPyp() && rec.PR_2_PYP_Total_Students_Year__c != null) pypStudentTotal += rec.PR_2_PYP_Total_Students_Year__c;
            }

            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Programme Structure was successfully removed.'));
            redirectUrl = '/pims/'+getApplicationPageName()+'?id=' + appId + '&tab=prog';
        }
        catch (DmlException ex) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error removing Programme Structure '+ex));
            return null;
        }
        return null;
    }


    // Used to allow auto-fill on Contact lookup fields within the form
    @RemoteAction
    public static List<String> lookupIBCoordinators(String searchTerm) {

        ID currContactId = [Select contactid from User where id = :Userinfo.getUserid()].contactId;
        ID AccID  = [Select AccountID from Contact where id = :currContactId].AccountId;
        ContactDAO contactData = ContactDAO.getInstance();
        List<Contact> contactList = contactData.searchContactsByNameAndAccount(searchTerm, AccID);
        List<String> contacts = new List<String>();
        for (Contact x : contactList) {
            contacts.add(x.Name);
        }
        return contacts;
    }

    // Used to allow auto-fill on School lookup fields within the form
    @RemoteAction
    public static List<String> lookupIBSchools(String searchTerm) {

        ID currContactId = [Select contactid from User where id = :Userinfo.getUserid()].contactId;
        ID AccID  = [Select AccountID from Contact where id = :currContactId].AccountId;
        String recType = [Select RecordType.Name from Account where id = :AccID].RecordType.Name;
        AccountDAO accountData = AccountDAO.getInstance();
        //List<Account> accountList = accountData.searchAccountsByNameAndType(searchTerm, 'School Account');
        List<Account> accountList = accountData.searchAccountsByNameAndType(searchTerm, recType);
        List<String> schools = new List<String>();
        for (Account x : accountList) {
            schools.add(x.Name);
        }
        return schools;
    }

}