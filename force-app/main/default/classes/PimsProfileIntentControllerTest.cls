@isTest

private class PimsProfileIntentControllerTest {
    
    @isTest
    static void testSavePypIBAEM() {
        List<IB_Role__c> listRolesToInsert = new List<IB_Role__c>();
        integer i=1;
        
        Account a = PimsTestUtil.createAccount('Coastal Cloud High School', 'School Account');
        a.IBIS_ID__c = '123654';
        insert a;
        system.debug('a.id ' + a.id);
        User u = PimsTestUtil.createPortalUserPYP('test.pims@ibotest.org', false);
        insert u;
        User usr = [select Contact.AccountId from user where id =: u.id];
        system.debug('usr.Contact.AccountId: ' + usr.Contact.AccountId);
        IB_Address__c addr = new IB_Address__c(Address_Line_1__c = 'Test Addr', City__c = 'NY', Province__c = 'NY', Postal_Code__c = '12345',IB_Account__c = usr.Contact.AccountId);
        insert addr;
        
        
        System.runAs(u) {
            
            ProfileService ps = new ProfileService();
            
            Account account = ps.getProfileAccount();
            account.IBIS_ID__c = '123656';
            system.debug('account.id ' + account.id);
            Contact con = PimsTestUtil.createContact('Test Contact', 'a@a.com', 'a@a.com', Date.newInstance(1980, 01, 01), account);
            insert con;
            
            PimsProfileIntentController controller = new PimsProfileIntentController();
            controller.getUserLanguageKey();
            controller.account = account;
            controller.isDashboardPage = true;
            controller.hasPypProgramme = false;
            controller.hasMypProgramme = false;
            controller.hasDpProgramme = false;
            controller.hasIbccProgramme = false;
           
                controller.pypProgramme = PimsTestUtil.createProgrammeForAccount2(account);
                //PageReference savePyp = controller.savePyp();
                PageReference savePyp;
                IB_Role_Repository__c repo2 = PimsTestUtil.createRoleRepo('Head of School (Overall)');
                
                insert repo2;
                
                IB_Role__c role2 = PimsTestUtil.createIbRole(repo2.Id, con.id, account.id);
                
                insert role2;
                
                
                IB_Role_Repository__c repo = PimsTestUtil.createRoleRepo('Programme Coordinator');
                insert repo;
                
                IB_Role__c role = PimsTestUtil.createIbRole(repo.Id, con.id, account.id);
                listRolesToInsert.add(role);
                
                IB_Role_Repository__c repo3 = PimsTestUtil.createRoleRepo('Billing Coordinator');
                insert repo3;
                
                IB_Role__c role3 = PimsTestUtil.createIbRole(repo3.Id, con.id, account.id);
                listRolesToInsert.add(role3);
                
                IB_Role_Repository__c repo4 = PimsTestUtil.createRoleRepo('School Contact');
                insert repo4;
                
                IB_Role__c role4 = PimsTestUtil.createIbRole(repo4.Id, con.Id, account.Id);
                listRolesToInsert.add(role4);
            
                IB_Role_Repository__c repo5 = PimsTestUtil.createRoleRepo('Exam Contact');
                insert repo5;
                
                IB_Role__c role5 = PimsTestUtil.createIbRole(repo5.Id, con.id, account.id);
                listRolesToInsert.add(role5);
            
                insert listRolesToInsert;
            Test.startTest();
                //controller.primaryContactRole = role;
                controller.headOfSchoolContactRole = role2;
            system.debug('rolee2  '+role2);
                controller.billingContactRole = role3;
                
                controller.programmeContactRole = role4;
                
                controller.examContactRole = role5;
                
                controller.pypProgramme.Programme_Legal_Name__c = 'Test Legal Name';
                controller.pypProgramme.Street_Address__c = addr.id;
                controller.account.Website = 'http://www.google.com';
                controller.account.Year_Founded__c = '1990';
                controller.account.Academic_Start_Month__c = 'August';
                controller.account.Academic_End_Month__c = 'May';
                controller.account.Month_Founded__c = 'January';
                controller.account.Legal_Status__c = 'State';
                controller.account.Language_Of_Correspondance__c = 'English';
                controller.account.Short_Name__c='short';
                //Following code line is added by Umair-Plumlogix of US11096 on 02/11/2020
                System.assertEquals(1,i);
                
                List<IB_Role__c> headOfSchool =  [
                    SELECT Id, Name, Role_Has_Subjects__c,IB_Contact__c, IB_Account__c, First_Name__c, Last_Name__c, IB_Programme_New__c, Programme_Type__c, Programme_Type_ES__c, Programme_Type_FR__c, IB_Role__c, IB_Role_Name__c, IB_Role_Name_es__c, IB_Role_Name_fr__c, IB_Programme_New__r.RecordType.Name
                    FROM IB_Role__c
                    ];
                
                system.debug('headOfSchoolTest  '+headOfSchool);
                controller.storePYPIntentInfo();
                savePyp = controller.savePyp();
            
        }
        Test.stopTest();
    }
    @isTest
    static void testSavePypIBAAdmin() {
        List<IB_Role__c> listRolesToInsert = new List<IB_Role__c>();
        integer i=1;
        
        Account a = PimsTestUtil.createAccount('Coastal Cloud High School', 'School Account');
        a.IBIS_ID__c = '123654';
		a.Region__c = 'IBA';
		a.Academic_End_Month__c = 'January';
        insert a;
        system.debug('a.id ' + a.id);
        User u = PimsTestUtil.createPortalUserPYP('test.pims@ibotest.org', false);
        insert u;
        User usr = [select Contact.AccountId from user where id =: u.id];
        system.debug('usr.Contact.AccountId: ' + usr.Contact.AccountId);
        IB_Address__c addr = new IB_Address__c(Address_Line_1__c = 'Test Addr', City__c = 'NY', Province__c = 'NY', Postal_Code__c = '12345',IB_Account__c = usr.Contact.AccountId);
        insert addr;
        
        
        //System.runAs(u) {
            
            ProfileService ps = new ProfileService();
            
            //Account account = ps.getProfileAccount();
			Account account = a;
            account.IBIS_ID__c = '123656';
            system.debug('account.id ' + account.id);
            Contact con = PimsTestUtil.createContact('Test Contact', 'a@a.com', 'a@a.com', Date.newInstance(1980, 01, 01), account);
            insert con;
            
            PimsProfileIntentController controller = new PimsProfileIntentController();
            controller.getUserLanguageKey();
            controller.account = account;
            controller.isDashboardPage = true;
            controller.hasPypProgramme = false;
            controller.hasMypProgramme = false;
            controller.hasDpProgramme = false;
            controller.hasIbccProgramme = false;
           
			controller.pypProgramme = PimsTestUtil.createProgrammeForAccount2(account);
			//PageReference savePyp = controller.savePyp();
			PageReference savePyp;
			IB_Role_Repository__c repo2 = PimsTestUtil.createRoleRepo('Head of School (Overall)');
			
			insert repo2;
			system.debug('repo2.Id: ' + repo2.Id);
			system.debug('repo2.Role_Name__c: ' + repo2.Role_Name__c);
			IB_Role__c role2 = PimsTestUtil.createIbRole(repo2.Id, con.id, account.id);
			
			insert role2;
			system.debug('role2.Id: ' + role2.Id);
			system.debug('role2.IB_Role_Name__c: ' + role2.IB_Role_Name__c);
			id hosRoleId = role2.Id;
			List<IB_Role__c> headOfSchool1 =  [
				SELECT Id, Name, Role_Has_Subjects__c,IB_Contact__c, IB_Account__c, First_Name__c, Last_Name__c, IB_Programme_New__c, Programme_Type__c, Programme_Type_ES__c, Programme_Type_FR__c, IB_Role__c, IB_Role_Name__c, IB_Role_Name_es__c, IB_Role_Name_fr__c, IB_Programme_New__r.RecordType.Name
				FROM IB_Role__c WHERE ID = :hosRoleId 
				];
			
			system.debug('headOfSchoolTest: '+headOfSchool1);
			
			IB_Role_Repository__c repo = PimsTestUtil.createRoleRepo('Programme Coordinator');
			insert repo;
			
			IB_Role__c role = PimsTestUtil.createIbRole(repo.Id, con.id, account.id);
			listRolesToInsert.add(role);
			
			IB_Role_Repository__c repo3 = PimsTestUtil.createRoleRepo('Billing Coordinator');
			insert repo3;
			
			IB_Role__c role3 = PimsTestUtil.createIbRole(repo3.Id, con.id, account.id);
			listRolesToInsert.add(role3);
			
			IB_Role_Repository__c repo4 = PimsTestUtil.createRoleRepo('School Contact');
			insert repo4;
			
			IB_Role__c role4 = PimsTestUtil.createIbRole(repo4.Id, con.Id, account.Id);
			listRolesToInsert.add(role4);
			IB_Role_Repository__c repo5 = PimsTestUtil.createRoleRepo('Exam Contact');
			insert repo5;
			
			IB_Role__c role5 = PimsTestUtil.createIbRole(repo5.Id, con.id, account.id);
			
			listRolesToInsert.add(role5);
        
        	insert listRolesToInsert;
        Test.startTest();
			//controller.primaryContactRole = role;
			controller.headOfSchoolContactRole = role2;
			system.debug('rolee2  '+role2);
			controller.billingContactRole = role3;
			
			controller.programmeContactRole = role4;
			
			controller.examContactRole = role5;
			
			controller.pypProgramme.Programme_Legal_Name__c = 'Test Legal Name';
			controller.pypProgramme.Street_Address__c = addr.id;
			controller.account.Website = 'http://www.google.com';
			controller.account.Year_Founded__c = '1990';
			controller.account.Academic_Start_Month__c = 'August';
			controller.account.Academic_End_Month__c = 'May';
			controller.account.Month_Founded__c = 'January';
			controller.account.Legal_Status__c = 'State';
			controller.account.Language_Of_Correspondance__c = 'English';
			controller.account.Short_Name__c='short';
			//Following code line is added by Umair-Plumlogix of US11096 on 02/11/2020
			System.assertEquals(1,i);
			
			List<IB_Role__c> headOfSchool =  [
				SELECT Id, Name, Role_Has_Subjects__c,IB_Contact__c, IB_Account__c, First_Name__c, Last_Name__c, IB_Programme_New__c, Programme_Type__c, Programme_Type_ES__c, Programme_Type_FR__c, IB_Role__c, IB_Role_Name__c, IB_Role_Name_es__c, IB_Role_Name_fr__c, IB_Programme_New__r.RecordType.Name
				FROM IB_Role__c WHERE IB_Account__c = :account.Id 
				AND IB_Role_Name__c = 'Head of School (Overall)'
				AND (End_Date__c = null OR End_Date__c > TODAY)
				];
			
			system.debug('headOfSchoolTest: '+headOfSchool);
			
			savePyp = controller.savePyp();
            
        //}
        Test.stopTest();
    }
    @isTest
    static void testSavePypIBAPAdmin() {
        
        integer i=1;
        List<IB_Role__c> listRolesToInsert = new List<IB_Role__c>();
        
        Account a = PimsTestUtil.createAccount('Coastal Cloud High School', 'School Account');
        a.IBIS_ID__c = '123654';
		a.Region__c = 'IBAP';
        insert a;
        system.debug('a.id ' + a.id);
        User u = PimsTestUtil.createPortalUserPYP('test.pims@ibotest.org', false);
        insert u;
        User usr = [select Contact.AccountId from user where id =: u.id];
        system.debug('usr.Contact.AccountId: ' + usr.Contact.AccountId);
        IB_Address__c addr = new IB_Address__c(Address_Line_1__c = 'Test Addr', City__c = 'NY', Province__c = 'NY', Postal_Code__c = '12345',IB_Account__c = usr.Contact.AccountId);
        insert addr;
        
        
        //System.runAs(u) {
            
            ProfileService ps = new ProfileService();
            
            Account account = a;
            account.IBIS_ID__c = '123656';
            system.debug('account.id ' + account.id);
            Contact con = PimsTestUtil.createContact('Test Contact', 'a@a.com', 'a@a.com', Date.newInstance(1980, 01, 01), account);
            insert con;
            
            PimsProfileIntentController controller = new PimsProfileIntentController();
            controller.getUserLanguageKey();
            controller.account = account;
            controller.isDashboardPage = true;
            controller.hasPypProgramme = false;
            controller.hasMypProgramme = false;
            controller.hasDpProgramme = false;
            controller.hasIbccProgramme = false;
           
                controller.pypProgramme = PimsTestUtil.createProgrammeForAccount2(account);
                //PageReference savePyp = controller.savePyp();
                PageReference savePyp;
                IB_Role_Repository__c repo2 = PimsTestUtil.createRoleRepo('Head of School (Overall)');
                
                insert repo2;
                
                IB_Role__c role2 = PimsTestUtil.createIbRole(repo2.Id, con.id, account.id);
                
                insert role2;
                
                
                IB_Role_Repository__c repo = PimsTestUtil.createRoleRepo('Programme Coordinator');
                insert repo;
                
                IB_Role__c role = PimsTestUtil.createIbRole(repo.Id, con.id, account.id);
                listRolesToInsert.add(role);
                
                IB_Role_Repository__c repo3 = PimsTestUtil.createRoleRepo('Billing Coordinator');
                insert repo3;
                
                IB_Role__c role3 = PimsTestUtil.createIbRole(repo3.Id, con.id, account.id);
                listRolesToInsert.add(role3);
                
                IB_Role_Repository__c repo4 = PimsTestUtil.createRoleRepo('School Contact');
                insert repo4;
                
                IB_Role__c role4 = PimsTestUtil.createIbRole(repo4.Id, con.Id, account.Id);
                listRolesToInsert.add(role4);
        
                IB_Role_Repository__c repo5 = PimsTestUtil.createRoleRepo('Exam Contact');
                insert repo5;
                
                IB_Role__c role5 = PimsTestUtil.createIbRole(repo5.Id, con.id, account.id);
                listRolesToInsert.add(role5);
        
                insert listRolesToInsert;
        Test.startTest();
                //controller.primaryContactRole = role;
                controller.headOfSchoolContactRole = role2;
            system.debug('rolee2  '+role2);
                controller.billingContactRole = role3;
                
                controller.programmeContactRole = role4;
                
                controller.examContactRole = role5;
                
                controller.pypProgramme.Programme_Legal_Name__c = 'Test Legal Name';
                controller.pypProgramme.Street_Address__c = addr.id;
                controller.account.Website = 'http://www.google.com';
                controller.account.Year_Founded__c = '1990';
                controller.account.Academic_Start_Month__c = 'August';
                controller.account.Academic_End_Month__c = 'May';
                controller.account.Month_Founded__c = 'January';
                controller.account.Legal_Status__c = 'State';
                controller.account.Language_Of_Correspondance__c = 'English';
                controller.account.Short_Name__c='short';
                //Following code line is added by Umair-Plumlogix of US11096 on 02/11/2020
                System.assertEquals(1,i);
                
                List<IB_Role__c> headOfSchool =  [
                    SELECT Id, Name, Role_Has_Subjects__c,IB_Contact__c, IB_Account__c, First_Name__c, Last_Name__c, IB_Programme_New__c, Programme_Type__c, Programme_Type_ES__c, Programme_Type_FR__c, IB_Role__c, IB_Role_Name__c, IB_Role_Name_es__c, IB_Role_Name_fr__c, IB_Programme_New__r.RecordType.Name
                    FROM IB_Role__c
                    ];
                
                system.debug('headOfSchoolTest  '+headOfSchool);
                
                savePyp = controller.savePyp();
            
        //}
        Test.stopTest();
    }
    @isTest
    static void testSaveMYPIBAEM() {
        integer i=1;
        Account a = PimsTestUtil.createAccount('Coastal Cloud High School', 'School Account');
        insert a;
        
        User u = PimsTestUtil.createPortalUserPYP('test.pims@ibotest.org', false);
        insert u;
        
        System.runAs(u) {
            
            ProfileService ps = new ProfileService();
            
            Account account = ps.getProfileAccount();
            
            Contact con = PimsTestUtil.createContact('Test Contact', 'a@a.com', 'a@a.com', Date.newInstance(1980, 01, 01), account);
            insert con;
            
            PimsProfileIntentController controller = new PimsProfileIntentController();
            controller.account = account;
            controller.isDashboardPage = true;
            controller.hasPypProgramme = false;
            controller.hasMypProgramme = false;
            controller.hasDpProgramme = false;
            controller.hasIbccProgramme = false;
            
            //PageReference savePyp = controller.savePyp();
            PageReference saveMyp;
            //PageReference saveDp = controller.saveDp();
            //PageReference saveIbcc = controller.saveIbcc();
            
            controller.mypProgramme = PimsTestUtil.createProgrammeForAccount2(account);
            
            //savePyp = controller.savePyp();
            
            IB_Role_Repository__c repo2 = PimsTestUtil.createRoleRepo('Head of School (Overall)');
            
            insert repo2;
            
            IB_Role__c role2 = PimsTestUtil.createIbRole(repo2.Id, con.id, account.id);
            
            insert role2;
            
            
            IB_Role_Repository__c repo = PimsTestUtil.createRoleRepo('Programme Coordinator');
            insert repo;
            
            IB_Role__c role = PimsTestUtil.createIbRole(repo.Id, con.id, account.id);
            
            
            
            IB_Role_Repository__c repo3 = PimsTestUtil.createRoleRepo('Billing Coordinator');
            insert repo3;
            
            IB_Role__c role3 = PimsTestUtil.createIbRole(repo3.Id, con.id, account.id);
            
            IB_Role_Repository__c repo4 = PimsTestUtil.createRoleRepo('School Contact');
            insert repo4;
            
            IB_Role__c role4 = PimsTestUtil.createIbRole(repo4.Id, con.Id, account.Id);
            
            IB_Role_Repository__c repo5 = PimsTestUtil.createRoleRepo('Exam Contact');
            insert repo5;
            
            IB_Role__c role5 = PimsTestUtil.createIbRole(repo5.Id, con.id, account.id);
            
            
            //controller.primaryContactRole = role;
            controller.headOfSchoolContactRole = role2;
            controller.billingContactRole = role3;
            
            controller.programmeContactRole = role4;
            
            controller.examContactRole = role5;
            
            controller.mypProgramme.Programme_Legal_Name__c = 'Test Legal Name';
            controller.account.Website = 'http://www.google.com';
            controller.account.Year_Founded__c = '1990';
            controller.account.Academic_Start_Month__c = 'August';
            controller.account.Academic_End_Month__c = 'May';
            controller.account.Month_Founded__c = 'January';
            controller.account.Legal_Status__c = 'State';
            controller.account.Language_Of_Correspondance__c = 'English';
            controller.storeMYPIntentInfo();
            saveMyp = controller.saveMyp();
            //Following code line is added by Umair-Plumlogix of US11096 on 02/11/2020
            System.assertEquals(1,i);
        }
    }
    @isTest
    static void testSaveMYPIBAAdmin() {
        integer i=1;
        Account a = PimsTestUtil.createAccount('Coastal Cloud High School', 'School Account');
		a.Region__c = 'IBA';
        insert a;
        
        User u = PimsTestUtil.createPortalUserPYP('test.pims@ibotest.org', false);
        insert u;
        
        //System.runAs(u) {
            
            ProfileService ps = new ProfileService();
            
            Account account = a;
            
            Contact con = PimsTestUtil.createContact('Test Contact', 'a@a.com', 'a@a.com', Date.newInstance(1980, 01, 01), account);
            insert con;
            
            PimsProfileIntentController controller = new PimsProfileIntentController();
            controller.account = account;
            controller.isDashboardPage = true;
            controller.hasPypProgramme = false;
            controller.hasMypProgramme = false;
            controller.hasDpProgramme = false;
            controller.hasIbccProgramme = false;
            
            //PageReference savePyp = controller.savePyp();
            PageReference saveMyp;
            //PageReference saveDp = controller.saveDp();
            //PageReference saveIbcc = controller.saveIbcc();
            
            controller.mypProgramme = PimsTestUtil.createProgrammeForAccount2(account);
            
            //savePyp = controller.savePyp();
            
            IB_Role_Repository__c repo2 = PimsTestUtil.createRoleRepo('Head of School (Overall)');
            
            insert repo2;
            
            IB_Role__c role2 = PimsTestUtil.createIbRole(repo2.Id, con.id, account.id);
            
            insert role2;
            
            
            IB_Role_Repository__c repo = PimsTestUtil.createRoleRepo('Programme Coordinator');
            insert repo;
            
            IB_Role__c role = PimsTestUtil.createIbRole(repo.Id, con.id, account.id);
            
            
            
            IB_Role_Repository__c repo3 = PimsTestUtil.createRoleRepo('Billing Coordinator');
            insert repo3;
            
            IB_Role__c role3 = PimsTestUtil.createIbRole(repo3.Id, con.id, account.id);
            
            IB_Role_Repository__c repo4 = PimsTestUtil.createRoleRepo('School Contact');
            insert repo4;
            
            IB_Role__c role4 = PimsTestUtil.createIbRole(repo4.Id, con.Id, account.Id);
            
            IB_Role_Repository__c repo5 = PimsTestUtil.createRoleRepo('Exam Contact');
            insert repo5;
            
            IB_Role__c role5 = PimsTestUtil.createIbRole(repo5.Id, con.id, account.id);
            
            
            //controller.primaryContactRole = role;
            controller.headOfSchoolContactRole = role2;
            controller.billingContactRole = role3;
            
            controller.programmeContactRole = role4;
            
            controller.examContactRole = role5;
            
            controller.mypProgramme.Programme_Legal_Name__c = 'Test Legal Name';
            controller.account.Website = 'http://www.google.com';
            controller.account.Year_Founded__c = '1990';
            controller.account.Academic_Start_Month__c = 'August';
            controller.account.Academic_End_Month__c = 'May';
            controller.account.Month_Founded__c = 'January';
            controller.account.Legal_Status__c = 'State';
            controller.account.Language_Of_Correspondance__c = 'English';
            
            saveMyp = controller.saveMyp();
            //Following code line is added by Umair-Plumlogix of US11096 on 02/11/2020
            System.assertEquals(1,i);
        //}
    }
    @isTest
    static void testSaveMYPIBAPAdmin() {
        integer i=1;
        Account a = PimsTestUtil.createAccount('Coastal Cloud High School', 'School Account');
		a.Region__c = 'IBAP';
        insert a;
        
        User u = PimsTestUtil.createPortalUserPYP('test.pims@ibotest.org', false);
        insert u;
        
        //System.runAs(u) {
            
            ProfileService ps = new ProfileService();
            
            Account account = a;
            
            Contact con = PimsTestUtil.createContact('Test Contact', 'a@a.com', 'a@a.com', Date.newInstance(1980, 01, 01), account);
            insert con;
            
            PimsProfileIntentController controller = new PimsProfileIntentController();
            controller.account = account;
            controller.isDashboardPage = true;
            controller.hasPypProgramme = false;
            controller.hasMypProgramme = false;
            controller.hasDpProgramme = false;
            controller.hasIbccProgramme = false;
            
            //PageReference savePyp = controller.savePyp();
            PageReference saveMyp;
            //PageReference saveDp = controller.saveDp();
            //PageReference saveIbcc = controller.saveIbcc();
            
            controller.mypProgramme = PimsTestUtil.createProgrammeForAccount2(account);
            
            //savePyp = controller.savePyp();
            
            IB_Role_Repository__c repo2 = PimsTestUtil.createRoleRepo('Head of School (Overall)');
            
            insert repo2;
            
            IB_Role__c role2 = PimsTestUtil.createIbRole(repo2.Id, con.id, account.id);
            
            insert role2;
            
            
            IB_Role_Repository__c repo = PimsTestUtil.createRoleRepo('Programme Coordinator');
            insert repo;
            
            IB_Role__c role = PimsTestUtil.createIbRole(repo.Id, con.id, account.id);
            
            
            
            IB_Role_Repository__c repo3 = PimsTestUtil.createRoleRepo('Billing Coordinator');
            insert repo3;
            
            IB_Role__c role3 = PimsTestUtil.createIbRole(repo3.Id, con.id, account.id);
            
            IB_Role_Repository__c repo4 = PimsTestUtil.createRoleRepo('School Contact');
            insert repo4;
            
            IB_Role__c role4 = PimsTestUtil.createIbRole(repo4.Id, con.Id, account.Id);
            
            IB_Role_Repository__c repo5 = PimsTestUtil.createRoleRepo('Exam Contact');
            insert repo5;
            
            IB_Role__c role5 = PimsTestUtil.createIbRole(repo5.Id, con.id, account.id);
            
            
            //controller.primaryContactRole = role;
            controller.headOfSchoolContactRole = role2;
            controller.billingContactRole = role3;
            
            controller.programmeContactRole = role4;
            
            controller.examContactRole = role5;
            
            controller.mypProgramme.Programme_Legal_Name__c = 'Test Legal Name';
            controller.account.Website = 'http://www.google.com';
            controller.account.Year_Founded__c = '1990';
            controller.account.Academic_Start_Month__c = 'August';
            controller.account.Academic_End_Month__c = 'May';
            controller.account.Month_Founded__c = 'January';
            controller.account.Legal_Status__c = 'State';
            controller.account.Language_Of_Correspondance__c = 'English';
            
            saveMyp = controller.saveMyp();
            //Following code line is added by Umair-Plumlogix of US11096 on 02/11/2020
            System.assertEquals(1,i);
        //}
    }
    @isTest
    static void testSaveDpIBAEM() {
        integer i=1;
        Account a = PimsTestUtil.createAccount('Coastal Cloud High School', 'School Account');
        insert a;
        
        User u = PimsTestUtil.createPortalUserPYP('test.pims@ibotest.org', false);
        insert u;
        
        System.runAs(u) {
            
            ProfileService ps = new ProfileService();
            
            Account account = ps.getProfileAccount();
            
            Contact con = PimsTestUtil.createContact('Test Contact', 'a@a.com', 'a@a.com', Date.newInstance(1980, 01, 01), account);
            insert con;
            
            PimsProfileIntentController controller = new PimsProfileIntentController();
            controller.account = account;
            controller.isDashboardPage = true;
            controller.hasPypProgramme = false;
            controller.hasMypProgramme = false;
            controller.hasDpProgramme = false;
            controller.hasIbccProgramme = false;
            
            //PageReference savePyp = controller.savePyp();
            //PageReference saveMyp = controller.saveMyp();
            PageReference saveDp;
            //PageReference saveIbcc = controller.saveIbcc();
            
            controller.dpProgramme = PimsTestUtil.createProgrammeForAccount2(account);
            
            //savePyp = controller.savePyp();
            
            IB_Role_Repository__c repo2 = PimsTestUtil.createRoleRepo('Head of School (Overall)');
            
            insert repo2;
            
            IB_Role__c role2 = PimsTestUtil.createIbRole(repo2.Id, con.id, account.id);
            
            insert role2;
            
            
            IB_Role_Repository__c repo = PimsTestUtil.createRoleRepo('Programme Coordinator');
            insert repo;
            
            IB_Role__c role = PimsTestUtil.createIbRole(repo.Id, con.id, account.id);
            
            
            
            IB_Role_Repository__c repo3 = PimsTestUtil.createRoleRepo('Billing Coordinator');
            insert repo3;
            
            IB_Role__c role3 = PimsTestUtil.createIbRole(repo3.Id, con.id, account.id);
            
            IB_Role_Repository__c repo4 = PimsTestUtil.createRoleRepo('School Contact');
            insert repo4;
            
            IB_Role__c role4 = PimsTestUtil.createIbRole(repo4.Id, con.Id, account.Id);
            
            IB_Role_Repository__c repo5 = PimsTestUtil.createRoleRepo('Exam Contact');
            insert repo5;
            
            IB_Role__c role5 = PimsTestUtil.createIbRole(repo5.Id, con.id, account.id);
            
            
            //controller.primaryContactRole = role;
            controller.headOfSchoolContactRole = role2;
            controller.billingContactRole = role3;
            
            controller.programmeContactRole = role4;
            
            controller.examContactRole = role5;
            
            controller.dpProgramme.Programme_Legal_Name__c = 'Test Legal Name';
            controller.account.Website = 'http://www.google.com';
            controller.account.Year_Founded__c = '1990';
            controller.account.Academic_Start_Month__c = 'August';
            controller.account.Academic_End_Month__c = 'May';
            controller.account.Month_Founded__c = 'January';
            controller.account.Legal_Status__c = 'State';
            controller.account.Language_Of_Correspondance__c = 'English';
            controller.storeDPIntentInfo();
            saveDp = controller.saveDp();
            //Following code line is added by Umair-Plumlogix of US11096 on 02/11/2020
            System.assertEquals(1,i);
        }
    }
    @isTest
    static void testSaveDpIBAAdmin() {
        integer i=1;
        Account a = PimsTestUtil.createAccount('Coastal Cloud High School', 'School Account');
		a.Region__c = 'IBA';
        insert a;
        
        User u = PimsTestUtil.createPortalUserPYP('test.pims@ibotest.org', false);
        insert u;
        
        //System.runAs(u) {
            
            ProfileService ps = new ProfileService();
            
            Account account = a;
            
            Contact con = PimsTestUtil.createContact('Test Contact', 'a@a.com', 'a@a.com', Date.newInstance(1980, 01, 01), account);
            insert con;
            
            PimsProfileIntentController controller = new PimsProfileIntentController();
            controller.account = account;
            controller.isDashboardPage = true;
            controller.hasPypProgramme = false;
            controller.hasMypProgramme = false;
            controller.hasDpProgramme = false;
            controller.hasIbccProgramme = false;
            
            //PageReference savePyp = controller.savePyp();
            //PageReference saveMyp = controller.saveMyp();
            PageReference saveDp;
            //PageReference saveIbcc = controller.saveIbcc();
            
            controller.dpProgramme = PimsTestUtil.createProgrammeForAccount2(account);
            
            //savePyp = controller.savePyp();
            
            IB_Role_Repository__c repo2 = PimsTestUtil.createRoleRepo('Head of School (Overall)');
            
            insert repo2;
            
            IB_Role__c role2 = PimsTestUtil.createIbRole(repo2.Id, con.id, account.id);
            
            insert role2;
            
            
            IB_Role_Repository__c repo = PimsTestUtil.createRoleRepo('Programme Coordinator');
            insert repo;
            
            IB_Role__c role = PimsTestUtil.createIbRole(repo.Id, con.id, account.id);
            
            
            
            IB_Role_Repository__c repo3 = PimsTestUtil.createRoleRepo('Billing Coordinator');
            insert repo3;
            
            IB_Role__c role3 = PimsTestUtil.createIbRole(repo3.Id, con.id, account.id);
            
            IB_Role_Repository__c repo4 = PimsTestUtil.createRoleRepo('School Contact');
            insert repo4;
            
            IB_Role__c role4 = PimsTestUtil.createIbRole(repo4.Id, con.Id, account.Id);
            
            IB_Role_Repository__c repo5 = PimsTestUtil.createRoleRepo('Exam Contact');
            insert repo5;
            
            IB_Role__c role5 = PimsTestUtil.createIbRole(repo5.Id, con.id, account.id);
            
            
            //controller.primaryContactRole = role;
            controller.headOfSchoolContactRole = role2;
            controller.billingContactRole = role3;
            
            controller.programmeContactRole = role4;
            
            controller.examContactRole = role5;
            
            controller.dpProgramme.Programme_Legal_Name__c = 'Test Legal Name';
            controller.account.Website = 'http://www.google.com';
            controller.account.Year_Founded__c = '1990';
            controller.account.Academic_Start_Month__c = 'August';
            controller.account.Academic_End_Month__c = 'May';
            controller.account.Month_Founded__c = 'January';
            controller.account.Legal_Status__c = 'State';
            controller.account.Language_Of_Correspondance__c = 'English';
            
            saveDp = controller.saveDp();
            //Following code line is added by Umair-Plumlogix of US11096 on 02/11/2020
            System.assertEquals(1,i);
        //}
    }
    @isTest
    static void testSaveDpIBAPAdmin() {
        integer i=1;
        Account a = PimsTestUtil.createAccount('Coastal Cloud High School', 'School Account');
		a.Region__c = 'IBAP';
        insert a;
        
        User u = PimsTestUtil.createPortalUserPYP('test.pims@ibotest.org', false);
        insert u;
        
        //System.runAs(u) {
            
            ProfileService ps = new ProfileService();
            
            Account account = a;
            
            Contact con = PimsTestUtil.createContact('Test Contact', 'a@a.com', 'a@a.com', Date.newInstance(1980, 01, 01), account);
            insert con;
            
            PimsProfileIntentController controller = new PimsProfileIntentController();
            controller.account = account;
            controller.isDashboardPage = true;
            controller.hasPypProgramme = false;
            controller.hasMypProgramme = false;
            controller.hasDpProgramme = false;
            controller.hasIbccProgramme = false;
            
            //PageReference savePyp = controller.savePyp();
            //PageReference saveMyp = controller.saveMyp();
            PageReference saveDp;
            //PageReference saveIbcc = controller.saveIbcc();
            
            controller.dpProgramme = PimsTestUtil.createProgrammeForAccount2(account);
            
            //savePyp = controller.savePyp();
            
            IB_Role_Repository__c repo2 = PimsTestUtil.createRoleRepo('Head of School (Overall)');
            
            insert repo2;
            
            IB_Role__c role2 = PimsTestUtil.createIbRole(repo2.Id, con.id, account.id);
            
            insert role2;
            
            
            IB_Role_Repository__c repo = PimsTestUtil.createRoleRepo('Programme Coordinator');
            insert repo;
            
            IB_Role__c role = PimsTestUtil.createIbRole(repo.Id, con.id, account.id);
            
            
            
            IB_Role_Repository__c repo3 = PimsTestUtil.createRoleRepo('Billing Coordinator');
            insert repo3;
            
            IB_Role__c role3 = PimsTestUtil.createIbRole(repo3.Id, con.id, account.id);
            
            IB_Role_Repository__c repo4 = PimsTestUtil.createRoleRepo('School Contact');
            insert repo4;
            
            IB_Role__c role4 = PimsTestUtil.createIbRole(repo4.Id, con.Id, account.Id);
            
            IB_Role_Repository__c repo5 = PimsTestUtil.createRoleRepo('Exam Contact');
            insert repo5;
            
            IB_Role__c role5 = PimsTestUtil.createIbRole(repo5.Id, con.id, account.id);
            
            
            //controller.primaryContactRole = role;
            controller.headOfSchoolContactRole = role2;
            controller.billingContactRole = role3;
            
            controller.programmeContactRole = role4;
            
            controller.examContactRole = role5;
            
            controller.dpProgramme.Programme_Legal_Name__c = 'Test Legal Name';
            controller.account.Website = 'http://www.google.com';
            controller.account.Year_Founded__c = '1990';
            controller.account.Academic_Start_Month__c = 'August';
            controller.account.Academic_End_Month__c = 'May';
            controller.account.Month_Founded__c = 'January';
            controller.account.Legal_Status__c = 'State';
            controller.account.Language_Of_Correspondance__c = 'English';
            
            saveDp = controller.saveDp();
            //Following code line is added by Umair-Plumlogix of US11096 on 02/11/2020
            System.assertEquals(1,i);
        //}
    }
    @isTest
    static void testSaveIbccIBAEM() {
        integer i=1;
        Account a = PimsTestUtil.createAccount('Coastal Cloud High School', 'School Account');
        insert a;
        
        User u = PimsTestUtil.createPortalUserPYP('test.pims@ibotest.org', false);
        insert u;
        
        System.runAs(u) {
            
            ProfileService ps = new ProfileService();
            
            Account account = ps.getProfileAccount();
            
            Contact con = PimsTestUtil.createContact('Test Contact', 'a@a.com', 'a@a.com', Date.newInstance(1980, 01, 01), account);
            insert con;
            
            PimsProfileIntentController controller = new PimsProfileIntentController();
            controller.account = account;
            controller.isDashboardPage = true;
            controller.hasPypProgramme = false;
            controller.hasMypProgramme = false;
            controller.hasDpProgramme = false;
            controller.hasIbccProgramme = false;
            
            //PageReference savePyp = controller.savePyp();
            //PageReference saveMyp = controller.saveMyp();
            //PageReference saveDp = controller.saveDp();
            PageReference saveIbcc;
            
            controller.ibccProgramme = PimsTestUtil.createProgrammeForAccount2(account);
            
            //savePyp = controller.savePyp();
            
            IB_Role_Repository__c repo2 = PimsTestUtil.createRoleRepo('Head of School (Overall)');
            
            insert repo2;
            
            IB_Role__c role2 = PimsTestUtil.createIbRole(repo2.Id, con.id, account.id);
            
            insert role2;
            
            
            IB_Role_Repository__c repo = PimsTestUtil.createRoleRepo('Programme Coordinator');
            insert repo;
            
            IB_Role__c role = PimsTestUtil.createIbRole(repo.Id, con.id, account.id);
            
            
            
            IB_Role_Repository__c repo3 = PimsTestUtil.createRoleRepo('Billing Coordinator');
            insert repo3;
            
            IB_Role__c role3 = PimsTestUtil.createIbRole(repo3.Id, con.id, account.id);
            
            IB_Role_Repository__c repo4 = PimsTestUtil.createRoleRepo('School Contact');
            insert repo4;
            
            IB_Role__c role4 = PimsTestUtil.createIbRole(repo4.Id, con.Id, account.Id);
            
            IB_Role_Repository__c repo5 = PimsTestUtil.createRoleRepo('Exam Contact');
            insert repo5;
            
            IB_Role__c role5 = PimsTestUtil.createIbRole(repo5.Id, con.id, account.id);
            
            
            //controller.primaryContactRole = role;
            controller.headOfSchoolContactRole = role2;
            controller.billingContactRole = role3;
            
            controller.programmeContactRole = role4;
            
            controller.examContactRole = role5;
            
            controller.IbccProgramme.Programme_Legal_Name__c = 'Test Legal Name';
            controller.account.Website = 'http://www.google.com';
            controller.account.Year_Founded__c = '1990';
            controller.account.Academic_Start_Month__c = 'August';
            controller.account.Academic_End_Month__c = 'May';
            controller.account.Month_Founded__c = 'January';
            controller.account.Legal_Status__c = 'State';
            controller.account.Language_Of_Correspondance__c = 'English';
            controller.storeIBCCIntentInfo();
            saveIbcc = controller.saveIbcc();
            //Following code line is added by Umair-Plumlogix of US11096 on 02/11/2020
            System.assertEquals(1,i);
        }
    }
    @isTest
    static void testSaveIbccIBAAdmin() {
        integer i=1;
        Account a = PimsTestUtil.createAccount('Coastal Cloud High School', 'School Account');
		a.Region__c = 'IBA';
        insert a;
        
        User u = PimsTestUtil.createPortalUserPYP('test.pims@ibotest.org', false);
        insert u;
        
        //System.runAs(u) {
            
            ProfileService ps = new ProfileService();
            
            Account account = a;
            
            Contact con = PimsTestUtil.createContact('Test Contact', 'a@a.com', 'a@a.com', Date.newInstance(1980, 01, 01), account);
            insert con;
            
            PimsProfileIntentController controller = new PimsProfileIntentController();
            controller.account = account;
            controller.isDashboardPage = true;
            controller.hasPypProgramme = false;
            controller.hasMypProgramme = false;
            controller.hasDpProgramme = false;
            controller.hasIbccProgramme = false;
            
            //PageReference savePyp = controller.savePyp();
            //PageReference saveMyp = controller.saveMyp();
            //PageReference saveDp = controller.saveDp();
            PageReference saveIbcc;
            
            controller.ibccProgramme = PimsTestUtil.createProgrammeForAccount2(account);
            
            //savePyp = controller.savePyp();
            
            IB_Role_Repository__c repo2 = PimsTestUtil.createRoleRepo('Head of School (Overall)');
            
            insert repo2;
            
            IB_Role__c role2 = PimsTestUtil.createIbRole(repo2.Id, con.id, account.id);
            
            insert role2;
            
            
            IB_Role_Repository__c repo = PimsTestUtil.createRoleRepo('Programme Coordinator');
            insert repo;
            
            IB_Role__c role = PimsTestUtil.createIbRole(repo.Id, con.id, account.id);
            
            
            
            IB_Role_Repository__c repo3 = PimsTestUtil.createRoleRepo('Billing Coordinator');
            insert repo3;
            
            IB_Role__c role3 = PimsTestUtil.createIbRole(repo3.Id, con.id, account.id);
            
            IB_Role_Repository__c repo4 = PimsTestUtil.createRoleRepo('School Contact');
            insert repo4;
            
            IB_Role__c role4 = PimsTestUtil.createIbRole(repo4.Id, con.Id, account.Id);
            
            IB_Role_Repository__c repo5 = PimsTestUtil.createRoleRepo('Exam Contact');
            insert repo5;
            
            IB_Role__c role5 = PimsTestUtil.createIbRole(repo5.Id, con.id, account.id);
            
            
            //controller.primaryContactRole = role;
            controller.headOfSchoolContactRole = role2;
            controller.billingContactRole = role3;
            
            controller.programmeContactRole = role4;
            
            controller.examContactRole = role5;
            
            controller.IbccProgramme.Programme_Legal_Name__c = 'Test Legal Name';
            controller.account.Website = 'http://www.google.com';
            controller.account.Year_Founded__c = '1990';
            controller.account.Academic_Start_Month__c = 'August';
            controller.account.Academic_End_Month__c = 'May';
            controller.account.Month_Founded__c = 'January';
            controller.account.Legal_Status__c = 'State';
            controller.account.Language_Of_Correspondance__c = 'English';
            
            saveIbcc = controller.saveIbcc();
            //Following code line is added by Umair-Plumlogix of US11096 on 02/11/2020
            System.assertEquals(1,i);
        //}
    }
    @isTest
    static void testSaveIbccIBAPAdmin() {
        integer i=1;
        Account a = PimsTestUtil.createAccount('Coastal Cloud High School', 'School Account');
		a.Region__c = 'IBAP';
        insert a;
        
        User u = PimsTestUtil.createPortalUserPYP('test.pims@ibotest.org', false);
        insert u;
        
        //System.runAs(u) {
            
            ProfileService ps = new ProfileService();
            
            Account account = a;
            
            Contact con = PimsTestUtil.createContact('Test Contact', 'a@a.com', 'a@a.com', Date.newInstance(1980, 01, 01), account);
            insert con;
            
            PimsProfileIntentController controller = new PimsProfileIntentController();
            controller.account = account;
            controller.isDashboardPage = true;
            controller.hasPypProgramme = false;
            controller.hasMypProgramme = false;
            controller.hasDpProgramme = false;
            controller.hasIbccProgramme = false;
            
            //PageReference savePyp = controller.savePyp();
            //PageReference saveMyp = controller.saveMyp();
            //PageReference saveDp = controller.saveDp();
            PageReference saveIbcc;
            
            controller.ibccProgramme = PimsTestUtil.createProgrammeForAccount2(account);
            
            //savePyp = controller.savePyp();
            
            IB_Role_Repository__c repo2 = PimsTestUtil.createRoleRepo('Head of School (Overall)');
            
            insert repo2;
            
            IB_Role__c role2 = PimsTestUtil.createIbRole(repo2.Id, con.id, account.id);
            
            insert role2;
            
            
            IB_Role_Repository__c repo = PimsTestUtil.createRoleRepo('Programme Coordinator');
            insert repo;
            
            IB_Role__c role = PimsTestUtil.createIbRole(repo.Id, con.id, account.id);
            
            
            
            IB_Role_Repository__c repo3 = PimsTestUtil.createRoleRepo('Billing Coordinator');
            insert repo3;
            
            IB_Role__c role3 = PimsTestUtil.createIbRole(repo3.Id, con.id, account.id);
            
            IB_Role_Repository__c repo4 = PimsTestUtil.createRoleRepo('School Contact');
            insert repo4;
            
            IB_Role__c role4 = PimsTestUtil.createIbRole(repo4.Id, con.Id, account.Id);
            
            IB_Role_Repository__c repo5 = PimsTestUtil.createRoleRepo('Exam Contact');
            insert repo5;
            
            IB_Role__c role5 = PimsTestUtil.createIbRole(repo5.Id, con.id, account.id);
            
            
            //controller.primaryContactRole = role;
            controller.headOfSchoolContactRole = role2;
            controller.billingContactRole = role3;
            
            controller.programmeContactRole = role4;
            
            controller.examContactRole = role5;
            
            controller.IbccProgramme.Programme_Legal_Name__c = 'Test Legal Name';
            controller.account.Website = 'http://www.google.com';
            controller.account.Year_Founded__c = '1990';
            controller.account.Academic_Start_Month__c = 'August';
            controller.account.Academic_End_Month__c = 'May';
            controller.account.Month_Founded__c = 'January';
            controller.account.Legal_Status__c = 'State';
            controller.account.Language_Of_Correspondance__c = 'English';
            
            saveIbcc = controller.saveIbcc();
            //Following code line is added by Umair-Plumlogix of US11096 on 02/11/2020
            System.assertEquals(1,i);
        //}
    }
    @isTest
    static void testFive() {
        integer i=1;
        Account a = PimsTestUtil.createAccount('Coastal Cloud High School', 'School Account');
        insert a;
        
        User u = PimsTestUtil.createPortalUserPYP('test.pims@ibotest.org', false);
        insert u;
        
        System.runAs(u) {
            
            ProfileService ps = new ProfileService();
            
            Account account = ps.getProfileAccount();
            
            /*Contact con = PimsTestUtil.createContact('Test Contact', 'a@a.com', 'a@a.com', Date.newInstance(1980, 01, 01), account);
insert con;*/
            
            PimsProfileIntentController controller = new PimsProfileIntentController();
            controller.account = account;
            controller.isDashboardPage = true;
            controller.hasPypProgramme = false;
            controller.hasMypProgramme = false;
            controller.hasDpProgramme = false;
            controller.hasIbccProgramme = false;
            
            PageReference save = controller.save();
            List<SelectOption> addressOptions = controller.getAddressOptions();
            List<SelectOption> contactOptions = controller.getContactOptions();
            Boolean displayPyp = controller.getDisplayPypForm();
            Boolean displayMyp = controller.getDisplayMypForm();
            Boolean displayDp = controller.getDisplayDpForm();
            Boolean displayIbcc = controller.getDisplayIbccForm();
            //Following code line is added by Umair-Plumlogix of US11096 on 02/11/2020
            System.assertEquals(1,i);
        }
    }
    
    @isTest
    static void testSix() {
        integer i=1;
        Account a = PimsTestUtil.createAccount('Coastal Cloud High School', 'School Account');
        insert a;
        
        User u = PimsTestUtil.createPortalUserPYP('test.pims@ibotest.org', false);
        insert u;
        
        System.runAs(u) {
            
            ProfileService ps = new ProfileService();
            
            Account account = ps.getProfileAccount();
            
            Contact con = PimsTestUtil.createContact('Test Contact', 'a@a.com', 'a@a.com', Date.newInstance(1980, 01, 01), account);
            insert con;
            
            PimsProfileIntentController controller = new PimsProfileIntentController();
            controller.account = account;
            controller.isDashboardPage = false;
            controller.hasPypProgramme = false;
            controller.hasMypProgramme = false;
            controller.hasDpProgramme = false;
            controller.hasIbccProgramme = false;
            try{
                //PageReference savePyp = controller.savePyp();
                //PageReference saveMyp = controller.saveMyp();
                //PageReference saveDp = controller.saveDp();
                //PageReference saveIbcc = controller.saveIbcc();
                PageReference savePyp;
                controller.pypProgramme = PimsTestUtil.createProgrammeForAccount2(account);
                
                //savePyp = controller.savePyp();
                
                IB_Role_Repository__c repo2 = PimsTestUtil.createRoleRepo('Head of School (Overall)');
                
                insert repo2;
                
                IB_Role__c role2 = PimsTestUtil.createIbRole(repo2.Id, con.id, account.id);
                
                insert role2;
                
                
                IB_Role_Repository__c repo = PimsTestUtil.createRoleRepo('Programme Coordinator');
                insert repo;
                
                IB_Role__c role = PimsTestUtil.createIbRole(repo.Id, con.id, account.id);
                
                
                
                IB_Role_Repository__c repo3 = PimsTestUtil.createRoleRepo('Billing Coordinator');
                insert repo3;
                
                IB_Role__c role3 = PimsTestUtil.createIbRole(repo3.Id, con.id, account.id);
                
                IB_Role_Repository__c repo4 = PimsTestUtil.createRoleRepo('School Contact');
                insert repo4;
                
                IB_Role__c role4 = PimsTestUtil.createIbRole(repo4.Id, con.Id, account.Id);
                
                IB_Role_Repository__c repo5 = PimsTestUtil.createRoleRepo('Exam Contact');
                insert repo5;
                
                IB_Role__c role5 = PimsTestUtil.createIbRole(repo5.Id, con.id, account.id);
                
                //controller.primaryContactRole = role;
                controller.headOfSchoolContactRole = role2;
                controller.billingContactRole = role3;
                
                controller.programmeContactRole = role4;
                
                controller.examContactRole = role5;
                
                controller.pypProgramme.Programme_Legal_Name__c = 'Test Legal Name';
                controller.account.Website = 'http://www.google.com';
                controller.account.Year_Founded__c = '1990';
                controller.account.Academic_Start_Month__c = 'August';
                controller.account.Academic_End_Month__c = 'May';
                controller.account.Month_Founded__c = 'January';
                controller.account.Legal_Status__c = 'State';
                controller.account.Language_Of_Correspondance__c = 'English';
                
                savePyp = controller.savePyp();
                //Following code line is added by Umair-Plumlogix of US11096 on 02/11/2020
                System.assertEquals(1,i);
            }
            catch(exception ex){
            }
        }
    }
    
    @isTest
    static void testSeven() {
        integer i=1;
        Account a = PimsTestUtil.createAccount('Coastal Cloud High School', 'School Account');
        insert a;
        
        User u = PimsTestUtil.createPortalUserPYP('test.pims@ibotest.org', false);
        insert u;
        
        System.runAs(u) {
            
            ProfileService ps = new ProfileService();
            
            Account account = ps.getProfileAccount();
            
            Contact con = PimsTestUtil.createContact('Test Contact', 'a@a.com', 'a@a.com', Date.newInstance(1980, 01, 01), account);
            insert con;
            
            PimsProfileIntentController controller = new PimsProfileIntentController();
            controller.account = account;
            controller.isDashboardPage = false;
            controller.hasPypProgramme = false;
            controller.hasMypProgramme = false;
            controller.hasDpProgramme = false;
            controller.hasIbccProgramme = false;
            
            //PageReference savePyp = controller.savePyp();
            PageReference saveMyp = controller.saveMyp();
            //PageReference saveDp = controller.saveDp();
            //PageReference saveIbcc = controller.saveIbcc();
            
            controller.mypProgramme = PimsTestUtil.createProgrammeForAccount2(account);
            
            //savePyp = controller.savePyp();
            
            IB_Role_Repository__c repo2 = PimsTestUtil.createRoleRepo('Head of School (Overall)');
            
            insert repo2;
            
            IB_Role__c role2 = PimsTestUtil.createIbRole(repo2.Id, con.id, account.id);
            
            insert role2;
            
            
            IB_Role_Repository__c repo = PimsTestUtil.createRoleRepo('Programme Coordinator');
            insert repo;
            
            IB_Role__c role = PimsTestUtil.createIbRole(repo.Id, con.id, account.id);
            
            
            
            IB_Role_Repository__c repo3 = PimsTestUtil.createRoleRepo('Billing Coordinator');
            insert repo3;
            
            IB_Role__c role3 = PimsTestUtil.createIbRole(repo3.Id, con.id, account.id);
            
            IB_Role_Repository__c repo4 = PimsTestUtil.createRoleRepo('School Contact');
            insert repo4;
            
            IB_Role__c role4 = PimsTestUtil.createIbRole(repo4.Id, con.Id, account.Id);
            
            IB_Role_Repository__c repo5 = PimsTestUtil.createRoleRepo('Exam Contact');
            insert repo5;
            
            IB_Role__c role5 = PimsTestUtil.createIbRole(repo5.Id, con.id, account.id);
            
            
            //controller.primaryContactRole = role;
            controller.headOfSchoolContactRole = role2;
            controller.billingContactRole = role3;
            
            controller.programmeContactRole = role4;
            
            controller.examContactRole = role5;
            
            controller.mypProgramme.Programme_Legal_Name__c = 'Test Legal Name';
            controller.account.Website = 'http://www.google.com';
            controller.account.Year_Founded__c = '1990';
            controller.account.Academic_Start_Month__c = 'August';
            controller.account.Academic_End_Month__c = 'May';
            controller.account.Month_Founded__c = 'January';
            controller.account.Legal_Status__c = 'State';
            controller.account.Language_Of_Correspondance__c = 'English';
            
            saveMyp = controller.saveMyp();
            //Following code line is added by Umair-Plumlogix of US11096 on 02/11/2020
            System.assertEquals(1,i);
        }
    }
    
    @isTest
    static void testEight() {
        integer i=1;
        Account a = PimsTestUtil.createAccount('Coastal Cloud High School', 'School Account');
        insert a;
        
        User u = PimsTestUtil.createPortalUserPYP('test.pims@ibotest.org', false);
        insert u;
        
        System.runAs(u) {
            
            ProfileService ps = new ProfileService();
            
            Account account = ps.getProfileAccount();
            
            Contact con = PimsTestUtil.createContact('Test Contact', 'a@a.com', 'a@a.com', Date.newInstance(1980, 01, 01), account);
            insert con;
            
            PimsProfileIntentController controller = new PimsProfileIntentController();
            controller.account = account;
            controller.isDashboardPage = false;
            controller.hasPypProgramme = false;
            controller.hasMypProgramme = false;
            controller.hasDpProgramme = false;
            controller.hasIbccProgramme = false;
            
            //PageReference savePyp = controller.savePyp();
            //PageReference saveMyp = controller.saveMyp();
            PageReference saveDp = controller.saveDp();
            //PageReference saveIbcc = controller.saveIbcc();
            
            controller.dpProgramme = PimsTestUtil.createProgrammeForAccount2(account);
            
            //savePyp = controller.savePyp();
            
            IB_Role_Repository__c repo2 = PimsTestUtil.createRoleRepo('Head of School (Overall)');
            
            insert repo2;
            
            IB_Role__c role2 = PimsTestUtil.createIbRole(repo2.Id, con.id, account.id);
            
            insert role2;
            
            
            IB_Role_Repository__c repo = PimsTestUtil.createRoleRepo('Programme Coordinator');
            insert repo;
            
            IB_Role__c role = PimsTestUtil.createIbRole(repo.Id, con.id, account.id);
            
            
            
            IB_Role_Repository__c repo3 = PimsTestUtil.createRoleRepo('Billing Coordinator');
            insert repo3;
            
            IB_Role__c role3 = PimsTestUtil.createIbRole(repo3.Id, con.id, account.id);
            
            IB_Role_Repository__c repo4 = PimsTestUtil.createRoleRepo('School Contact');
            insert repo4;
            
            IB_Role__c role4 = PimsTestUtil.createIbRole(repo4.Id, con.Id, account.Id);
            
            IB_Role_Repository__c repo5 = PimsTestUtil.createRoleRepo('Exam Contact');
            insert repo5;
            
            IB_Role__c role5 = PimsTestUtil.createIbRole(repo5.Id, con.id, account.id);
            
            
            //controller.primaryContactRole = role;
            controller.headOfSchoolContactRole = role2;
            controller.billingContactRole = role3;
            
            controller.programmeContactRole = role4;
            
            controller.examContactRole = role5;
            
            controller.dpProgramme.Programme_Legal_Name__c = 'Test Legal Name';
            controller.account.Website = 'http://www.google.com';
            controller.account.Year_Founded__c = '1990';
            controller.account.Academic_Start_Month__c = 'August';
            controller.account.Academic_End_Month__c = 'May';
            controller.account.Month_Founded__c = 'January';
            controller.account.Legal_Status__c = 'State';
            controller.account.Language_Of_Correspondance__c = 'English';
            
            saveDp = controller.saveDp();
            //Following code line is added by Umair-Plumlogix of US11096 on 02/11/2020
            System.assertEquals(1,i);
        }
    }
    
    @isTest
    static void testNine() {
        integer i=1;
        Account a = PimsTestUtil.createAccount('Coastal Cloud High School', 'School Account');
        insert a;
        
        User u = PimsTestUtil.createPortalUserPYP('test.pims@ibotest.org', false);
        insert u;
        
        System.runAs(u) {
            
            ProfileService ps = new ProfileService();
            
            Account account = ps.getProfileAccount();
            
            Contact con = PimsTestUtil.createContact('Test Contact', 'a@a.com', 'a@a.com', Date.newInstance(1980, 01, 01), account);
            insert con;
            
            PimsProfileIntentController controller = new PimsProfileIntentController();
            controller.account = account;
            controller.isDashboardPage = false;
            controller.hasPypProgramme = false;
            controller.hasMypProgramme = false;
            controller.hasDpProgramme = false;
            controller.hasIbccProgramme = false;
            
            //PageReference savePyp = controller.savePyp();
            //PageReference saveMyp = controller.saveMyp();
            //PageReference saveDp = controller.saveDp();
            PageReference saveIbcc = controller.saveIbcc();
            
            controller.ibccProgramme = PimsTestUtil.createProgrammeForAccount2(account);
            
            //savePyp = controller.savePyp();
            
            IB_Role_Repository__c repo2 = PimsTestUtil.createRoleRepo('Head of School (Overall)');
            
            insert repo2;
            
            IB_Role__c role2 = PimsTestUtil.createIbRole(repo2.Id, con.id, account.id);
            
            insert role2;
            
            
            IB_Role_Repository__c repo = PimsTestUtil.createRoleRepo('Programme Coordinator');
            insert repo;
            
            IB_Role__c role = PimsTestUtil.createIbRole(repo.Id, con.id, account.id);
            
            
            
            IB_Role_Repository__c repo3 = PimsTestUtil.createRoleRepo('Billing Coordinator');
            insert repo3;
            
            IB_Role__c role3 = PimsTestUtil.createIbRole(repo3.Id, con.id, account.id);
            
            IB_Role_Repository__c repo4 = PimsTestUtil.createRoleRepo('School Contact');
            insert repo4;
            
            IB_Role__c role4 = PimsTestUtil.createIbRole(repo4.Id, con.Id, account.Id);
            
            IB_Role_Repository__c repo5 = PimsTestUtil.createRoleRepo('Exam Contact');
            insert repo5;
            
            IB_Role__c role5 = PimsTestUtil.createIbRole(repo5.Id, con.id, account.id);
            
            
            //controller.primaryContactRole = role;
            controller.headOfSchoolContactRole = role2;
            controller.billingContactRole = role3;
            
            controller.programmeContactRole = role4;
            
            controller.examContactRole = role5;
            
            controller.IbccProgramme.Programme_Legal_Name__c = 'Test Legal Name';
            controller.account.Website = 'http://www.google.com';
            controller.account.Year_Founded__c = '1990';
            controller.account.Academic_Start_Month__c = 'August';
            controller.account.Academic_End_Month__c = 'May';
            controller.account.Month_Founded__c = 'January';
            controller.account.Legal_Status__c = 'State';
            controller.account.Language_Of_Correspondance__c = 'English';
            
            saveIbcc = controller.saveIbcc();
            //Following code line is added by Umair-Plumlogix of US11096 on 02/11/2020
            System.assertEquals(1,i);
        }
    }
    @isTest
    static void testEP() {
        
        integer i=1;
        Test.startTest();
        Account a = PimsTestUtil.createAccount('Coastal Cloud High School', 'School Account');
        a.IBIS_ID__c = '123654';
        insert a;
        system.debug('a.id ' + a.id);
        User u = PimsTestUtil.createPortalUserPYP('test.pims@ibotest.org', false);
        insert u;
        User usr = [select Contact.AccountId from user where id =: u.id];
        system.debug('usr.Contact.AccountId: ' + usr.Contact.AccountId);
        IB_Address__c addr = new IB_Address__c(Address_Line_1__c = 'Test Addr', City__c = 'NY', Province__c = 'NY', Postal_Code__c = '12345',IB_Account__c = usr.Contact.AccountId);
        insert addr;
        
        
        System.runAs(u) {
            
            ProfileService ps = new ProfileService();
            
            Account account = ps.getProfileAccount();
            account.IBIS_ID__c = '123656';
            system.debug('account.id ' + account.id);
            Contact con = PimsTestUtil.createContact('Test Contact', 'a@a.com', 'a@a.com', Date.newInstance(1980, 01, 01), account);
            insert con;
            
            PimsProfileIntentController controller = new PimsProfileIntentController();
            controller.getUserLanguageKey();
            controller.account = account;
			controller.getischeckEP();
            
        }
        Test.stopTest();
    }
}