/**		
	* <h1>IB_ProgrammeBeforeInsertTriggerHandler</h1>		
	* This class is responsible managing before insert trigger functionality on ib_programme object as part of trigger consolidation,US11226.
	* 
	* @author  Abd Ur Rehman		
	* @version 1.0		
	* @since   28-1-2020
	
Modification Log     :                                                                              

*-------------------------------------------------------------------------------------------------- 

* Developer                   Date                   Description          Version                          

* ------------------------------------------------------------------------------------------------- 


*/

public class IB_ProgrammeBeforeInsertTriggerHandler extends TriggerHandlerBase {
    
    /**		
	   * This Method is responsible for afterupdate trigger execution ,US11226.
	   * @author: Abd Ur Rehman-Plumlogix 
       * @since 28-1-2020
	   * @param triggerparameter.		
	   * @return void.		
	  */
     public override void mainEntry(TriggerParameters tp){
         //if(TriggerContextUtility.isFirstRun()){
         //TriggerContextUtility.setFirstRunFalse();
		process((Map<Id,IB_Programme__c>)tp.oldMap, (Map<Id,IB_Programme__c>)tp.newMap ,(list<IB_Programme__c>)tp.newList
                ,(list<IB_Programme__c>)tp.oldList);
        // }
	}
	
	/**		
	   * This Method is responsible for afterupdate trigger execution ,US11226.
	   * @author: Abd Ur Rehman-Plumlogix 
       * @since 28-1-2020
	   * @param map and list of ib_programme.		
	   * @return void.		
	  */

	private static void process (Map<Id,IB_Programme__c> oldProgramme, Map<Id,IB_Programme__c> newProgramme, 
                                 list<IB_Programme__c> newlist , list<IB_Programme__c> oldlist) {
     IB_programmetriggerlogic2(oldProgramme,newlist);                       
		
	}
	
	/**		
	   * This Method is responsible for IB_programmetriggerlogic trigger execution ,US11226.
	   * @author: Abd Ur Rehman-Plumlogix 
       * @since 28-1-2020
	   * @param map and list of ib_programme.		
	   * @return void.		
	  */
 private static void IB_programmetriggerlogic2(Map<ID,IB_Programme__C> oldMap , list<IB_programme__c> newlist)
    {
       /** ECM635 phase 2**/
        List<Id> programmeAccountIds= new List<Id>();
       for(IB_Programme__c prog:newlist)
       {
           programmeAccountIds.add(prog.Account__c);
       }
        system.debug('programmeAccountIds**'+programmeAccountIds);
      List<IB_Programme__c> existingProgrammeList=[select id,RecordType.DeveloperName,Account__c from IB_Programme__c where Account__c in: programmeAccountIds and 
                                                   Status__c in ('Interested','Candidate','Authorized','Pending') ];
          Map<Id,List<String>> existingAccountRecordtypeMap= new  Map<Id,List<String>> ();
        if(!existingProgrammeList.isEmpty()){
      
        for(IB_Programme__c ibProgramme: existingProgrammeList){
            if(existingAccountRecordtypeMap.containsKey(ibProgramme.Account__c)){
                existingAccountRecordtypeMap.get(ibProgramme.Account__c).add(ibProgramme.RecordType.DeveloperName);
            }else{
                List<String> newAccountProgrammes= new List<String>();
                newAccountProgrammes.add(ibProgramme.RecordType.DeveloperName);
            existingAccountRecordtypeMap.put(ibProgramme.Account__c,newAccountProgrammes );
            }
        }
       
        system.debug('existingProgrammeList**'+existingProgrammeList);
         system.debug('existingAccountRecordtypeMap**'+existingAccountRecordtypeMap);
        }
        
        Map<ID, Schema.RecordTypeInfo> rtMap = Schema.SObjectType.IB_Programme__c.getRecordTypeInfosById();
         /** ECM635 phase 2**/
         for(IB_Programme__c prog:newlist)
       {
            /** ECM635 phase 2**/
           if(!existingAccountRecordtypeMap.isEmpty()){
          
               if(rtMap.get(prog.RecordTypeId).getDeveloperName()=='Agreement' && existingAccountRecordtypeMap.containsKey(prog.Account__c) && 
                  existingAccountRecordtypeMap.get(prog.Account__c).contains('Diploma_Programme'))
               {
                   prog.addError('Unable to create UK-MEP Agreement because School already has DP programme. Please consult your Salesforce administrator with this error message for assistance.');
               }
               
                if(rtMap.get(prog.RecordTypeId).getDeveloperName()=='Diploma_Programme' && existingAccountRecordtypeMap.containsKey(prog.Account__c) && 
                  existingAccountRecordtypeMap.get(prog.Account__c).contains('Agreement'))
               {
                   prog.addError('Unable to create DP record because School already has UK-MEP Agreement. Please consult your Salesforce administrator with this error message for assistance.');
               }
           }
            /** ECM635 phase 2**/
            
           /*When AFA_Initiation_Date gets Updated*/
          if(prog.AFA_Initiation_Date__c !=null){
          //if(prog.AFA_Initiation_Date__c != oldMap.get(prog.Id).AFA_Initiation_Date__c ) {
          Integer d = prog.AFA_Initiation_Date__c.day();
          Integer mo = prog.AFA_Initiation_Date__c.month();
          Integer yr = prog.AFA_Initiation_Date__c.year();

          DateTime DT = DateTime.newInstance(yr, mo, d);
              String dtConverted = DT.format('MMM d yyyy');
              prog.Invoice_Date__c = dtConverted;
          }
          if(prog.Status__c=='Authorized')
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