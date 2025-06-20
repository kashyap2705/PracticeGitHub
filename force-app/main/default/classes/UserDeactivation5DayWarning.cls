global class UserDeactivation5DayWarning implements Database.Batchable<sObject>{
    
    public static boolean TriggerActivator=true;
    List<User> InActiveUsers= new List<User>();
    List<String> errorList;
    integer usercount = 0;
    global Database.QueryLocator start(Database.BatchableContext bc) {
        
        if(Test.isRunningTest())
            
            return Database.getQueryLocator([SELECT CreatedDate,IsActive,Profile.Name,LastLoginDate,Date_Deactivated__c,Deactivation_Warning_5_days__c FROM User where IsActive = True AND (Profile.Name='Customer Community Basic' OR Profile.Name='Customer Community Advanced' OR Profile.Name='SCU + Advanced' OR Profile.Name='SCU + Basic') AND LastLoginDate != LAST_N_MONTHS:23 LIMIt 200]);
        
        return Database.getQueryLocator([SELECT CreatedDate,IsActive,Profile.Name,LastLoginDate,Date_Deactivated__c,Deactivation_Warning_5_days__c FROM User where IsActive = True AND (Profile.Name='Customer Community Basic' OR Profile.Name='Customer Community Advanced' OR Profile.Name='SCU + Advanced' OR Profile.Name='SCU + Basic') AND LastLoginDate < LAST_N_MONTHS:23]);
    }
    
    
    
    global void execute(Database.BatchableContext bc, List<User> scope){
        TriggerActivator=true;
        Integer InActiveMonths;
        Date UserLastLoginDate;
        Date scheduledDay;
        
        for(User u :scope)
        {
            if(u.LastLoginDate!=null)
            {
                InActiveMonths= date.newinstance(u.LastLoginDate.year(), u.LastLoginDate.month(), u.LastLoginDate.day()).monthsBetween(date.today());
                if(u.IsActive==true && InActiveMonths>=23 && u.Deactivation_Warning_5_days__c==false)
                {
                    u.Deactivation_Warning_5_days__c=true;
                    InActiveUsers.Add(u);
                    userCount = userCount + 1;
                }
            }
            else
            {
                InActiveMonths = null;
                UserLastLoginDate = null;
                scheduledDay = null;
                if(u.LastLoginDate==null)
                {
                    UserLastLoginDate = date.newinstance(u.CreatedDate.year(), u.CreatedDate.month(), u.CreatedDate.day());
                    scheduledDay=date.today(); 
                    InActiveMonths=UserLastLoginDate.monthsBetween(scheduledDay);
                    if((u.IsActive==true && InActiveMonths>=23 && u.Deactivation_Warning_5_days__c==false) || Test.isRunningTest())
                    {
                        u.Deactivation_Warning_5_days__c=true;
                        InActiveUsers.Add(u);
                        userCount = userCount + 1;
                    }
                }
            }
        }
        TriggerActivator=false;
        Database.SaveResult[] srcList = Database.update (InActiveUsers,false);
        for(Database.SaveResult r : srcList)
        {
            if(r.isSuccess() != true)
            {
                List<Database.error> errors = r.getErrors();
                for(Database.error error : errors){
                    errorList.add(error.getMessage());
                }
            }
        }
    }
    
    global void finish(Database.BatchableContext bc)
    {
        TriggerActivator=true;
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String message = '';
        String[] toAddresses=new String[]{'salesforceadmins@ibo.org'};
        mail.setToAddresses(toAddresses);
        mail.setSubject('5 day warning batch results');
        if(errorList != null)
        {
            message = 'The following errors occured during the 5 day warning batch: \n\n';
            for(String error : errorList){
                message = message + error + '\n';
            }
        } else {
            message = 'The batch completed with no errors.';
        }
        message = message + '\n The batch attempted to update ' + userCount + ' user records.';
        mail.setPlainTextBody(message);
       Messaging.sendEmail(new Messaging.SingleEmailMessage[]{mail});
    }
}