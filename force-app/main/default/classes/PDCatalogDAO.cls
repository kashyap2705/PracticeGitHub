public class PDCatalogDAO {
    
    private static final PDCatalogDAO instance = new PDCatalogDAO();
    private static List<PD_Catalog__c> catalog;

    private PDCatalogDAO() {}

    public static PDCatalogDAO getInstance() {
        return instance;
    }
    
    public List<PD_Catalog__c> getFullCatalog() {

        catalog = [
            SELECT Id, OwnerId, IsDeleted, Name, CurrencyIsoCode, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, LastActivityDate, Year__c, 
            	Category__c, Workshop_Name__c, Workshop_Sub_Name__c, Programme__c, Online_PD__c, Also_available_online__c, Also_in_Spanish__c, Also_in_French__c 
            FROM PD_Catalog__c
        ];

        return catalog;

    }

}