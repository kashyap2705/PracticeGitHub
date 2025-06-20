/* Created Date: 7/1/2019
   Description: Each day checking old withdrwan status date and updating the status to withdrawn */
global class Programme_Status implements Schedulable {
    global void execute(SchedulableContext ctx) {
              
       //US-11020(Refactoring Functionality)
      
       //List having Programme status need to be updated
       List<IB_Programme__c> prog_to_be_updated = new List<IB_Programme__c>();
        
      //query IB_Programme having status = Authorized and Old_Withdrawn_Status_Date_c = Today
       List<IB_Programme__c> ib_prog = new List<IB_Programme__c>();
       ib_prog = [Select id,Old_Withdrawn_Status_Date__c,Status__c from IB_Programme__c 
                  where Old_Withdrawn_Status_Date__c =:System.today() 
                  And Status__c = 'Authorized'];
       
        System.debug(ib_prog.size());
        
       //Update the Status Value
       if(ib_prog.size() >0) {
       
         for(IB_Programme__c prog:ib_prog){
       
           prog.Status__c = 'Withdrawn';
           prog_to_be_updated.add(prog);
       
           }
         //Update the list
           try {
          if(prog_to_be_updated.size() > 0)
             update prog_to_be_updated;      
           }
           catch (Exception ex) {
               System.debug('Exception '+ex);
           }
       }        
     
    }
}