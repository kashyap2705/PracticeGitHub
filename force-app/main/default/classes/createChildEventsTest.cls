@isTest
public class createChildEventsTest {
    @isTest static void testCreateRemoteConsultation() {
        try{
            recordtype rt = [select id, name from recordtype where sobjectType = 'campaign' and name = 'Authorization'];
            Account acc = PimsTestUtil.createAccount('Test Account', 'Association Account' );
            insert acc;
            Account theAccount = PimsTestUtil.createAccount('ThatThereSchool','School Account');
            theAccount.Lead_Account__c = true;
            insert theAccount;
            Contact theContact = PimsTestUtil.createContact('Robert Strunk','RS@rs.com','rs@profEmail.com', Date.newInstance(1984, 09, 14), theAccount);
            insert theContact;
            Campaign camp = new Campaign(Name = 'Candidacy Remote Consultation ' + acc.Name,
                                         Event_Organizer_Account__c = acc.id,
                                         Type = 'Authorization',
                                         Sub_Type__c = 'Candidacy Consultation',
                                         IB_Docs_ID__c = 'Test',
                                         Status = 'Staffed',
                                         StartDate = system.today() - 100,
                                         EndDate = system.today() + 100,
                                         Staffing_Event_Published__c = false,
                                         Event_Organizer_Region__c = 'IBAEM',
                                         Required_Number_of_Educators__c = 3,
                                         Venue_Account__c = acc.id,
                                         RecordTypeId = rt.id);
            insert camp;
            My_Staffing_Event__c assmt = new My_Staffing_Event__c(IB_Event__c = camp.id, 
                                                                  IB_Contact__c = theContact.id, Role_Level__c = 'Fully Qualified',
                                                                  Application_Status__c = 'Confirmed');
            
            insert assmt;
            
            createChildEvents.eventIdMethodName param = new createChildEvents.eventIdMethodName();
            param.eventId = camp.Id;
            param.methodName = 'createRemoteConsultation'; 
            
            List<createChildEvents.eventIdMethodName> params = new List<createChildEvents.eventIdMethodName>();
            params.add(param);
            
            List<String> results = createChildEvents.createRemoteConsultationInvocable(params);
            
            createChildEvents.createRemoteConsultation(camp.id);
            
        }
        catch(exception e)
        {
            System.debug('Excep'+e);
        }
    }
    @isTest static void testCreateConsultationVisit() {
        recordtype rt = [select id, name from recordtype where sobjectType = 'campaign' and name = 'Authorization'];
        Account acc = PimsTestUtil.createAccount('Test Account', 'Association Account' );
        insert acc;
        Account theAccount = PimsTestUtil.createAccount('ThatThereSchool','School Account');
        theAccount.Lead_Account__c = true;
        insert theAccount;
        Contact theContact = PimsTestUtil.createContact('Robert Strunk','RS@rs.com','rs@profEmail.com', Date.newInstance(1984, 09, 14), theAccount);
        insert theContact;
        Campaign camp = new Campaign(Name = 'Candidacy Consultation Visit ' + acc.Name,
                                     Event_Organizer_Account__c = acc.id,
                                     Type = 'Authorization',
                                     Sub_Type__c = 'Candidacy Consultation',
                                     IB_Docs_ID__c = 'Test',
                                     Status = 'Staffed',
                                     StartDate = system.today() - 100,
                                     EndDate = system.today() + 100,
                                     Staffing_Event_Published__c = false,
                                     Event_Organizer_Region__c = 'IBAEM',
                                     Required_Number_of_Educators__c = 3,
                                     Venue_Account__c = acc.id,
                                     RecordTypeId = rt.id);
        insert camp;
        My_Staffing_Event__c assmt = new My_Staffing_Event__c(IB_Event__c = camp.id, 
                                                              IB_Contact__c = theContact.id, Role_Level__c = 'Fully Qualified',
                                                              Application_Status__c = 'Confirmed');
        
        insert assmt;
        
        createChildEvents.eventIdMethodName param = new createChildEvents.eventIdMethodName();
        param.eventId = camp.Id;
        param.methodName = 'createConsultationVisit'; 
        
        List<createChildEvents.eventIdMethodName> params = new List<createChildEvents.eventIdMethodName>();
        params.add(param);
        
        List<String> results = createChildEvents.createRemoteConsultationInvocable(params);
        
        createChildEvents.createConsultationVisit(camp.id);
    }
    @isTest static void testCreateRemoteConsultationError() {
        recordtype rt = [select id, name from recordtype where sobjectType = 'campaign' and name = 'Authorization'];
        Account acc = PimsTestUtil.createAccount('Test Account', 'Association Account');
        insert acc;
        Campaign camp = new Campaign(Name = 'Test ' + acc.Name,
                                     Event_Organizer_Account__c = acc.id,
                                     Type = 'Authorization',
                                     Sub_Type__c = 'Verification Visit',
                                     IB_Docs_ID__c = 'Test',
                                     Status = 'Staffed',
                                     StartDate = system.today() - 100,
                                     EndDate = system.today() + 100,
                                     Staffing_Event_Published__c = false,
                                     Event_Organizer_Region__c = 'IBAEM',
                                     Required_Number_of_Educators__c = 3,
                                     Venue_Account__c = acc.id);
        insert camp;
        system.debug('Camp Name: ' + camp.Name);
        string campId = createChildEvents.createRemoteConsultation(camp.id);
        system.debug('Camp Id: ' + campId);
    }
}