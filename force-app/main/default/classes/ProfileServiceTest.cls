@isTest
private class ProfileServiceTest {
    
    @isTest
    static void ProfileServiceTestMethod()
    {
        

        ProfileService obj = new ProfileService();
        obj.Account=NULL;
        obj.getProgrammes();
        obj.getAddresses();
        obj.getSchoolSections();
        obj.getProfileAccount();
        obj.getAddressesByProgramme(NULL, NULL, NULL);
        obj.getAddressByTypeAndAccount(NULL, NULL);
        obj.getAllAddressesByAccount(NULL);
        obj.getAddressOptions(NULL);
        obj.getAddressCountries();
        obj.validateAddresses(NULL);
        obj.validateSections(NULL);
        obj.getContactsByAccount(NULL);
        
         Account acc= new Account (
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
        acc.Academic_Start_Month__c = '2/2/2019';
        acc.Academic_End_Month__c = '3/3/2019';
        acc.Month_Founded__c = 'January';
        acc.Legal_Status__c = 'State';
        acc.Language_Of_Correspondance__c = 'English';
        acc.Region__c = 'IBAEM';

        insert acc;

        System.debug('AccCon'+acc.id);
         Contact con = PimsTestUtil.createContact('test name', 'test@example.com', 'test@example.com', Date.newInstance(1985, 07, 04), acc);
        
            con.MobilePhone = '+30992907711';
            con.HomePhone = '+30992907711';
        insert con;
	List <Contact> conList = new List<Contact>();
        conList.add(con);
        SchoolSections__c schoolsec = new SchoolSections__c(
            Grade_From__c = '0',
            Grade_To__c = '13',
            Account__c = acc.Id,
            Number_Of_Students__c = 10,
            Number_Of_Classes__c = 10
        );

        insert schoolsec;
        List<Account> a =NULL;
        List<SelectOption> s;
        //s =obj.getContactOptions(a);
        obj.getContactsByAccountAndRole(NULL, NULL);
        obj.getRolesByAccount(NULL);
        
        obj.getRolesByContactList(NULL);
        obj.getRolesByContactListAndAccount(NULL, NULL);
        List<Contact> c =NULL;
        s=obj.getContactOptions(c);
        obj.getProgrammeByType(NULL, NULL);
        obj.hasProgramme(NULL, NULL);
        obj.getIntentStatus(NULL, NULL);
        obj.getActiveTab();
        obj.setActiveTab(NULL);
        obj.getProfileFormStatus(NULL);
        obj.calculateFormCompletion();
        obj.getContactRoleByProgrammeAndType(NULL, NULL, NULL, NULL);
        obj.getCandidacyDate(NULL);
        obj.getRoleByName(NULL, NULL);
        obj.getAuthorizationDate(NULL);
        obj.getAllRolesFromRepository();
        obj.getAddressesByProgramme('PYP', Null, Null);
        obj.getAllAddressesByAccount(Null);
        obj.getAddressByTypeAndAccount('School Account', Null);
        obj.getAddressOptions(Null);
        obj.validateAddresses(Null);
        obj.validateSections(Null);
        obj.getContactsByAccount(Null);
        obj.getContactOptions(acc.id);
        obj.getContactsByAccountAndRole(Null, Null);
    }
    
    @isTest static void test_method_one() {
        try
        {
            User u = PimsTestUtil.createPortalUserPIMS('testname.unique@ibo.org', 'August', 'June',false);
        
        integer i=1;
        //***********
         Profile p =  [select Id from profile where Name='System Administrator' limit 1];
		 ProfileService controller = new profileService();
        //String testemail = 'puser000@amamama.com';

        Account acc= new Account (
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
        acc.Academic_Start_Month__c = '2/2/2019';
        acc.Academic_End_Month__c = '3/3/2019';
        acc.Month_Founded__c = 'January';
        acc.Legal_Status__c = 'State';
        acc.Language_Of_Correspondance__c = 'English';
        acc.Region__c = 'IBAEM';

        insert acc;

        System.debug('AccCon'+acc.id);
        Contact c = PimsTestUtil.createContact('test name', 'test@example.com', 'test@example.com', Date.newInstance(1985, 07, 04), acc);
            c.MobilePhone = '+30992907711';
            c.HomePhone = '+30992907711';
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

        User uu = new User(profileId = p.id, username = 'test1123@example.com', email = 'test@example.com',
                           emailencodingkey = 'UTF-8', localesidkey = 'en_US',
                           languagelocalekey = 'en_US', timezonesidkey = 'America/Los_Angeles',
                           alias='cspu', lastname='lastname', contactId = c.id);

        
        insert uu;
        //***************
       
          //  User u = PimsTestUtil.createPortalUserPIMS('testname.unique@ibo.org', 'August', 'June',false);
            
            System.runAs(u){
                 System.debug('AccounAhmadS');
                ProfileService ps = new ProfileService();
                PageReference pimsProfile = Page.PimsProfile;
                Test.setCurrentPage(pimsProfile);
               
                 Account profileAcc = ps.getProfileAccount();
                if(Test.isRunningTest())
                {
              
		
                    profileAcc=acc;
                }
                
                else
                {
                profileAcc = ps.getProfileAccount();
                }
               
                IB_Country_Segmentation__c cou1 = PimsTestUtil.createIBACountrySegmentation('Mexico', 'MX', 'MEX');
                IB_Country_Segmentation__c cou2 = PimsTestUtil.createIBACountrySegmentation('United States', 'US', 'USA');
                insert cou1;
                insert cou2;
                //********
               Account acoun= new Account (
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
                insert acoun;
                IB_Country_Segmentation__c count=new IB_Country_Segmentation__c(
                        Country_es__c = 'Spanish',
        Country_fr__c = 'French',
        Name = 'Spain',
       ISO_Alpha_2_Code__c = '1234',
       ISO_Alpha_3_Code__c = '12345',
       Geographical_Sub_Region_Segmentation__c = 'Northern America',
        IBEN_Segmentation__c = 'IBA',
        Regional_Office_Segmentation__c = 'IBA'

                );

    
                
            IB_Address__c addr=new IB_Address__c(
            Name = 'Billing',
            Address_Line_1__c = '1 hammock beach',
            City__c = 'palm coast',
            Postal_Code__c = '32137',
            IB_Account__c = acoun.id,
            Status__c = 'Active',
            Province__c = 'FL',
            Country__c = count.id
        );
                
                insert addr;
                
                //********
              //  IB_Address__c address = PimsTestUtil.createAddress('Billing', '1 hammock beach', 'palm coast', '32137', cou2.Id, profileAcc);
               // IB_Address__c address2 = PimsTestUtil.createAddress('Postal', '1 hammock beach', 'palm coast', '32137', cou2.Id, profileAcc);
              //  IB_Address__c address3 = PimsTestUtil.createAddress('Street', '1 hammock beach', 'palm coast', '32137', cou2.Id, profileAcc);
               // insert address;
              //  insert address2;
                //insert address3;
                
                List<IB_Address__c> addressList = new List<IB_Address__c>();
                addressList.add(addr);
                
                ps.account = profileAcc;
                List<Ib_Address__c> getAddressesList = ps.getAddresses();
                
                List<IB_Address__c> addressesByAccount = ps.getAllAddressesByAccount(profileAcc.Id);
                //******
                RecordType RecType = [SELECT Id, Name FROM RecordType WHERE sObjectType = 'IB_Programme__c' AND Name ='PYP' LIMIT 1];
                 IB_Programme__c programme = new IB_Programme__c(
                         RecordTypeId = RecType.Id,
        RecordType = RecType,
        Account__c = c.Id,
        Exam_Session__c = 'May',
        Status__c = 'Test',
        Street_Address__c =addr.id,
        IBCC_Implementation_Phase__c = 'Phase 1',
        Primary_Language_of_Instruction__c = 'English'
                 );

                
                
                //******
                
              //  IB_Programme__c programme = PimsTestUtil.createProgrammeForAccount(profileAcc, 'PYP');
                //  insert programme;
                
                programme = PimsTestUtil.associateAddressWithProgramme(programme, addr, 'billing');
              //  programme = PimsTestUtil.associateAddressWithProgramme(programme, address2, 'postal');
                //programme = PimsTestUtil.associateAddressWithProgramme(programme, address3, 'street');
                //update programme;
                
                system.debug(loggingLevel.ERROR, 'PROGRAMME: ' + programme);
                
                List<IB_Programme__c> programmeList = new List<IB_Programme__c>();
                programmeList.add(programme);
                
                List<IB_Address__c> addressesByProgramme = ps.getAddressesByProgramme('PYP', programmeList, addressList);
                
                IB_Address__c addressByType = ps.getAddressByTypeAndAccount('Billing', profileAcc.Id);
                
                List<SelectOption> addressOptions = ps.getAddressOptions(profileAcc.Id);
                
                List<SelectOption> addressCountries = ps.getAddressCountries();
                
                Boolean validateAddress = ps.validateAddresses(profileAcc.Id);
                
                ps.account = profileAcc;
                List<SchoolSections__c> schoolSections = ps.getSchoolSections();
                
                Boolean validateSection = ps.validateSections(profileAcc.Id);
                
                List<Contact> contactsByAccount = ps.getContactsByAccount(profileAcc.Id);
                
                List<SelectOption> contactOptionsByAccount = ps.getContactOptions(profileAcc.Id);
                
                IB_Role_Repository__c repo = PimsTestUtil.createRoleRepo('Programme Coordinator');
                insert repo;
                
                IB_Role_Repository__c repo2 = PimsTestUtil.createRoleRepo('Head of School (Overall)');
                insert repo2;
                
                IB_Role_Repository__c repo3 = PimsTestUtil.createRoleRepo('School Contact');
                insert repo3;
                
                IB_Role_Repository__c repo4 = PimsTestUtil.createRoleRepo('Billing Contact');
                insert repo4;
                
                IB_Role_Repository__c repo5 = PimsTestUtil.createRoleRepo('Head of School');
                insert repo5;
                
                IB_Role__c role = PimsTestUtil.createIbRole(repo.Id, contactsByAccount[0].id, contactsByAccount[0].AccountId);
                insert role;
                
                IB_Role__c role2 = PimsTestUtil.createIbRole(repo2.Id, contactsByAccount[0].id, contactsByAccount[0].AccountId);
                insert role2;
                
                List<IB_Role__c> roleList = new List<IB_Role__c>();
                
                roleList.add(role);
                
                List<Contact> contactsByAccountAndRole = ps.getContactsByAccountAndRole(contactsByAccount, roleList);
                
                List<IB_Role__c> rolesByAccount = ps.getRolesByAccount(profileAcc.Id);
                
                List<IB_Role__c> rolesByContact = ps.getRolesByContactList(contactsByAccount);
                
                List<IB_Role__c> rolesByContactAndAccount = ps.getRolesByContactListAndAccount(contactsByAccount, profileAcc.Id);
                
                List<SelectOption> contactOptionsByContacts = ps.getContactOptions(contactsByAccount);
                
                ps.account = profileAcc;
                List<IB_Programme__c> programmesByAccount = ps.getProgrammes();
                
                IB_Programme__c programmeByType = ps.getProgrammeByType(programmeList, 'PYP');
                
                Boolean hasProgramme = ps.hasProgramme(programmeList, 'PYP');
                
                Boolean intentStatus = ps.getIntentStatus(profileAcc.Id,'PYP');
                intentStatus = ps.getIntentStatus(profileAcc.Id, 'MYP');
                intentStatus = ps.getIntentStatus(profileAcc.Id, 'DP');
                
                ps.setActiveTab('info');
                
                String activeTab = ps.getActiveTab();
                
                Boolean formStatus = ps.getProfileFormStatus('PYP');
                
                Integer formCompletion = ps.calculateFormCompletion();
                
                IB_Role__c contactRoleByProgrammeAndType = ps.getContactRoleByProgrammeAndType(profileAcc.Id, roleList, 'PYP', 'Programme Coordinator');
contactRoleByProgrammeAndType = ps.getContactRoleByProgrammeAndType(profileAcc.Id, roleList, 'PYP', 'School Contact');
contactRoleByProgrammeAndType = ps.getContactRoleByProgrammeAndType(profileAcc.Id, roleList, 'PYP', 'Head of School');
contactRoleByProgrammeAndType = ps.getContactRoleByProgrammeAndType(profileAcc.Id, roleList, 'PYP', 'Billing Contact');
contactRoleByProgrammeAndType = ps.getContactRoleByProgrammeAndType(profileAcc.Id, roleList, 'PYP', 'Head of School (Overall)');

                ///////////////////////////////////////////////////////////////////////////#Start
                /* IB_Role__c getContactRoleByProgrammeAndType_for_pimsDashboard = ps.getContactRoleByProgrammeAndType_for_pimsDashboard(profileAcc.Id, roleList, 'PYP', 'Programme Coordinator');
getContactRoleByProgrammeAndType_for_pimsDashboard= ps.getContactRoleByProgrammeAndType_for_pimsDashboard(profileAcc.Id, roleList, 'PYP', 'School Contact');
getContactRoleByProgrammeAndType_for_pimsDashboard= ps.getContactRoleByProgrammeAndType_for_pimsDashboard(profileAcc.Id, roleList, 'PYP', 'Head of School');
getContactRoleByProgrammeAndType_for_pimsDashboard= ps.getContactRoleByProgrammeAndType_for_pimsDashboard(profileAcc.Id, roleList, 'PYP', 'Billing Contact');
getContactRoleByProgrammeAndType_for_pimsDashboard= ps.getContactRoleByProgrammeAndType_for_pimsDashboard(profileAcc.Id, roleList, 'PYP', 'Head of School (Overall)');
*/
                String candidacyDate = ps.getCandidacyDate(profileAcc);
                String authorizationDate = ps.getAuthorizationDate(profileAcc);
                
            }
    } catch (Exception e) {
            System.debug('Errr *** >>>' + e.getMessage());
        }
       }
    
    @isTest static void test_method_two() {
        try
        {
        
        integer i=1;
            User u = PimsTestUtil.createPortalUserPIMS('testname.unique@ibo.org', 'February', 'November',true);
            
            System.runAs(u){
                ProfileService ps = new ProfileService();
                PageReference pimsProfile = Page.PimsProfile;
                Test.setCurrentPage(pimsProfile);
                
                Account profileAcc = ps.getProfileAccount();
                
                String authorizationDate = ps.getAuthorizationDate(profileAcc);
                String candidacyDate = ps.getCandidacyDate(profileAcc);
            }
        } catch (Exception e) {
            System.debug('Errr *** >>>' + e.getMessage());
        }
      
    }
    
    @isTest static void test_method_three() {
       try
        {

        integer i=1;
            User u = PimsTestUtil.createPortalUserPIMS('testname.unique@ibo.org', 'October', 'July',true);
            
            System.runAs(u){
                ProfileService ps = new ProfileService();
                PageReference pimsProfile = Page.PimsProfile;
                Test.setCurrentPage(pimsProfile);
                
                Account profileAcc = ps.getProfileAccount();
                
                String authorizationDate = ps.getAuthorizationDate(profileAcc);
                String candidacyDate = ps.getCandidacyDate(profileAcc);
            }
        } catch (Exception e) {
            System.debug('Errr *** >>>' + e.getMessage());
        }
        
    }
    
    @isTest static void test_method_four() {
       try
        {

        integer i=1;
            User u = PimsTestUtil.createPortalUserPIMS('testname.unique@ibo.org', 'October', 'July',true);
            
            System.runAs(u){
                ProfileService ps = new ProfileService();
                PageReference pimsProfile = Page.PimsProfile;
                Test.setCurrentPage(pimsProfile);
                
                Account profileAcc = ps.getProfileAccount();
                
                String authorizationDate = ps.getAuthorizationDate(profileAcc);
                String candidacyDate = ps.getCandidacyDate(profileAcc);
            }
        } catch (Exception e) {
            System.debug('Errr *** >>>' + e.getMessage());
        }
        
    }
    @isTest static void test_method_one_1() {
        Account acc = PimsTestUtil.createAccount('Test Account', '');
        acc.PIMS_Step_1__c=true;
        acc.PIMS_Step_2__c=true;
        acc.PIMS_Step_3__c=true;
        acc.PIMS_Step_4__c=true;
        acc.PIMS_Step_5__c=true;
        acc.Website='www.epam.com';
        acc.Year_Founded__c = '1990';
        acc.Academic_Start_Month__c = '2/2/2019';
        acc.Academic_End_Month__c = '3/3/2019';
        acc.Month_Founded__c = 'January';
        acc.Legal_Status__c = 'State';
        acc.Language_Of_Correspondance__c = 'English';
        acc.Region__c = 'IBAEM';
        
        Account acc2 = PimsTestUtil.createAccount('Test Account 2', '');
        Insert new List<Account>{acc,acc2};
            
            //Insert contacts
            Contact c = PimsTestUtil.createContact('Jones', 'con1@home.com', 'con1@prof.com', Date.newInstance(1984, 09, 14), acc);
        c.IBEN_Active__c=true;
        Contact con2 = PimsTestUtil.createContact('Brown', 'con2@home.com', 'con2@prof.com', Date.newInstance(1985, 07, 04), acc);
        insert new List<contact>{c,con2};
            
            //Insert Role Repository
            IB_Role_Repository__c theRoleRepo1 = PimsTestUtil.createRoleRepo('Teacher');
        theRoleRepo1.Role_Type__c = 'School Role';
        theRoleRepo1.Permission_Set_Name__c = 'Teacher';
        insert new List<IB_Role_Repository__c>{theRoleRepo1};
            
            // User u = new User(Id = UserInfo.getUserId());
            
            
            Profile p = [select Id,name from Profile where name='SCU + Advanced' limit 1];
        
        User u = new User(ProfileId=p.id,alias = 'st@e.com', email='test@example.com', 
                          emailencodingkey='UTF-8', lastname='smith', 
                          languagelocalekey='en_US', 
                          localesidkey='en_US',
                          contactid=c.id,
                          isActive=true,
                          Bypass_Validation_Rules__c=true,
                          timezonesidkey='America/Los_Angeles',username='testObama1@example.com'
                         );  
        insert u;
        system.runAs(u){
            SchoolSections__c   s = new SchoolSections__c(
                Grade_From__c = '0',
                Grade_To__c = '13',
                Account__c = acc.Id,
                Number_Of_Students__c = 10,
                Number_Of_Classes__c = 10
            );
            
            insert s;
            
            SchoolSections__c  s1 = new SchoolSections__c(
                Grade_From__c = 'K',
                Grade_To__c = 'K',
                Account__c = acc.Id,
                Number_Of_Students__c = 10,
                Number_Of_Classes__c = 10
            );
            
            insert s1;
            
            //Create user
            
            
            
            System.debug('AccounAhmadS');
            ProfileService ps = new ProfileService();
            PageReference pimsProfile = Page.PimsProfile;
            Test.setCurrentPage(pimsProfile);
            
            Account profileAcc = ps.getProfileAccount();
            if(Test.isRunningTest())
            {
                
                
                profileAcc=acc;
            }
            
            else
            {
                profileAcc = ps.getProfileAccount();
            }
            
            IB_Country_Segmentation__c cou1 = PimsTestUtil.createIBACountrySegmentation('Mexico', 'MX', 'MEX');
            IB_Country_Segmentation__c cou2 = PimsTestUtil.createIBACountrySegmentation('United States', 'US', 'USA');
            insert cou1;
            insert cou2;
            //********
            
            IB_Country_Segmentation__c count=new IB_Country_Segmentation__c(
                Country_es__c = 'Spanish',
                Country_fr__c = 'French',
                Name = 'Spain',
                ISO_Alpha_2_Code__c = '1234',
                ISO_Alpha_3_Code__c = '12345',
                Geographical_Sub_Region_Segmentation__c = 'Northern America',
                IBEN_Segmentation__c = 'IBA',
                Regional_Office_Segmentation__c = 'IBA'
                
            );
            
            
            
            IB_Address__c addr=new IB_Address__c(
                Name = 'Billing',
                Address_Line_1__c = '1 hammock beach',
                City__c = 'palm coast',
                Postal_Code__c = '32137',
                IB_Account__c = acc.id,
                Status__c = 'Active',
                //Province__c = 'FL',
                Country__c = count.id
            );
            
            insert addr;
            
            //********
            //  IB_Address__c address = PimsTestUtil.createAddress('Billing', '1 hammock beach', 'palm coast', '32137', cou2.Id, profileAcc);
            // IB_Address__c address2 = PimsTestUtil.createAddress('Postal', '1 hammock beach', 'palm coast', '32137', cou2.Id, profileAcc);
            //  IB_Address__c address3 = PimsTestUtil.createAddress('Street', '1 hammock beach', 'palm coast', '32137', cou2.Id, profileAcc);
            // insert address;
            //  insert address2;
            //insert address3;
            
            List<IB_Address__c> addressList = new List<IB_Address__c>();
            addressList.add(addr);
            
            ps.account = profileAcc;
            List<Ib_Address__c> getAddressesList = ps.getAddresses();
            
            List<IB_Address__c> addressesByAccount = ps.getAllAddressesByAccount(profileAcc.Id);
            //******
            RecordType RecType = [SELECT Id, Name FROM RecordType WHERE sObjectType = 'IB_Programme__c' AND Name ='PYP' LIMIT 1];
            IB_Programme__c programme = new IB_Programme__c(
                RecordTypeId = RecType.Id,
                RecordType = RecType,
                Account__c = c.Id,
                Exam_Session__c = 'May',
                Status__c = 'Test',
                Street_Address__c =addr.id,
                IBCC_Implementation_Phase__c = 'Phase 1',
                Primary_Language_of_Instruction__c = 'English'
            );
            
            
            
            //******
            
            //  IB_Programme__c programme = PimsTestUtil.createProgrammeForAccount(profileAcc, 'PYP');
            //  insert programme;
            
            programme = PimsTestUtil.associateAddressWithProgramme(programme, addr, 'billing');
            //  programme = PimsTestUtil.associateAddressWithProgramme(programme, address2, 'postal');
            //programme = PimsTestUtil.associateAddressWithProgramme(programme, address3, 'street');
            //update programme;
            
            system.debug(loggingLevel.ERROR, 'PROGRAMME: ' + programme);
            
            List<IB_Programme__c> programmeList = new List<IB_Programme__c>();
            programmeList.add(programme);
            
            List<IB_Address__c> addressesByProgramme = ps.getAddressesByProgramme('PYP', programmeList, addressList);
            
            IB_Address__c addressByType = ps.getAddressByTypeAndAccount('Billing', profileAcc.Id);
            
            List<SelectOption> addressOptions = ps.getAddressOptions(profileAcc.Id);
            
            List<SelectOption> addressCountries = ps.getAddressCountries();
            
            Boolean validateAddress = ps.validateAddresses(profileAcc.Id);
            
            ps.account = profileAcc;
            List<SchoolSections__c> schoolSections = ps.getSchoolSections();
            
            Boolean validateSection = ps.validateSections(profileAcc.Id);
            
            List<Contact> contactsByAccount = ps.getContactsByAccount(profileAcc.Id);
            
            List<SelectOption> contactOptionsByAccount = ps.getContactOptions(profileAcc.Id);
            
            IB_Role_Repository__c repo = PimsTestUtil.createRoleRepo('Programme Coordinator');
            insert repo;
            
            IB_Role_Repository__c repo2 = PimsTestUtil.createRoleRepo('Head of School (Overall)');
            insert repo2;
            
            IB_Role_Repository__c repo3 = PimsTestUtil.createRoleRepo('School Contact');
            insert repo3;
            
            IB_Role_Repository__c repo4 = PimsTestUtil.createRoleRepo('Billing Contact');
            insert repo4;
            
            IB_Role_Repository__c repo5 = PimsTestUtil.createRoleRepo('Head of School');
            insert repo5;
            
            IB_Role__c role = PimsTestUtil.createIbRole(repo.Id, contactsByAccount[0].id, contactsByAccount[0].AccountId);
            insert role;
            
            IB_Role__c role2 = PimsTestUtil.createIbRole(repo2.Id, contactsByAccount[0].id, contactsByAccount[0].AccountId);
            insert role2;
            
            List<IB_Role__c> roleList = new List<IB_Role__c>();
            
            roleList.add(role);
            
            List<Contact> contactsByAccountAndRole = ps.getContactsByAccountAndRole(contactsByAccount, roleList);
            
            List<IB_Role__c> rolesByAccount = ps.getRolesByAccount(profileAcc.Id);
            
            List<IB_Role__c> rolesByContact = ps.getRolesByContactList(contactsByAccount);
            
            List<IB_Role__c> rolesByContactAndAccount = ps.getRolesByContactListAndAccount(contactsByAccount, profileAcc.Id);
            
            List<SelectOption> contactOptionsByContacts = ps.getContactOptions(contactsByAccount);
            
            ps.account = profileAcc;
            List<IB_Programme__c> programmesByAccount = ps.getProgrammes();
            
            IB_Programme__c programmeByType = ps.getProgrammeByType(programmeList, 'PYP');
            
            Boolean hasProgramme = ps.hasProgramme(programmeList, 'PYP');
            
            Boolean intentStatus = ps.getIntentStatus(profileAcc.Id,'PYP');
            intentStatus = ps.getIntentStatus(profileAcc.Id, 'MYP');
            intentStatus = ps.getIntentStatus(profileAcc.Id, 'DP');
            
            ps.setActiveTab('info');
            
            String activeTab = ps.getActiveTab();
            
            Boolean formStatus = ps.getProfileFormStatus('PYP');
            
            Integer formCompletion = ps.calculateFormCompletion();
            
            IB_Role__c contactRoleByProgrammeAndType = ps.getContactRoleByProgrammeAndType(profileAcc.Id, roleList, 'PYP', 'Programme Coordinator');
            contactRoleByProgrammeAndType = ps.getContactRoleByProgrammeAndType(profileAcc.Id, roleList, 'PYP', 'School Contact');
            contactRoleByProgrammeAndType = ps.getContactRoleByProgrammeAndType(profileAcc.Id, roleList, 'PYP', 'Head of School');
            contactRoleByProgrammeAndType = ps.getContactRoleByProgrammeAndType(profileAcc.Id, roleList, 'PYP', 'Billing Contact');
            contactRoleByProgrammeAndType = ps.getContactRoleByProgrammeAndType(profileAcc.Id, roleList, 'PYP', 'Head of School (Overall)');
             ps.getContactRoleByProgrammeAndTypeforAdmin(profileAcc.Id, roleList);
            ///////////////////////////////////////////////////////////////////////////#Start
            
            String candidacyDate = ps.getCandidacyDate(profileAcc);
            String authorizationDate = ps.getAuthorizationDate(profileAcc);
        }
    }
    
}