public with sharing class ApplicationTeachingTimeController  {

    public Application_Teaching_Time__c applicationTeachingTime {get;set;}
    public Application_Teaching_Time__c editTeachingTime {get;set;}
    public Application_Teaching_Time__c att {get;set;}
    public List<Application_Teaching_Time__c> applicationTeachingTimeList {get;set;}

    public IB_Application__c application {get;set;}
    public Id deleteActId {get;set;}
    public String activeTab {get;set;}
    public String accId {get;set;}
    public String appId {get;set;}
    public String progId {get;set;}
    public String redirectUrl {get;set;}
    public IB_Programme__c programme {get;set;}
    public Boolean isUpdatePage {get;set;}


    public ApplicationTeachingTimeController() {

        if (!Test.isRunningTest()) ApplicationService.setApplicationId(appId);
        application = ApplicationService.getApplication();

        if (!Test.isRunningTest()) ProgrammeService.setProgrammeId(application.Application_Lookup_to_Programme__r.Id);
        programme = ProgrammeService.getProgramme();

        accId = programme.account__c;
        progId = programme.Id;

        applicationTeachingTimeList = [
            SELECT B2_10a_1_Classroom_Percentage__c, B2_10a_1_Other_Activities__c, B2_10a_1_Single_Subject__c, B2_10a_1_Total_Time__c,
            B2_10a_1_Week_Length__c, B2_10a_1_Year_Grade__c, B2_10c_1_Number_Weeks__c, B2_10c_1_Subject_Group__c, B2_10c_1_Teaching_Time__c,
            B2_10c_Number_Periods__c,  Id, Name, IB_Application_Lookup__c
            FROM Application_Teaching_Time__c
            WHERE IB_Application_Lookup__c = :appId
        ];
    }

    public PageReference save() {

        try {

            insert applicationTeachingTime;

            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Teaching time was saved successfully.'));

        }
        catch (Exception ex) {
            ApexPages.addMessages(ex);
        }

        return null;
    }


    public PageReference editTeachingTime() {

        PageReference pageRef = ApexPages.currentPage();

        try {

            update editTeachingTime;

            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Teaching time was saved successfully.'));
        }
        catch (DmlException ex) {
            ApexPages.addMessages(ex);
        }

        return null;
    }
}