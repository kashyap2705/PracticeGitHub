public with sharing class IBRoleDAO {

    public static final IBRoleDAO INSTANCE = new IBRoleDAO();

    private IBRoleDAO() {

    }

    public IB_Role__c getRoleById (final String Id) {

        if ( String.isBlank(Id)) {

            throw new DAOException('The ID cannot be zero or an empty string.');
        }

        final List<IB_Role__c> result = [ Select i.Role_Level__c,  i.Status__c, i.IB_Role_Name__c, i.IB_Role_Name_fr__c, i.IB_Role_Name_es__c, i.Title__c, Active__c, Application_Feedback__c,  i.Referee_2_Title__c, i.Referee_2_Last_Name__c, i.Referee_2_First_Name__c, i.Referee_2_Email__c, i.Referee_1_Last_Name__c, i.Referee_1_First_Name__c, i.Referee_1_Email__c, i.Ref_2_Feedback_Request__c, i.Ref_1_Feedback_Request__c, i.RecordTypeId, i.Programme_Selection__c, i.Programme_Selection_Form__c, i.Motivation__c,
                                   i.LastModifiedDate, i.LastModifiedById, i.LastActivityDate, i.IsDeleted, i.Declined_Application_Status_Information__c,  i.Id, i.IB_Role__c, i.IB_Role_Category__c, i.IB_Contact__c, i.First_Referee_Professional_Relationship__c, i.Second_Referee_Professional_Relationship__c, i.IB_Account__c, i.IB_Programme__c, i.Start_Date__c, i.End_Date__c, i.Subject_Groups__c, i.Subject__c, Restricted_Subjects__c From IB_Role__c i where id = : id ];

        if (null == result || result.isEmpty()) {
            return null;
        }

        return result.get(0);

    }

    public Id getDefaultRoleOwnerId(){

        List<Group> defaultQueue = new List<Group>([
            SELECT Id
            FROM Group
            WHERE DeveloperName = 'IBEN_Created_Records'
        ]);

        if(!defaultQueue.isEmpty()){
            return defaultQueue[0].Id;
        }

        return null;
    }

}