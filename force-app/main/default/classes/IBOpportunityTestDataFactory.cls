/**
 * Test data factory for IB Opportunity object
 * @author: Satyanarayana Gajavalli
 * @since : 04-30-2025
 * @Modification Log:
 * Date            Created/Modified    Ticket           Description    
 * 04-30-2025      Created             US-0002555       Created the class
 */
@isTest
public without sharing class IBOpportunityTestDataFactory {
    
    private final static String DEFAULT_STAGE = 'Evaluation';
    private final static String DEFAULT_CURRENCY = 'EUR';
    private final static String DEFAULT_TYPE = 'New Business';
    private final static String DEFAULT_LEAD_SOURCE = 'Web';

    // Static cache for Record Type IDs
    private static Map<String, String> recordTypeIdCache = new Map<String, String>();

    public static List<Opportunity> createOpportunities(String recordTypeName, Opportunity tempOpp, Integer nOpps) {
        Id recordTypeId = String.isNotBlank(recordTypeName) ? getRecordTypeId(recordTypeName) : null;
        List<Opportunity> opportunities = new List<Opportunity>();
        for (Integer i = 0; i < nOpps; i++) {
            Opportunity opp = (tempOpp != null) ? tempOpp.clone(false) : new Opportunity();
            opp = createOpportunityInstance(opp, recordTypeId);
            opportunities.add(opp);
        }
        return opportunities;
    }

    public static Opportunity createOpportunity(String recordTypeName, Opportunity tempOpp) {
        Id recordTypeId = String.isNotBlank(recordTypeName) ? getRecordTypeId(recordTypeName) : null;
        Opportunity opp = (tempOpp != null) ? tempOpp.clone(false) : new Opportunity();
        opp = createOpportunityInstance(opp, recordTypeId);
        return opp;
    }

    public static String getRecordTypeId(String recTypeName) {
        // Check cache first
        if (recordTypeIdCache.containsKey(recTypeName)) {
            return recordTypeIdCache.get(recTypeName);
        }

        String recTypeId = '';
        try {
            recTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(recTypeName).getRecordTypeId();
        } catch (Exception e) {
            recTypeId = [SELECT Id FROM RecordType WHERE SobjectType = 'Opportunity' LIMIT 1].Id;
        }
        recordTypeIdCache.put(recTypeName, recTypeId);
        return recTypeId;
    }

    public static Opportunity createOpportunityInstance(Opportunity oppRecord, String recordTypeId) {
        Opportunity oppInstance = oppRecord;
        if (recordTypeId != null) {
            oppInstance.RecordTypeId = recordTypeId;
        }

        oppInstance.Name = String.isBlank(oppRecord.Name) ? TestDataUtility.generateRandomString(5) + ' Opportunity' : oppRecord.Name;
        oppInstance.StageName = String.isBlank(oppRecord.StageName) ? DEFAULT_STAGE : oppRecord.StageName;
        oppInstance.CloseDate = oppRecord.CloseDate == null ? Date.today().addDays(30) : oppRecord.CloseDate;
        oppInstance.CurrencyIsoCode = String.isBlank(oppRecord.CurrencyIsoCode) ? DEFAULT_CURRENCY : oppRecord.CurrencyIsoCode;
        oppInstance.Type = String.isBlank(oppRecord.Type) ? DEFAULT_TYPE : oppRecord.Type;
        oppInstance.LeadSource = String.isBlank(oppRecord.LeadSource) ? DEFAULT_LEAD_SOURCE : oppRecord.LeadSource;
        oppInstance.Amount = oppRecord.Amount == null ? 10000 : oppRecord.Amount;

        return oppInstance;
    }

    // Simple creation method for backward compatibility
    public static Opportunity createOpportunity(String name, Id accountId) {
        return new Opportunity(
            Name = name,
            StageName = DEFAULT_STAGE,
            AccountId = accountId,
            CloseDate = Date.today().addDays(30),
            CurrencyIsoCode = DEFAULT_CURRENCY,
            Type = DEFAULT_TYPE
        );
    }
}