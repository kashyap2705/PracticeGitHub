@isTest(SeeAllData=true)
public class ContactFactoryTest {
    public static List<Contact> createContacts(Integer Count, Boolean isInsert ,Account acc){
        List<Contact> conList = new List<Contact>();
        for(Integer i=0; i<count; i++){
            Contact contactRecords = new Contact(Salutation = 'Mr.',
                                      LastName = 'Messi'+i,
                                      MobilePhone = '+30992907711',
                                      HomePhone = '+30992907711',
                                      //OtherPhone = '+30992907711',
                                      Email = 'TestEmail'+i+'@gmail.com',
                                      Birthdate = Date.today().addYears(-20),
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
                                      Country_of_Birth__c = 'Armenia',
                                     Phone_Number__c ='2345674567',
                                      Country_Code__c = 'Afghanistan (+93)');
            conList.add(contactRecords);
            
        }
        if(isInsert)
            insert conList;
        return conList;
    }
}