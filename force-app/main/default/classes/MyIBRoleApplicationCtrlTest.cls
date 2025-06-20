@isTest
private class MyIBRoleApplicationCtrlTest {
    
    
    @isTest static void test_method_one() {
        
        TestsUtil.initCampaigns();
        List<Account> accs = TestsUtil.getAccounts();
        List<Campaign> camps = TestsUtil.getCampaigns();
        
        
        IB_Country_Segmentation__c country = TestsUtil.createCountry('test_country_name', 'EUROPE', accs.get(0));
        insert country;
        
        Account acc = PimsTestUtil.createAccount('Test Class Account', '');
        acc.IBIS_ID__c = '000001';
        insert acc;
        
        Contact con3 = PimsTestUtil.createContact('Test Contact', 'a@a.com', 'a@a.com', Date.newInstance(1980, 1, 1), acc);
        con3.AccountId=acc.id;
        insert con3;
        User u = TestsUtil.createPortalUser('TestingPortal');
        u.FirstName = 'test1';
        u.LanguageLocaleKey = 'en_US';
        u.ContactId=con3.Id;
        insert u;
        Contact con = [Select id,Phone_Number__c,Country_Code__c from contact where id = :u.ContactId];
        con.Country_Code__c = 'Åland Islands (+3581)';
        con.Phone_Number__c = '123456';
        update con;
        Contact_information__c contact = new Contact_information__c();
        contact.Email__c = 'Test@gmail.com';
        contact.IB_Contact__c = con3.ID;
        // contact.IB_Contact__r.Country_Code__c='Afghanistan (+93)';
        // contact.IB_Contact__r.Phone_Number__c='123456789012';
        insert contact;
        IB_Role_Repository__c repo = TestsUtil.createRoleRepo();
        repo.Role_Level__c = 'Fully Qualified';
        repo.Require_Educational_Degree__c = true;
        repo.Require_Language_Experience__c = true;
        repo.MyIB_Has_Subjects__c = true;
        repo.MyIB_Has_Workshop_Titles__c = true;
        repo.Display_in_MyIB__c = true;
        
        
        IB_Role_Repository__c repo2 = TestsUtil.createRoleRepo();
        repo2.Role_Level__c = 'Fully Qualified';
        repo2.Require_Educational_Degree__c = true;
        repo2.Require_Language_Experience__c = true;
        repo2.MyIB_Has_Subjects__c = true;
        
        repo2.MyIB_Has_Workshop_Titles__c = true;
        repo2.Custom_Application__c = 'TeacherApp';
        repo2.MyIB_Use_My_School_Subjects__c = true;
        repo2.Role_Name__c = 'Teacher';
        repo2.Display_in_MyIB__c = true;
        repo2.Application_Available_in_MyIB__c = true;
        insert new List<IB_Role_Repository__c> {repo,repo2};
            
            IB_Event_Role__c eventRole = new IB_Event_Role__c(
                IB_Event__c = camps.get(0).Id,
                Number_of_Required_Educators__c = 1,
                IB_Role__c = repo.Id
            );
        insert eventRole;
        
        IB_Subject__c subject = new IB_Subject__c();
        subject.IB_Programme__c = 'PYP';
        subject.IB_Programme_Long__c = 'PYP';
        subject.Subject_Code__c = 'pyp';
        subject.Subject_Group__c = 'Arts (PYP)';
        subject.Subject_Group_Identifier__c = 'artsm';
        subject.Subject_Name__c = 'Dance';
        subject.Subject_Name_FR__c = 'Dance';
        subject.Subject_Name_SP__c = 'Dance';
        subject.Available_in_IBEN__c = true;
        subject.Available_in_MySchool__c = true;
        insert subject;
        
        IB_Subject__c subject2 = new IB_Subject__c();
        subject2.IB_Programme__c = 'PYP';
        subject2.IB_Programme_Long__c = 'PYP';
        subject2.Subject_Code__c = 'pyp';
        subject2.Subject_Group__c = 'Arts (PYP)';
        subject2.Subject_Group_Identifier__c = 'artsm';
        subject2.Subject_Name__c = 'Design';
        subject2.Subject_Name_FR__c = 'Design';
        subject2.Subject_Name_SP__c = 'Design';
        subject2.Available_in_IBEN__c = true;
        subject2.Available_in_MySchool__c = true;
        insert subject2;
        
        IB_Subject__c subject3 = new IB_Subject__c();
        subject3.IB_Programme__c = 'PYP';
        subject3.IB_Programme_Long__c = 'PYP';
        subject3.Subject_Code__c = 'pyp';
        subject3.Subject_Group__c = 'Arts (PYP)';
        subject3.Subject_Group_Identifier__c = 'artsm';
        subject3.Subject_Name__c = 'Paint';
        subject3.Subject_Name_FR__c = 'Paint';
        subject3.Subject_Name_SP__c = 'Paint';
        subject3.Available_in_IBEN__c = true;
        subject3.Available_in_MySchool__c = true;
        insert subject3;
        
        IB_Workshop_Titles__c workshop = new IB_Workshop_Titles__c();
        workshop.Programme__c = 'PYP';
        workshop.Subject__c = 'Dance';
        workshop.Subject_Group__c = 'Arts';
        workshop.Workshop__c = 'Workshop Development';
        workshop.Workshop_Title_ENG__c = 'test';
        workshop.Workshop_Title_FR__c = 'test';
        workshop.Workshop_Title_SP__c = 'test';
        workshop.Available_To__c = date.today()+6;
        insert workshop;
        
        IB_Workshop_Titles__c workshop2 = new IB_Workshop_Titles__c();
        workshop2.Programme__c = 'PYP';
        workshop2.Subject__c = 'Dance';
        workshop2.Subject_Group__c = 'Arts';
        workshop2.Workshop__c = 'Workshop Development';
        workshop2.Workshop_Title_ENG__c = 'test2';
        workshop2.Workshop_Title_FR__c = 'test2';
        workshop2.Workshop_Title_SP__c = 'test2';
        workshop2.Available_To__c = date.today()+6;
        insert workshop2;
        
        IB_Workshop_Title_Subject__c workshopSubject = new IB_Workshop_Title_Subject__c();
        workshopSubject.IB_Subject__c = subject.Id;
        workshopSubject.IB_Workshop_Title__c = workshop2.Id;
        insert workshopSubject;
        
        IB_Workshop_Titles__c workshop3 = new IB_Workshop_Titles__c();
        workshop3.Programme__c = 'PYP';
        workshop3.Subject__c = 'Dance';
        workshop3.Subject_Group__c = 'Arts';
        workshop3.Workshop__c = 'Workshop Development';
        workshop3.Workshop_Title_ENG__c = 'test3';
        workshop3.Workshop_Title_FR__c = 'test3';
        workshop3.Workshop_Title_SP__c = 'test3';
        workshop3.Available_To__c = date.today();
        insert workshop3;
        
        IB_Data_Translate__c dt = new IB_Data_Translate__c();
        dt.Object_Name__c = 'IB_Role_Repository__c';
        dt.Locale__c = 'es';
        dt.Record_ID__c = 'PYP';
        dt.Translate_Value_1__c = 'PYP';
        
        IB_Data_Translate__c dt2 = new IB_Data_Translate__c();
        dt2.Object_Name__c = 'IB_Role_Repository__c';
        dt2.Locale__c = 'fr';
        dt2.Record_ID__c = 'PYP';
        dt2.Translate_Value_1__c = 'PYP';
        
        IB_Data_Translate__c dt3 = new IB_Data_Translate__c();
        dt3.Object_Name__c = 'IB_Programme__c';
        dt3.Locale__c = 'es';
        dt3.Record_ID__c = 'PYP';
        dt3.Translate_Value_1__c = 'PYP';
        
        IB_Data_Translate__c dt4 = new IB_Data_Translate__c();
        dt4.Object_Name__c = 'IB_Programme__c';
        dt4.Locale__c = 'fr';
        dt4.Record_ID__c = 'PYP';
        dt4.Translate_Value_1__c = 'PYP';
        
        insert new List<IB_Data_Translate__c> {dt,dt2,dt3,dt4};
            
            
            
            IB_Programme__c programme = PimsTestUtil.createProgrammeForAccount(acc,'PYP');
        //insert programme;
        System.debug('1111111111111 ' + Limits.getQueries());
        
        //System.runAs(u){
        Test.startTest();
        System.debug('Limits.getQueries 1: ' + Limits.getQueries());
        
        Apexpages.currentPage().getParameters().put('SubParam',subject.Id+'&Dance(PYP)');
        
        IB_Role__c role1 = TestsUtil.createIbRole(repo.Id, u.contactId);            
        role1.Programme_Selection__c = 'PYP';
        role1.Subject_Groups__c = 'Other';
        //insert role1;
        System.debug('Limits.getQueries 2: ' + Limits.getQueries());
        
        Role_Application_Subject__c ras = new Role_Application_Subject__c();
        ras.IB_Subject__c = subject.Id;
        ras.Role_And_Application__c = role1.Id;
        insert ras;
        
        Role_Application_Workshop_Title__c rawt = new Role_Application_Workshop_Title__c();
        rawt.IB_Workshop_Title__c = workshop.Id;
        rawt.Role_And_Application__c = role1.Id;
        insert rawt;
        
        
        ApexPages.currentPage().getParameters().put('roleId',role1.IB_Role__c);
        
        IB_Role__c newRole = new IB_Role__c();
        ApexPages.StandardController sc = new ApexPages.StandardController(newRole);
        MyIBRoleApplicationCtrl ra = new MyIBRoleApplicationCtrl(sc);
        
        
        List<SelectOption> options = new List<SelectOption>();
        
        options.add(new SelectOption('Arts-PYP','Arts-PYP'));        
        options.add(new SelectOption('Paint','Paint'));
        ra.getSubjectOptsLeft();
        ra.subjectOptsLeft=options;
        ra.getSubjectOptsLeft();
        ra.getReferencesCap();
        ra.subjectOptsRight=options;
        ra.selectedWorkshopTitles=options;
        ra.programmData = 'PYP';
        String programme2 = ra.selectedprogramme;
        ra.programmData  = 'MYP';
        programme2 = ra.selectedprogramme;
        ra.programmData  = 'CP';
        programme2 = ra.selectedprogramme;
        ra.programmData  = 'DP + CP';
        programme2 = ra.selectedprogramme;
        ra.programmData  = 'IB Ed';
        programme2 = ra.selectedprogramme;
        ra.programmData  = 'Lead';
        programme2 = ra.selectedprogramme;
        ra.programmData  = 'DP';
        programme2 = ra.selectedprogramme;
        IB_Workshop_Details__c detail = new IB_Workshop_Details__c(
            Name = 'Test Detail',
            IB_Category__c = 'Category 3',
            IB_Workshop_Title__c = workshop.id
        );
        insert detail;
        MyIBRoleApplicationCtrl.Workshops_Details w_d= new MyIBRoleApplicationCtrl.Workshops_Details(detail,true);
        List<MyIBRoleApplicationCtrl.Workshops_Details> w_d_list = new List<MyIBRoleApplicationCtrl.Workshops_Details>();
        w_d_list.add(w_d);
        ra.Workshops_Details_All = w_d_list;
        ra.Workshops_Details_List = w_d_list;
        ra.filters();
        ra.inputText1 = 'workshptile';
        ra.filters();
        ra.programmData = 'PYP';
        ra.get_workshop_titles();
        ra.get_searchtitle();
        ra.selected_workshops();
        ra.Workshops_Details_All = w_d_list;
        ra.Workshops_Details_List = w_d_list;
        ra.inputText1 = 'Test';
        ra.searchfilter_category = null;
        ra.filters();
        ra.inputText1 = null;
        ra.searchfilter_category =  'Test';
        ra.filters();
        ra.programmData = 'DP';
        programme2 = ra.selectedprogramme;
        ra.searchfilter_category = 'Test';
        ra.filters();
        ra.get_workshop_titles();
        ra.get_searchtitle();
        ra.selected_workshops();
        ra.getProgramme();
        ra.searchfilter_category = 'Test';
        ra.filters();
        ra.geteducator_background_role();
        ra.geteducator_programme();
        ra.ib_background = new List<IB_E_Background__c>();
        ra.addAnother();
        ra.addAnother();
        ra.row_to_remove = 1;
        ra.remove();
        ra.SaveInfo();
        ra.getSubjectGroups();
        ra.getSubjects();
        ra.getCountryInfo();
        ra.getProgrammsInfo();
        ra.initSubjects();
        ra.initSubjectGroups();
        ra.getProgrammeCoordinatorsForSchool();
        // This part is updated by Arbaz-Plumlogix US-12376 09/09/2021 (DP Authorized School Programme Coordinator )
        // //Start
        List<String> matchAccs = MyIBRoleApplicationCtrl.lookupSchoolAccount('Test',role1.IB_Role__c);
        
        ra.role.Account_ID__c = acc.Id;
        
        List<String> matchAccs2 = MyIBRoleApplicationCtrl.lookupSchoolAccountByNameMulti('Test Class Account:000001',role1.IB_Role__c);
        //End
        ra.getProgrammesForSchool();
        
        ra.role.IB_Programme_New__c = programme.Id;
        
        ra.selectProgramme();
        
        ra.isLoggedIn();
        ra.programmData = 'PYP';
        ra.subjectGroupString = 'Arts (PYP)';
        ra.getSubjects();
        system.debug(loggingLevel.ERROR,'left: ' + ra.subjectOptsLeft);
        ra.subjectOptsRight.add(ra.subjectOptsLeft[0]);
        String a = ra.roleDescription;
        a = ra.categoryData;
        a = ra.roleData;
        
        a = ra.subjectString;
        a = ra.ibisCode;
        a = ra.schoolAccountId;
        a = ra.schoolName;
        
        IB_E_Background__c eBackground = ra.languageExperience;
        eBackground = ra.educationalDegree;
        
        a = ra.languageExpRecType;
        a = ra.educationalDegRecType;
        
        ra.getStatus();
        
        ra.getRole();
        List<SelectOption> optionss = ra.bqcsubject;
        
        ApexPages.currentPage().getParameters().put('roleId', role1.IB_Role__c);
        MyIBRoleApplicationRedirect red = new MyIBRoleApplicationRedirect();
        red.redirect();
        
        ApexPages.currentPage().getParameters().put('id',role1.Id);
        IB_Workshop_Titles__c IbInst = new IB_Workshop_Titles__c();
        IbInst.Programme__c = programme.id;
        IbInst.Workshop_Title_ENG__c = 'English';
        IbInst.Workshop_Title_FR__c = 'French';
        insert IbInst;
        // MyIBRoleApplicationSubjectsCtrl rasc = new MyIBRoleApplicationSubjectsCtrl();
        /*   rasc.getSubjectGroups();
rasc.subjectGroup = 'Arts (PYP)';
rasc.getSubjectNames();
rasc.getWorkshopTitles();
rasc.deleteId = ras.Id;
rasc.removeSubject();
rasc.addSubject = ras.IB_Subject__c;
rasc.createSubject();
rasc.saveWorkshopTitles();
*/
        
        //  MyIBRolesController rolesCntrl = new MyIBRolesController();
        //  rolesCntrl.isLoggedIn();
        //rolesCntrl.getLocale();
        
        
        //            Test.startTest();
        u.LanguageLocaleKey = 'fr';
        //update u;
        ra.initSubjects();
        ra.getSubjects();
        ra.getWorkshopTitles();
        ra.getProgrammesForSchool();
        ra.SaveInfo();
        ra.getCountryInfo();
        u.LanguageLocaleKey = 'es';
        //update u;
        ra.initSubjects();
        ra.getCountryInfo();
        ra.getSubjects();
        ra.getWorkshopTitles();
        ra.getProgrammesForSchool();
        ra.bqcsubjectGroupString = null;
        
        ra.SaveInfo_IBEC_Role();
        //Test.stopTest();
        // }
        
        //RoleRepositoryService.getAllRoles();
        
        
        
        
        
        
    }
    
    @isTest static void test_method_two() {  
        
        try
        {
            TestsUtil.initCampaigns();
            List<Account> accs = TestsUtil.getAccounts();
            List<Campaign> camps = TestsUtil.getCampaigns();
            
            IB_Country_Segmentation__c country = TestsUtil.createCountry('test_country_name', 'EUROPE', accs.get(0));
            insert country;
            
            User u = TestsUtil.createPortalUser('TestingPortal');
            u.FirstName = 'test3';
            // insert u;
            Contact_information__c contact = new Contact_information__c();
            contact.Email__c = 'Test@gmail.com';
            contact.IB_Contact__c = u.ContactId;
            insert contact;
            
            IB_Role_Repository__c repo = TestsUtil.createRoleRepo();
            repo.Role_Level__c = 'Fully Qualified';
            repo.Require_Educational_Degree__c = true;
            repo.Require_Language_Experience__c = true;
            repo.MyIB_Has_Subjects__c = true;
            repo.MyIB_Has_Workshop_Titles__c = true;
            repo.Display_in_MyIB__c = true;
            
            
            IB_Role_Repository__c repo2 = TestsUtil.createRoleRepo();
            repo2.Role_Level__c = 'Fully Qualified';
            repo2.Require_Educational_Degree__c = true;
            repo2.Require_Language_Experience__c = true;
            repo2.MyIB_Has_Subjects__c = true;
            repo2.MyIB_Has_Workshop_Titles__c = true;
            repo2.Custom_Application__c = 'TeacherApp';
            repo2.MyIB_Use_My_School_Subjects__c = true;
            repo2.Role_Name__c = 'Teacher';
            repo2.Display_in_MyIB__c = true;
            repo2.Application_Available_in_MyIB__c = true;
            insert new List<IB_Role_Repository__c> {repo,repo2};
                
                IB_Event_Role__c eventRole = new IB_Event_Role__c(
                    IB_Event__c = camps.get(0).Id,
                    Number_of_Required_Educators__c = 1,
                    IB_Role__c = repo.Id
                );
            insert eventRole;
            
            IB_Subject__c subject = new IB_Subject__c();
            subject.IB_Programme__c = 'CP';
            subject.IB_Programme_Long__c = 'CP';
            subject.Subject_Code__c = 'cp';
            subject.Subject_Group__c = 'Arts (PYP)';
            subject.Subject_Group_Identifier__c = 'artsm';
            subject.Subject_Name__c = 'Dance';
            subject.Subject_Name_FR__c = 'Dance';
            subject.Subject_Name_SP__c = 'Dance';
            subject.Available_in_IBEN__c = true;
            subject.Available_in_MySchool__c = true;
            insert subject;
            
            IB_Subject__c subject2 = new IB_Subject__c();
            subject2.IB_Programme__c = 'CP';
            subject2.IB_Programme_Long__c = 'CP';
            subject2.Subject_Code__c = 'cp';
            subject2.Subject_Group__c = 'Arts (PYP)';
            subject2.Subject_Group_Identifier__c = 'artsm';
            subject2.Subject_Name__c = 'Design';
            subject2.Subject_Name_FR__c = 'Design';
            subject2.Subject_Name_SP__c = 'Design';
            subject2.Available_in_IBEN__c = true;
            subject2.Available_in_MySchool__c = true;
            insert subject2;
            
            IB_Subject__c subject3 = new IB_Subject__c();
            subject3.IB_Programme__c = 'CP';
            subject3.IB_Programme_Long__c = 'CP';
            subject3.Subject_Code__c = 'cp';
            subject3.Subject_Group__c = 'Arts (CP)';
            subject3.Subject_Group_Identifier__c = 'artsm';
            subject3.Subject_Name__c = 'Paint';
            subject3.Subject_Name_FR__c = 'Paint';
            subject3.Subject_Name_SP__c = 'Paint';
            subject3.Available_in_IBEN__c = true;
            subject3.Available_in_MySchool__c = true;
            insert subject3;
            
            IB_Workshop_Titles__c workshop = new IB_Workshop_Titles__c();
            workshop.Programme__c = 'CP';
            workshop.Subject__c = 'Dance';
            workshop.Subject_Group__c = 'Arts';
            workshop.Workshop__c = 'Workshop Development';
            workshop.Workshop_Title_ENG__c = 'test';
            workshop.Workshop_Title_FR__c = 'test';
            workshop.Workshop_Title_SP__c = 'test';
            insert workshop;
            
            IB_Workshop_Titles__c workshop2 = new IB_Workshop_Titles__c();
            workshop2.Programme__c = 'CP';
            workshop2.Subject__c = 'Dance';
            workshop2.Subject_Group__c = 'Arts';
            workshop2.Workshop__c = 'Workshop Development';
            workshop2.Workshop_Title_ENG__c = 'test2';
            workshop2.Workshop_Title_FR__c = 'test2';
            workshop2.Workshop_Title_SP__c = 'test2';
            insert workshop2;
            
            IB_Workshop_Title_Subject__c workshopSubject = new IB_Workshop_Title_Subject__c();
            workshopSubject.IB_Subject__c = subject.Id;
            workshopSubject.IB_Workshop_Title__c = workshop2.Id;
            insert workshopSubject;
            
            IB_Workshop_Titles__c workshop3 = new IB_Workshop_Titles__c();
            workshop3.Programme__c = 'CP';
            workshop3.Subject__c = 'Dance';
            workshop3.Subject_Group__c = 'Arts';
            workshop3.Workshop__c = 'Workshop Development';
            workshop3.Workshop_Title_ENG__c = 'test3';
            workshop3.Workshop_Title_FR__c = 'test3';
            workshop3.Workshop_Title_SP__c = 'test3';
            insert workshop3;
            
            IB_Data_Translate__c dt = new IB_Data_Translate__c();
            dt.Object_Name__c = 'IB_Role_Repository__c';
            dt.Locale__c = 'es';
            dt.Record_ID__c = 'CP';
            dt.Translate_Value_1__c = 'CP';
            
            IB_Data_Translate__c dt2 = new IB_Data_Translate__c();
            dt2.Object_Name__c = 'IB_Role_Repository__c';
            dt2.Locale__c = 'fr';
            dt2.Record_ID__c = 'CP';
            dt2.Translate_Value_1__c = 'CP';
            
            IB_Data_Translate__c dt3 = new IB_Data_Translate__c();
            dt3.Object_Name__c = 'IB_Programme__c';
            dt3.Locale__c = 'es';
            dt3.Record_ID__c = 'CP';
            dt3.Translate_Value_1__c = 'CP';
            
            IB_Data_Translate__c dt4 = new IB_Data_Translate__c();
            dt4.Object_Name__c = 'IB_Programme__c';
            dt4.Locale__c = 'fr';
            dt4.Record_ID__c = 'CP';
            dt4.Translate_Value_1__c = 'CP';
            
            insert new List<IB_Data_Translate__c> {dt,dt2,dt3,dt4};
                
                Account acc = PimsTestUtil.createAccount('Test Class Account', '');
            acc.IBIS_ID__c = '000001';
            insert acc;
            
            IB_Programme__c programme = PimsTestUtil.createProgrammeForAccount(acc,'PYP');
            insert programme;
            
            // System.runAs(u){
            Test.startTest();
            Apexpages.currentPage().getParameters().put('SubParam',subject.Id+'&Dance(PYP)');
            
            IB_Role__c role1 = TestsUtil.createIbRole(repo2.Id, u.contactId);            
            role1.Programme_Selection__c = 'CP';
            role1.Subject_Groups__c = 'Other';
            //insert role1;
            
            Role_Application_Subject__c ras = new Role_Application_Subject__c();
            ras.IB_Subject__c = subject.Id;
            ras.Role_And_Application__c = role1.Id;
            //insert ras;
            
            Role_Application_Workshop_Title__c rawt = new Role_Application_Workshop_Title__c();
            rawt.IB_Workshop_Title__c = workshop.Id;
            rawt.Role_And_Application__c = role1.Id;
            //insert rawt;
            
            
            ApexPages.currentPage().getParameters().put('roleId',role1.IB_Role__c);
            
            IB_Role__c newRole = new IB_Role__c();
            ApexPages.StandardController sc = new ApexPages.StandardController(newRole);
            MyIBRoleApplicationCtrl ra = new MyIBRoleApplicationCtrl(sc);
            
            ra.getReferencesCap();
            ra.hasPhone = true;
            ra.SaveInfo();
            ra.getSubjectGroups();
            ra.getSubjects();
            // This part is updated by Arbaz-Plumlogix US-12376 09/09/2021 (DP Authorized School Programme Coordinator )
            // //Start
            List<String> matchAccs = MyIBRoleApplicationCtrl.lookupSchoolAccount('Test',role1.IB_Role__c);
            
            ra.role.Account_ID__c = acc.Id;
            
            List<String> matchAccs2 = MyIBRoleApplicationCtrl.lookupSchoolAccountByNameMulti('Test Class Account:000001',role1.IB_Role__c);
            //End
            ra.getProgrammesForSchool();
            
            ra.role.IB_Programme_New__c = programme.Id;
            
            ra.selectProgramme();
            
            ra.isLoggedIn();
            
            ra.subjectGroupString = 'Arts (PYP)';
            ra.getSubjects();
            system.debug(loggingLevel.ERROR,'left: ' + ra.subjectOptsLeft);
            //ra.subjectOptsRight.add(ra.subjectOptsLeft[0]);
            String a = ra.roleDescription;
            a = ra.categoryData;
            a = ra.roleData;
            
            a = ra.subjectString;
            a = ra.ibisCode;
            a = ra.schoolAccountId;
            a = ra.schoolName;
            
            IB_E_Background__c eBackground = ra.languageExperience;
            eBackground = ra.educationalDegree;
            
            a = ra.languageExpRecType;
            a = ra.educationalDegRecType;
            
            ra.getStatus();
            
            ra.getRole();
            
            ApexPages.currentPage().getParameters().put('roleId', role1.IB_Role__c);
            MyIBRoleApplicationRedirect red = new MyIBRoleApplicationRedirect();
            red.redirect();
            
            ApexPages.currentPage().getParameters().put('id',role1.Id);
            
            MyIBRolesController rolesCntrl = new MyIBRolesController();
            rolesCntrl.isLoggedIn();
            rolesCntrl.getLocale();
            
            u.LanguageLocaleKey = 'fr';
            //update u;
            ra.initSubjects();
            ra.getSubjects();
            ra.getWorkshopTitles();
            ra.getProgrammesForSchool();
            
            u.LanguageLocaleKey = 'es';
            //update u;
            ra.initSubjects();
            ra.getSubjects();
            ra.getWorkshopTitles();
            ra.getProgrammesForSchool();
            Test.stopTest();
        }
        
        catch(exception e)
        {
            system.debug('excep'+e);
            
        }
        
    }
    
    @isTest static void test_method_three() {
        
        try
        {
            TestsUtil.initCampaigns();
            List<Account> accs = TestsUtil.getAccounts();
            List<Campaign> camps = TestsUtil.getCampaigns();
            
            IB_Country_Segmentation__c country = TestsUtil.createCountry('test_country_name', 'EUROPE', accs.get(0));
            insert country;
            Account acc = PimsTestUtil.createAccount('Test Class Account', '');
            acc.IBIS_ID__c = '000001';
            insert acc;
            Contact con3 = PimsTestUtil.createContact('Test Contact', 'a@a.com', 'a@a.com', Date.newInstance(1980, 1, 1), acc);
            con3.AccountId=acc.id;
            
            con3.Country_Code__c = 'Åland Islands (+3581)';
            con3.Phone_Number__c = '123456';
            insert con3;
            User u = TestsUtil.createPortalUser('TestingPortal');
            u.FirstName = 'test2';
            u.ContactId=con3.Id;
            insert u;
            
            Contact_information__c contact = new Contact_information__c();
            contact.Email__c = 'Test@gmail.com';
            contact.IB_Contact__c = u.ContactId;
            insert contact;
            
            IB_Role_Repository__c repo = TestsUtil.createRoleRepo();
            repo.Role_Level__c = 'Fully Qualified';
            repo.Require_Educational_Degree__c = true;
            repo.Require_Language_Experience__c = true;
            repo.MyIB_Has_Subjects__c = true;
            repo.MyIB_Has_Workshop_Titles__c = true;
            repo.Display_in_MyIB__c = true;
            repo.Role_Type__c = 'IBEN Role';
            
            
            IB_Role_Repository__c repo2 = TestsUtil.createRoleRepo();
            repo2.Role_Level__c = 'Fully Qualified';
            repo2.Require_Educational_Degree__c = true;
            repo2.Require_Language_Experience__c = true;
            repo2.MyIB_Has_Subjects__c = true;
            repo2.MyIB_Has_Workshop_Titles__c = true;
            repo2.Custom_Application__c = 'TeacherApp';
            repo2.MyIB_Use_My_School_Subjects__c = true;
            repo2.Role_Name__c = 'Teacher';
            repo2.Display_in_MyIB__c = true;
            repo2.Application_Available_in_MyIB__c = true;
            insert new List<IB_Role_Repository__c> {repo,repo2};
                
                IB_Event_Role__c eventRole = new IB_Event_Role__c(
                    IB_Event__c = camps.get(0).Id,
                    Number_of_Required_Educators__c = 1,
                    IB_Role__c = repo.Id
                );
            insert eventRole;
            
            IB_Subject__c subject = new IB_Subject__c();
            subject.IB_Programme__c = 'CP';
            subject.IB_Programme_Long__c = 'CP';
            subject.Subject_Code__c = 'cp';
            subject.Subject_Group__c = 'Arts (PYP)';
            subject.Subject_Group_Identifier__c = 'artsm';
            subject.Subject_Name__c = 'Dance';
            subject.Subject_Name_FR__c = 'Dance';
            subject.Subject_Name_SP__c = 'Dance';
            subject.Available_in_IBEN__c = true;
            subject.Available_in_MySchool__c = true;
            insert subject;
            
            IB_Subject__c subject2 = new IB_Subject__c();
            subject2.IB_Programme__c = 'CP';
            subject2.IB_Programme_Long__c = 'CP';
            subject2.Subject_Code__c = 'cp';
            subject2.Subject_Group__c = 'Arts (PYP)';
            subject2.Subject_Group_Identifier__c = 'artsm';
            subject2.Subject_Name__c = 'Design';
            subject2.Subject_Name_FR__c = 'Design';
            subject2.Subject_Name_SP__c = 'Design';
            subject2.Available_in_IBEN__c = true;
            subject2.Available_in_MySchool__c = true;
            insert subject2;
            
            IB_Subject__c subject3 = new IB_Subject__c();
            subject3.IB_Programme__c = 'CP';
            subject3.IB_Programme_Long__c = 'CP';
            subject3.Subject_Code__c = 'cp';
            subject3.Subject_Group__c = 'Arts (CP)';
            subject3.Subject_Group_Identifier__c = 'artsm';
            subject3.Subject_Name__c = 'Paint';
            subject3.Subject_Name_FR__c = 'Paint';
            subject3.Subject_Name_SP__c = 'Paint';
            subject3.Available_in_IBEN__c = true;
            subject3.Available_in_MySchool__c = true;
            insert subject3;
            
            IB_Workshop_Titles__c workshop = new IB_Workshop_Titles__c();
            workshop.Programme__c = 'CP';
            workshop.Subject__c = 'Dance';
            workshop.Subject_Group__c = 'Arts';
            workshop.Workshop__c = 'Workshop Development';
            workshop.Workshop_Title_ENG__c = 'test';
            workshop.Workshop_Title_FR__c = 'test';
            workshop.Workshop_Title_SP__c = 'test';
            insert workshop;
            
            IB_Workshop_Titles__c workshop2 = new IB_Workshop_Titles__c();
            workshop2.Programme__c = 'CP';
            workshop2.Subject__c = 'Dance';
            workshop2.Subject_Group__c = 'Arts';
            workshop2.Workshop__c = 'Workshop Development';
            workshop2.Workshop_Title_ENG__c = 'test2';
            workshop2.Workshop_Title_FR__c = 'test2';
            workshop2.Workshop_Title_SP__c = 'test2';
            insert workshop2;
            
            IB_Workshop_Title_Subject__c workshopSubject = new IB_Workshop_Title_Subject__c();
            workshopSubject.IB_Subject__c = subject.Id;
            workshopSubject.IB_Workshop_Title__c = workshop2.Id;
            insert workshopSubject;
            
            IB_Workshop_Titles__c workshop3 = new IB_Workshop_Titles__c();
            workshop3.Programme__c = 'CP';
            workshop3.Subject__c = 'Dance';
            workshop3.Subject_Group__c = 'Arts';
            workshop3.Workshop__c = 'Workshop Development';
            workshop3.Workshop_Title_ENG__c = 'test3';
            workshop3.Workshop_Title_FR__c = 'test3';
            workshop3.Workshop_Title_SP__c = 'test3';
            insert workshop3;
            
            IB_Data_Translate__c dt = new IB_Data_Translate__c();
            dt.Object_Name__c = 'IB_Role_Repository__c';
            dt.Locale__c = 'es';
            dt.Record_ID__c = 'CP';
            dt.Translate_Value_1__c = 'CP';
            
            IB_Data_Translate__c dt2 = new IB_Data_Translate__c();
            dt2.Object_Name__c = 'IB_Role_Repository__c';
            dt2.Locale__c = 'fr';
            dt2.Record_ID__c = 'CP';
            dt2.Translate_Value_1__c = 'CP';
            
            IB_Data_Translate__c dt3 = new IB_Data_Translate__c();
            dt3.Object_Name__c = 'IB_Programme__c';
            dt3.Locale__c = 'es';
            dt3.Record_ID__c = 'CP';
            dt3.Translate_Value_1__c = 'CP';
            
            IB_Data_Translate__c dt4 = new IB_Data_Translate__c();
            dt4.Object_Name__c = 'IB_Programme__c';
            dt4.Locale__c = 'fr';
            dt4.Record_ID__c = 'CP';
            dt4.Translate_Value_1__c = 'CP';
            
            insert new List<IB_Data_Translate__c> {dt,dt2,dt3,dt4};
                
                /*  Account acc = PimsTestUtil.createAccount('Test Class Account', '');
acc.IBIS_ID__c = '000001';
insert acc;*/
                
                IB_Programme__c programme = PimsTestUtil.createProgrammeForAccount(acc,'PYP');
            insert programme;
            //This Part is being added by Ammara-Plumlogix on 10/16/2019,Increase Code Coverage
            //begin
            RecordType rt1 = RecordTypeDAO.INSTANCE.getRecordTypeByNameAndsObjectType('Language Experience', 'IB_E_Background__c');
            RecordType rt2 = RecordTypeDAO.INSTANCE.getRecordTypeByNameAndsObjectType('Educational Degrees', 'IB_E_Background__c');
            
            IB_E_Background__c bg1 = TestsUtil.createMyProfileObject(u.contactId , rt1.Id);
            bg1.Language__c = 'English';
            bg1.Language_Delivery__c = 'Yes';
            IB_E_Background__c bg2 = TestsUtil.createMyProfileObject(u.contactId, rt1.Id);
            bg2.Language__c = 'Spanish';
            bg1.Language_Delivery__c = 'Yes';
            IB_E_Background__c bg3 = TestsUtil.createMyProfileObject(u.contactId, rt2.Id);
            bg3.Language__c = 'French';
            bg1.Language_Delivery__c = 'Yes';
            insert new List<IB_E_Background__c>{bg1,bg2,bg3};
                
                //End
                
                System.runAs(u){
                    Test.startTest();
                    Apexpages.currentPage().getParameters().put('SubParam',subject.Id+'&Dance(PYP)');
                    
                    IB_Role__c role1 = TestsUtil.createIbRole(repo.Id, u.contactId);            
                    role1.Programme_Selection__c = 'CP';
                    role1.Subject_Groups__c = 'Other';
                    //insert role1;
                    
                    Role_Application_Subject__c ras = new Role_Application_Subject__c();
                    ras.IB_Subject__c = subject.Id;
                    ras.Role_And_Application__c = role1.Id;
                    //insert ras;
                    
                    Role_Application_Workshop_Title__c rawt = new Role_Application_Workshop_Title__c();
                    rawt.IB_Workshop_Title__c = workshop.Id;
                    rawt.Role_And_Application__c = role1.Id;
                    //insert rawt;
                    
                    
                    ApexPages.currentPage().getParameters().put('roleId',role1.IB_Role__c);
                    
                    IB_Role__c newRole = new IB_Role__c();
                    ApexPages.StandardController sc = new ApexPages.StandardController(newRole);
                    MyIBRoleApplicationCtrl ra = new MyIBRoleApplicationCtrl(sc);
                    
                    ra.getReferencesCap();
                    ra.SaveInfo();
                    ra.SaveInfo_IBEC_Role();
                    ra.getSubjectGroups();
                    ra.getSubjects();
                    // This part is updated by Arbaz-Plumlogix US-12376 09/09/2021 (DP Authorized School Programme Coordinator )
                    // //Start
                    List<String> matchAccs = MyIBRoleApplicationCtrl.lookupSchoolAccount('Test',role1.IB_Role__c);
                    
                    ra.role.Account_ID__c = acc.Id;
                    
                    List<String> matchAccs2 = MyIBRoleApplicationCtrl.lookupSchoolAccountByNameMulti('Test Class Account:000001',role1.IB_Role__c);
                    
                    ra.getProgrammesForSchool();
                    //End
                    ra.role.IB_Programme_New__c = programme.Id;
                    
                    ra.selectProgramme();
                    
                    ra.isLoggedIn();
                    
                    ra.subjectGroupString = 'Arts (PYP)';
                    ra.getSubjects();
                    system.debug(loggingLevel.ERROR,'left: ' + ra.subjectOptsLeft);
                    //ra.subjectOptsRight.add(ra.subjectOptsLeft[0]);
                    String a = ra.roleDescription;
                    a = ra.categoryData;
                    a = ra.roleData;
                    
                    a = ra.subjectString;
                    a = ra.ibisCode;
                    a = ra.schoolAccountId;
                    a = ra.schoolName;
                    
                    IB_E_Background__c eBackground = ra.languageExperience;
                    eBackground = ra.educationalDegree;
                    
                    a = ra.languageExpRecType;
                    a = ra.educationalDegRecType;
                    
                    ra.getStatus();
                    
                    ra.getRole();
                    
                    ApexPages.currentPage().getParameters().put('roleId', role1.IB_Role__c);
                    MyIBRoleApplicationRedirect red = new MyIBRoleApplicationRedirect();
                    red.redirect();
                    
                    ApexPages.currentPage().getParameters().put('id',role1.Id);
                    // MyIBRoleApplicationSubjectsCtrl rasc = new MyIBRoleApplicationSubjectsCtrl();
                    /*  rasc.getSubjectGroups();
rasc.subjectGroup = 'Arts (PYP)';
rasc.getSubjectNames();
rasc.getWorkshopTitles();
rasc.deleteId = ras.Id;
rasc.removeSubject();
rasc.addSubject = ras.IB_Subject__c;
rasc.createSubject();
rasc.saveWorkshopTitles();
*/
                    
                    //MyIBRolesController rolesCntrl = new MyIBRolesController();
                    // rolesCntrl.isLoggedIn();
                    //rolesCntrl.getLocale();
                    
                    u.LanguageLocaleKey = 'fr';
                    update u;
                    ra.initSubjects();
                    ra.getSubjects();
                    ra.getWorkshopTitles();
                    ra.getProgrammesForSchool();
                    
                    u.LanguageLocaleKey = 'es';
                    update u;
                    ra.initSubjects();
                    ra.getSubjects();
                    ra.getWorkshopTitles();
                    ra.getProgrammesForSchool();
                    Test.stopTest();
                }
            
            
            
            
        }
        catch(exception e)
        {
            system.debug('excep'+e);
        }
        
        
        
    }
    
    @isTest static void test_method_four() {
        try {
            
            
            
            User u = TestsUtil.createPortalUser('TestingPortal');
            u.FirstName = 'test2';
            u.LanguageLocaleKey = 'fr';                
            insert u;
            
            Contact con1 = [Select id,AccountId from contact where id = :u.ContactId];
            Account acc = [Select id from account where id =: con1.AccountId];
            IB_Programme__c prog3 = PimsTestUtil.createProgrammeForAccount (acc, 'Diploma Programme');
            prog3.Date_Decision_on_Authorization__c = date.today();
            prog3.Owner__c = UserInfo.getUserId();
            prog3.Status__c = 'Authorized';        
            insert new List<IB_Programme__c>{prog3};
                
                IB_Role_Repository__c reppo2=new IB_Role_Repository__c(
                    Available__c=true,
                    SF_Role_Application__c=true,
                    Available_From__c=Date.today().addDays(-12),//2014-02-27 00:00:00
                    CurrencyIsoCode='EUR',
                    Role_Name__c='CAS Coordinator',
                    Category__c='School Services',
                    Role_Level__c='Fully Qualified;Shadow;',
                    Sub_Category__c='Evaluation & Authorization',
                    Related_Programmes__c='PYP;MYP;DP;IBCC',
                    Available_in_Region__c='Global',
                    Training_Model__c = 'Advanced Training',
                    IB_Staff_Role__c=true,
                    Role_Type__c = 'School Role'
                );    
            insert reppo2;            
            
            IB_Role__c role9 = PimsTestUtil.createIbRole(reppo2.Id, con1.Id, acc.Id);
            role9.IB_Account__c = acc.Id;
            role9.Account_ID__c = acc.id;
            role9.IB_Role__c = reppo2.Id;
            role9.IB_Programme_New__c = prog3.Id;
            
            role9.Start_Date__c = Date.today();
            role9.Status__c='Applicant';
            
            Test.startTest();
            System.runAs(u){         
                ApexPages.currentPage().getParameters().put('roleId', role9.IB_Role__c);
                MyIBRoleApplicationRedirect red = new MyIBRoleApplicationRedirect();
                red.redirect();
                
                ApexPages.StandardController sc = new ApexPages.StandardController(role9);
                MyIBRoleApplicationCtrl ra = new MyIBRoleApplicationCtrl(sc);
                ApexPages.currentPage().getParameters().put('id',role9.Id);
                ra.hasphone = true;
                ra.con = con1;
                // This part is updated by Arbaz-Plumlogix US-12376 09/09/2021 (DP Authorized School Programme Coordinator )
                // //Start
                List<String> matchAccs = MyIBRoleApplicationCtrl.lookupSchoolAccount('test',role9.IB_Role__c);
                List<String> matchAccs2 = MyIBRoleApplicationCtrl.lookupSchoolAccountByNameMulti('acc_test_any_possible_name:000002',role9.IB_Role__c);
                ra.getProgrammeCoordinatorsForSchool();                
                ra.SaveInfo();
                //End
            }
            Test.stopTest();
            
        }
        catch(exception e)
        {
            system.debug('excep'+e);
            
        }
        
    }   
    
    @isTest static void test_method_five() {
        try
        {
            TestsUtil.initCampaigns();
            List<Account> accs = TestsUtil.getAccounts();
            List<Campaign> camps = TestsUtil.getCampaigns();
            
            IB_Country_Segmentation__c country = TestsUtil.createCountry('test_country_name', 'EUROPE', accs.get(0));
            insert country;
            
            User u = TestsUtil.createPortalUser('TestingPortal-123');
            u.FirstName = 'test4';
            //insert u;
            
            Contact_information__c contact = new Contact_information__c();
            contact.Email__c = 'Test@gmail.com';
            contact.IB_Contact__c = u.ContactId;
            insert contact;
            
            IB_Role_Repository__c repo = TestsUtil.createRoleRepo();
            repo.Role_Level__c = 'Fully Qualified';
            repo.Require_Educational_Degree__c = true;
            repo.Require_Language_Experience__c = true;
            repo.MyIB_Has_Subjects__c = true;
            repo.MyIB_Has_Workshop_Titles__c = true;
            repo.Display_in_MyIB__c = true;
            
            
            IB_Role_Repository__c repo2 = TestsUtil.createRoleRepo();
            repo2.Role_Level__c = 'Fully Qualified';
            repo2.Require_Educational_Degree__c = true;
            repo2.Require_Language_Experience__c = true;
            repo2.MyIB_Has_Subjects__c = true;
            repo2.MyIB_Has_Workshop_Titles__c = true;
            repo2.Custom_Application__c = 'TeacherApp';
            repo2.MyIB_Use_My_School_Subjects__c = true;
            repo2.Role_Name__c = 'Teacher';
            repo2.Display_in_MyIB__c = true;
            repo2.Application_Available_in_MyIB__c = true;
            insert new List<IB_Role_Repository__c> {repo,repo2};
                
                IB_Event_Role__c eventRole = new IB_Event_Role__c(
                    IB_Event__c = camps.get(0).Id,
                    Number_of_Required_Educators__c = 1,
                    IB_Role__c = repo.Id
                );
            insert eventRole;
            
            IB_Subject__c subject = new IB_Subject__c();
            subject.IB_Programme__c = 'PYP';
            subject.IB_Programme_Long__c = 'PYP';
            subject.Subject_Code__c = 'pyp';
            subject.Subject_Group__c = 'Arts (PYP)';
            subject.Subject_Group_Identifier__c = 'artsm';
            subject.Subject_Name__c = 'Dance';
            subject.Subject_Name_FR__c = 'Dance';
            subject.Subject_Name_SP__c = 'Dance';
            subject.Available_in_IBEN__c = true;
            subject.Available_in_MySchool__c = true;
            
            IB_Subject__c subject2 = new IB_Subject__c();
            subject2.IB_Programme__c = 'PYP';
            subject2.IB_Programme_Long__c = 'PYP';
            subject2.Subject_Code__c = 'pyp';
            subject2.Subject_Group__c = 'Arts (PYP)';
            subject2.Subject_Group_Identifier__c = 'artsm';
            subject2.Subject_Name__c = 'Design';
            subject2.Subject_Name_FR__c = 'Design';
            subject2.Subject_Name_SP__c = 'Design';
            subject2.Available_in_IBEN__c = true;
            subject2.Available_in_MySchool__c = true;
            
            IB_Subject__c subject3 = new IB_Subject__c();
            subject3.IB_Programme__c = 'PYP';
            subject3.IB_Programme_Long__c = 'PYP';
            subject3.Subject_Code__c = 'pyp';
            subject3.Subject_Group__c = 'Arts (PYP)';
            subject3.Subject_Group_Identifier__c = 'artsm';
            subject3.Subject_Name__c = 'Paint';
            subject3.Subject_Name_FR__c = 'Paint';
            subject3.Subject_Name_SP__c = 'Paint';
            subject3.Available_in_IBEN__c = true;
            subject3.Available_in_MySchool__c = true;
            insert new List<IB_Subject__c> {subject,subject2,subject3};
                
                IB_Workshop_Titles__c workshop = new IB_Workshop_Titles__c();
            workshop.Programme__c = 'PYP';
            workshop.Subject__c = 'Dance';
            workshop.Subject_Group__c = 'Arts';
            workshop.Workshop__c = 'Workshop Development';
            workshop.Workshop_Title_ENG__c = 'test';
            workshop.Workshop_Title_FR__c = 'test';
            workshop.Workshop_Title_SP__c = 'test';
            
            IB_Workshop_Titles__c workshop2 = new IB_Workshop_Titles__c();
            workshop2.Programme__c = 'PYP';
            workshop2.Subject__c = 'Dance';
            workshop2.Subject_Group__c = 'Arts';
            workshop2.Workshop__c = 'Workshop Development';
            workshop2.Workshop_Title_ENG__c = 'test2';
            workshop2.Workshop_Title_FR__c = 'test2';
            workshop2.Workshop_Title_SP__c = 'test2';
            
            IB_Workshop_Title_Subject__c workshopSubject = new IB_Workshop_Title_Subject__c();
            workshopSubject.IB_Subject__c = subject.Id;
            workshopSubject.IB_Workshop_Title__c = workshop2.Id;
            insert workshopSubject;
            
            IB_Workshop_Titles__c workshop3 = new IB_Workshop_Titles__c();
            workshop3.Programme__c = 'PYP';
            workshop3.Subject__c = 'Dance';
            workshop3.Subject_Group__c = 'Arts';
            workshop3.Workshop__c = 'Workshop Development';
            workshop3.Workshop_Title_ENG__c = 'test3';
            workshop3.Workshop_Title_FR__c = 'test3';
            workshop3.Workshop_Title_SP__c = 'test3';
            insert new List<IB_Workshop_Titles__c> {workshop,workshop2,workshop3};
                
                IB_Data_Translate__c dt = new IB_Data_Translate__c();
            dt.Object_Name__c = 'IB_Role_Repository__c';
            dt.Locale__c = 'es';
            dt.Record_ID__c = 'PYP';
            dt.Translate_Value_1__c = 'PYP';
            
            IB_Data_Translate__c dt2 = new IB_Data_Translate__c();
            dt2.Object_Name__c = 'IB_Role_Repository__c';
            dt2.Locale__c = 'fr';
            dt2.Record_ID__c = 'PYP';
            dt2.Translate_Value_1__c = 'PYP';
            
            IB_Data_Translate__c dt3 = new IB_Data_Translate__c();
            dt3.Object_Name__c = 'IB_Programme__c';
            dt3.Locale__c = 'es';
            dt3.Record_ID__c = 'PYP';
            dt3.Translate_Value_1__c = 'PYP';
            
            IB_Data_Translate__c dt4 = new IB_Data_Translate__c();
            dt4.Object_Name__c = 'IB_Programme__c';
            dt4.Locale__c = 'fr';
            dt4.Record_ID__c = 'PYP';
            dt4.Translate_Value_1__c = 'PYP';
            
            insert new List<IB_Data_Translate__c> {dt,dt2,dt3,dt4};
                
                Account acc = accs.get(0);
            
            IB_Programme__c programme = PimsTestUtil.createProgrammeForAccount(acc,'PYP');
            //insert programme;
            
            
            //System.runAs(u){
            Test.startTest();
            Apexpages.currentPage().getParameters().put('SubParam',subject.Id+'&Dance(PYP)');
            
            IB_Role__c role1 = TestsUtil.createIbRole(repo2.Id, u.contactId);            
            role1.Programme_Selection__c = 'PYP';
            role1.Subject_Groups__c = 'Other';
            //insert role1;
            
            Role_Application_Subject__c ras = new Role_Application_Subject__c();
            ras.IB_Subject__c = subject.Id;
            ras.Role_And_Application__c = role1.Id;
            //insert ras;
            
            Role_Application_Workshop_Title__c rawt = new Role_Application_Workshop_Title__c();
            rawt.IB_Workshop_Title__c = workshop.Id;
            rawt.Role_And_Application__c = role1.Id;
            //insert rawt;
            
            
            ApexPages.currentPage().getParameters().put('roleId',role1.IB_Role__c);
            
            IB_Role__c newRole = new IB_Role__c();
            ApexPages.StandardController sc = new ApexPages.StandardController(newRole);
            MyIBRoleApplicationCtrl ra = new MyIBRoleApplicationCtrl(sc);
            
            ra.getReferencesCap();
            ra.SaveInfo();
            ra.getSubjectGroups();
            ra.getSubjects();
            // This part is updated by Arbaz-Plumlogix US-12376 09/09/2021 (DP Authorized School Programme Coordinator )
            // //Start
            List<String> matchAccs = MyIBRoleApplicationCtrl.lookupSchoolAccount('Test',role1.IB_Role__c);
            
            ra.role.Account_ID__c = acc.Id;
            
            List<String> matchAccs2 = MyIBRoleApplicationCtrl.lookupSchoolAccountByNameMulti('Test Class Account:000001',role1.IB_Role__c);
            //End
            ra.getProgrammesForSchool();
            
            ra.role.IB_Programme_New__c = programme.Id;
            
            ra.selectProgramme();
            
            ra.isLoggedIn();
            
            ra.subjectGroupString = 'Arts (PYP)';
            ra.getSubjects();
            system.debug(loggingLevel.ERROR,'left: ' + ra.subjectOptsLeft);
            //ra.subjectOptsRight.add(ra.subjectOptsLeft[0]);
            String a = ra.roleDescription;
            a = ra.categoryData;
            a = ra.roleData;
            
            a = ra.subjectString;
            a = ra.ibisCode;
            a = ra.schoolAccountId;
            a = ra.schoolName;
            
            IB_E_Background__c eBackground = ra.languageExperience;
            eBackground = ra.educationalDegree;
            
            a = ra.languageExpRecType;
            a = ra.educationalDegRecType;
            
            ra.getStatus();
            
            ra.getRole();
            
            ApexPages.currentPage().getParameters().put('roleId', role1.IB_Role__c);
            MyIBRoleApplicationRedirect red = new MyIBRoleApplicationRedirect();
            red.redirect();
            
            ApexPages.currentPage().getParameters().put('id',role1.Id);
            u.LanguageLocaleKey = 'fr';
            //update u;
            ra.initSubjects();
            ra.getSubjects();
            ra.getWorkshopTitles();
            ra.getProgrammesForSchool();
            
            u.LanguageLocaleKey = 'es';
            //update u;
            ra.initSubjects();
            ra.getSubjects();
            ra.getWorkshopTitles();
            ra.getProgrammesForSchool();
            Test.stopTest();
        }
        
        
        catch(exception e)
        {
            system.debug('excep'+e);
            
        }
        
    } 
    
    @isTest static void test_method_two_Spanish() {
        
        try
        {
            TestsUtil.initCampaigns();
            List<Account> accs = TestsUtil.getAccounts();
            List<Campaign> camps = TestsUtil.getCampaigns();
            
            IB_Country_Segmentation__c country = TestsUtil.createCountry('test_country_name', 'EUROPE', accs.get(0));
            insert country;
            
            User u = TestsUtil.createPortalUser('TestingPortal');
            u.FirstName = 'test2';
            u.LanguageLocaleKey = 'es';                
            insert u;
            
            Contact_information__c contact = new Contact_information__c();
            contact.Email__c = 'Test@gmail.com';
            contact.IB_Contact__c = u.ContactId;
            insert contact;
            
            IB_Role_Repository__c repo = TestsUtil.createRoleRepo();
            repo.Role_Level__c = 'Fully Qualified';
            repo.Require_Educational_Degree__c = true;
            repo.Require_Language_Experience__c = true;
            repo.MyIB_Has_Subjects__c = true;
            repo.MyIB_Has_Workshop_Titles__c = true;
            repo.Display_in_MyIB__c = true;
            
            
            IB_Role_Repository__c repo2 = TestsUtil.createRoleRepo();
            repo2.Role_Level__c = 'Fully Qualified';
            repo2.Require_Educational_Degree__c = true;
            repo2.Require_Language_Experience__c = true;
            repo2.MyIB_Has_Subjects__c = true;
            repo2.MyIB_Has_Workshop_Titles__c = true;
            repo2.Custom_Application__c = 'TeacherApp';
            repo2.MyIB_Use_My_School_Subjects__c = true;
            repo2.Role_Name__c = 'Teacher';
            repo2.Display_in_MyIB__c = true;
            repo2.Application_Available_in_MyIB__c = true;
            insert new List<IB_Role_Repository__c> {repo,repo2};
                
                IB_Event_Role__c eventRole = new IB_Event_Role__c(
                    IB_Event__c = camps.get(0).Id,
                    Number_of_Required_Educators__c = 1,
                    IB_Role__c = repo.Id
                );
            insert eventRole;
            
            IB_Subject__c subject = new IB_Subject__c();
            subject.IB_Programme__c = 'CP';
            subject.IB_Programme_Long__c = 'CP';
            subject.Subject_Code__c = 'cp';
            subject.Subject_Group__c = 'Arts (PYP)';
            subject.Subject_Group_Identifier__c = 'artsm';
            subject.Subject_Name__c = 'Dance';
            subject.Subject_Name_FR__c = 'Dance';
            subject.Subject_Name_SP__c = 'Dance';
            subject.Available_in_IBEN__c = true;
            subject.Available_in_MySchool__c = true;
            insert subject;
            
            IB_Subject__c subject2 = new IB_Subject__c();
            subject2.IB_Programme__c = 'CP';
            subject2.IB_Programme_Long__c = 'CP';
            subject2.Subject_Code__c = 'cp';
            subject2.Subject_Group__c = 'Arts (PYP)';
            subject2.Subject_Group_Identifier__c = 'artsm';
            subject2.Subject_Name__c = 'Design';
            subject2.Subject_Name_FR__c = 'Design';
            subject2.Subject_Name_SP__c = 'Design';
            subject2.Available_in_IBEN__c = true;
            subject2.Available_in_MySchool__c = true;
            insert subject2;
            
            IB_Subject__c subject3 = new IB_Subject__c();
            subject3.IB_Programme__c = 'CP';
            subject3.IB_Programme_Long__c = 'CP';
            subject3.Subject_Code__c = 'cp';
            subject3.Subject_Group__c = 'Arts (CP)';
            subject3.Subject_Group_Identifier__c = 'artsm';
            subject3.Subject_Name__c = 'Paint';
            subject3.Subject_Name_FR__c = 'Paint';
            subject3.Subject_Name_SP__c = 'Paint';
            subject3.Available_in_IBEN__c = true;
            subject3.Available_in_MySchool__c = true;
            insert subject3;
            
            IB_Workshop_Titles__c workshop = new IB_Workshop_Titles__c();
            workshop.Programme__c = 'DP';
            workshop.Subject__c = 'Dance';
            workshop.Subject_Group__c = 'Arts';
            workshop.Workshop__c = 'Workshop Development';
            workshop.Workshop_Title_ENG__c = 'test';
            workshop.Workshop_Title_FR__c = 'test';
            workshop.Workshop_Title_SP__c = 'test';
            insert workshop;
            
            IB_Workshop_Titles__c workshop2 = new IB_Workshop_Titles__c();
            workshop2.Programme__c = 'CP';
            workshop2.Subject__c = 'Dance';
            workshop2.Subject_Group__c = 'Arts';
            workshop2.Workshop__c = 'Workshop Development';
            workshop2.Workshop_Title_ENG__c = 'test2';
            workshop2.Workshop_Title_FR__c = 'test2';
            workshop2.Workshop_Title_SP__c = 'test2';
            insert workshop2;
            
            IB_Workshop_Title_Subject__c workshopSubject = new IB_Workshop_Title_Subject__c();
            workshopSubject.IB_Subject__c = subject.Id;
            workshopSubject.IB_Workshop_Title__c = workshop2.Id;
            insert workshopSubject;
            
            IB_Workshop_Titles__c workshop3 = new IB_Workshop_Titles__c();
            workshop3.Programme__c = 'CP';
            workshop3.Subject__c = 'Dance';
            workshop3.Subject_Group__c = 'Arts';
            workshop3.Workshop__c = 'Workshop Development';
            workshop3.Workshop_Title_ENG__c = 'test3';
            workshop3.Workshop_Title_FR__c = 'test3';
            workshop3.Workshop_Title_SP__c = 'test3';
            insert workshop3;
            
            IB_Data_Translate__c dt = new IB_Data_Translate__c();
            dt.Object_Name__c = 'IB_Role_Repository__c';
            dt.Locale__c = 'es';
            dt.Record_ID__c = 'CP';
            dt.Translate_Value_1__c = 'CP';
            
            IB_Data_Translate__c dt2 = new IB_Data_Translate__c();
            dt2.Object_Name__c = 'IB_Role_Repository__c';
            dt2.Locale__c = 'fr';
            dt2.Record_ID__c = 'CP';
            dt2.Translate_Value_1__c = 'CP';
            
            IB_Data_Translate__c dt3 = new IB_Data_Translate__c();
            dt3.Object_Name__c = 'IB_Programme__c';
            dt3.Locale__c = 'es';
            dt3.Record_ID__c = 'CP';
            dt3.Translate_Value_1__c = 'CP';
            
            IB_Data_Translate__c dt4 = new IB_Data_Translate__c();
            dt4.Object_Name__c = 'IB_Programme__c';
            dt4.Locale__c = 'fr';
            dt4.Record_ID__c = 'CP';
            dt4.Translate_Value_1__c = 'CP';
            
            insert new List<IB_Data_Translate__c> {dt,dt2,dt3,dt4};
                
                Account acc = PimsTestUtil.createAccount('Test Class Account', '');
            acc.IBIS_ID__c = '000001';
            insert acc;
            
            IB_Programme__c programme = PimsTestUtil.createProgrammeForAccount(acc,'PYP');
            insert programme;
            //This Part is being added by Ammara-Plumlogix on 10/16/2019,Increase Code Coverage
            //begin
            RecordType rt1 = RecordTypeDAO.INSTANCE.getRecordTypeByNameAndsObjectType('Language Experience', 'IB_E_Background__c');
            RecordType rt2 = RecordTypeDAO.INSTANCE.getRecordTypeByNameAndsObjectType('Educational Degrees', 'IB_E_Background__c');
            
            IB_E_Background__c bg1 = TestsUtil.createMyProfileObject(u.contactId , rt1.Id);
            bg1.Language__c = 'English';
            bg1.Language_Delivery__c = 'Yes';
            IB_E_Background__c bg2 = TestsUtil.createMyProfileObject(u.contactId, rt1.Id);
            bg2.Language__c = 'Spanish';
            bg1.Language_Delivery__c = 'Yes';
            IB_E_Background__c bg3 = TestsUtil.createMyProfileObject(u.contactId, rt2.Id);
            bg3.Language__c = 'French';
            bg1.Language_Delivery__c = 'Yes';
            insert new List<IB_E_Background__c>{bg1,bg2,bg3};
                
                //End
                IB_Role__c role1 = TestsUtil.createIbRole(repo.Id, u.contactId);            
            role1.Programme_Selection__c = 'CP';
            role1.Subject_Groups__c = 'Other';
            //insert role1;
            
            Role_Application_Subject__c ras = new Role_Application_Subject__c();
            ras.IB_Subject__c = subject.Id;
            ras.Role_And_Application__c = role1.Id;
            //insert ras;
            
            Role_Application_Workshop_Title__c rawt = new Role_Application_Workshop_Title__c();
            rawt.IB_Workshop_Title__c = workshop.Id;
            rawt.Role_And_Application__c = role1.Id;
            //insert rawt;
            
            
            IB_Workshop_Details__c detail = new IB_Workshop_Details__c(
                Name = 'Test Detail',
                IB_Category__c = 'Category 3',
                IB_Workshop_Title__c = workshop.id
            );
            insert detail;
            
            
            System.runAs(u){
                Test.startTest();
                Apexpages.currentPage().getParameters().put('SubParam',subject.Id+'&Dance(PYP)');
                
                
                ApexPages.currentPage().getParameters().put('roleId',role1.IB_Role__c);
                
                IB_Role__c newRole = new IB_Role__c();
                ApexPages.StandardController sc = new ApexPages.StandardController(newRole);
                MyIBRoleApplicationCtrl ra = new MyIBRoleApplicationCtrl(sc);
                
                ra.getReferencesCap();
                ra.getSubjectGroups();
                ra.getSubjects();
                // This part is updated by Arbaz-Plumlogix US-12376 09/09/2021 (DP Authorized School Programme Coordinator )
                // //Start
                List<String> matchAccs = MyIBRoleApplicationCtrl.lookupSchoolAccount('Test',role1.IB_Role__c);
                
                ra.role.Account_ID__c = acc.Id;
                
                List<String> matchAccs2 = MyIBRoleApplicationCtrl.lookupSchoolAccountByNameMulti('Test Class Account:000001',role1.IB_Role__c);
                //End
                ra.getProgrammesForSchool();
                
                ra.role.IB_Programme_New__c = programme.Id;
                
                ra.selectProgramme();
                
                ra.isLoggedIn();
                ra.subjectGroupString = 'Arts (PYP)';
                ra.getSubjects();
                system.debug(loggingLevel.ERROR,'left: ' + ra.subjectOptsLeft);
                String a = ra.roleDescription;
                a = ra.categoryData;
                a = ra.roleData;
                
                a = ra.subjectString;
                a = ra.ibisCode;
                a = ra.schoolAccountId;
                a = ra.schoolName;
                
                IB_E_Background__c eBackground = ra.languageExperience;
                eBackground = ra.educationalDegree;
                
                a = ra.languageExpRecType;
                a = ra.educationalDegRecType;
                
                ra.getStatus();
                
                ra.getRole();
                ra.programmData  = 'Lead';
                MyIBRoleApplicationCtrl.Workshops_Details w_d= new MyIBRoleApplicationCtrl.Workshops_Details(detail,true);
                List<MyIBRoleApplicationCtrl.Workshops_Details> w_d_list = new List<MyIBRoleApplicationCtrl.Workshops_Details>();
                w_d_list.add(w_d);
                ra.Workshops_Details_List = w_d_list;
                ra.inputText1 = 'Test';
                ra.get_workshop_titles();
                ra.get_searchtitle();
                ra.selected_workshops();
                ra.programmData = 'DP';
                String programme2 = ra.selectedprogramme;
                ra.get_workshop_titles();
                ra.get_searchtitle();
                ra.selected_workshops();
                ra.SaveInfo();
                Test.stopTest();
            }
            
            
            
            
        }
        catch(exception e)
        {
            system.debug('excep'+e);
        }
        
        
        
    }
    
    @isTest static void test_method_two_French() {
        
        try
        {
            TestsUtil.initCampaigns();
            List<Account> accs = TestsUtil.getAccounts();
            List<Campaign> camps = TestsUtil.getCampaigns();
            
            IB_Country_Segmentation__c country = TestsUtil.createCountry('test_country_name', 'EUROPE', accs.get(0));
            insert country;
            
            User u = TestsUtil.createPortalUser('TestingPortal');
            u.FirstName = 'test2';
            u.LanguageLocaleKey = 'fr';                
            insert u;
            
            Contact_information__c contact = new Contact_information__c();
            contact.Email__c = 'Test@gmail.com';
            contact.IB_Contact__c = u.ContactId;
            insert contact;
            
            IB_Role_Repository__c repo = TestsUtil.createRoleRepo();
            repo.Role_Level__c = 'Fully Qualified';
            repo.Require_Educational_Degree__c = true;
            repo.Require_Language_Experience__c = true;
            repo.MyIB_Has_Subjects__c = true;
            repo.MyIB_Has_Workshop_Titles__c = true;
            repo.Display_in_MyIB__c = true;
            
            
            IB_Role_Repository__c repo2 = TestsUtil.createRoleRepo();
            repo2.Role_Level__c = 'Fully Qualified';
            repo2.Require_Educational_Degree__c = true;
            repo2.Require_Language_Experience__c = true;
            repo2.MyIB_Has_Subjects__c = true;
            repo2.MyIB_Has_Workshop_Titles__c = true;
            repo2.Custom_Application__c = 'TeacherApp';
            repo2.MyIB_Use_My_School_Subjects__c = true;
            repo2.Role_Name__c = 'Teacher';
            repo2.Display_in_MyIB__c = true;
            repo2.Application_Available_in_MyIB__c = true;
            insert new List<IB_Role_Repository__c> {repo,repo2};
                
                IB_Event_Role__c eventRole = new IB_Event_Role__c(
                    IB_Event__c = camps.get(0).Id,
                    Number_of_Required_Educators__c = 1,
                    IB_Role__c = repo.Id
                );
            insert eventRole;
            
            IB_Subject__c subject = new IB_Subject__c();
            subject.IB_Programme__c = 'CP';
            subject.IB_Programme_Long__c = 'CP';
            subject.Subject_Code__c = 'cp';
            subject.Subject_Group__c = 'Arts (PYP)';
            subject.Subject_Group_Identifier__c = 'artsm';
            subject.Subject_Name__c = 'Dance';
            subject.Subject_Name_FR__c = 'Dance';
            subject.Subject_Name_SP__c = 'Dance';
            subject.Available_in_IBEN__c = true;
            subject.Available_in_MySchool__c = true;
            insert subject;
            
            IB_Subject__c subject2 = new IB_Subject__c();
            subject2.IB_Programme__c = 'CP';
            subject2.IB_Programme_Long__c = 'CP';
            subject2.Subject_Code__c = 'cp';
            subject2.Subject_Group__c = 'Arts (PYP)';
            subject2.Subject_Group_Identifier__c = 'artsm';
            subject2.Subject_Name__c = 'Design';
            subject2.Subject_Name_FR__c = 'Design';
            subject2.Subject_Name_SP__c = 'Design';
            subject2.Available_in_IBEN__c = true;
            subject2.Available_in_MySchool__c = true;
            insert subject2;
            
            IB_Subject__c subject3 = new IB_Subject__c();
            subject3.IB_Programme__c = 'CP';
            subject3.IB_Programme_Long__c = 'CP';
            subject3.Subject_Code__c = 'cp';
            subject3.Subject_Group__c = 'Arts (CP)';
            subject3.Subject_Group_Identifier__c = 'artsm';
            subject3.Subject_Name__c = 'Paint';
            subject3.Subject_Name_FR__c = 'Paint';
            subject3.Subject_Name_SP__c = 'Paint';
            subject3.Available_in_IBEN__c = true;
            subject3.Available_in_MySchool__c = true;
            insert subject3;
            
            IB_Workshop_Titles__c workshop = new IB_Workshop_Titles__c();
            workshop.Programme__c = 'DP';
            workshop.Subject__c = 'Dance';
            workshop.Subject_Group__c = 'Arts';
            workshop.Workshop__c = 'Workshop Development';
            workshop.Workshop_Title_ENG__c = 'test';
            workshop.Workshop_Title_FR__c = 'test';
            workshop.Workshop_Title_SP__c = 'test';
            insert workshop;
            
            IB_Workshop_Titles__c workshop2 = new IB_Workshop_Titles__c();
            workshop2.Programme__c = 'CP';
            workshop2.Subject__c = 'Dance';
            workshop2.Subject_Group__c = 'Arts';
            workshop2.Workshop__c = 'Workshop Development';
            workshop2.Workshop_Title_ENG__c = 'test2';
            workshop2.Workshop_Title_FR__c = 'test2';
            workshop2.Workshop_Title_SP__c = 'test2';
            insert workshop2;
            
            IB_Workshop_Title_Subject__c workshopSubject = new IB_Workshop_Title_Subject__c();
            workshopSubject.IB_Subject__c = subject.Id;
            workshopSubject.IB_Workshop_Title__c = workshop2.Id;
            insert workshopSubject;
            
            IB_Workshop_Titles__c workshop3 = new IB_Workshop_Titles__c();
            workshop3.Programme__c = 'CP';
            workshop3.Subject__c = 'Dance';
            workshop3.Subject_Group__c = 'Arts';
            workshop3.Workshop__c = 'Workshop Development';
            workshop3.Workshop_Title_ENG__c = 'test3';
            workshop3.Workshop_Title_FR__c = 'test3';
            workshop3.Workshop_Title_SP__c = 'test3';
            insert workshop3;
            
            IB_Data_Translate__c dt = new IB_Data_Translate__c();
            dt.Object_Name__c = 'IB_Role_Repository__c';
            dt.Locale__c = 'es';
            dt.Record_ID__c = 'CP';
            dt.Translate_Value_1__c = 'CP';
            
            IB_Data_Translate__c dt2 = new IB_Data_Translate__c();
            dt2.Object_Name__c = 'IB_Role_Repository__c';
            dt2.Locale__c = 'fr';
            dt2.Record_ID__c = 'CP';
            dt2.Translate_Value_1__c = 'CP';
            
            IB_Data_Translate__c dt3 = new IB_Data_Translate__c();
            dt3.Object_Name__c = 'IB_Programme__c';
            dt3.Locale__c = 'es';
            dt3.Record_ID__c = 'CP';
            dt3.Translate_Value_1__c = 'CP';
            
            IB_Data_Translate__c dt4 = new IB_Data_Translate__c();
            dt4.Object_Name__c = 'IB_Programme__c';
            dt4.Locale__c = 'fr';
            dt4.Record_ID__c = 'CP';
            dt4.Translate_Value_1__c = 'CP';
            
            insert new List<IB_Data_Translate__c> {dt,dt2,dt3,dt4};
                
                Account acc = PimsTestUtil.createAccount('Test Class Account', '');
            acc.IBIS_ID__c = '000001';
            insert acc;
            
            IB_Programme__c programme = PimsTestUtil.createProgrammeForAccount(acc,'PYP');
            insert programme;
            //This Part is being added by Ammara-Plumlogix on 10/16/2019,Increase Code Coverage
            //begin
            RecordType rt1 = RecordTypeDAO.INSTANCE.getRecordTypeByNameAndsObjectType('Language Experience', 'IB_E_Background__c');
            RecordType rt2 = RecordTypeDAO.INSTANCE.getRecordTypeByNameAndsObjectType('Educational Degrees', 'IB_E_Background__c');
            
            IB_E_Background__c bg1 = TestsUtil.createMyProfileObject(u.contactId , rt1.Id);
            bg1.Language__c = 'English';
            bg1.Language_Delivery__c = 'Yes';
            IB_E_Background__c bg2 = TestsUtil.createMyProfileObject(u.contactId, rt1.Id);
            bg2.Language__c = 'Spanish';
            bg1.Language_Delivery__c = 'Yes';
            IB_E_Background__c bg3 = TestsUtil.createMyProfileObject(u.contactId, rt2.Id);
            bg3.Language__c = 'French';
            bg1.Language_Delivery__c = 'Yes';
            insert new List<IB_E_Background__c>{bg1,bg2,bg3};
                
                //End
                IB_Role__c role1 = TestsUtil.createIbRole(repo.Id, u.contactId);            
            role1.Programme_Selection__c = 'CP';
            role1.Subject_Groups__c = 'Other';
            //insert role1;
            
            Role_Application_Subject__c ras = new Role_Application_Subject__c();
            ras.IB_Subject__c = subject.Id;
            ras.Role_And_Application__c = role1.Id;
            //insert ras;
            
            Role_Application_Workshop_Title__c rawt = new Role_Application_Workshop_Title__c();
            rawt.IB_Workshop_Title__c = workshop.Id;
            rawt.Role_And_Application__c = role1.Id;
            //insert rawt;
            
            
            IB_Workshop_Details__c detail = new IB_Workshop_Details__c(
                Name = 'Test Detail',
                IB_Category__c = 'Category 3',
                IB_Workshop_Title__c = workshop.id
            );
            insert detail;
            
            
            System.runAs(u){
                Test.startTest();
                Apexpages.currentPage().getParameters().put('SubParam',subject.Id+'&Dance(PYP)');
                
                
                ApexPages.currentPage().getParameters().put('roleId',role1.IB_Role__c);
                
                IB_Role__c newRole = new IB_Role__c();
                ApexPages.StandardController sc = new ApexPages.StandardController(newRole);
                MyIBRoleApplicationCtrl ra = new MyIBRoleApplicationCtrl(sc);
                
                ra.getReferencesCap();
                ra.getSubjectGroups();
                ra.getSubjects();
                // This part is updated by Arbaz-Plumlogix US-12376 09/09/2021 (DP Authorized School Programme Coordinator )
                // Start
                List<String> matchAccs = MyIBRoleApplicationCtrl.lookupSchoolAccount('Test',role1.IB_Role__c);
                
                ra.role.Account_ID__c = acc.Id;
                
                List<String> matchAccs2 = MyIBRoleApplicationCtrl.lookupSchoolAccountByNameMulti('Test Class Account:000001',role1.IB_Role__c);
                //End                
                ra.getProgrammesForSchool();
                
                ra.role.IB_Programme_New__c = programme.Id;
                
                ra.selectProgramme();
                
                ra.isLoggedIn();
                ra.subjectGroupString = 'Arts (PYP)';
                ra.getSubjects();
                system.debug(loggingLevel.ERROR,'left: ' + ra.subjectOptsLeft);
                String a = ra.roleDescription;
                a = ra.categoryData;
                a = ra.roleData;
                
                a = ra.subjectString;
                a = ra.ibisCode;
                a = ra.schoolAccountId;
                a = ra.schoolName;
                
                IB_E_Background__c eBackground = ra.languageExperience;
                eBackground = ra.educationalDegree;
                
                a = ra.languageExpRecType;
                a = ra.educationalDegRecType;
                
                ra.getStatus();
                
                ra.getRole();
                ra.programmData  = 'Lead';
                MyIBRoleApplicationCtrl.Workshops_Details w_d= new MyIBRoleApplicationCtrl.Workshops_Details(detail,true);
                List<MyIBRoleApplicationCtrl.Workshops_Details> w_d_list = new List<MyIBRoleApplicationCtrl.Workshops_Details>();
                w_d_list.add(w_d);
                
                ra.Workshops_Details_List = w_d_list;
                ra.get_searchtitle();
                ra.inputText1 = 'Test';
                ra.get_workshop_titles();
                ra.all_workshop();
                ra.get_searchtitle();
                ra.selected_workshops();
                ra.categoryData = 'Category 3';
                ra.category_filter_workshop();
                ra.programmData = 'PYP';
                String programme2 = ra.selectedprogramme;
                ra.get_workshop_titles();
                ra.get_searchtitle();
                ra.selected_workshops();
                ra.SaveInfo();
                Test.stopTest();
            }
            
            //RoleRepositoryService.getAllRoles();
            
            
            
        }
        catch(exception e)
        {
            system.debug('excep'+e);
        }
        
        
        
    }
}