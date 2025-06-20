public class ClsPatientTgrHandler {
    
    public static void CalculateAvg (Map<Id,contact> oldmapvalues,Map<Id,contact> newmapvalues,List<contact> newpatientlist)
    {
        
        List<contact> ProperlyCuredPatientList = new List<contact> ();
        Set<Id> arealist = new Set<Id> (); 
        for(contact p :newpatientlist )
        {
            
            if(newmapvalues.get(p.id).Discharge_Date__c != null &&
               newmapvalues.get(p.id).AccountId != null)
            {
                ProperlyCuredPatientList.add(p);
                arealist.add(p.AccountId);
            }
        }
        if(!arealist.isEmpty())
        {
            ClsPatientTgrHandler.calculateRecoveryRate(arealist);
        }
    }  
    public static void calculateRecoveryRate (Set<Id> arealist)
    {
        
        List<contact> lstpatients= [select id,name,CreatedDate__c,AccountId,Discharge_Date__c 
                                       from contact where AccountId in: arealist and Discharge_Date__c!= null];
        Map<id,Integer> mapAreaToCuredAvg = new Map<id,Integer>();
        Map<id,Integer> mapAreaToCount = new Map<id,Integer>();
        List<Account> listAreatoUpdate = new  List<Account>();
        for(contact p : lstpatients )
        {
            if(mapAreaToCuredAvg.containsKey(p.AccountId))
            {
                Integer existingDiff =   mapAreaToCuredAvg.get(p.AccountId);
                system.debug('existingDiff**'+existingDiff);
                mapAreaToCuredAvg.put(p.AccountId,existingDiff+(p.CreatedDate__c.daysBetween(p.Discharge_Date__c)));
                system.debug('days Taken to cure 2nd time**'+mapAreaToCuredAvg);
            }
            else{
                system.debug('days Taken to cure 1st time**'+(p.CreatedDate__c.daysBetween(p.Discharge_Date__c)));
                mapAreaToCuredAvg.put(p.AccountId,(p.CreatedDate__c.daysBetween(p.Discharge_Date__c)));
            }
            
            
             if(mapAreaToCount.containsKey(p.AccountId))
            {
                Integer existingDiff =   mapAreaToCount.get(p.AccountId);
                mapAreaToCount.put(p.AccountId,existingDiff+1);
            }
            else{
                  
                mapAreaToCount.put(p.AccountId,1);
                system.debug('mapAreaToCount**'+mapAreaToCount);
            }

            
            system.debug('mapAreaToCount keyset**'+mapAreaToCuredAvg.keySet());
            for(Id areaId: mapAreaToCuredAvg.keySet())
            {
                Integer total= mapAreaToCuredAvg.get(areaId);
                Integer count= mapAreaToCount.get(areaId);
                system.debug('count**'+count);
                
                system.debug('AvgDaysTakenToCure__c**'+Decimal.valueOf(total/count));
                listAreatoUpdate.add(new Account(Id= areaId,AvgDaysTakenToCure__c = Decimal.valueOf(total/count))) ;
            }
            //update listAreatoUpdate;
        }
        update listAreatoUpdate;
    }
}