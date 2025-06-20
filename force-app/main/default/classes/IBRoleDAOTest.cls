@IsTest 
private class IBRoleDAOTest {
    
    static testMethod void testNotValidParamsForMethods () {
    	
    	try {
    		IBRoleDAO.INSTANCE.getRoleById(null);
    		
    	} catch (DAOException daoExcep) {
    	   	System.assert(true);
    	   	
    	} catch (Exception Exce) {
    	   	System.assert(false, 'Incorrect exception !');
    	   	
    	}
    }
    
    static testMethod void testEmptyResultForgetRoleByIdMethod() {
    	
    	System.assert(null == IBRoleDAO.INSTANCE.getRoleById('Test'), 'Unexpected result! Should be null' );
    	
        IBRoleDAO.INSTANCE.getDefaultRoleOwnerId();
            
    
    }
    
    
}