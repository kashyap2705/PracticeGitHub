@isTest
public class LeadFactoryTest {
    public static List<Lead> createLeads(Integer Count, Boolean isInsert ,Account acc){
        List<Lead> allLeadRecord = new List<Lead>();
        for(Integer i=0; i<count; i++){
            Lead leadRecord = new Lead(FirstName = 'testing'+i,
                                       LastName = 'Firsttest'+i,
                                       Email = 'a@a'+i+'.com',
                                       Phone = '+923457123',
                                       //OtherPhone = '+30992907711',
                                       Company = 'Test',
                                       Existing_Account_Related__c = acc.id,
                                       Lead_Type__c = 'New',
                                       IB_Programme_Interest__c = 'MYP',
                                       Rating = 'Warm',
                                       Position_with_School__c = 'Teacher',
                                       CountryCode = 'US',
                                       LeadSource = 'Direct',
                                       StateCode = 'USFL',
                                       Country__c = 'UNITED STATES',
                                       Region__c = 'IBA',
                                       Sub_Region__c = 'NORTHERN AMERICA');
                
                allLeadRecord.add(leadRecord);
            
        }
        if(isInsert)
            insert allLeadRecord;
        return allLeadRecord;
    }
    
}