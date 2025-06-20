@isTest
private class ContactEmailDAOTest {
    
    static testMethod void testNotValidParamsForMethods () {
        
        Account theAccount = PimsTestUtil.createAccount('TestIBSchool','School Account');
        insert theAccount;

        Contact theContact = PimsTestUtil.createContact('Jack Reacher','jr@tibs.com','jr@profEmail.com', Date.newInstance(1984, 09, 14), theAccount);
        insert theContact;
        
        ContactEmail__c mail1 = new ContactEmail__c(
            Contact__c = theContact.Id,
            Account__c = theAccount.Id,
            EmailAddress__c = 'email@email.com'
        );
        
        List<ContactEmail__c> mailList = new List<ContactEmail__c>{mail1};
        insert mailList;
        
        try {
            ContactEmailDAO.getInstance().getEmailsByAccount(theAccount.Id);
            
        } catch (DAOException daoExcep) {
            System.assert(true);
            
        } catch (Exception Exce) {
            System.assert(false, 'Incorrect exception !');
            
        }
        
        try {
            ContactEmailDAO.getInstance().getEmailByAccountAndContact(theAccount.Id, theContact.Id);
            
        } catch (DAOException daoExcep) {
            System.assert(true);
            
        } catch (Exception Exce) {
            System.assert(false, 'Incorrect exception !');
            
        }
        
        try {
            ContactEmailDAO.getInstance().getEmailByContact (mailList, theContact.Id);
            
        } catch (DAOException daoExcep) {
            System.assert(true);
            
        } catch (Exception Exce) {
            System.assert(false, 'Incorrect exception !');
            
        }
    }
    
}