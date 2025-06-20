/**
* <h1>Update Institute Accounts</h1>
* This Batch Class is responsible for updating 3 fields on IB Institute Accounts:
* 1. Confirmed_Transcript_Users__c, 2. Maximum_Transcript_Users__c, 3. isPartner
* ECM00293
* @author  Parridhi O Bindal.
* @version 1.0
* @since   2021-03-04.
*/

global class UpdateInstituteAccounts implements Database.Batchable<sObject>{
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        String query = 'Select Id, Confirmed_Transcript_Users__c, Maximum_Transcript_Users__c, isPartner, Active__c from Account where RecordType.Name=\'IB Institute\'';
        return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext BC, List<Account> scope){
        
        List<Account> updatedInstitutes = new List<Account>();
        List<IB_Role__c> accRoles = new List<IB_Role__c>();
        
       
        for(Account a : scope)
        {
            System.debug('a.Maximum_Transcript_Users__c : '+ a.Maximum_Transcript_Users__c);
            if(a.Maximum_Transcript_Users__c == null)
            {
                a.Maximum_Transcript_Users__c = '10';
            } else if( Integer.valueOf(a.Maximum_Transcript_Users__c) < 10 )
            {
                a.Maximum_Transcript_Users__c = '10';
            }
            
            accRoles = [select id,Status__c,IB_Role_Name__c from IB_Role__c where IB_Account__c=:a.Id and Status__c='Confirmed' and IB_Role_Name__c='Institute Transcript User'];
            a.Confirmed_Transcript_Users__c =accRoles.size();
            
            if(a.Active__c == 'Active' && a.isPartner == false)
            {
                a.isPartner = true;
            }
            updatedInstitutes.add(a);
        }
        
        System.debug('updatedInstitutes.size() : ' + updatedInstitutes.size());
        if(updatedInstitutes.size() > 0)
        {
            update updatedInstitutes;
        }
    }
    global void finish(Database.BatchableContext BC){}
}