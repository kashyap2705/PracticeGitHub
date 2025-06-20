public class changeProfileFutureMethodClass {
    
    @future public static void changeProfileMethod(String username)
    {        
        try { 
            List<User> userList = [SELECT ProfileId, ContactId, Name FROM user Where username=:username LIMIT 1];
            if(!userList.isEmpty()) {
                List<IB_Role__c> roleList = new List<IB_Role__c>();
                roleList = [Select Status__c, IB_Role_Name__c, IB_Contact__c, Id from IB_role__c
                            where IB_Contact__c =: userList[0].ContactId
                            AND IB_Role_Name__c IN ('Head of School', 'Programme Coordinator','Head of School(Overall)')
                            AND Status__c ='Confirmed'];
                
                Profile pro;
                if(roleList.size()>0){
                    pro = [SELECT ID FROM profile WHERE name='SCU + Advanced'];
                }
                else{
                    pro = [SELECT ID FROM profile WHERE name='Customer Community Advanced'];
                }
                userList[0].ProfileId = pro.Id;
                if(!Test.isRunningTest())
                    update userList;    
            }
        } catch(Exception exp) {
            Logger.get().add(exp, LogSeverity.ERROR).publish();        
        }
    }
    
     @future public static void changeProfileMethodADAS(String username){ 
         try{
            List<User> usersList = [SELECT ProfileId, Name FROM user Where username=:username];
            profile profileToUpdate = [SELECT ID FROM profile WHERE name='Customer Community Basic'];
         	if(usersList.size()>0){
                usersList[0].ProfileId = profileToUpdate.Id;
                if(!Test.isRunningTest())
                Update usersList;
            }
     	  }
         catch(Exception exp){
              System.debug('Exception : '+exp);
          }
    } 
}