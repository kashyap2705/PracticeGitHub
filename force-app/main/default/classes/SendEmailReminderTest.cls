@isTest
public class SendEmailReminderTest {
    
    private static void setupTestData(String language) {
        
        Account accOne = new Account();
        Account acc = AccountTestDataFactory.createAccount('School Account',accOne);
        insert acc;
        
        Contact conNew = new Contact(FirstName = 'Test',
                                     LastName = 'Contact',
                                     Email = 'test@example.com',
                                     AccountId = acc.Id);
        Contact con = ContactTestDataFactory.createContact(null,conNew);
        insert con;
        
        IB_Country_Segmentation__c ibCon = new IB_Country_Segmentation__c();
        ibCon.IBEN_Independent_Account__c = acc.Id;
        ibCon = IBCountrySegmentationTestDataFactory.createIBCountrySegmentation(ibCon);
        ibCon.Name = 'Austria';
        ibCon.Geographical_Sub_Region_Segmentation__c = 'Europe';
        ibCon.Regional_Office_Segmentation__c = 'IBAEM';
        ibCon.IBEN_Segmentation__c = 'IBAEM';
        insert ibCon;

        IB_Address__c addressOne = new IB_Address__c();
        addressOne.IB_Account__c = acc.Id;
        addressOne.Country__c = ibCon.Id;
        IB_Address__c address = IBAddressTestDataFactory.createIBAddress(addressOne);
        insert address;
        
        IB_Programme__c progOne = new IB_Programme__c(
            Name = 'Test Programme',
            Language_Of_Correspondence__c = language,
            Account__c = acc.Id,
            IBCC_Implementation_Phase__c = 'Phase 1',
            Street_Address__c = address.Id,
            Status__c = 'Interested',
            Date_Decision_on_Authorization__c = date.today()
        );
        IB_Programme__c prog = IBProgrammeTestDataFactory.createIBProgramme(null,progOne);
        insert prog;
        
        Date endDate = date.today() + 10;
        
        Campaign camp = new Campaign(
            Name = 'Candidacy Remote Consultation',
            Status = 'Staffing in Progress',
            Reminder_date__c = System.today(),
            Related_IB_Programme__c = prog.Id,
            EndDate = endDate
        );
        insert camp;
        
        Staffing_Event__c staffEvent= new Staffing_Event__c();
        staffEvent.IB_Event__c=camp.Id;
        staffEvent.Name='Evaluation Visit';
        insert staffEvent;
        
        My_Staffing_Event__c myEvent = new My_Staffing_Event__c(
            Application_Status__c = 'Confirmed',
            IB_Contact__c = con.Id,
            IB_Event__c = camp.Id,
            Staffing_Event__c = staffEvent.Id
        );
        insert myEvent;
        
        camp.Status = 'Staffed';
        update camp;
    }

    @isTest
    static void testScheduling() {
        setupTestData('English');
        
        Test.startTest();
        SendEmailReminder sh1 = new SendEmailReminder();
        String sch = '0 0 23 * * ?';
        System.schedule('Test Email Reminder', sch, sh1);
        Test.stopTest();
        
        CronTrigger ct = [SELECT Id, CronJobDetail.Name FROM CronTrigger WHERE CronJobDetail.Name = 'Test Email Reminder'];
        System.assertEquals('Test Email Reminder', ct.CronJobDetail.Name, 'Job should be scheduled');
    }
}