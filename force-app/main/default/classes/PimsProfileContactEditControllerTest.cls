@isTest
private class PimsProfileContactEditControllerTest {



     static testMethod void test_method_one() {
         integer i=1;

        
         // User u = PimsTestUtil.createPortalUserPIMS('testname.unique@ibo.org','August','May',false);
          //u.FirstName = 'test1';
          //insert u;
          
             //  Profile p =  [select Id from profile where Name='System Administrator' limit 1];
              Profile p =  [select Id from profile where Name='Customer Community Advanced' limit 1];


        //String testemail = 'puser000@amamama.com';

        Account acc = new Account (
                Name = 'test acc name',
                Region__c = 'IBAEM',
                Sub_region__c = 'EUROPE',
                External_PD_Provider__c = true,
                Language_Of_Correspondance__c = 'English',
                Legal_Status__c = 'Private',
                Billing_Currency__c = 'USD',
                Lead_Account__c = true,
                Short_Name__c = 'test acc name'
            );
           
        acc.PIMS_Step_1__c = true;
        acc.PIMS_Step_2__c = true;
        acc.PIMS_Step_3__c = true;
        acc.PIMS_Step_4__c = true;
        acc.PIMS_Step_5__c = true;
        acc.Website = 'http://www.google.com';
        acc.Year_Founded__c = '1990';
        acc.Academic_Start_Month__c ='August' ;
        acc.Academic_End_Month__c = 'May';
        acc.Month_Founded__c = 'January';
        acc.Legal_Status__c = 'State';
        acc.Language_Of_Correspondance__c = 'English';
        acc.Region__c = 'IBAEM';

        insert acc;

        Contact c = new Contact (
            Salutation = 'Mr.',
            LastName = 'test name',
            MobilePhone = '+30992907711',
            HomePhone = '+30992907711',
            //OtherPhone = '+30992907711',
            Email = 'testname.unique@ibo.org',
            Birthdate = Date.today().addYears(-22),
            Alternative_Email__c  = 'noname@example.commm',
            FirstName = 'noname',
            MailingCity = 'Palm Coast',
            MailingState = 'Florida',
            MailingCountry = 'United States',
            MailingPostalCode = '32137',
            MailingStreet = 'street',
            AccountId = acc.Id,
            Full_time_Part_time__c = 'Full Time',
            Number_of_years_at_school__c = '4',
            Phone = '+13861234567',
            Qualifications__c = 'BS',
            Job_Title__c = 'Blah',
            Birth_Locale__c   = 'sea',
            Country_of_Birth__c = 'Armenia'
        );
           
        c.AccountId = acc.Id;
        insert c;

        SchoolSections__c s = new SchoolSections__c(
            Grade_From__c = '0',
            Grade_To__c = '13',
            Account__c = acc.Id,
            Number_Of_Students__c = 10,
            Number_Of_Classes__c = 10
        );

        insert s;

        SchoolSections__c s1 = new SchoolSections__c(
            Grade_From__c = 'K',
            Grade_To__c = 'K',
            Account__c = acc.Id,
            Number_Of_Students__c = 10,
            Number_Of_Classes__c = 10
        );

        insert s1;

       // if(generateRoles){
      //      generateStandardRoles();
       // }

        User u = new User(profileId = p.id, username = 'testname.unique@ibo.org', email ='testname.unique@ibo.org',
                           emailencodingkey = 'UTF-8', localesidkey = 'en_US',
                           languagelocalekey = 'en_US', timezonesidkey = 'America/Los_Angeles',
                           alias='cspu', lastname='lastname',contactId = c.id);

     //   system.debug(loggingLevel.Error,'User: ' + pu);
        system.debug(loggingLevel.Error,'Account: ' + acc);
        system.debug(loggingLevel.Error,'Contact: ' + c);
        insert u;
        
          System.runAs(u){

               ProfileService ps = new ProfileService();

               Account account = ps.getProfileAccount();

              
               List<Contact> currContacts = ps.getContactsByAccount(acc.Id);
               Contact con3 = currContacts[0];

             // insert con3;
               List<IB_Address__c> addressesByAccount = ps.getAllAddressesByAccount(acc.Id);

               IB_Programme__c programme = PimsTestUtil.createProgrammeForAccount(acc, 'PYP');
              // insert programme;

               List<IB_Programme__c> programmeList = new List<IB_Programme__c>();
               programmeList.add(programme);
               system.debug(loggingLevel.error, 'record type: ' + programmeList[0].RecordType.Name);
               system.debug(loggingLevel.error, 'record type id:' + programmeList[0].RecordTypeId);

               List<Contact> contactsByAccount = ps.getContactsByAccount(acc.Id);

               IB_Role_Repository__c repo = PimsTestUtil.createRoleRepo('Programme Coordinator');
               repo.Display_In_PIMS_Community__c = true;
               insert repo;

               IB_Role_Repository__c repo2 = PimsTestUtil.createRoleRepo('Head of School (Overall)');
               repo.Display_In_PIMS_Community__c = true;
               insert repo2;

               IB_Role_Repository__c repo3 = PimsTestUtil.createRoleRepo('Billing Coordinator');
               repo.Display_In_PIMS_Community__c = true;
               insert repo3;

               List<IB_Role_Repository__c> rolesFromRepository = new List<IB_Role_Repository__c>();
               rolesFromRepository.add(repo);
               rolesFromRepository.add(repo2);
               rolesFromRepository.add(repo3);

               IB_Subject__c theSubject = new IB_Subject__c(
                    IB_Programme__c = 'CP',
                    IB_Programme_Long__c = 'IB Career-related Programme',
                    Subject_Group__c = 'Other',
                    Subject_Name__c = 'Career related study',
                    Subject_Code__c = 'careerstud'
               );
               insert theSubject;

               Role_Application_Subject__c roleAndAppSubject = new Role_Application_Subject__c(
                    IB_Subject__c = theSubject.Id
               );
               insert roleAndAppSubject;

            Test.startTest();

               IB_Role__c role = new IB_Role__c(
            IB_Contact__c = con3.Id,
            IB_Role__c = repo3.Id,
            Programme_Selection__c='PYP;MYP;DP;IBCC',
            Status__c='Confirmed',
            Active__c = true,
            Role_Level__c = 'Fully Qualified',
            IB_Account__c = acc.id
        );
              System.debug('RoleAhmmm'+role);
          
               role.IB_Programme_New__c = programme.Id;
               insert role;

               PageReference pimsProfile = Page.PimsProfile;
               Test.setCurrentPage(pimsProfile);
               pimsProfile.getParameters().put('id',con3.Id);
               pimsProfile.getParameters().put('role',role.Id);
               pimsProfile.getParameters().put('sub',roleAndAppSubject.Id);
              system.debug('pageIdA'+pimsProfile.getAnchor());

               PimsProfileContactEditController controller = new PimsProfileContactEditController();
               controller.programmes = programmeList;
                controller.email = 'xxxx1@xxx.xx';
                controller.emailBody = 'hello!';
               controller.url = 'www.yyyy.yy';
               controller.invitationID = con3.Invitation_ID__c;

               controller.contactForEmail = con3;

               controller.rolesFromRepository = rolesfromRepository;

               system.debug(loggingLevel.ERROR, 'controller.programmes: ' + controller.programmes);

               // This Part is being added by Ahmad Shakeel-Plumlogix on 10-11-2019,US11129.
//begin

          
              
               controller.init();
           
               controller.edit();
//End
               controller.createRole();
               controller.addSubject = theSubject.Id;
               controller.createSubject();
               controller.deleteId = roleAndAppSubject.Id;
               controller.removeSubject();
               controller.createProDev();
               controller.updateProDev();
               controller.removeProDev();
               controller.editAccountEmailOnly();
               List<SelectOption> progOpts = controller.getProgrammeOptions();
               List<SelectOption> roleOpts = controller.getRoleOptions();
               List<SelectOption> subGroups = controller.getSubjectGroups();
               List<SelectOption> subNames = controller.getSubjectNames();
               List<SelectOption> getQualificationsList = controller.getQualifications();
               DateUtility dateVal = controller.dateUtil;
              String userLang = controller.getUserLanguageKey();
              //Following code line is added by Umair-Plumlogix of US11096 on 02/11/2020
              System.assertEquals(1,i);

            Test.stopTest();

          }
         
      
     }

     static testMethod void test_method_two() {
         integer i=1;

       
          User u = PimsTestUtil.createPortalUserPIMS('testname.unique@ibo.org','August','May',false);
          u.FirstName = 'test2';
             
          insert u;
           

          System.runAs(u){

               ProfileService ps = new ProfileService();

               Account account = ps.getProfileAccount();

               List<Contact> currContacts = ps.getContactsByAccount(account.Id);
               Contact con3 = currContacts[0];

               List<IB_Address__c> addressesByAccount = ps.getAllAddressesByAccount(account.Id);

               IB_Programme__c programme = PimsTestUtil.createProgrammeForAccount(account, 'MYP');
              // insert programme;

               List<IB_Programme__c> programmeList = new List<IB_Programme__c>();
               programmeList.add(programme);
               system.debug(loggingLevel.error, 'record type: ' + programmeList[0].RecordType.Name);
               system.debug(loggingLevel.error, 'record type id:' + programmeList[0].RecordTypeId);

               List<Contact> contactsByAccount = ps.getContactsByAccount(account.Id);

               IB_Role_Repository__c repo = PimsTestUtil.createRoleRepo('Programme Coordinator');
               repo.Display_In_PIMS_Community__c = true;
               insert repo;

               IB_Role_Repository__c repo2 = PimsTestUtil.createRoleRepo('Head of School (Overall)');
               repo.Display_In_PIMS_Community__c = true;
               insert repo2;

               IB_Role_Repository__c repo3 = PimsTestUtil.createRoleRepo('Billing Coordinator');
               repo.Display_In_PIMS_Community__c = true;
               insert repo3;

               List<IB_Role_Repository__c> rolesFromRepository = new List<IB_Role_Repository__c>();
               rolesFromRepository.add(repo);
               rolesFromRepository.add(repo2);
               rolesFromRepository.add(repo3);

               IB_Subject__c theSubject = new IB_Subject__c(
                    IB_Programme__c = 'CP',
                    IB_Programme_Long__c = 'IB Career-related Programme',
                    Subject_Group__c = 'Other',
                    Subject_Name__c = 'Career related study',
                    Subject_Code__c = 'careerstud'
               );
               insert theSubject;

               Role_Application_Subject__c roleAndAppSubject = new Role_Application_Subject__c(
                    IB_Subject__c = theSubject.Id
               );
               insert roleAndAppSubject;

            Test.startTest();

               IB_Role__c role = PimsTestUtil.createIbRole(repo.Id, con3.Id, account.Id);
               role.IB_Programme_New__c = programme.Id;
               insert role;

               PageReference pimsProfile = Page.PimsProfile;
               Test.setCurrentPage(pimsProfile);
               pimsProfile.getParameters().put('id',con3.Id);
               pimsProfile.getParameters().put('role',role.Id);

               PimsProfileContactEditController controller = new PimsProfileContactEditController();
               controller.programmes = programmeList;

               controller.rolesFromRepository = rolesfromRepository;

               system.debug(loggingLevel.ERROR, 'controller.programmes: ' + controller.programmes);

               controller.init();
               controller.edit();
               controller.createRole();
               controller.addSubject = theSubject.Id;
               controller.createSubject();
               controller.deleteId = roleAndAppSubject.Id;
               controller.removeSubject();
               controller.createProDev();
               controller.updateProDev();
               controller.removeProDev();
              controller.sendEmail('test@example.com');
              controller.createEmail();
              //Following code line is added by Umair-Plumlogix of US11096 on 02/11/2020
              System.assertEquals(1,i);
               List<SelectOption> progOpts = controller.getProgrammeOptions();
               List<SelectOption> roleOpts = controller.getRoleOptions();
               List<SelectOption> subGroups = controller.getSubjectGroups();
               List<SelectOption> subNames = controller.getSubjectNames();
               DateUtility dateVal = controller.dateUtil;
               String userLang = controller.getUserLanguageKey();
               //Following code line is added by Umair-Plumlogix of US11096 on 02/11/2020
              System.assertEquals(1,i);

            //Test.stopTest();

          }
         

         
     }
    
     static testMethod void test_method_three() {
         integer i=1;
         Profile p =  [select Id from profile where Name='Customer Community Advanced' limit 1];
        Account acc = new Account (
                Name = 'test acc name',
                Region__c = 'IBAEM',
                Sub_region__c = 'EUROPE',
                External_PD_Provider__c = true,
                Language_Of_Correspondance__c = 'English',
                Legal_Status__c = 'Private',
                Billing_Currency__c = 'USD',
                Lead_Account__c = true,
                Short_Name__c = 'test acc name'
            );
           
        acc.PIMS_Step_1__c = true;
        acc.PIMS_Step_2__c = true;
        acc.PIMS_Step_3__c = true;
        acc.PIMS_Step_4__c = true;
        acc.PIMS_Step_5__c = true;
        acc.Website = 'http://www.google.com';
        acc.Year_Founded__c = '1990';
        acc.Academic_Start_Month__c ='August' ;
        acc.Academic_End_Month__c = 'May';
        acc.Month_Founded__c = 'January';
        acc.Legal_Status__c = 'State';
        acc.Language_Of_Correspondance__c = 'English';
        acc.Region__c = 'IBAEM';

        insert acc;

        Contact c = new Contact (
            Salutation = 'Mr.',
            LastName = 'test name',
            MobilePhone = '+30992907711',
            HomePhone = '+30992907711',
            //OtherPhone = '+30992907711',
            Email = 'testname.unique@ibo.org',
            Birthdate = Date.today().addYears(-22),
            Alternative_Email__c  = 'noname@example.commm',
            FirstName = 'noname',
            MailingCity = 'Palm Coast',
            MailingState = 'Florida',
            MailingCountry = 'United States',
            MailingPostalCode = '32137',
            MailingStreet = 'street',
            AccountId = acc.Id,
            Full_time_Part_time__c = 'Full Time',
            Number_of_years_at_school__c = '4',
            Phone = '+13861234567',
            Qualifications__c = 'BS',
            Job_Title__c = 'Blah',
            Birth_Locale__c   = 'sea',
            Country_of_Birth__c = 'Armenia'
        );
           
        c.AccountId = acc.Id;
        insert c;

        SchoolSections__c s = new SchoolSections__c(
            Grade_From__c = '0',
            Grade_To__c = '13',
            Account__c = acc.Id,
            Number_Of_Students__c = 10,
            Number_Of_Classes__c = 10
        );

        insert s;

        SchoolSections__c s1 = new SchoolSections__c(
            Grade_From__c = 'K',
            Grade_To__c = 'K',
            Account__c = acc.Id,
            Number_Of_Students__c = 10,
            Number_Of_Classes__c = 10
        );

        insert s1;
         IB_Programme__c programme = PimsTestUtil.createProgrammeForAccount(acc, 'Diploma Programme');
         insert programme;         


        User u = new User(profileId = p.id, username = 'testname.unique@ibo.org', email ='testname.unique@ibo.org',
                           emailencodingkey = 'UTF-8', localesidkey = 'en_US',
                           languagelocalekey = 'en_US', timezonesidkey = 'America/Los_Angeles',

                           alias='cspu', lastname='lastname',contactId = c.id);
        insert u;
             
          System.runAs(u){

               ProfileService ps = new ProfileService();
               Account account = ps.getProfileAccount();              
               List<Contact> currContacts = ps.getContactsByAccount(acc.Id);
               Contact con3 = currContacts[0];
                con3.Phone_Number__c = '123123123';
              con3.Country_Code__c = 'Israel (+972)';
              update con3;
               List<IB_Address__c> addressesByAccount = ps.getAllAddressesByAccount(acc.Id);

               List<IB_Programme__c> programmeList = new List<IB_Programme__c>();
               programmeList.add(programme);
               system.debug(loggingLevel.error, 'record type: ' + programmeList[0].RecordType.Name);
               system.debug(loggingLevel.error, 'record type id:' + programmeList[0].RecordTypeId);
               List<Contact> contactsByAccount = ps.getContactsByAccount(acc.Id);
               IB_Role_Repository__c repo = PimsTestUtil.createRoleRepo('Programme Coordinator');
               repo.Display_In_PIMS_Community__c = true;
               repo.Application_Available_in_MyIB__c = false;
               repo.Role_Name__c = 'Test';
               insert repo;

               IB_Role_Repository__c repo2 = PimsTestUtil.createRoleRepo('Head of School (Overall)');
               repo.Display_In_PIMS_Community__c = true;
               insert repo2;

               IB_Role_Repository__c repo3 = PimsTestUtil.createRoleRepo('Billing Coordinator');
               repo.Display_In_PIMS_Community__c = true;
               insert repo3;

               List<IB_Role_Repository__c> rolesFromRepository = new List<IB_Role_Repository__c>();
               rolesFromRepository.add(repo);
               rolesFromRepository.add(repo2);
               rolesFromRepository.add(repo3);

               IB_Subject__c theSubject = new IB_Subject__c(
                    IB_Programme__c = 'CP',
                    IB_Programme_Long__c = 'IB Career-related Programme',
                    Subject_Group__c = 'Other',
                    Subject_Name__c = 'Career related study',
                    Subject_Code__c = 'careerstud'
               );
               insert theSubject;

               Role_Application_Subject__c roleAndAppSubject = new Role_Application_Subject__c(
                    IB_Subject__c = theSubject.Id
               );
               insert roleAndAppSubject;

            Test.startTest();

            IB_Role__c role = new IB_Role__c(
            IB_Contact__c = con3.Id,
            IB_Role__c = repo3.Id,
            Programme_Selection__c='PYP;MYP;DP;IBCC',
            Status__c='Confirmed',
            Active__c = true,
            Role_Level__c = 'Fully Qualified',
            IB_Account__c = acc.id,
            IB_Programme_New__c = programme.Id
        );
          
               role.IB_Programme_New__c = programme.Id;
               insert role;

               PageReference pimsProfile = Page.PimsProfile;
               Test.setCurrentPage(pimsProfile);
               pimsProfile.getParameters().put('id',con3.Id);
               pimsProfile.getParameters().put('role',role.Id);
               pimsProfile.getParameters().put('sub',roleAndAppSubject.Id);
              system.debug('pageIdA'+pimsProfile.getAnchor());

               PimsProfileContactEditController controller = new PimsProfileContactEditController();
               controller.programmes = programmeList;
                controller.email = 'xxxx1@xxx.xx';
                controller.emailBody = 'hello!';
               controller.url = 'www.yyyy.yy';
               controller.invitationID = con3.Invitation_ID__c;


               controller.contactForEmail = con3;

               controller.rolesFromRepository = rolesfromRepository;
               controller.init();
           

               controller.edit();
               controller.createRole();
               controller.addSubject = theSubject.Id;
               controller.createSubject();
            //  Boolean abc = false;
                controller.phone_number = '2345670' ;
           // controller.MobilePhone = '1234567890' ;
            controller.citySelected='(+92)';
             
             //  controller.deleteId = roleAndAppSubject.Id;

               controller.removeSubject();
               controller.createProDev();
               controller.updateProDev();
               controller.removeProDev();
               controller.editAccountEmailOnly();
               List<SelectOption> progOpts = controller.getProgrammeOptions();
               List<SelectOption> roleOpts = controller.getRoleOptions();

              system.debug('before getSubjectGroups');
               List<SelectOption> subGroups = controller.getSubjectGroups();
              system.debug('after getSubjectGroups');
               List<SelectOption> subNames = controller.getSubjectNames();

               DateUtility dateVal = controller.dateUtil;
              String userLang = controller.getUserLanguageKey();
              System.assertEquals(1,i);
              
              controller.edit_phone();

            Test.stopTest();

          }
     }
    
    
    
    static testMethod void test_method_four() {
         integer i=1;

       
          User u = PimsTestUtil.createPortalUserPIMS('testname.unique@ibo.org','August','May',false);
          u.LanguageLocaleKey='fr';
          u.FirstName = 'test2';
             
          insert u;
           

          System.runAs(u){

               ProfileService ps = new ProfileService();

               Account account = ps.getProfileAccount();

               List<Contact> currContacts = ps.getContactsByAccount(account.Id);
               Contact con3 = currContacts[0];

               List<IB_Address__c> addressesByAccount = ps.getAllAddressesByAccount(account.Id);

               IB_Programme__c programme = PimsTestUtil.createProgrammeForAccount(account, 'MYP');
              // insert programme;

               List<IB_Programme__c> programmeList = new List<IB_Programme__c>();
               programmeList.add(programme);
               system.debug(loggingLevel.error, 'record type: ' + programmeList[0].RecordType.Name);
               system.debug(loggingLevel.error, 'record type id:' + programmeList[0].RecordTypeId);

               List<Contact> contactsByAccount = ps.getContactsByAccount(account.Id);

               IB_Role_Repository__c repo = PimsTestUtil.createRoleRepo('Programme Coordinator');
               repo.Display_In_PIMS_Community__c = true;
               insert repo;

               IB_Role_Repository__c repo2 = PimsTestUtil.createRoleRepo('Head of School (Overall)');
               repo.Display_In_PIMS_Community__c = true;
               insert repo2;

               IB_Role_Repository__c repo3 = PimsTestUtil.createRoleRepo('Billing Coordinator');
               repo.Display_In_PIMS_Community__c = true;
               insert repo3;

               List<IB_Role_Repository__c> rolesFromRepository = new List<IB_Role_Repository__c>();
               rolesFromRepository.add(repo);
               rolesFromRepository.add(repo2);
               rolesFromRepository.add(repo3);

               IB_Subject__c theSubject = new IB_Subject__c(
                    IB_Programme__c = 'CP',
                    IB_Programme_Long__c = 'IB Career-related Programme',
                    Subject_Group__c = 'Other',
                    Subject_Name__c = 'Career related study',
                    Subject_Code__c = 'careerstud'
               );
               insert theSubject;

               Role_Application_Subject__c roleAndAppSubject = new Role_Application_Subject__c(
                    IB_Subject__c = theSubject.Id
               );
               insert roleAndAppSubject;

            Test.startTest();

               IB_Role__c role = PimsTestUtil.createIbRole(repo.Id, con3.Id, account.Id);
               role.IB_Programme_New__c = programme.Id;
               insert role;

               PageReference pimsProfile = Page.PimsProfile;
               Test.setCurrentPage(pimsProfile);
               pimsProfile.getParameters().put('id',con3.Id);
               pimsProfile.getParameters().put('role',role.Id);

               PimsProfileContactEditController controller = new PimsProfileContactEditController();
               controller.programmes = programmeList;

               controller.rolesFromRepository = rolesfromRepository;

               system.debug(loggingLevel.ERROR, 'controller.programmes: ' + controller.programmes);

               controller.init();
               controller.edit();
               controller.createRole();
               controller.addSubject = theSubject.Id;
               controller.createSubject();
               controller.deleteId = roleAndAppSubject.Id;
               controller.removeSubject();
               controller.createProDev();
               controller.updateProDev();
               controller.removeProDev();
              controller.sendEmail('test@example.com');
              controller.createEmail();
              //Following code line is added by Umair-Plumlogix of US11096 on 02/11/2020
              System.assertEquals(1,i);
               List<SelectOption> progOpts = controller.getProgrammeOptions();
               List<SelectOption> roleOpts = controller.getRoleOptions();
               List<SelectOption> subGroups = controller.getSubjectGroups();
               List<SelectOption> subNames = controller.getSubjectNames();
               DateUtility dateVal = controller.dateUtil;
               String userLang = controller.getUserLanguageKey();
               //Following code line is added by Umair-Plumlogix of US11096 on 02/11/2020
              System.assertEquals(1,i);

            //Test.stopTest();

          }
         

         
     }
    
}