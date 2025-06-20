@IsTest 
public with sharing class UserLicenseDAOTest {
     
    static testMethod void testNotValidParamsForMethods () {
    	
    	try {
    		UserLicenseDAO.INSTANCE.getLicenseByProfileId(null);
    		
    	} catch (DAOException daoExcep) {
    	   	System.assert(true);
    	   	
    	} catch (Exception Exce) {
    	   	System.assert(false, 'Incorrect exception !');
    	   	
    	}
    }
    
    static testMethod void testEmptyResultForgetLicenseByProfileIdMethod() {
    	
    	System.assert(null == UserLicenseDAO.INSTANCE.getLicenseByProfileId('Test'), 'Unexpected result! Should be null' );
    	
    }
    
}