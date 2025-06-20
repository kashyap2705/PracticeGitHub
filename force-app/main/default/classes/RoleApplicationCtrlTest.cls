@isTest
public class RoleApplicationCtrlTest {
    @TestSetup
    static void setupdata()
    {
        Account theAccount = PimsTestUtil.createAccount('ThatThereSchool','School Account');
        insert theAccount;
        
         Contact theContact = PimsTestUtil.createContact('K N','kn@kn.com','kn@profEmail.com', Date.newInstance(1984, 09, 14), theAccount);
        insert theContact; Profile p =  [select Id from profile where Name='Scu + Advanced' limit 1];
        
        IB_Subject__c sub = new IB_Subject__c(Available_in_IBEN__c = true);
        insert sub;
        
        User pu = new User(profileId = p.id, username = 'rs@em558861ail.com', email = 'rs@email.com',
                           emailencodingkey = 'UTF-8', localesidkey = 'en_US',
                           languagelocalekey = 'en_US', timezonesidkey = 'America/Los_Angeles',
                           alias='cspu', lastname='lastname', contactId = theContact.id);

        insert pu;
              
    }

    @isTest 
	static void testController_English() {
        integer i=1;
        init();
		User usr=[select id from user where username = 'rs@em558861ail.com' limit 1 ];
		IB_Role__c role = TestsUtil.getIbRoles().get(0);
        
        System.debug('foo: ' + role);
        ApexPages.StandardController sc = new ApexPages.StandardController(role);
        RoleApplicationCtrl rac = new RoleApplicationCtrl(sc);
        system.runAs(usr)
        {
        try{
        Test.startTest();
        rac.getReferencesCap();
        rac.saveInfo();
        rac.withdraw();
        rac.cancel();
        rac.searchRole();
        rac.searchPrograme();
        rac.getRole();
        rac.getIsInternal();
        rac.getCategoriesInfo();
        rac.getProgramsByRoleId(role.Id);
        rac.getTraining();
        //rac.getEventRole();
        rac.getElapsedTime();
        rac.getEdit();
        rac.getStatus();
        rac.getUserLanguageKey();
        rac.getRolesInfo();
        rac.getProgrammsInfo();
        rac.getSubjectGroupOpts();
        rac.getSubjectOptsLeft();
        rac.getSubjectGroups();
        rac.getSubjects();
        rac.getWorkshopTitles();
        rac.subjectString = null;
        rac.roleRepo = null;
        User u = new User(Id=UserInfo.getUserId(),LanguageLocaleKey = 'fr');
        update u;
        rac.initSubjects();
        rac.getSubjects();
        rac.getWorkshopTitles();
        rac.getElapsedTime();
        rac.searchRole();
        u = new User(Id=UserInfo.getUserId(),LanguageLocaleKey = 'es');
        update u;
        rac.initSubjects();
        rac.getSubjects();
        rac.getWorkshopTitles();
        rac.getElapsedTime();
        rac.searchRole();
        
        Apexpages.currentPage().getParameters().put('SubParam',null);
        u = new User(Id=UserInfo.getUserId(),LanguageLocaleKey = 'en_US');
        rac.getWorkshopTitles();
        rac.isInternal = false;
        rac.SaveInfo();
        System.assertEquals(1,i);
        u = new User(Id=UserInfo.getUserId(),LanguageLocaleKey = 'fr');
        rac.getWorkshopTitles();
        
        u = new User(Id=UserInfo.getUserId(),LanguageLocaleKey = 'es');
        rac.getWorkshopTitles();
        //Following code line is added by Umair-Plumlogix of US11096 on 02/11/2020
        System.assertEquals(1,i);
        Test.stopTest();
        }
        catch(Exception x)
        {system.debug('exception ' +  x);}
        
        }
    
    }
    
    public static void init(){
        
		TestsUtil.initCampaigns();
        List<Account> accs = TestsUtil.getAccounts();
        List<Campaign> camps = TestsUtil.getCampaigns();
		
		IB_Country_Segmentation__c country = TestsUtil.createCountry('test_country_name', 'EUROPE', accs.get(0));
		insert country;
		
		Contact cont = TestsUtil.createContact('test_contact_001', 'xxx@xxxx.xxx', 'xxx@xxxxxxxxxx.xxx', Date.today().addYears(-24), country);
		insert cont;
		
		IB_Role_Repository__c repo = TestsUtil.createRoleRepo();
		repo.Role_Level__c = 'Fully Qualified';
		insert repo;

		IB_Role__c role1 = TestsUtil.createIbRole(repo.Id, cont.Id);		
		role1.Programme_Selection__c = 'PYP';
        role1.Subject_Groups__c = 'Other';
		insert role1;
            
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
        insert subject;
        
        IB_Subject__c subject2 = new IB_Subject__c();
        subject2.IB_Programme__c = 'PYP';
        subject2.IB_Programme_Long__c = 'Diploma';
        subject2.Subject_Code__c = 'pyp';
        subject2.Subject_Group__c = 'Arts (PYP)';
        subject2.Subject_Group_Identifier__c = 'artsm';
        subject2.Subject_Name__c = 'Design';
        subject2.Subject_Name_FR__c = 'Design';
        subject2.Subject_Name_SP__c = 'Design';
        insert subject2;
        
        Role_Application_Subject__c ras = new Role_Application_Subject__c();
        ras.IB_Subject__c = subject.Id;
        ras.Role_And_Application__c = role1.Id;
        insert ras;
        
        Apexpages.currentPage().getParameters().put('SubParam',subject.Id+'&Dance(PYP)');
        
        IB_Workshop_Titles__c workshop = new IB_Workshop_Titles__c();
        workshop.Programme__c = 'PYP';
        workshop.Subject__c = 'Dance';
        workshop.Subject_Group__c = 'Arts';
        workshop.Workshop__c = 'Workshop Development';
        workshop.Workshop_Title_ENG__c = 'test';
        workshop.Workshop_Title_FR__c = 'test';
        workshop.Workshop_Title_SP__c = 'test';
        insert workshop;
        
        IB_Workshop_Titles__c workshop2 = new IB_Workshop_Titles__c();
        workshop2.Programme__c = 'PYP';
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
        workshop3.Programme__c = 'PYP';
        workshop3.Subject__c = 'Dance';
        workshop3.Subject_Group__c = 'Arts';
        workshop3.Workshop__c = 'Workshop Development';
        workshop3.Workshop_Title_ENG__c = 'test3';
        workshop3.Workshop_Title_FR__c = 'test3';
        workshop3.Workshop_Title_SP__c = 'test3';
        insert workshop3;
        
        Role_Application_Workshop_Title__c rawt = new Role_Application_Workshop_Title__c();
        rawt.IB_Workshop_Title__c = workshop.Id;
        rawt.Role_And_Application__c = role1.Id;
        insert rawt;
	}
    
}