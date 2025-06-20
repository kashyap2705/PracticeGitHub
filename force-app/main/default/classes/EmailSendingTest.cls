/*******************************************************************************************
* @Name��   EmailSendingTest 
* @Author���Ammara Alvi����
* @Date�����12/27/2018����
* @Group��������
* @Description��This class is test class for EmailSending
*******************************************************************************************/
/* MODIFICATION LOG
* Version��������� Developer��������� Date�������������� Description
*-------------------------------------------------------------------------------------------
*� 1.0������������� Ranjith Kondabathini����� 05/16/2023�������� Added logger framework to publish error messages
*******************************************************************************************/
@isTest
public class EmailSendingTest {
    public static Campaign camp1;
    public static IB_Programme__c prg;
    public static My_Staffing_Event__c staffingEvent;

   @testSetup
  static void setTestData() {
    
    Account tempAccount = AccountTestDataFactory.createAccount(null, null);
    insert tempAccount;

    List<Contact> contacts = ContactTestDataFactory.createContacts(null, null, 2);
    for (Contact contact : contacts) {
        contact.AccountId = tempAccount.Id; 
    }
    insert contacts;
    
    Contact headOfSchool = contacts[0]; 
    Contact programmeCoordinator = contacts[1]; 

    IB_Programme__c templateIBProgramme = new IB_Programme__c(
        Account__c = tempAccount.Id,
        Contact_Head_of_School__c = headOfSchool.Id, 
        Contact_Programme_Coordinator__c = programmeCoordinator.Id, 
        StageName__c = 'Consultation process', 
        Status__c = 'Candidate', 
        Introduction_Letter_Sent__c = false,
        Programme_in_candidacy__c = true 
    );
    prg = IBProgrammeTestDataFactory.createIBProgramme(null, templateIBProgramme);
    insert prg;

    
    Campaign templateCampaign = new Campaign(
        Related_IB_Programme__c = prg.Id, 
        Status = 'Staffed', 
        Sub_Type__c = 'Candidacy Consultation' 
    );
    camp1 = CampaignTestDataFactory.createCampaign(null, templateCampaign);
    insert camp1;

   
    staffingEvent = new My_Staffing_Event__c(
        IB_Event__c = camp1.Id, 
        Application_Status__c = 'Confirmed', 
        IB_Contact__c = headOfSchool.Id 
    );
    insert staffingEvent;
}

    @isTest
    static void testIbEventEmailAutomation() {
        camp1 = [SELECT Id FROM Campaign LIMIT 1];
    
        Test.startTest();
        EmailSending.ibevent_email_automation(camp1.Id); 
        Test.stopTest();
        
        prg= [Select id from IB_Programme__c Limit 1 ];
        IB_Programme__c updatedProgramme = [SELECT Introduction_Letter_Sent__c FROM IB_Programme__c WHERE Id = :prg.Id];
        System.assertEquals(true, updatedProgramme.Introduction_Letter_Sent__c, 'Introduction Letter flag should be updated to true.');
    }

    @isTest
    static void testAttachmentLetter() {
        prg = [SELECT Id FROM IB_Programme__c LIMIT 1];
        camp1 = [SELECT Id FROM Campaign LIMIT 1];
        staffingEvent = [Select id from My_Staffing_Event__c Limit 1 ];
        Test.startTest();
        EmailSending.attachmentLetter(prg.Id, staffingEvent.Id); 
        Test.stopTest();
        
        prg = [SELECT Id FROM IB_Programme__c LIMIT 1];
        List<Attachment> attachments = [SELECT Name FROM Attachment WHERE ParentId = :prg.Id];
        System.assert(attachments.size() > 0, 'Attachments should exist for the IB Programme.');
        System.assertEquals('Welcome Letter.pdf', attachments[0].Name, 'Attachment name should be "Introduction Letter.pdf".');
    }

    @isTest
    static void testSendEmailNotification() {
        Test.startTest();
        EmailSending.send_email_notification(prg, staffingEvent);
        Test.stopTest();
        System.assert(true, 'Email notification should finish successfully.');
    }
}