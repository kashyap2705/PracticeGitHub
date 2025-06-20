@IsTest 
private class DocumentDAOTest {
    
    static testMethod void testNotValidParamsForMethods () {
      
      try {
        DocumentDAO.INSTANCE.getDocumentPathByName(null);
        
      } catch (DAOException daoExcep) {
           System.assert(true);
           
      } catch (Exception Exce) {
           System.assert(false, 'Incorrect exception !');
           
      }
    }
    
    static testMethod void testEmptyResultForgetRoleByIdMethod() {
      
      System.assert(null == DocumentDAO.INSTANCE.getDocumentPathByName('Test'), 'Unexpected result! Should be null' );
      
    }
    
}