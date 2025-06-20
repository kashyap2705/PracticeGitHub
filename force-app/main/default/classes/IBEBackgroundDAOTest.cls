@IsTest 
private class IBEBackgroundDAOTest {
     
    static testMethod void testNotValidParamsForMethods () {
    	Account acc2 = PimsTestUtil.createAccount('Test Account 2', '');
           upsert acc2;
        //insert new List<Account>{acc2};      
            Contact con1 = PimsTestUtil.createContact('Jones', 'con1@home.com', 'con1@prof.com', Date.newInstance(1984, 09, 14), acc2);
            upsert con1;
    	try {
           // IBEBackgroundDAO obje = new  IBEBackgroundDAO();
            IBEBackgroundDAO.INSTANCE.getRequiredIBEBackgroundsForRole(con1.id);
            IBEBackgroundDAO.INSTANCE.getIBEBackgroundById(con1.id);
            
    		IBEBackgroundDAO.INSTANCE.getIBEBackgroundsForContactAndRecordType('Test', null);
            
    	} catch (DAOException daoExcep) {
    	   	System.assert(true);
    	} catch (Exception Exce) {
    	   	System.assert(false, 'Incorrect exception !');
    	}
     	
     	try {
    		IBEBackgroundDAO.INSTANCE.getIBEBackgroundsForContactAndRecordType(null, 'Test');
    	} catch (DAOException daoExcep) {
    	   	System.assert(true);
    	} catch (Exception Exce) {
    	   	System.assert(false, 'Incorrect exception !');
    	}
    	
    	try {
    		IBEBackgroundDAO.INSTANCE.getIBBackgroundsForContactAndRecordType ('Test', null , 0, 0);
    	} catch (DAOException daoExcep) {
    	   	System.assert(true);
    	} catch (Exception Exce) {
    	   	System.assert(false, 'Incorrect exception !');
    	}
     	
     	try {
    		IBEBackgroundDAO.INSTANCE.getIBBackgroundsForContactAndRecordType (null, 'Test' , 0, 0);
    	} catch (DAOException daoExcep) {
    	   	System.assert(true);
    	} catch (Exception Exce) {
    	   	System.assert(false, 'Incorrect exception !');
    	}
    	
    	try {
    		IBEBackgroundDAO.INSTANCE.getCountofIBBackgroundsForContactAndRecordType ('Test', null );
    	} catch (DAOException daoExcep) {
    	   	System.assert(true);
    	} catch (Exception Exce) {
    	   	System.assert(false, 'Incorrect exception !');
    	}
     	
     	try {
    		IBEBackgroundDAO.INSTANCE.getCountofIBBackgroundsForContactAndRecordType (null, 'Test' );
    	} catch (DAOException daoExcep) {
    	   	System.assert(true);
    	} catch (Exception Exce) {
    	   	System.assert(false, 'Incorrect exception !');
    	}
    	try {
    		IBEBackgroundDAO.INSTANCE.getIBBackgroundsForContactAndRecordType (con1.Id, con1.Id, 0 ,0 );
    	} catch (DAOException daoExcep) {
    	   	System.assert(true);
    	} catch (Exception Exce) {
    	   	System.assert(false, 'Incorrect exception !');
    	}
        
        IBEBackgroundDAO.INSTANCE.getCountofIBBackgroundsForContactAndRecordType (con1.Id, con1.Id);
    }  
    
}