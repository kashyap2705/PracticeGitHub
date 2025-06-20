@IsTest
private class ICFInstructionsControllerTest {

    @testSetup
    static Void setup() {

        Account theAccount = PimsTestUtil.createAccount('TestIBSchool','School Account');
        insert theAccount;

        Contact theContact = PimsTestUtil.createContact('Jack Reacher','jr@tibs.com','jr@profEmail.com', Date.newInstance(1984, 09, 14), theAccount);
        Contact theContact2 = PimsTestUtil.createContact('Jack Reacher','jr2@tibs.com','jr2@profEmail.com', Date.newInstance(1984, 09, 14), theAccount);
        Contact theContact3 = PimsTestUtil.createContact('Jack Reacher','jr3@tibs.com','jr3@profEmail.com', Date.newInstance(1984, 09, 14), theAccount);
        insert new List<Contact> {theContact,theContact2,theContact3};

        Profile p =  [select Id from profile where Name='Customer Community Advanced' limit 1];

        User pu = new User(profileId = p.id, username = 'tu1@email.com', email = 'tu1@email.com',
                emailencodingkey = 'UTF-8', localesidkey = 'en_US',
                languagelocalekey = 'en_US', timezonesidkey = 'America/New_York',
                alias='cspu1', lastname='lastname', contactId = theContact.id);

        User pu2 = new User(profileId = p.id, username = 'tu2@email.com', email = 'tu1@email.com',
                emailencodingkey = 'UTF-8', localesidkey = 'fr',
                languagelocalekey = 'fr', timezonesidkey = 'America/New_York',
                alias='cspu2', lastname='lastname', contactId = theContact2.id);

        User pu3 = new User(profileId = p.id, username = 'tu3@email.com', email = 'tu1@email.com',
                emailencodingkey = 'UTF-8', localesidkey = 'es',
                languagelocalekey = 'es', timezonesidkey = 'America/New_York',
                alias='cspu3', lastname='lastname', contactId = theContact3.id);

        insert new List<User> {pu,pu2,pu3};

    }

    static testMethod void testMethodOne() {

        Account theAccount = [SELECT ID FROM ACCOUNT LIMIT 1];
        Contact theContact = [SELECT ID FROM CONTACT LIMIT 1];

        IB_Programme__c theProgramme = PimsTestUtil.createProgrammeForAccount (theAccount,'PYP');
        theProgramme.StageName__c = 'Consideration';
        insert theProgramme;

        IB_Application__c theApp = new IB_Application__c(
                AC_3_1_Feasability_Lead__c = theContact.Id,
                Application_Lookup_to_Programme__c = theProgramme.Id,
                AC_3_1_Feasability_Leads__c = theContact.Id,
                AFC_Assessment_Status__c = 'Complete',
                AFC_Collaborative_Planning_Status__c = 'Complete',
                AFC_Documents_Status__c = 'Complete',
                AFC_Implementation_Budget_Status__c = 'Complete',
                AFC_Leadership_Structure_Status__c = 'Complete',
                AFC_Philosophy_Status__c = 'Complete',
                AFC_Profile_Review_Status__c = 'Complete',
                AFC_Programme_Information_Status__c = 'Complete',
                AFC_Resources_Support_Status__c = 'Complete',
                AFC_School_Description_Status__c = 'Complete',
                AFC_Subject_Proposal_Status__c = 'Complete',
                AFC_Written_Curriculum_Status__c = 'Complete'
        );
        insert theApp;

        List<User> users = [SELECT ID FROM USER WHERE username in ('tu1@email.com','tu2@email.com','tu3@email.com')];

        System.runAs(users[0]){
            Pagereference thePage = Page.ICF_Section_Instructions;
            thePage.getParameters().put('id', theApp.Id);
            Test.setCurrentPage(thePage);
            ICFInstructionsController controller = new ICFInstructionsController();
        }

        System.runAs(users[1]){
            Pagereference thePage = Page.ICF_Section_Instructions;
            thePage.getParameters().put('id', theApp.Id);
            Test.setCurrentPage(thePage);
            ICFInstructionsController controller = new ICFInstructionsController();
        }

        System.runAs(users[2]){
            Pagereference thePage = Page.ICF_Section_Instructions;
            thePage.getParameters().put('id', theApp.Id);
            Test.setCurrentPage(thePage);
            ICFInstructionsController controller = new ICFInstructionsController();
        }
    }

    static testMethod void testMethodTwo() {

        Account theAccount = [SELECT ID FROM ACCOUNT LIMIT 1];
        Contact theContact = [SELECT ID FROM CONTACT LIMIT 1];

        IB_Programme__c theProgramme = PimsTestUtil.createProgrammeForAccount (theAccount,'CP');
        theProgramme.StageName__c = 'Consideration';
        insert theProgramme;

        IB_Application__c theApp = new IB_Application__c(
                AC_3_1_Feasability_Lead__c = theContact.Id,
                Application_Lookup_to_Programme__c = theProgramme.Id,
                AC_3_1_Feasability_Leads__c = theContact.Id,
                AFC_Assessment_Status__c = 'Complete',
                AFC_Collaborative_Planning_Status__c = 'Complete',
                AFC_Documents_Status__c = 'Complete',
                AFC_Implementation_Budget_Status__c = 'Complete',
                AFC_Leadership_Structure_Status__c = 'Complete',
                AFC_Philosophy_Status__c = 'Complete',
                AFC_Profile_Review_Status__c = 'Complete',
                AFC_Programme_Information_Status__c = 'Complete',
                AFC_Resources_Support_Status__c = 'Complete',
                AFC_School_Description_Status__c = 'Complete',
                AFC_Subject_Proposal_Status__c = 'Complete',
                AFC_Written_Curriculum_Status__c = 'Complete'
        );
        insert theApp;

        List<User> users = [SELECT ID FROM USER WHERE username in ('tu1@email.com','tu2@email.com','tu3@email.com')];

        System.runAs(users[0]){
            Pagereference thePage = Page.ICF_Section_Instructions;
            thePage.getParameters().put('id', theApp.Id);
            Test.setCurrentPage(thePage);
            ICFInstructionsController controller = new ICFInstructionsController();
        }

        System.runAs(users[1]){
            Pagereference thePage = Page.ICF_Section_Instructions;
            thePage.getParameters().put('id', theApp.Id);
            Test.setCurrentPage(thePage);
            ICFInstructionsController controller = new ICFInstructionsController();
        }

        System.runAs(users[2]){
            Pagereference thePage = Page.ICF_Section_Instructions;
            thePage.getParameters().put('id', theApp.Id);
            Test.setCurrentPage(thePage);
            ICFInstructionsController controller = new ICFInstructionsController();
        }

    }

    /*static testMethod void testMethodThree() {

        PageReference thePage = Page.ICF_Section_Instructions;
        Test.setCurrentPage(thePage);
        thePage.getParameters().put('appId','');
        ICFInstructionsController controller = new ICFInstructionsController();
        

    }*/


}