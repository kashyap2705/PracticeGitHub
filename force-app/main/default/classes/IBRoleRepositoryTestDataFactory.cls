/**
* @description - This is used to create test data for IB_Role_Repository__c object.
*
* @author: Satyanarayana Gajavalli
* @since 21-10-2024
* @Modification Log:
* Date            Created/Modified   Ticket           Description    
* 21-10-2024      Created            US-0002466       Created the class
*/
@isTest
public without sharing class IBRoleRepositoryTestDataFactory { 

    // Default field values
    private final static Boolean DEFAULT_AVAILABLE = true;
    private final static Boolean DEFAULT_SF_ROLE_APPLICATION = true;
    private final static Date DEFAULT_AVAILABLE_FROM = Date.today().addDays(-12);
    private final static String DEFAULT_CURRENCY_ISO = 'EUR';
    private final static String DEFAULT_ROLE_NAME = 'Admin Assistant';
    private final static String DEFAULT_CATEGORY = 'Learning Centre';
    private final static String DEFAULT_ROLE_LEVEL = 'Fully Qualified';
    private final static String DEFAULT_SUB_CATEGORY = 'Administration';
    private final static String DEFAULT_RELATED_PROGRAMMES = 'PYP;MYP;DP;IBCC';
    private final static String DEFAULT_AVAILABLE_REGION = 'Global';
    private final static String DEFAULT_TRAINING_MODEL = 'Advanced Training';
    private final static Boolean DEFAULT_IB_STAFF_ROLE = true;
    private final static Boolean DEFAULT_DISPLAY_IN_PIMS = true;
    private final static Boolean DEFAULT_APPLICATION_AVAILABLE = false;

    /**
     * @description - Creates a specified number of `IB_Role_Repository__c` records, either cloned from a provided template 
     *                or initialized as new records. Each record is further customized using `createIBRoleRepositoryInstance`.
     * @param tempRoleRepository - The template `IB_Role_Repository__c` record to clone. If null, new empty records are created.
     * @param nRoleRepositories - The number of `IB_Role_Repository__c` records to create.
     * @return - List of newly created `IB_Role_Repository__c` records.
     */
    public static List<IB_Role_Repository__c> createIBRoleRepositories(IB_Role_Repository__c tempRoleRepository, Integer nRoleRepositories) {
        List<IB_Role_Repository__c> ibRoleRepositories = new List<IB_Role_Repository__c>();
        for (Integer i = 0; i < nRoleRepositories; i++) {
            IB_Role_Repository__c ibRoleRepository;
            if (tempRoleRepository != null) {
                ibRoleRepository = tempRoleRepository.clone(false);
            } else {
                ibRoleRepository = new IB_Role_Repository__c();
            }

            ibRoleRepository = createIBRoleRepositoryInstance(ibRoleRepository);
            ibRoleRepositories.add(ibRoleRepository);
        }
        return ibRoleRepositories;
    }

    /**
     * @description - Creates a single `IB_Role_Repository__c` record, either cloned from a provided template 
     *                or initialized as a new record. The record is then customized using `createIBRoleRepositoryInstance`.
     * @param tempRoleRepository - The template `IB_Role_Repository__c` record to clone. If null, a new empty record is created.
     * @return - A newly created `IB_Role_Repository__c` record.
     */
    public static IB_Role_Repository__c createIBRoleRepository(IB_Role_Repository__c tempRoleRepository) {
        IB_Role_Repository__c ibRoleRepository;
        if (tempRoleRepository != null) {
            ibRoleRepository = tempRoleRepository.clone(false);
        } else {
            ibRoleRepository = new IB_Role_Repository__c();
        }

        ibRoleRepository = createIBRoleRepositoryInstance(ibRoleRepository);
        return ibRoleRepository;
    }

    /**
     * @description - Populates the fields of a given `IB_Role_Repository__c` record with default values if they are not already set.
     *                Ensures that any blank or null fields in the provided record are populated with specified default values.
     * @param ibRoleRepositoryRecord - The `IB_Role_Repository__c` record to populate with field values.
     * @return - An `IB_Role_Repository__c` record with populated fields, where unset fields are replaced with defaults.
     */
    public static IB_Role_Repository__c createIBRoleRepositoryInstance(IB_Role_Repository__c ibRoleRepositoryRecord) {
        IB_Role_Repository__c ibRoleRepositoryInstance = ibRoleRepositoryRecord;            
        ibRoleRepositoryInstance.Available__c = TestDataUtility.getValueOrDefault(ibRoleRepositoryRecord.Available__c,DEFAULT_AVAILABLE);
        ibRoleRepositoryInstance.SF_Role_Application__c = TestDataUtility.getValueOrDefault(ibRoleRepositoryRecord.SF_Role_Application__c,DEFAULT_SF_ROLE_APPLICATION);
        ibRoleRepositoryInstance.Available_From__c = TestDataUtility.getValueOrDefault(ibRoleRepositoryRecord.Available_From__c,DEFAULT_AVAILABLE_FROM);
        ibRoleRepositoryInstance.CurrencyIsoCode = TestDataUtility.getValueOrDefault(ibRoleRepositoryRecord.CurrencyIsoCode,DEFAULT_CURRENCY_ISO);
        ibRoleRepositoryInstance.Role_Name__c = TestDataUtility.getValueOrDefault(ibRoleRepositoryRecord.Role_Name__c,DEFAULT_ROLE_NAME);
        ibRoleRepositoryInstance.Category__c = TestDataUtility.getValueOrDefault(ibRoleRepositoryRecord.Category__c,DEFAULT_CATEGORY);
        ibRoleRepositoryInstance.Role_Level__c = TestDataUtility.getValueOrDefault(ibRoleRepositoryRecord.Role_Level__c,DEFAULT_ROLE_LEVEL);
        ibRoleRepositoryInstance.Sub_Category__c = TestDataUtility.getValueOrDefault(ibRoleRepositoryRecord.Sub_Category__c,DEFAULT_SUB_CATEGORY);
        ibRoleRepositoryInstance.Related_Programmes__c = TestDataUtility.getValueOrDefault(ibRoleRepositoryRecord.Related_Programmes__c,DEFAULT_RELATED_PROGRAMMES);
        ibRoleRepositoryInstance.Available_in_Region__c = TestDataUtility.getValueOrDefault(ibRoleRepositoryRecord.Available_in_Region__c,DEFAULT_AVAILABLE_REGION);
        ibRoleRepositoryInstance.Training_Model__c = TestDataUtility.getValueOrDefault(ibRoleRepositoryRecord.Training_Model__c,DEFAULT_TRAINING_MODEL);
        ibRoleRepositoryInstance.IB_Staff_Role__c = TestDataUtility.getValueOrDefault(ibRoleRepositoryRecord.IB_Staff_Role__c,DEFAULT_IB_STAFF_ROLE);
        ibRoleRepositoryInstance.Display_In_PIMS_Community__c = TestDataUtility.getValueOrDefault(ibRoleRepositoryRecord.Display_In_PIMS_Community__c,DEFAULT_DISPLAY_IN_PIMS);
        ibRoleRepositoryInstance.Application_Available_in_MyIB__c = TestDataUtility.getValueOrDefault(ibRoleRepositoryRecord.Application_Available_in_MyIB__c,DEFAULT_APPLICATION_AVAILABLE);
        return ibRoleRepositoryInstance;
    }
    
}