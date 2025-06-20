public class IBENServicesHelper {

    /**     
* This Method is responsible to generate moodle training username as part of IBEN functionality, US-94175.
* @author: Parridhi O Bindall
* @since 06/06/2021
* @param Set of Contact Id.     
* @return void.     
 
    public static void generateTrainingUsername(Set<ID> contactIds)
    { 
        System.debug('IB_RoleTriggerHelper# generateTrainingUsername called');
        
        String fname = '', trimmedfname = '';
        String lname = '', trimmedlname ='';
        Integer n, year, sum = 0;
        String name0, name1, name2, name3, interimUsername= '' ,username = '';
        
        List<Contact> contactList = [Select Id, Name, FirstName, LastName, Legal_first_name__c, Legal_Last_name__c, BirthDate, Examiner_training_username__c from Contact where Id in :contactIds AND Examiner_training_username__c = Null];
        List<Contact> updatedContactList = new List<Contact>();
        for(Contact c: contactList){
            System.debug('IB_RoleTriggerHelper# generateTrainingUsername called:'+c);
            System.debug('IB_RoleTriggerHelper# generateTrainingUsername called:'+c.Legal_first_name__c);
            
            trimmedfname = c.Legal_first_name__c.trim();
            fname = trimmedfname.left(2);
            
            trimmedlname = c.Legal_Last_name__c.trim();
            lname = trimmedlname.left(2);
            
            year = (c.BirthDate).Year();
            
            //name0
            if(fname.length() < 2){
                name0 = fname + 'z'; 
            }else{
                name0 = fname;
            }
            System.debug('IB_RoleTriggerHelper# name0 : '+ name0);
            
            //name1
            if(lname.length() < 2){
                name1 = lname + 'z'; 
            }else{
                name1 = lname;
            }
            System.debug('IB_RoleTriggerHelper# name1 : '+ name1);
            
            //name2
            while(year > 0)
            {
                n = Math.mod(year,10);
                sum = sum + n;
                year = year / 10;
            }
            System.debug('year sum : '+ sum);
            name2 = String.valueOf(sum);
            System.debug('IB_RoleTriggerHelper# name2 : '+ name2);
            
            //name3  
            interimUsername = name0.toLowerCase() + name1.toLowerCase() + name2 +'%';
            
            // - Get all usernames that starts with interimUsername
            List<Contact> existingUsernameList = new List<Contact>();
            existingUsernameList = [Select Id, Name, Examiner_training_username__c from Contact where Examiner_training_username__c LIKE :interimUsername];
            if(existingUsernameList.size() > 0){
                Set<String> nameSet = new Set<String>();
                List<Integer> countList = new List<Integer>();
                
                for(integer j=0; j<existingUsernameList.size() ; j++){
                    countList.add(Integer.valueOf(existingUsernameList[j].Examiner_training_username__c.right(3)));
                }
                System.debug('countList.size() : '+ countList.size());
                
                Integer maxValue = countList[0];
                for(integer j=0; j<countList.size() ; j++){
                    if(maxValue < countList[j])
                        maxValue = countList[j];
                }
                System.debug('maxValue : '+ maxValue);
                
                Integer newCount = maxValue + 1;
                
                if(newCount < 10)
                    name3 = '00'+ String.valueOf(newCount) ;
                else if(newCount >= 10 && newCount <=99)
                    name3 = '0' + String.valueOf(newCount) ;
                else if(newCount >= 100 && newCount <=999)
                    name3 = String.valueOf(newCount) ;
            }else
            {
                name3 = '001';
            }
            username = name0.toLowerCase() + name1.toLowerCase() + name2 + name3;
            System.debug('IB_RoleTriggerHelper# Username is : '+ username);
            c.Examiner_training_username__c = username;
            updatedContactList.add(c);
        }
        
        System.debug('IB_RoleTriggerHelper# updatedContactList.size() : '+ updatedContactList.size());
        if(updatedContactList.size() > 0){
            update updatedContactList;
        }
        
    }*/

    /**     
* This Method is responsible to - Assign IB Code (previously IBIS Contact ID) to Contact .
* @author: Parridhi O Bindall
* @since 09/29/2021
* @param set of contact Ids 
* @return void
*/ 
    public static void contactIBCodeGeneration(List<Contact> contactList){
        Id ContactRecordTypeId = Schema.getGlobalDescribe().get('Contact').getDescribe().getRecordTypeInfosByName().get('Standard Contact').getRecordTypeId();
        List<Contact> updateList = new List<Contact>();
        ContactMaxIBCode__c cSetting = ContactMaxIBCode__c.getInstance('MaxContactIBCode');
  		Integer maxCode;
        if(Test.isRunningTest()){
            maxCode = 100000;
        } else {
        	maxCode = Integer.valueof(cSetting.MaxIBCode__c);
        }
        System.debug('maxCode:'+maxCode);
        
        for(Contact con: contactList){
            if(con.IBIS_contact_ID__c == null && con.RecordTypeId == ContactRecordTypeId){
                con.IBIS_contact_ID__c = String.valueof(maxCode);
                maxCode++;
                updateList.add(con);
            }
        }
        
        
        System.debug('updateList.size(): '+updateList.size());
        if(updateList.size() > 0){
            try{ 
                System.debug('maxCode: '+maxCode);
                cSetting.MaxIBCode__c = maxCode;
                System.debug('cSetting.MaxIBCode__c: '+cSetting.MaxIBCode__c);
                update cSetting;
                update updateList;
            }catch(Exception e)
            {
                System.debug('Exception : ' + e.getMessage());
                //INC0220482 Ben McGarvey, Added emailing the error message as its important that these person codes are given out
                List<String> toAddress = new string[] {Label.Exception_Email_Alias}; 
                String emailBody='Error Occured in IBENServicesHelper Class and Cause is '+e.getCause() + ' at Line no '+e.getLineNumber() +
                    ' Error Message is '+ e.getMessage() +' and Stack Track Is'+e.getStackTraceString() + '<br/>';
                String emailSubject='Exception Occured when trying to give IB Person code to a user';
                Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                email.setToAddresses(toAddress);
        		email.setSubject(emailSubject);
        		email.setHtmlBody(emailBody);
    	    	system.debug('email exception***'+email);	
	        	Messaging.sendEmail(new Messaging.SingleEmailMessage[] { email });
            }
        }
        
    }
    
    
    /**     
* This Method is responsible to - Check if the contact has a valid IBEN Examining Role.
* @author: Parridhi O Bindall
* @since 09/21/2021
* @param contact Id
* @return Boolean
*/ 
    public static Boolean validExaminerRoleHolder(Id contactId){
        Set<String> validRoles = new Set<String>{'Examiner','Chief Examiner','Examiner Responsible', 'Deputy Examiner Responsible', 'Principal Examiner', 'Exam Team Leader','Assessment Language Reviewer','Assessment Content Developer','Assessment Translator', 'Workshop Leader', 'Evaluation Leader', 'Programme Leader', 'Field Representative', 'Site visit team leader', 'Site visit team member', 'Reader', 'IB Chair of synchronised visit', 'Lead educator', 'Content developer', 'Online Facilitator'};
            List<IB_Role__c> examRoles = new List<IB_Role__c>();
        examRoles = [Select Id from IB_Role__c where IB_Contact__c = :contactId AND Status__c='Confirmed' AND Active__c=true AND IB_Role_Name__c in :validRoles];
        
        if(examRoles.size() > 0)
            return true;
        else
            return false;
    }
    
    
    
    /**     
* This Method is responsible to Link roles to identify conflicts of interest as part of IBEN functionality - 80199 
* @author: Parridhi O Bindall
* @since 09/14/2021
* @param Role record
* @return void
*/
    public static void createCOIOnRoleUpsert(IB_Role__c newRole){
        List<IB_Role__c> role = new List<IB_Role__c>();
        role = [Select Id, IB_Contact__c, Start_Date__c, End_Date__c, IB_Account__c, IB_Contact__r.AccountId from IB_Role__c where Id = :newRole.Id LIMIT 1];
        system.debug('role'+ role);
        Conflict_of_Interest__c  coi = new Conflict_of_Interest__c();
        coi.Type_of_Conflict__c = 'Connection to a school';
        coi.IB_Contact__c = role[0].IB_Contact__c != null ? role[0].IB_Contact__c : null;
        coi.IB_Account__c = role[0].IB_Account__c != null ? role[0].IB_Account__c : role[0].IB_Contact__r.AccountId ;
        coi.Start_Date__c = role[0].Start_Date__c != null ? role[0].Start_Date__c : System.today();
        coi.End_Date__c = role[0].End_Date__c != null ? role[0].End_Date__c : null;
        insert coi;
    }
    
    
}