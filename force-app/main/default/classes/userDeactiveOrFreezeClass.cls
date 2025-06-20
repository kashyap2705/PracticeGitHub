/**
* <h1>Deactivate or Freeze Users</h1>
* This Batch Class is responsible for Freezing Or Deactivating User Which have last Login date greater Than 90 or 150 days respectively
* and Prevent_deactivation_due_to_inactivity__c is false.
* DE6118.
* @author  Ahmad Shakeel.
* @version 1.0
* @since   2019-10-10.
*/
global class userDeactiveOrFreezeClass  implements Database.Batchable<sObject> , Database.Stateful
{
    @testvisible public date testingDate=null;
    public static boolean FreezeTriggerActivator=true;
    global List<String> FrezeResults=new List<String>();
    global List<String>	updateResult=new List<String>();
    List<User> InActiveUsers= new List<User>();
    List<UserLogin> FreezedUsers= new List<UserLogin>();
    
    
    /**
   * This method will get all the user who have last loginDate greater Than 90 days
   * and Prevent_deactivation_due_to_inactivity__c is false.
   * @param Database.BatchableContext.
   * @return Database.QueryLocator This returns the List of User which have loginDate greater Than 90 days or Null.
   */
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        
        if(Test.isRunningTest())
            return Database.getQueryLocator([SELECT CreatedDate,IsActive,Prevent_deactivation_due_to_inactivity__c,Profile.UserLicense.Name,LastLoginDate FROM User WHERE IsActive = true AND Prevent_deactivation_due_to_inactivity__c = false AND (Profile.UserLicense.Name='Salesforce' OR Profile.UserLicense.Name='Salesforce Platform') AND LastLoginDate != LAST_N_DAYS:90 LIMIt 100]);
        
        return Database.getQueryLocator([SELECT CreatedDate,IsActive,Prevent_deactivation_due_to_inactivity__c,Profile.UserLicense.Name,LastLoginDate FROM User WHERE IsActive = true AND Prevent_deactivation_due_to_inactivity__c = false AND (Profile.UserLicense.Name='Salesforce' OR Profile.UserLicense.Name='Salesforce Platform') AND LastLoginDate != LAST_N_DAYS:90]);
    }
    
    
 /**
   * This method will Deactivate and Freeze the user as per acceptance criteria.
   * @param Database.BatchableContext and list of Users.
   * @return void.
   */
    
    global void execute(Database.BatchableContext bc, List<User> scope)
    {
        Integer iterator=0;
        
        Set<id> frezId=new Set<id>();
        for(User x: scope)
        {
            frezId.add(x.id);
        }
        Integer inActiveDays;
        
        List<UserLogin> userLogin=[SELECT UserId,IsFrozen FROM UserLogin WHERE UserId IN:frezId AND IsFrozen=false];
        for(User u :scope)
        {
            if(u.LastLoginDate!=null)
            {
                    Date lastLoginDate; 
                    if(!Test.isRunningTest())
                    {
                   		lastLoginDate = date.newinstance(u.LastLoginDate.year(), u.LastLoginDate.month(), u.LastLoginDate.day());
                    }
                    else
                    {
                        lastLoginDate=testingDate;
                    }
                    
                    Date todayDate=date.today(); 
                    inActiveDays=lastLoginDate.daysBetween(todayDate);
                    if(inActiveDays>=90 && inActiveDays<=150)
                    {
                        
                        for(UserLogin ug:userLogin)
                        {                            
                            if(ug.UserId==u.Id)
                            {
                                ug.IsFrozen=true;
                                FreezedUsers.Add(ug);
                                
                                
                                
                            }
                        }
                    }
                    else if(inActiveDays>150)
                    {
                        u.IsActive=false;
                        InActiveUsers.Add(u);
                      
                    }
                
            }
            
            else
            {
               
                    Date lastLoginDate = date.newinstance(u.CreatedDate.year(), u.CreatedDate.month(), u.CreatedDate.day());
                    Date todayDate=date.today(); 
                    inActiveDays=lastLoginDate.daysBetween(todayDate);
                    if(inActiveDays>=90 && inActiveDays<=150)
                    {
                        
                        for(UserLogin ug:userLogin)
                        {
                            
                            if(ug.UserId==u.Id)
                            {
                                ug.IsFrozen=true;
                                FreezedUsers.Add(ug);
                                
                             
                                
                            }
                        }
                    }
                    else if(inActiveDays>150)
                    {
                        u.IsActive=false;
                        InActiveUsers.Add(u);
                 
                    }
                
            }
           
        }
      
        List<Database.SaveResult>updateResultsFreze = Database.update(FreezedUsers,false);
    
            for(integer i =0; i<FreezedUsers.size();i++)
            {
                String msg1='';
                If(!updateResultsFreze[i].isSuccess())
                {
                    msg1 += FreezedUsers[i].id + '\n'+'Error: ';
                    for(Database.Error err: updateResultsFreze[i].getErrors()){
                        msg1 += err.getmessage()+'\n\n';
                    }
                }
                if(msg1!='' && msg1!=Null)
                {
                   FrezeResults.add(msg1);
                }
            }
        
        if(!Test.isRunningTest())
        
            FreezeTriggerActivator=false;
            
            List<Database.SaveResult> updateResultDeactivate=Database.update(InActiveUsers,false);
            FreezeTriggerActivator=True;
            for(integer i =0; i<InActiveUsers.size();i++)
            {
                String msg='';
                If(!updateResultDeactivate[i].isSuccess())
                {
                    msg += InActiveUsers[i].id + '\n'+'Error: ';
                    for(Database.Error err: updateResultDeactivate[i].getErrors()){
                        msg += err.getmessage()+'\n\n';
                    }
                }
                if(msg!='' && msg!=Null)
                {
                    updateResult.add(msg);
                }
            }
         
    }
    
     /**
   * This method will execute at the end of batch class which will
   * send email of users which could not be deactivated or freezed
   * because they are used in other components .
   * @param Database.BatchableContext .
   * @return Void.
   */
    
    global void finish(Database.BatchableContext bc)
    {
         FreezeTriggerActivator=True;
        if(updateResult.size()>0)
        {
           
            
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            
            String[] toAddresses = new String[] {'salesforceadmins@ibo.org'};
                
                mail.setToAddresses(toAddresses);
            String str='';
            
            mail.setSubject('List of Failed Users During deactivation');
            for(integer x=0;x<updateResult.size()/2;x++)
            {
                str=str+updateResult[x];
                str+='\n';
            }
         
            mail.plainTextBody = str;
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }
        if(FrezeResults.size()>0)
        {
             
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
       		String[] toAddresses = new String[] {'salesforceadmins@ibo.org'};
          	mail.setToAddresses(toAddresses);
            String str='';
   			mail.setSubject('List of Failed Users During Freezing');
            
            for(integer x=0;x<FrezeResults.size()/2;x++)
            {
                str=str+FrezeResults[x];
                str+='\n';
            }
           
            mail.plainTextBody = str;
     		Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }
        
    }
    
}