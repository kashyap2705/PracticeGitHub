public with sharing class ApplicationStaffTableController implements AppTablesInterface {

    public Application_Staff_Table__c appStaffTable {get;set;}
    public List<Application_Staff_Table__c> ApplicationStaffTableList {get;set;}

    public Id deleteAstId {get;set;}
    public String activeTab {get;set;}
    public Boolean isUpdatePage {get;set;}
    public IB_Application__c application {get;set;}

    public PageReference editStaff() {

        PageReference pageRef = ApexPages.currentPage();

        try {

            update ApplicationStaffTableList;
            /*activeTab = 'sectionb';
            if (isUpdatePage) {
                pageRef = new PageReference('/pims/PimsApplicationForCandidacy');
            }
            pageRef.setRedirect(true);*/
        }
        catch (DmlException ex) {
            /*ApexPages.addMessages(ex);
            activeTab = 'sectionb';
            pageRef.setRedirect(false);
            */
        }
        /*pageRef.getParameters().put('tab', activeTab);*/
        return pageRef;
    }

    // Not sure this method is even being called because it deals with deleting an Application_Library_Resources__c record
    // All other methods in this class work on the Application_Staff_Table__c object
    public PageReference remove() {

        PageReference pageRef = ApexPages.currentPage();

        try {

            Application_Library_Resources__c astToDelete = new Application_Library_Resources__c();
            astToDelete.Id = deleteAstId;
            //system.debug('astToDelete.Id ====> '+astToDelete.Id);
            delete astToDelete;

            activeTab = 'sectionb';
            if (isUpdatePage) {
                pageRef = new PageReference('/pims/PimsApplicationForCandidacy');
            }
            pageRef.setRedirect(true);
        }
        catch (DmlException ex) {
            ApexPages.addMessages(ex);
            activeTab = 'sectionb';
            pageRef.setRedirect(false);
        }
        pageRef.getParameters().put('tab', activeTab);
        return pageRef;
    }

    public PageReference save() {

        PageReference pageRef = ApexPages.currentPage();

        try {
            /*if (!profileService.validateSections(account.Id)) {
                     throw new CustomValidationException('At least one needs to be filled out.');
            }*/

            update appStaffTable;

            if (isUpdatePage) {
                activeTab = 'sectionb';
                pageRef = new PageReference('/pims/PimsApplicationForCandidacy');
            }
            pageRef.setRedirect(true);
        }
        catch (Exception ex) {
            ApexPages.addMessages(ex);
            activeTab = 'sectionb';
            pageRef.setRedirect(false);
        }

        pageRef.getParameters().put('tab', activeTab);
        return pageRef;
    }

    public PageReference create() {

        PageReference pageRef = ApexPages.currentPage();

        try {

            insert appStaffTable;

            activeTab = 'sectionb';
            if (isUpdatePage) {
                pageRef = new PageReference('/pims/PimsApplicationForCandidacy');
            }
            pageRef.setRedirect(true);
        }
        catch (DmlException ex) {
            ApexPages.addMessages(ex);
            activeTab = 'sectionb';
            pageRef.setRedirect(false);
        }

        pageRef.getParameters().put('tab', activeTab);
        return pageRef;
    }
}