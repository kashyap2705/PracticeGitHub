/**
 * @description - This is used to create test data for the Lead object.
 *
 * @author  Satyanarayana Gajavalli
 * @since 27-02-2025
 * @ModificationLog 
 * Date            Created/Modified   Ticket           Description    
 * 27-02-2025      Created            US-0003106       Created the class
 * 28-03-2025	   Modified			  US-0002473       Optimize to Reuse Account/Contact
 */
@isTest
public without sharing class LeadTestDataFactory {
    
    private final static String DEFAULT_LEAD_SOURCE = 'Sales Development - Inbound';
    private final static String DEFAULT_FIRST_NAME = 'TestFirstName';
    private final static String DEFAULT_LAST_NAME = 'TestLastName';
    private final static String DEFAULT_COMPANY = 'TestCompany';
    private final static String DEFAULT_EMAIL = 'testlead@test.com';
    private final static String DEFAULT_COUNTRY = 'United States';
    private final static String DEFAULT_STATE = 'Florida';
    private final static String DEFAULT_REGION = 'IBA';
    private final static String DEFAULT_SUB_REGION = 'NORTHERN AMERICA';
    private final static String DEFAULT_STATUS = 'Open';
    private final static Boolean DEFAULT_PYP_INTEREST = true;
    private final static String DEFAULT_POSITION_WITH_SCHOOL = 'Teacher';

    private final static Map<String, Object> DEFAULT_FIELD_VALUES = new Map<String, Object>{
        'LeadSource' => DEFAULT_LEAD_SOURCE,
        'FirstName' => DEFAULT_FIRST_NAME,
        'LastName' => DEFAULT_LAST_NAME,
        'Company' => DEFAULT_COMPANY,
        'Email' => DEFAULT_EMAIL,
        'Status' => DEFAULT_STATUS,
        'Country' => DEFAULT_COUNTRY,
        'State' => DEFAULT_STATE,
        'Region__c' => DEFAULT_REGION,
        'Sub_Region__c' => DEFAULT_SUB_REGION,
        'Position_with_School__c' => DEFAULT_POSITION_WITH_SCHOOL,
        'PYP_Interest__c' => DEFAULT_PYP_INTEREST
    };

    // Static variables to hold single account and contact
    private static Id defaultAccountId;
    private static Id defaultContactId;
	
    /**
     * @description - Creates a list of Lead records
     * @param tempLead - Template Lead record to clone (can be null)
     * @param nLeads - Number of records to create
     * @return List<Lead>
     */
    public static List<Lead> createLeads(Lead tempLead, Integer nLeads) {
        List<Lead> leads = new List<Lead>();
        // Create single account and contact if not already created
        if (defaultAccountId == null) {
            defaultAccountId = createDefaultAccount();
        }
        if (defaultContactId == null) {
            defaultContactId = createDefaultContact();
        }

        for (Integer i = 0; i < nLeads; i++) {
            Lead lead = (tempLead != null) ? tempLead.clone(false) : new Lead();
            lead = populateLeadFields(lead);
            leads.add(lead);
        }
        return leads;
    }
	
    /**
     * @description - Creates a single Lead record
     * @param tempLead - Template Lead record to clone (can be null)
     * @return Lead
     */
    public static Lead createLead(Lead tempLead) {
        Lead lead = (tempLead != null) ? tempLead.clone(false) : new Lead();
        return populateLeadFields(lead);
    }
	
    /**
     * @description - Populates fields of a Lead instance
     * @param leadRecord - The record to populate fields
     * @return Lead with populated fields
     */
    private static Lead populateLeadFields(Lead leadRecord) {
        Lead leadInstance = leadRecord;
        leadInstance = applyDefaultStringFields(leadInstance);
        leadInstance.PYP_Interest__c = (leadRecord.PYP_Interest__c == false) ? false : DEFAULT_PYP_INTEREST;
        leadInstance.Existing_Account_Related__c = String.isBlank(leadRecord.Existing_Account_Related__c) ? defaultAccountId : leadRecord.Existing_Account_Related__c;
        leadInstance.Existing_Contact_Related__c = String.isBlank(leadRecord.Existing_Contact_Related__c) ? defaultContactId : leadRecord.Existing_Contact_Related__c;
        return leadInstance;
    }
	
    /**
     * @description - Applies default values to string fields using a map
     * @param leadRecord - The Lead record to populate
     * @return Lead with populated string fields
     */
    private static Lead applyDefaultStringFields(Lead leadRecord) {
        Lead leadInstance = leadRecord;
        for (String field : DEFAULT_FIELD_VALUES.keySet()) {
            if (field != 'PYP_Interest__c') {
                String currentValue = (String)leadInstance.get(field);
                leadInstance.put(field, String.isBlank(currentValue) ? DEFAULT_FIELD_VALUES.get(field) : currentValue);
            }
        }
        return leadInstance;
    }
	
    /**
     * @description - Creates a default Account record
     * @return Id of the created Account
     */
    private static Id createDefaultAccount() {
        Account account = AccountTestDataFactory.createAccount(null, null);
        insert account;
        return account.Id;
    }
	
    /**
     * @description - Creates a default Contact record
     * @return Id of the created Contact
     */
    private static Id createDefaultContact() {
        Contact contact = ContactTestDataFactory.createContact(null, null);
        insert contact;
        return contact.Id;
    }
}