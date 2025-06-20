/**
* <h1> pingFedIDUpdate </h1>
* This class is created to update PingFedId, Person_code and OrgId in User object
* 
* @author  Arunkumar Kathiravan
* @version 1.0
* @since   2021-08-19 

Modification Log     :                                                                              

*-------------------------------------------------------------------------------------------------- 

* Developer                   Date                   Description          Version                          

* ------------------------------------------------------------------------------------------------- 


*/
global class pingFedIDUpdate implements Database.Batchable<sObject> {
    global Database.QueryLocator start(Database.BatchableContext BC) {
        //Query users with PingFedId is null or not equal to IBIS Contact ID
		String query = 'SELECT Id, Name, Person_Code__c,PingFed_Identifier__c,Organization_ID__c, UserName, Contact.IBIS_Contact_ID__c,Contact.Account.IBIS_ID__c,ContactId FROM User ';
		String queryConditions = ' where isActive = true AND ContactId != null AND (PingFed_Identifier__c = null OR (Person_Code__c != null AND PingFed_Identifier__c like \'%@%\'))';
		queryConditions += (Test.isRunningTest()?' AND UserName like \'%testUtils%\'':' LIMIT 200');
        system.debug('queryConditions: ' + queryConditions);
        return Database.getQueryLocator(query+queryConditions);
    }
     
    global void execute(Database.BatchableContext BC, List<User> usrList) {
        list<User> usrUpdateList = new list<User>();
        system.debug('usrList: ' + usrList);
        for(User usr : usrList) {
            if(usr.Contact.IBIS_Contact_ID__c != null){
				usr.PingFed_Identifier__c = usr.Contact.IBIS_Contact_ID__c;
				if(usr.Person_Code__c != usr.Contact.IBIS_Contact_ID__c){
					usr.Person_Code__c = usr.Contact.IBIS_Contact_ID__c;
				}
				if(usr.Contact.Account.IBIS_ID__c != null){
					usr.Organization_ID__c = usr.Contact.Account.IBIS_ID__c;
				}
				else{
					usr.Organization_ID__c = '999999';
				}
				usrUpdateList.add(usr);
			}
			else{
				usr.PingFed_Identifier__c = usr.UserName;
				if(usr.Contact.Account.IBIS_ID__c != null){
					usr.Organization_ID__c = usr.Contact.Account.IBIS_ID__c;
				}
				else{
					usr.Organization_ID__c = '999999';
				}
				usrUpdateList.add(usr);
			}
        }
        try {
            if(!usrUpdateList.isEmpty()){
				update usrUpdateList;
			}
         
        } catch(Exception e) {
            System.debug(e);
        }
         
    }   
     
    global void finish(Database.BatchableContext BC) {
        // execute any post-processing operations like sending email
    }
}