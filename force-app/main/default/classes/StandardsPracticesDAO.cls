public class StandardsPracticesDAO { 

    private static final StandardsPracticesDAO instance = new StandardsPracticesDAO();
    private static Standards_Practices__c practice;
    private static List<Standards_Practices__c> practices;

    private StandardsPracticesDAO() {}

    public static StandardsPracticesDAO getInstance() {
        return instance;
    }

    public List<Standards_Practices__c> getStandardsAndPractices() {

        practices = [
            SELECT Id, OwnerId, IsDeleted, Name, CurrencyIsoCode, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById,  
                Standard__c, Practice__c, Required_For_Candidacy__c, Required_For_Authorization__c, In_Progress_For_Candidacy__c, In_Progress_For_Authorization__c, Practice_Short__c, Practice_ID__c  
            FROM Standards_Practices__c 
            ORDER BY Sequence__c ASC
        ];

        return practices;

    }

    public List<Standards_Practices__c> getStandardsAndPracticesByProgramme(String programmeChoice) {

        system.debug('programmeChoice: ' + programmeChoice);
        practices = [
            SELECT Id, OwnerId, IsDeleted, Name, CurrencyIsoCode, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById,  
                Standard__c, Practice__c, Required_For_Candidacy__c, Required_For_Authorization__c, In_Progress_For_Candidacy__c, In_Progress_For_Authorization__c, Practice_Short__c, Practice_ID__c  
            FROM Standards_Practices__c 
            WHERE Eligible_for_Programme__c includes (:programmeChoice)
            ORDER BY Sequence__c ASC
        ];

        return practices;

    }
}