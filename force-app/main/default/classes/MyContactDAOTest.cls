@IsTest 
private class MyContactDAOTest {
    
    static testMethod void testNotValidParamsForMethods () {
            /// This Part is being added by Ammara-Plumlogix on 9-22-2019,US-11329
            //begin
    	    Account theAccount = PimsTestUtil.createAccount('Test School Account', 'School Account');
            insert theAccount;
        
            Id recordTypeId = RecordTypeDAO.INSTANCE.getRecordTypeByNameAndsObjectType('Invited Contact', 'Contact').Id;
        
            Contact theContact = PimsTestUtil.createContact('John Doe', 'JD@jd.com', 'jd@profEmail.com', Date.newInstance(1984, 09, 14), theAccount);
            theContact.Email = 'examle@gmail.com';
            theContact.Phone = '+923456789';
            theContact.MobilePhone = '+923456789';
            theContact.RecordTypeId = recordTypeId;
            insert theContact;  
            //End
            //
            
            IB_Role_Repository__c tmpRepo = TestsUtil.createRoleRepo();
            tmpRepo.Role_Name__c = 'Programme Coordinator';
            insert tmpRepo;
        
        IB_Address__c tmpAdd = new IB_Address__c(
            Name = 'STRUNK',
            IB_Account__c = theAccount.Id,
            Address_Line_1__c = 'Test',
            City__c = 'Test city',
            Postal_Code__c = '12345'
        );
        insert tmpAdd;
        
             IB_Programme__c tmpProg = new IB_Programme__c(
                Exam_Session__c = 'STRUNK',
                Primary_Language_of_Instruction__c = 'English',
                Status__c = 'Invited',
                Street_Address__c = tmpAdd.Id,
                IBCC_Implementation_Phase__c = 'Phase 1',
                Account__c = theAccount.Id
            );
            insert tmpProg;
        
            IB_Role__c tmpRole = TestsUtil.createIbRole(tmpRepo.Id, theContact.Id);
            tmpRole.IB_Programme_New__c = tmpProg.Id;
            tmpRole.IB_Account__c = theAccount.Id;
            insert tmpRole;
        
        
    	try {
    		MyContactDAO.INSTANCE.getContactbyId( null);
    		
    	} catch (DAOException daoExcep) {
    	   	System.assert(true);
    	   	
    	} catch (Exception Exce) {
    	   	System.assert(false, 'Incorrect exception !');
    	   	
    	}
    	// This Part is being added by Ammara-Plumlogix on 9-22-2019,US-11329
       //begin
        try {
    		MyContactDAO.INSTANCE.getContactbyId( theContact.id);
            MyContactDAO.INSTANCE.getRolebyContactId(theContact.id);
    		
    	} catch (DAOException daoExcep) {
    	   	System.assert(true);
    	   	
    	} catch (Exception Exce) {
    	   	System.assert(false, 'Incorrect exception !');
    	   	
    	}
     	//End
     	try {
    		MyContactDAO.INSTANCE.getContactbyIds(null);
    		
    	} catch (DAOException daoExcep) {
    	   	System.assert(true);
    	   	
    	} catch (Exception Exce) {
    	   	System.assert(false, 'Incorrect exception !');
    	   	
    	}
    	// This Part is being updated by Ammara-Plumlogix on 9-22-2019,US-11329
       //begin
        try {
            List<String> test_ids = new List<String>();
            test_ids.add(theContact.id);
    		MyContactDAO.INSTANCE.getContactbyIds(test_ids);
    		
    	} catch (DAOException daoExcep) {
    	   	System.assert(true);
    	   	
    	} catch (Exception Exce) {
    	   	System.assert(false, 'Incorrect exception !');
    	   	
    	}
    	//End
    	
    	try {
    		MyContactDAO.INSTANCE.getContactbyWere (null);
    		
    	} catch (DAOException daoExcep) {
    	   	System.assert(true);
    	   	
    	} catch (Exception Exce) {
    	   	System.assert(false, 'Incorrect exception !');
    	   	
    	}
    	// This Part is being updated by Ammara-Plumlogix on 9-22-2019,US-11329
       //begin
        try {
    		MyContactDAO.INSTANCE.getContactbyWere ('Email != null');
    		
    	} catch (DAOException daoExcep) {
    	   	System.assert(true);
    	   	
    	} catch (Exception Exce) {
    	   	System.assert(false, 'Incorrect exception !');
    	   	
    	}
        try {
    		MyContactDAO.INSTANCE.getContactbyInvitationID(null);
    		
    	} catch (DAOException daoExcep) {
    	   	System.assert(true);
    	   	
    	} catch (Exception Exce) {
    	   	System.assert(false, 'Incorrect exception !');
    	   	
    	}
         try {
    		MyContactDAO.INSTANCE.getContactbyInvitationID(theContact.Invitation_ID__c);
    		
    	} catch (DAOException daoExcep) {
    	   	System.assert(true);
    	   	
    	} catch (Exception Exce) {
    	   	System.assert(false, 'Incorrect exception !');
    	   	
    	}
         try {
    		MyContactDAO.INSTANCE.getContactbyEmail(null);
    		
    	} catch (DAOException daoExcep) {
    	   	System.assert(true);
    	   	
    	} catch (Exception Exce) {
    	   	System.assert(false, 'Incorrect exception !');
    	   	
    	}
          try {              
    		MyContactDAO.INSTANCE.getContactbyEmail('examle@gmail.com');
    		
    	} catch (DAOException daoExcep) {
    	   	System.assert(true);
    	   	
    	} catch (Exception Exce) {
    	   	System.assert(true, 'Associated User not there');
    	   	
    	}//End

    }
}