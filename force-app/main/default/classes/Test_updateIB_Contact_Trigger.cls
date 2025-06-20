@isTest
public class Test_updateIB_Contact_Trigger {
  /*  
  /* Plumlogix
  /* Rollback of user story as the user story was released without UAT approval
  /* Commenting the function so the recordtype can be deleted
    @isTest
    static void testMethod_updateIB_Contact_Trigger()
    {
        Case caseObj = new Case(
            Status = 'Working',
            Origin = 'Phone');
        
        RecordType Rectype =[SELECT id,name from RecordType where name='Support Without Case Team'];
        
        caseObj.RecordTypeid = Rectype.id;
        insert caseObj;
        Group whistleBlowing = [Select Id from Group where type='Queue' and Name='Whistleblowing' LIMIT 1];
        caseObj.HitProtectedQueue2__c = True;
        caseObj.OwnerId=whistleBlowing.Id;
        update caseObj;
        
    }*/
}