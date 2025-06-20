/**     
    * <h1>IB_ProgrammeBeforeUpdateTriggerHandler</h1>       
    * This class is responsible managing afterupdate trigger functionality on ib_programme object as part of trigger consolidation,US11226.
    * 
    * @author  Abd Ur Rehman        
    * @version 1.0      
    * @since   28-1-2020
    
Modification Log     :                                                                              

*-------------------------------------------------------------------------------------------------- 

* Developer                   Date                   Description          Version                          

* ------------------------------------------------------------------------------------------------- 


*/

public with sharing class IB_ProgrammeBeforeUpdateTriggerHandler extends TriggerHandlerBase {

    /**     
       * This Method is responsible for trigger exceution ,US11226.
       * @author: Abd Ur Rehman-Plumlogix 
       * @since 28-1-2020
       * @param map and list of contact.        
       * @return void.      
      */
      Static Boolean bypassValidationRules;//INC0207105 Ben Mcgarvey made this static to save on repeat soql
      Static preventAuthorizedCheckContactsHandler  PACC_Handler;
    public override void mainEntry(TriggerParameters tp){
        process((Map<Id,IB_Programme__c>)tp.oldMap, (Map<Id,IB_Programme__c>)tp.newMap ,(list<IB_Programme__c>)tp.newList
                ,(list<IB_Programme__c>)tp.oldList);
    }
    
     /**        
       * This Method is responsible for trigger exceution ,US11226.
       * @author: Abd Ur Rehman-Plumlogix 
       * @since 28-1-2020
       * @param map and list of contact.        
       * @return void.      
      */
    private static void process (Map<Id,IB_Programme__c> oldProgramme, Map<Id,IB_Programme__c> newProgramme 
                                 ,list<IB_Programme__c> newlist , list<IB_Programme__c> oldlist) {
   
      IB_programmetriggerlogic2(oldProgramme,newlist);
     preventAuthorizedCheckContactsNew(newlist,oldlist );
   
     }
     
     /**        
       * This Method is responsible for IB_programmetrigger functionality,US11226.
       * @author: Abd Ur Rehman-Plumlogix 
       * @since 28-1-2020
       * @param map and list of contact.        
       * @return void.      
      */
      
     
    private static void IB_programmetriggerlogic2(Map<ID,IB_Programme__C> oldMap , list<IB_programme__c> newlist)
    {
     //code added by prerna on 07-03-2025 for ECM00739- PART-1  -- START--
        Set<Id> accountIds = new Set<Id>();
        for (IB_Programme__c prog : newlist) {
            accountIds.add(prog.Account__c);
        }
        
        Map<Id, Account> accountMap = new Map<Id, Account>([SELECT Id, OwnerId FROM Account WHERE Id IN :accountIds]);
        
        Set<Id> userIds = new Set<Id>();
        for (Account acc : accountMap.values()) {
            userIds.add(acc.OwnerId);
        }
        Map<Id, User> userMap = new Map<Id, User>([SELECT Id, Department, IsActive FROM User WHERE Id IN :userIds]);
        //code added by prerna on 01-04-2024 for ECM00739- PART-1 -- END--
        for(IB_Programme__c prog:newlist)
        {
            //code added by prerna on 07-03-2025 for ECM00739- PART-1  -- START--
            Account acc = accountMap.get(prog.Account__c);
            if (acc != null) {
                User accountOwner = userMap.get(acc.OwnerId);
                System.debug('accountOwner===>'+accountOwner);
                if (accountOwner != null) {
                    if (accountOwner.Department == 'IBWS' && accountOwner.IsActive == true &&
                        prog.Status__c == 'Authorized' && oldMap.get(prog.Id).Status__c != 'Authorized') {      // Set Authorized Date when status is changed to 'Authorized'
                            prog.Authorized_Date__c = System.now();
                        }
                    if (prog.Status__c != 'Authorized' && oldMap.get(prog.Id).Status__c == 'Authorized') {
                        prog.Authorized_Date__c = null;
                        prog.Processed_By_Batch__c = false;
                    }
                }
            }
            //code added by prerna on 01-04-2024 for ECM00739- PART-1 -- END--
            //code added by prerna on 01-04-2024for ECM00684 -- START--
            if(prog.Status__c == 'Previously Interested' && oldMap.get(prog.Id).Status__c == 'Interested')
            {
                prog.Ready_for_AFC_Invoicing__c = false;
            }
            //code added by prerna on 01-04-2024 for ECM00684 -- END--
            
            /*When AFA_Initiation_Date gets Updated*/
            if(prog.AFA_Initiation_Date__c !=null){
                if(prog.AFA_Initiation_Date__c != oldMap.get(prog.Id).AFA_Initiation_Date__c )
                {
                    Integer d = prog.AFA_Initiation_Date__c.day();
                    Integer mo = prog.AFA_Initiation_Date__c.month();
                    Integer yr = prog.AFA_Initiation_Date__c.year();
                    
                    DateTime DT = DateTime.newInstance(yr, mo, d);
                    String dtConverted = DT.format('MMM d yyyy');
                    prog.Invoice_Date__c = dtConverted;
                }
                
                if((prog.Status__c=='Authorized' && oldMap.get(prog.Id).Status__c != 'Authorized') || (prog.Status__c=='Authorized' && prog.Exam_Session__c != oldMap.get(prog.Id).Exam_Session__c))
                {
                    Integer mo = Date.today().month();
                    Integer d = Date.today().day();
                    if(prog.Exam_Session__c=='May')
                    {
                        if(mo<8|| (mo==8 &&d==1) )
                        {
                            prog.Invoice_Date__c = 'Aug 1 '+Date.today().year();
                        }
                        else if(mo>=8)
                        {
                            Integer year= Date.today().year();
                            year++; 
                            prog.Invoice_Date__c = 'Aug 1 '+year;
                            
                            
                        }
                        
                    }
                    else if(prog.Exam_Session__c=='November')
                    {
                        if(mo<2|| (mo==2 &&d==1) )
                        {
                            prog.Invoice_Date__c = 'Feb 1 '+Date.today().year();
                        }
                        else if(mo>=2)
                        {
                            Integer year= Date.today().year();
                            year++; 
                            
                            prog.Invoice_Date__c = 'Feb 1 '+year;
                            
                            
                        }
                        
                    }
                    
                }
            } 
            
        }
    }
    /**     
       * This Method is responsible for preventAuthorizedCheckContactsNew functionality,US11226.
       * @author: Abd Ur Rehman-Plumlogix 
       * @since 28-1-2020
       * @param list of contact.        
       * @return void.      
      */
      
    private static void preventAuthorizedCheckContactsNew(list<IB_programme__c> newlist, list<IB_programme__c> oldlist)
    {
          //Get current record, get status, get related Roles and Applications, get Role Name for each R&A, tick off Programme Coordinator and Head of School
    //If both not true, display error
    System.debug('Prevent Authorized check newlist '+newlist+' oldlist '+oldlist);
    String programmeId;
    String programmeStatus;
    String oldProgrammeStatus;
    //Boolean bypassValidationRules;//INC0207105 Benjamin McGarvey, Had to reduce soql queries so made static
    List<IB_Programme__c> currProgs = new List<IB_Programme__c>();
        if(PACC_Handler==null){
            PACC_Handler = new preventAuthorizedCheckContactsHandler();
        }
    //If admin user or loading records, do not perform this validation
    Id userId = UserInfo.getUserId();
        if (!Test.isRunningTest()&&bypassValidationRules==null) {
            bypassValidationRules = [SELECT Bypass_Validation_Rules__c FROM User WHERE id = :userId].Bypass_Validation_Rules__c;
        }else if(Test.isRunningTest()){
            bypassValidationRules=false;
        }
    System.debug('debug validation rule'+bypassValidationRules);
    if (!bypassValidationRules) {

        for(IB_Programme__c old : oldlist){
            oldProgrammeStatus = old.Status__c;
        }

        for(IB_Programme__c prog : newlist){
            programmeId = prog.Id;
            programmeStatus = prog.Status__c;

            System.debug('Old Status is: ' + oldProgrammeStatus);
            System.debug('New Status is: ' + programmeStatus);
            system.debug('programmeId =====> '+programmeId);
            system.debug('Apple ID =====> '+prog.Account__c);
            if ((programmeStatus == 'Candidate' && oldProgrammeStatus == 'Interested') || (programmeStatus == 'Authorized' && oldProgrammeStatus != 'Authorized')) {
                AccountDAO dao = AccountDAO.getInstance();
                Account account = new Account();
                account = dao.getAccountById(prog.Account__c);
                if(account.RecordType.Name != 'Online Provider')
                currProgs.add(prog);
            }
        }
        system.debug('currProgs =====>'+currProgs);
    }
    //Send the list of programmes to the preventAuthorizedCheckContactsHandler class to be processed
    if (currProgs.size() > 0) PACC_Handler.processUpdatedProgs(currProgs);
    }
}