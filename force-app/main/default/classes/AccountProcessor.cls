public class AccountProcessor
{
    @future
    public static void countContacts(List<Id> accidlist)
    {
        
        List<Account> acclist = [select id,name,(select id,name from contacts) from account where id in : accidlist];
        List<Account> xyz = new List<Account>();
        
        for(Account acc: acclist)
        {
            acc.Number_of_Contacts__c = acc.contacts.size();
            xyz.add(acc);
        }
        update xyz;
    }
    
    
    
}