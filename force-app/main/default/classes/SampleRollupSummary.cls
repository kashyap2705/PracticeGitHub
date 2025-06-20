public class SampleRollupSummary {
  
    public static void rollupContacts(list<contact> lstOfconts){
        system.debug('==lstOfconts== : '+lstOfconts);
        set<id> accIds = new set<id>();
        list<account> updLstOfAccs = new list<account>();
        list<contact> lstCons = new list<contact>();
      
        for(contact con : lstOfconts){
    if(con.accountid != null)
            accIds.add(con.accountid);
        }
        system.debug('==accIds==:'+accIds);
        list<account> lstAccs = [select id,name,Totalamount__c, (select id,amount__c from contacts) from account where id in : accIds];
      
        for(account acc : lstAccs){
            system.debug('==acc.contacts.size()=='+acc.contacts.size());
			decimal sumamt = 0;
           if(acc.contacts.size() >0)
           for(contact co : acc.contacts){
		       if(co.amount__c != null)
               sumamt = sumamt+co.amount__c;            
            }
		acc.Totalamount__c = sumamt;
		updLstOfAccs.add(acc);
		}
        if(updLstOfAccs.size() > 0){
            update updLstOfAccs;
        }
      
      
    }
  
}