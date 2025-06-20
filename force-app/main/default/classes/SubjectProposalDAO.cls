public class SubjectProposalDAO {
    
    private static final SubjectProposalDAO instance = new SubjectProposalDAO();
    
    
    private List<Roles_and_Applications_Subject_Proposal__c> proposals;
    private Roles_and_Applications_Subject_Proposal__c proposal;
    //public static List<IB_Data_Translate__c> translations { get; set; }
    
    private SubjectProposalDAO() {}
    
    public static SubjectProposalDAO getInstance() {
        return instance;
    }
    
    public Roles_and_Applications_Subject_Proposal__c getProposalById(Id proposalId) {
        
        proposal = [
            SELECT Id, OwnerId, IsDeleted, Name, CurrencyIsoCode, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, LastActivityDate, IB_Application_Lookup__c,
            Subject_Lookup__c, Subject_Group__c, Subject_Name__c, Language_of_Instruction__c, MYP_Year_Subject_taught__c, Subject_Level__c, Current_Number_of_Students__c, Estimated_Number_of_Students__c,
            Year_1_Hours__c, Year_2_Hours__c, Before_Year_1_Subject_Name__c, Before_Year_2_Subject_Name__c, IsYearOne__c, IsYearTwo__c, Subject_Lookup__r.Course_Outline__c, 
            Subject_Lookup__r.Course_Outline_SP__c, Subject_Lookup__r.Course_Outline_FR__c, Subject_Lookup__r.Subject_Name_SP__c, Subject_Lookup__r.Subject_Name_FR__c, Subject_Lookup__r.IB_Programme__c  
            FROM Roles_and_Applications_Subject_Proposal__c
            WHERE Id = :proposalId
            ORDER BY Subject_Group__c ASC
        ];
        
        return proposal;
        
    }
    
    public List<Roles_and_Applications_Subject_Proposal__c> getProposalsByApplicationId(Id appId) {
        
        proposals = [
            SELECT Id, OwnerId, IsDeleted, Name, CurrencyIsoCode, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, LastActivityDate, IB_Application_Lookup__c,
            Subject_Lookup__c, Subject_Group__c, Subject_Name__c, Language_of_Instruction__c, MYP_Year_Subject_taught__c, Subject_Level__c, Current_Number_of_Students__c, Estimated_Number_of_Students__c,
            Year_1_Hours__c, Year_2_Hours__c, Before_Year_1_Subject_Name__c, Before_Year_2_Subject_Name__c, IsYearOne__c, IsYearTwo__c, Subject_Lookup__r.Course_Outline__c, 
            Subject_Lookup__r.Course_Outline_SP__c,Subject_Lookup__r.Subject_Group__c, Subject_Lookup__r.Course_Outline_FR__c, Subject_Lookup__r.Subject_Name_SP__c, Subject_Lookup__r.Subject_Name_FR__c, Subject_Lookup__r.IB_Programme__c 
            FROM Roles_and_Applications_Subject_Proposal__c
            WHERE IB_Application_Lookup__c = :appId
            ORDER By Subject_Group__c ASC
        ];
        
        return proposals;
        
    }
    
}