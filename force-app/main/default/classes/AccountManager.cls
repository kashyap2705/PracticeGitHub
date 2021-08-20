/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 08-21-2021
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public with sharing class AccountManager {


  @AuraEnabled(cacheable= true)
  public static List<Account> retrieveAccount(){
      List<Account> acclist = new List<Account>();
      try {
        acclist=[select id,name,industry from account];
          
      } catch (Exception e) {
          throw new AuraHandledException(e.getMessage());
      }
      system.debug('Hii Anil tutorial*****'+ acclist);
      return acclist;
  }
}