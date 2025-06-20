/**
* @description - This is used to create test data for IB_Role__c object.
*
* @author: Satyanarayana Gajavalli
* @since   23-10-2024
* @Modification Log:
* Date            Created/Modified    Ticket           Description    
* 23-10-2024      Created             US-0002466       Created the class
*/
@isTest
public without sharing class IBRoleTestDataFactory {
    
    private final static Boolean DEFAULT_ACTIVE = true;
    private final static String DEFAULT_STATUS = 'Applicant';
    private final static String DEFAULT_PROG = 'PYP;MYP;DP;IBCC';

    /**
     * @description - Creates a specified number of `IB_Role__c` records, either cloned from a provided template 
     *                or initialized as new records. Each record is further customized using `createRoleInstance`.
     * @param tempRole - The template `IB_Role__c` record to clone. If null, new empty records are created.
     * @param nRoles - The number of `IB_Role__c` records to create.
     * @return - A list of newly created `IB_Role__c` records.
     */
    public static List<IB_Role__c> createRoles(IB_Role__c tempRole, Integer nRoles){
        List<IB_Role__c> roles = new List<IB_Role__c>();
        for (Integer i = 0; i < nRoles; i++) {
            IB_Role__c role;
            if(tempRole != null){
                role = tempRole.clone(false);
            } else {
                role = new IB_Role__c();
            }
            role = createRoleInstance(role);
            roles.add(role);
        }
        return roles;
    }

    /**
     * @description - Creates a single `IB_Role__c` record, either cloned from a provided template or initialized as a new record.
     *                The record is then customized using `createRoleInstance`.
     * @param tempRole - The template `IB_Role__c` record to clone. If null, a new empty record is created.
     * @return - A newly created `IB_Role__c` record with customized fields.
     */
    public static IB_Role__c createRole(IB_Role__c tempRole){
        IB_Role__c role;
        if(tempRole != null){
            role = tempRole.clone(false);
        } else {
            role = new IB_Role__c();
        }
        return createRoleInstance(role);
    }
    
    /**
     * @description - Populates the fields of a given `IB_Role__c` record with default values if they are not already set.
     *                Ensures that any blank or null fields in the provided record are populated with specified default values.
     * @param roleRecord - The `IB_Role__c` record to populate with field values.
     * @return - An `IB_Role__c` record with populated fields, where unset fields are replaced with defaults.
     */
    public static IB_Role__c createRoleInstance(IB_Role__c roleRecord){
        IB_Role__c roleInstance = roleRecord;
        roleInstance.Status__c = String.isBlank(roleRecord.Status__c) ? DEFAULT_STATUS : roleRecord.Status__c;
        roleInstance.Active__c = (roleRecord.Active__c == null) ? DEFAULT_ACTIVE : roleRecord.Active__c;
        roleInstance.Programme_Selection__c = String.isBlank(roleRecord.Programme_Selection__c) ? DEFAULT_PROG : roleRecord.Programme_Selection__c;
        return roleInstance;
    }
}