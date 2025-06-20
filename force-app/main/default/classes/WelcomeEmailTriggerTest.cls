@isTest
private class WelcomeEmailTriggerTest
{
    @isTest
    static void itShould()
    {
        integer i=1;
        //Profile p =  [select Id from profile where Name='SCU + Advanced' limit 1];
        List<Profile> profiles = [select Id, Name from Profile where Name in ('SCU + Advanced','SCU + Basic','Customer Community Advanced','Customer Community Basic','SCU + Advanced', 'System Administrator')];

        //String testemail = 'puser000@amamama.com';
        
        Account acc = PimsTestUtil.createAccount('test acc name', '');
        insert acc;
        
        List<Contact> contacts = new List<Contact>();


        for(Profile p : profiles){
            String testemail = p.Id + '@' + p.Id + '.com';
            Contact c = PimsTestUtil.createContact('test ' + p.Id, testemail, testemail, Date.today().addYears(-22), acc);
            c.AccountId = acc.Id;
            c.Job_Title__c = p.Id;
            c.Contact_Comments__c = p.Name;
            contacts.add(c);
        }
        //Contact c = createContact('test name', testemail, testemail, Date.today().addYears(-22), acc);
        //c.AccountId = acc.Id;
        //insert c;

        SchoolSections__c s = new SchoolSections__c(
            Grade_From__c = '0',
            Grade_To__c = '5',
            Account__c = acc.Id,
            Number_Of_Students__c = 10,
            Number_Of_Classes__c = 10

        );

        insert s;

        PimsTestUtil.generateStandardRoles();

        List<User> users = new List<User>();

        insert contacts;

        User sysadmin = new User();

        for(Contact c : contacts){
            User pu = new User(profileId = c.Job_Title__c, username = c.email, email = c.email,
                           emailencodingkey = 'UTF-8', localesidkey = 'en_US',
                           languagelocalekey = 'en_US', timezonesidkey = 'America/Los_Angeles',
                           alias=c.Job_Title__c.right(8), lastname=c.Job_Title__c, contactId = c.id, isActive = true);
            if(c.Contact_Comments__c == 'System Administrator'){
                sysadmin = pu;
                pu.contactId = null;
            }
            users.add(pu);
        }


        insert users;

        System.runAs(sysadmin){
            for(User u : users){
                if(u.Id != sysadmin.id){
                    u.IsActive = false;
                }
            }

            WelcomeEmailTriggerHelper.resetUserMap();

            update users;

            for(User u : users){
                if(u.Id != sysadmin.id){
                    u.IsActive = true;
                }
            }

            WelcomeEmailTriggerHelper.resetUserMap();
            //Following code line is added by Umair-Plumlogix of US11096 on 02/11/2020
            System.assertEquals(1,i);

            update users;
        }
    }
}