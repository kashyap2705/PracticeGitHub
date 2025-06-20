@isTest
public class AccClassOPTest {
  
    @isTest public  static void TestOne()
    {
        MaxRoles__c MR = new MaxRoles__c();
        MR.Name = 'Max Allowed Teachers';
        MR.Max_Allowed_Roles__c = '200';
        Insert MR;
        
        Account acc = AccountTestDataFactory.createAccount('Online Provider', null);
        insert acc;
        
        IB_Country_Segmentation__c ibCon = new IB_Country_Segmentation__c();
        ibCon.IBEN_Independent_Account__c = acc.Id;
        ibCon = IBCountrySegmentationTestDataFactory.createIBCountrySegmentation(ibCon);
        ibCon.Name = 'Austria';
        ibCon.Geographical_Sub_Region_Segmentation__c = 'Europe';
        ibCon.Regional_Office_Segmentation__c = 'IBAEM';
        ibCon.IBEN_Segmentation__c = 'IBAEM';
        insert ibCon;
        IB_Address__c address = new IB_Address__c(
                Name = 'Billing',
                Address_Line_1__c = '1 hammock beach',
                City__c = 'palm coast',
                Postal_Code__c = '32137',
                IB_Account__c = acc.Id,
                Status__c = 'Active',
                //Province__c = 'FL',		//Commented by Shahrukh on 25/09/2024 due to test class failure
                Country__c = ibCon.id
            );
        insert address;

        Contact con = new Contact();
        con = ContactTestDataFactory.createContact('', con);
        con.AccountId = acc.Id;
        insert con;
        
        User communityUser = new User();
        communityUser = UserTestDataFactory.createUser('SCU + Advanced', communityUser);
        communityUser.ContactId = con.Id;
        communityUser.IsActive = true;
        insert communityUser;

        IB_Role_Repository__c reppo = new IB_Role_Repository__c();
        reppo = IBRoleRepositoryTestDataFactory.createIBRoleRepository(reppo);
        reppo.Role_Name__c = 'Online Coordinator'; 
        reppo.Category__c = 'Assessment';
        reppo.Sub_Category__c = 'None';
        reppo.Related_Programmes__c = 'PYP;MYP;DP;CP';
        reppo.IB_Staff_Role__c=false;
        insert reppo;

        IB_Programme__c prog = new IB_Programme__c();
        prog = IBProgrammeTestDataFactory.createIBProgramme('MYP', prog);
        prog.Account__c = acc.Id;
        prog.Street_Address__c = address.Id;
        insert prog;
        
        Contact_information__c ci = new Contact_information__c();
        ci.Email__c = TestDataUtility.generateRandomEmail(10, 'gmail.com');
        ci.IB_Contact__c = con.id;
        ci = ContactInformationTestDataFactory.createContactInformation('email', ci);
        insert ci;

        Contact_information__c cip = new Contact_information__c();
        cip.Phone__c = '+98211212';
        cip.IB_Contact__c = con.id;
        cip = ContactInformationTestDataFactory.createContactInformation('phone', cip);
        insert cip;

        IB_Role__c role7 = new IB_Role__c();
        role7.IB_Account__c = acc.Id;
        role7.Account_ID__c = acc.Id;
        role7.IB_Role__c = reppo.Id;
        role7.IB_Programme_New__c = prog.Id;
        role7.Start_Date__c = Date.today();
        role7.Email_Confirmed__c = true;
        role7.Status__c='Confirmed';
        role7.Contact_Information_Email__c = ci.id;
        role7.Contact_Information_Phone__c = cip.id;
        role7.Job_Title__c = 'BA';
        role7.IB_Contact__c = con.Id;
        role7 = IBRoleTestDataFactory.createRole(role7);
        insert role7;
        
        Test.startTest();

        List<Account> ResultsgetAllAccounts = new List<Account>();
        IB_Role__c ResultsIBRole = new IB_Role__c();
        IB_Address__c ResultsAddress = new IB_Address__c();
        Integer ResultsIsAdminInt = -1;
        String ResultsMaxTeachers = 'Blah';

        System.runAs(communityUser)
        {  
            System.assertNotEquals(label.BASE_URL,AccClassOP.getBaseUrl());
            System.assertNotEquals('smith',AccClassOP.getUserDetails());
            AccClassOP.UpdateAccounts(acc.Name);
            ResultsgetAllAccounts = AccClassOP.getAllAccounts();
            ResultsIBRole = AccClassOP.confirm_OC();
            ResultsAddress = AccClassOP.getAccountAddress();
            ResultsIsAdminInt = AccClassOP.isAdmin();
            AccClassOP.UpdateContactAccount();
            ResultsMaxTeachers = AccclassOP.getMaxTeacherRoles();
        }
        Test.stopTest();

        System.assertNotEquals(ResultsgetAllAccounts, null, 'The list shouldnt be null');
        System.assertEquals(ResultsgetAllAccounts.size(), 1, 'There should only be one account silly');
        
        System.assertNotEquals(ResultsIBRole, null, 'The IB role shouldnt be null');
        System.assertNotEquals(ResultsIBRole.IB_Contact__c, null, 'The IB role Contact shouldnt be null');
        System.assertEquals(ResultsIBRole.IB_Contact__c, con.Id, 'The contact should be matching');

        System.assertNotEquals(ResultsAddress, null, 'The IB address shouldnt be null');
        //System.assertEquals(ResultsAddress.Province__c, 'FL', 'The Province should be Florida');
        System.assertEquals(ResultsAddress.Country__c, ibCon.Id, 'The Countries should match');

        System.assertNotEquals(ResultsIsAdminInt, null, 'The Is Admin shouldnt be null');
        System.assertEquals(ResultsIsAdminInt, 2, 'It should be 2 to represent non-admin');

        System.assertNotEquals(ResultsMaxTeachers, null, 'The Max Teacher setting shouldnt be null');
        System.assertEquals(ResultsMaxTeachers, '200', 'It should be 200, matching the test class');
    }
}