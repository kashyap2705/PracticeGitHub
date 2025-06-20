public without sharing class IBCountrySegmentationDAO {
    
    
    public static final IBCountrySegmentationDAO INSTANCE = new IBCountrySegmentationDAO();
    
    private IBCountrySegmentationDAO() {
    
    }
    
    public List<IB_Country_Segmentation__c> getAll () {
        return [select id, name, country_fr__c, country_es__c from IB_Country_Segmentation__c order by name asc];
        
    }
     
    public IB_Country_Segmentation__c getById (final String id) {
        if (String.isEmpty(id)) {
             throw new DAOException('The ID cannot be zero or an empty string.');
            
        }
        
        final List<IB_Country_Segmentation__c> result = [select id, name, IBEN_Independent_Account__c from IB_Country_Segmentation__c where id =: id];
        
        system.debug( 'Result ' + result );
        
        if (null == result || result.isEmpty()) {
            return null;
        }
                
        return result.get(0);

    } 
    
    
    
}